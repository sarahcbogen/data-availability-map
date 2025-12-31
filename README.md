# South Florida Data Availability Map

This application visualizes the spatial and temporal availability of water quality data in South Florida. Users can select a region (Biscayne Bay or South Florida), a date range, data sources, and water quality parameters of interest.

Spatial data availability is displayed by mapping monitoring sites with available data. Temporal availability can be explored by clicking on individual sites, which opens popup bar charts showing the number of measurements by month and parameter.

The application has lightweight data requirements and is intended to help users assess dataset completeness, refine research questions, and guide more detailed queries of the source datasets.

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

The application expects a monthly summary data file in the data/ subdirectory with the column structure described below. Basic type coercion is applied to match expected R data types (character, numeric, integer, date). No additional data validation or quality assurance is performed, and NA values are not explicitly handled.

- **site_id**: Identifier for the sampling site
- **dataset_id**: The original data source . ***Unique values from this column populate the "Select Dataset(s):" options on the user interface***
- **LONGITUDE**: Geographic longitude of the site
- **LATITUDE**: Geographic latitude of the site
- **datatype**: The type of parameter measured . ***Unique values from this column populate the "Select Parameters:" options on the user interface***
- **Month**: Stored as a character string in the format 'yyyy-mm-01'
- **count**: Number of measurements for the given site_id, datatype, and Month

A generalized example dataset (demo_data.csv) is included with this repository. The path and file name of the data file can be changed in the second section of **app.R**.

## Live App

A deployed version of this app with the demo data set is available [here](https://sarahcbogen.shinyapps.io/data-availability-map/).


