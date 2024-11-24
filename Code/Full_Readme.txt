Tidal Data Analysis for Kilrush and Dublin Port
This repository contains R scripts for analyzing tidal data from Kilrush and Dublin Port. The scripts focus on error-checking digitized marigrams, generating tidal marigrams from Marine Institute data, and comparing predicted tidal heights with actual data. The scripts retrieve and process data from the ERDDAP server for Kilrush, generate marigrams, and validate tidal predictions.

Overview of Components
Dublin_Port_Error_Checking_Code:
This script uses the ftide_calc_dubport model to compare predicted tidal data with actual digitized data for Dublin Port. It helps identify discrepancies between predicted and digitized data, generating a text summary of the results. The ftide_calc_dubport model is available upon request.

Generate_Kilrush_Marigram_Images:
This script generates tidal marigrams (graphs) for Kilrush, Ireland, for the years 2019–2021 using tidal data from the Irish National Tide Gauge Network. It fetches data from the Marine Institute’s ERDDAP server, performs harmonic analysis, and visualizes the tidal data weekly, saving the results as PNG images.

Kilrush_Predicted_Tide_Error_Checking_Code:
This script compares predicted tidal heights with actual digitized values for Kilrush. It calculates residuals (the difference between predicted and actual values) and generates a summary of the residuals, offering insights into the accuracy of the digitized data.

Getting Started
These instructions will guide you through setting up and running the scripts in this repository.

Prerequisites
Before running the scripts, ensure you have the following installed on your system:

R (version 4.0 or above)
RStudio (optional, but recommended for easier script execution)
You will also need to install the necessary R libraries. You can do this by running the following commands in your R console:

r
Copy code
install.packages(c('rerddap', 'tidyverse', 'lubridate', 'TideHarmonics', 'reshape2', 'zoo', 'wesanderson', 'VulnToolkit', 'readxl', 'dplyr', 'ggplot2'))
Setting Up the Environment
Clone the repository or download the project files to your local machine.
Set the working directory in R to the folder containing the scripts and data. Use the setwd() function to specify the correct path. For example:
r
Copy code
setwd("C:/path/to/your/working/directory")
Script Descriptions
1. Dublin_Port_Error_Checking_Code
This script compares predicted tidal heights for Dublin Port with actual digitized data. It uses the ftide_calc_dubport model (available upon request) to generate predicted tides and checks for discrepancies. The script outputs a text file summarizing the comparison.

How to Run:
Ensure you have access to the ftide_calc_dubport model (contact the repository owner for access).
Run the script in R or RStudio:
r
Copy code
source("Dublin_Port_Error_Checking_Code.R")
Review the output text file generated in the working directory for the error-checking summary.
2. Generate_Kilrush_Marigram_Images
This script generates tidal marigrams for Kilrush, Ireland, for the years 2019–2021. It fetches tidal data from the Marine Institute's ERDDAP server, performs harmonic analysis, and visualizes the tidal data in weekly marigrams. The marigrams are saved as PNG files in the working directory.

How to Run:
Modify the setwd() path in the script to point to your working directory.
Run the script in R or RStudio:
r
Copy code
source("Generate_Kilrush_Marigram_Images.R")
The script will generate and save weekly marigrams for the selected year (default is 2021).

To generate marigrams for other years, modify the year(DateTime) == 2021 condition in the script to the desired year. For example, change it to:

year(DateTime) == 2019 for 2019
year(DateTime) == 2020 for 2020
This allows you to generate marigrams for years 2019, 2020, or any year of your choosing.

Output:
The output images will be saved as PNG files with the format kilrush_YYYY_week_WW.png, where YYYY is the year and WW is the week number.
3. Kilrush_Predicted_Tide_Error_Checking_Code
This script compares predicted tidal heights with actual digitized values for Kilrush. It calculates residuals (the difference between predicted and actual values) and generates a summary of the residuals.

How to Run:
Ensure you have digitized marigrams for Kilrush (available in the Excel_Data folder).
Run the script in R or RStudio:
r
Copy code
source("Kilrush_Predicted_Tide_Error_Checking_Code.R")
The script will generate a summary of the residuals and save it as a text file in the working directory.
Data
Kilrush Tidal Data:
Data for Kilrush is retrieved from the Marine Institute's ERDDAP server. The script Generate_Kilrush_Marigram_Images fetches this data for the specified years (2019–2021).

Digitized Data:
A sample of digitized tidal data for Dublin Port and Kilrush can be found in the Excel_Data folder. This data is used for error-checking and comparison with predicted tidal values.

Example Output
Marigrams:
The script Generate_Kilrush_Marigram_Images generates marigrams (tidal plots) and saves them as PNG files. For example, the output file for week 22 in 2021 would be named:

r
Copy code
kilrush_2021_week_22.png
Error Checking:
The script Kilrush_Predicted_Tide_Error_Checking_Code generates a text file summarizing the residuals (differences between predicted and digitized data). This file provides insights into the accuracy of the digitized data.

Additional Notes
Model Access:
The ftide_calc_dubport model is required for the Dublin Port error-checking script. Please contact patrick.mcloughlin.2014@mumail.ie for access to the model if needed.

Troubleshooting:

If you encounter issues accessing the Marine Institute's ERDDAP server, check your internet connection or verify that the server is online.
Ensure that the working directory is correctly set to avoid issues with file paths.
License
This project is licensed under the MIT License - see the LICENSE file for details.

Contact
For any questions or issues, please contact patrick.mcloughlin.2014@mumail.ie.

Final Notes:
This README is clear and provides users with step-by-step guidance on running the scripts and understanding their outputs. It offers clear instructions for installing dependencies, running scripts, and troubleshooting common issues. This format should work well for users who want to understand your project, set it up, and use it successfully.