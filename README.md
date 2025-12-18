# South Florida Data Availability Map

This application was designed to visualize the spatial and temporal coverage of water quality data in South Florida to assess dataset completeness and inform research questions.

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


The provided demo dataset (demo_data.csv)
(Set_A or Set_B)
(e.g., datatype1, datatype2, datatype3, datatype4)

The application requires a monthly summary data file stored in the data/ subdirectory. The summary data file should be in long format and include. The application assumes the data file is in proper format and does not currently do checking. The application coercess scanned-in data to the expected R data format (character, numeric, integer, date). No others.

- **site_id**: Identifier for the sampling site
- **dataset_id**: The original data source . ***Unique values from this column populate the "Select Dataset(s):" options on the user interface***
- **LONGITUDE**: Geographic longitude of the site
- **LATITUDE**: Geographic latitude of the site
- **datatype**: The type of parameter measured . ***Unique values from this column populate the "Select Parameters:" options on the user interface***
- **Month**: Stored as a character string in the format 'YYYY-MM-01'
- **count**: Numeric count of measurements for the given site_id, datatype, and Month


## Live App

A deployed version of this app with the demo data set is available [here](https://sarahcbogen.shinyapps.io/data-availability-map/).


