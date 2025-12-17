## South Florida Data Availability Map

This application was designed to visualize the spatial and temporal coverage of water quality data in South Florida to assess dataset completeness and inform research questions.


### Repository Structure

```plaintext
├── app.R               # Main Shiny application file (or ui.R + server.R)
├── data/               # Data used by the application
│   └── demo_data.csv   # Example dataset for demonstration
├── www/                # Static assets (CSS, JS, images)
└── README.md           # Project documentation
```


### Software Requirements
- R version >= 4.0.0
- RStudio (optional)

```r
install.packages(c("shiny", "leaflet", "dplyr", "ggplot2", "shinythemes", "lubridate", "tidyr"))
```




### Data


### Live App

A deployed version of this app with the demo data set is available [here](https://sarahcbogen.shinyapps.io/data-availability-map/).


