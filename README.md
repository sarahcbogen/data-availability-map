# South Florida Data Availability Map

This application was designed to visualize the spatial and temporal coverage of water quality data in South Florida to assess dataset completeness and inform research questions.


## Requirements
- R version >= 4.0.0
- RStudio (optional)

Required R packages my be installed with the command:
```r
install.packages(c("shiny", "leaflet", "dplyr", "ggplot2", "lubridate", "tidyr"))
```

## Project Directory Structure

```plaintext
├── data/                          # Data used by the application
│   └── demo_data.csv              # Example dataset for demonstration
├── app.R                          # Main Shiny application file (or ui.R + server.R)
├── data-availability-map.Rproj    # R project file
└── README.md                      # Project documentation
```

## Data


## Live App

A deployed version of this app with the demo data set is available [here](https://sarahcbogen.shinyapps.io/data-availability-map/).


