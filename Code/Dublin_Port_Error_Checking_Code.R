# Load necessary libraries
# These libraries are used for reading data, processing, and creating visualizations.
library('readxl')        # For reading Excel files
library('tidyverse')     # For data manipulation and visualization
library('lubridate')     # For handling dates and times
library('TideHarmonics') # For tidal predictions
library('reshape2')      # For reshaping data
library('rerddap')       # For accessing data from ERDDAP servers
library('VulnToolkit')   # For vulnerability toolkit operations

# Set up student info (adjust these variables based on your file path and folder structure)
# Replace with your own data folder structure or adjust the relative paths.
student <- "1179892_assignsubmission_file/"
file <- "February 1975_High_Low_Tides"

# Use relative path for setting the working directory (data should be in 'data/' folder)
# This avoids hardcoding paths and makes the script portable across systems.
setwd("data/")  # Assuming data is placed inside the 'data/' directory in the project folder

# Read the data from the Excel file
# Adjust file path if needed. 'skip = 6' means the first 6 rows are skipped while reading.
data <- read_excel(paste0(student, file, ".xlsx"), skip = 6)

# Plot the Adjusted Height values
# This is the first visual representation of your data.
ggplot(data) +
    geom_line(aes(x = Datetime, y = `Adjusted Height`)) + 
    geom_point(aes(x = Datetime, y = `Adjusted Height`))

# Load the tide model from the 'scripts/ftide_calc_dubport' folder (ftide_calc_dubport.Rdata)
# NOTE: The 'ftide_calc_dubport.Rdata' file is not included in this repository.
# It is available upon request. Contact the repository maintainer for access.
load("scripts/ftide_calc_dubport.Rdata")

# Define the time period for predictions based on the data's Datetime range
# The first and last timestamps from the dataset are used to create the prediction window.
t1 <- as.POSIXct(min(date(data$Datetime), na.rm = TRUE), tz = "UTC")
t2 <- as.POSIXct(max(date(data$Datetime) + 1, na.rm = TRUE), tz = "UTC")

# Predict tidal heights over the defined time period using the pre-calculated model
# This gives us the expected tidal heights during the given period.
pred_tide <- predict(ftide_calc_dubport, t1, t2, by = 1, msl = FALSE)

# Create a tibble for the predicted tides with DateTime and PredTide columns
# We now have the predicted tide heights for every hour between the start and end time.
ptide <- tibble(DateTime = seq(t1, t2, by = "hour"),
                PredTide = pred_tide)

# Extract high-low data for comparison with the predicted values
# The HL function is used to find high and low tide points in the predicted data.
hl <- HL(ptide$PredTide, ptide$DateTime)

# Plot the Adjusted Height values with the predicted high/low tide points overlaid
# Visualizing the comparison between observed and predicted tide heights.
ggplot(data) +
    geom_line(aes(x = Datetime, y = `Adjusted Height`)) + 
    geom_point(aes(x = Datetime, y = `Adjusted Height`)) +
    geom_point(data = hl, aes(x = time, y = level / 0.3048 + mean(data$`Adjusted Height`)), color = 'pink')

# Calculate predicted heights for each data point
# For each entry in the dataset, find the closest predicted tide and adjust the height.
data$PredHeight <- data$`Adjusted Height` + NA
for (k in 1:length(data$PredHeight)) {
    ind <- which.min(abs(data$Datetime[k] - hl$time))
    data$PredHeight[k] <- hl$level[ind] / 0.3048 + mean(data$`Adjusted Height`)
}

# Calculate residuals: the difference between actual and predicted heights
# The residual is used to assess how well the predicted tides match the observed data.
data$Residual <- data$`Adjusted Height` - data$PredHeight
data$Interval <- c(as.numeric(diff(data$Datetime)) / 60, NA)

# Plot Adjusted Height, Predicted Heights, and Residuals
# This visualizes the relationship between the observed and predicted data.
ggplot(data) +
    geom_line(aes(x = Datetime, y = `Adjusted Height`)) + 
    geom_point(aes(x = Datetime, y = `Adjusted Height`)) +
    geom_point(data = hl, aes(x = time, y = level / 0.3048 + mean(data$`Adjusted Height`)), color = 'pink') +
    geom_point(aes(x = Datetime, y = `Adjusted Height` - PredHeight), color = 'purple')

# Ensure 'Datetime' is in POSIXct format (if not already)
# This makes sure the datetime values are correctly formatted for further processing.
data$Datetime <- as.POSIXct(data$Datetime)

# Create the 'Week' column to group data by weeks
# This column is useful for generating weekly summaries.
data$Week <- week(data$Datetime)

# Define a function to generate weekly residual summaries
# This function creates a summary of high and low tides for each week, including the largest residuals.
get_weekly_residual_summary <- function(week_num, data, output = FALSE) {
    week_data <- data %>% filter(Week == week_num)
    num_highs <- nrow(week_data %>% filter(`High or Low` == "H"))
    num_lows <- nrow(week_data %>% filter(`High or Low` == "L"))
    
    top_residuals <- week_data %>%
        arrange(desc(abs(Residual))) %>%
        select(`High or Low`, Datetime, `Adjusted Height`, PredHeight, Residual, Interval, Week) %>%
        head(5)
    
    summary_text <- paste0("\nWeek: ", week_num, "\n",
                           "Number of Highs: ", num_highs, "\n",
                           "Number of Lows: ", num_lows, "\n\n",
                           "Top 5 Largest Residuals:\n")
    summary_text <- paste0(summary_text, capture.output(print(top_residuals)), collapse = "\n")
    
    if (output) {
        return(summary_text)
    } else {
        cat(summary_text)
    }
}

# Loop through each unique week in the dataset and generate the weekly summary
unique_weeks <- unique(data$Week)

# Define the output file location for saving the summaries
output_file <- "output/dublin_port_weekly_residuals_summary.txt"

# Ensure the output directory exists; create it if it doesn't
if (!dir.exists(dirname(output_file))) {
    dir.create(dirname(output_file), recursive = TRUE)
}

# Write the weekly summaries to the output file
sink(output_file)
for (wk in unique_weeks) {
    summary_output <- get_weekly_residual_summary(wk, data, output = TRUE)
    cat(summary_output)
}
sink()

cat("Residuals summary saved at:", output_file)
