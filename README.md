# South Florida Data Availability Map

This application was designed to visualize the spatial and temporal availability of water quality data in South Florida. Users select a generalized spatial area (Biscayne Bay or South Florida), a date range of interest, and datasets and parameters of interest. The application shows spatial data availability by mapping the sites that have any data availability. Users can explore temporal data availability by clicking individual sites, revealing popup bar charts showing the number of measurements by month and parameter.

The application has relatively lightweight data requirements and may be used to assess dataset completeness, guide research questions, and inform more targeted and detailed queries of the source data sets.

## Project Directory Structure

```plaintext
├── data/                          # Data used by the application
│   └── demo_data.csv              # Example dataset for demonstration
├── app.R                          # Main Shiny application file (or ui.R + server.R)
├── data-availability-map.Rproj    # R project file
└── README.md                      # Project documentation
```

## Requirements

### Software

- R version >= 4.0.0
- RStudio (optional)

### Packages

Required R packages my be installed with the command:
```r
install.packages(c("shiny", "leaflet", "dplyr", "ggplot2", "lubridate", "tidyr"))
```

### Data

The application requires a monthly summary data file stored in the **data/** subdirectory. The required column structure of the data file is described below. The application coerces scanned-in data to the expected R data format (character, numeric, integer, date). However, the application does not currently provide other data format checking or quality assurance features and assumes no NA values.

- **site_id**: Identifier for the sampling site
- **dataset_id**: The original data source . ***Unique values from this column populate the "Select Dataset(s):" options on the user interface***
- **LONGITUDE**: Geographic longitude of the site
- **LATITUDE**: Geographic latitude of the site
- **datatype**: The type of parameter measured . ***Unique values from this column populate the "Select Parameters:" options on the user interface***
- **Month**: Stored as a character string in the format 'yyyy-mm-01'
- **count**: Number of measurements for the given site_id, datatype, and Month

The demo dataset (demo_data.csv) is provided in this repository as a generalized working example. The path and file name of the data file used by the application can be changed in the second section of **app.R**.

## Live App

A deployed version of this app with the demo data set is available [here](https://sarahcbogen.shinyapps.io/data-availability-map/).


