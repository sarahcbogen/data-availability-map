## South Florida WQ Data Coverage Map

This application was designed to visualize the spatial and temporal coverage of water quality data in South Florida to assess dataset completeness and inform research questions.

## Live App

A deployed version of this app is available [here](https://sarahcbogen.shinyapps.io/data-availability-map/).

## Repository Structure

.
├── app.R               # Main Shiny application file (or ui.R + server.R)
├── R/                  # Additional R scripts or modules
├── data/               # Data used by the application
├── www/                # Static assets (CSS, JS, images)
├── README.md           # Project documentation
└── DESCRIPTION         # Optional: package-style metadata

### Requirements
- R version >= X.X.X
- RStudio (optional)

### Install required packages

install.packages(c(
  "shiny",
  "leaflet",
  "dplyr",
  "ggplot2",
  "shinythemes",
  "lubridate",
  "tidyr"
))

## Running the App Locally

Clone the repository:

git clone https://github.com/USERNAME/REPOSITORY.git
cd REPOSITORY

Launch the app in R:

shiny::runApp()
mypackage::run_app()

## Data


## Usage


