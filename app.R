# Load packages ----------------------------------------------------------------

library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)

# Load data --------------------------------------------------------------------

data <- read.csv("data/demo_data.csv")

# Ensure all columns are the expected data type
data$site_id <- as.character(data$site_id)
data$dataset_id <- as.character(data$dataset_id)
data$LONGITUDE <- as.numeric(data$LONGITUDE)
data$LATITUDE <- as.numeric(data$LATITUDE)
data$Month <- as_date(data$Month)
data$count <-  as.integer(data$count)

# ggplot template --------------------------------------------------------------

plot_template <- ggplot() +
  geom_col(
    aes(x = Month, y = count, fill = datatype),
    color = "grey20",
    linewidth = 0.4
  ) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    x = "",
    y = "Monthly Measurement Counts",
    fill = "datatype"
  ) +
  theme_minimal()

# Function for building plots --------------------------------------------------

make_avail_plot <- function(siteID, data_long, full_info){
  
  # Helper function used to create popup bar plots showing number of
  # measurements per month for each datatype at each site.
  #
  # Args:
  #   siteID: a character string corresponding to a value in data$site_id
  #   data_long: a data frame with columns dataset_id, site_id, LONGITUDE,
  #              LATITUDE, datatype, and count
  #   full_info: a data frame with columns Month and datatype that represents 
  #              every combination of these two values for the full date range
  #
  # Returns:
  #   A ggplot object
  
  full_months_and_datatypes <- full_info
  
  # grab datatype, month, and count for siteID specified in function input
  df <- data_long[, c("datatype", "Month", "count")]
  
  # Left join existing data with full months and datatypes and zero out NAs
  df_monthly_counts <- merge(full_info, df, by = c("Month", "datatype"), 
                             all.x = TRUE)
  df_monthly_counts$count[is.na(df_monthly_counts$count)] <- 0
  
  plot_template + df_monthly_counts +
    ggtitle(toupper(siteID))
}

# UI ---------------------------------------------------------------------------

ui <- fluidPage(
  
  titlePanel("South Florida WQ Data Coverage - (DEMO)"),
  
  sidebarLayout(
    sidebarPanel(
      
      # user selects map extent ------------------------------------------------
      selectInput(
        "extentChoice",
        "Select Map Extent:",
        choices = c("Biscayne Bay", "South Florida"),
        selected = "Biscayne Bay"
      ),
      
      # user selects data sets -------------------------------------------------
      checkboxGroupInput(
        "datasetFilter",
        "Select Dataset(s):",
        choices = sort(unique(data$dataset_id)),
        selected = NULL
      ),
      
      # user selects date range-------------------------------------------------
      dateRangeInput(
        inputId = "dateRange", 
        label = "Select Date Range:",
        start = as.character(max(max(data$Month) - years(2), min(data$Month))),
        end = as.character(max(data$Month)),
        min = as.character(min(data$Month)),
        max = as.character(max(data$Month))
      ),
      
      # user selects parameters-------------------------------------------------
      checkboxGroupInput(
        "paramChoice",
        "Select Parameters:",
        choices = sort(unique(data$datatype)),
        selected = NULL
      ),
      
      # map update button-------------------------------------------------------
      actionButton("updateMap", "Update Map", class = "btn-primary"),
      uiOutput("message")
    ),
    
    mainPanel(
      leafletOutput("map", height = 600)
    )
  )
)

# SERVER -----------------------------------------------------------------------

server <- function(input, output, session) {
  
  # Define error message logic -------------------------------------------------

  msg_visible <- reactiveVal(FALSE)
  
  output$message <- renderUI({
    if (msg_visible()) {
      tags$span("Please select at least one dataset and at least one parameter", 
                style = "color:red; font-style:italic;")
    } else {
      NULL
    }
  })
  
  # Render base map ------------------------------------------------------------
  # (full extent, no data)
  
  output$map <- renderLeaflet({
    
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -81, lat = 25.9, zoom = 7.5)
  })
  
  # Update map on click --------------------------------------------------------
  # (with ui-selected options)
  
  observeEvent(input$updateMap, {
    
    ## Check for empty selections ----------------------------------------------
    
    if (length(input$paramChoice) == 0 || 
        any(input$paramChoice == "") || 
        length(input$datasetFilter) == 0 || 
        any(input$datasetFilter == "")) {
      msg_visible(TRUE)   # show message
      return()            # stop further execution for this click
    } else {
      msg_visible(FALSE)  # hide message
    }
    
    # Get ui-selected options -------------------------------------------------
    
    req(input$paramChoice, input$extentChoice, input$datasetFilter)
    
    # Determine map extent
    if (input$extentChoice == "Biscayne Bay") {
      north <- 25.9
      south <- 25.3
      east  <- -80.1
      west  <- -80.4
      lat_center <- 25.65
      lng_center <- -80.15
      zoom_level <- 9.5
    } else {
      north <- 27.5
      south <- 24.3
      east  <- -80
      west  <- -81.9
      lat_center <- 25.9
      lng_center <- -81
      zoom_level <- 7.5
    }
    
    # Determine datasets and datatypes
    focal_datatypes <- input$paramChoice
    focal_datasets  <- input$datasetFilter
    
    # Determine date range
    begin <- input$dateRange[1]
    end <- input$dateRange[2]
    
    # Build full date sequence
    date_seq <- seq(
      from = as.Date(format(as.Date(begin), "%Y-%m-01")),
      to   = as.Date(format(as.Date(end), "%Y-%m-01")),
      by   = "month"
    )
    
    # Get all combinations of month and datatype
    months_and_datatypes <- expand_grid(Month = date_seq, 
                                        datatype = focal_datatypes)
    
    # Build updated map --------------------------------------------------------
    
    withProgress(message = "Loading map...", value = 0, {
      
      setProgress(0.2, detail = "Filtering data...")
      
      # Get filtered data
      filtered_long <- data[
        data$Month < end &
          data$Month > begin &
          data$LONGITUDE < east &
          data$LONGITUDE > west &
          data$LATITUDE  < north &
          data$LATITUDE  > south &
          data$datatype  %in% focal_datatypes &
          data$dataset_id %in% focal_datasets, ]
      
      # Get site info
      site_ids <- unique(filtered_long$site_id)
      n_sites <- length(site_ids)
      all_graphs <- vector("list", n_sites)
      
      # Split by site - for efficiency
      data_by_site <- split(filtered_long, filtered_long$site_id)
      
      # set up plot files
      plot_dir <- "plot_images"
      dir.create(plot_dir, showWarnings = FALSE)
      img_files <- file.path(
        plot_dir,
        paste0("plot_", seq_along(all_graphs), ".png")
      )
      
      for (i in seq_along(site_ids)) {
        
        # print(paste('generating plot', i, "of", n_sites))
        setProgress(0.5, detail = paste('generating plot', i, "of", n_sites))
        
        # Build plot
        all_graphs[[i]] <- make_avail_plot(
          siteID = site_ids[[i]],
          data_long = data_by_site[[site_ids[[i]]]],
          full_info = months_and_datatypes
        )
        
        # Save plot
        ggplot2::ggsave(
          filename = img_files[i],
          plot = all_graphs[[i]],
          width = 400 / 72,
          height = 200 / 72,
          dpi = 72
        )
        
      }
      
      setProgress(0.65, detail = "Rendering popups...")
      
      filtered_locs <- filtered_long %>%
        group_by(dataset_id, site_id, LONGITUDE, LATITUDE) %>%
        summarise(total_count = sum(count, na.rm = TRUE), .groups = "drop") %>%
        ungroup()
      filtered_locs <- filtered_locs[match(site_ids, filtered_locs$site_id), ]
      
      filtered_locs$popup <- leafpop::popupImage(
        img_files,
        width = 400,
        height = 200,
        embed = TRUE
      )
      
      # Render map
      
      setProgress(0.75, detail = "Rendering map...")
      
      if (nrow(filtered_locs) == 0) {
        output$map <- renderLeaflet({
          leaflet() %>%
            addProviderTiles("CartoDB.Positron") %>%
            setView(lng = lng_center, lat = lat_center, zoom = zoom_level)
        })
        incProgress(1)
        return()
      }
      
      pal <- colorFactor("Dark2", domain = unique(filtered_locs$dataset_id))
      
      output$map <- renderLeaflet({
        leaflet(filtered_locs) %>%
          addProviderTiles("CartoDB.Positron") %>%
          setView(lng = lng_center, lat = lat_center, zoom = zoom_level) %>%
          addCircles(
            radius = ~sqrt(total_count) * 2,
            lng = ~LONGITUDE,
            lat = ~LATITUDE,
            color = ~pal(dataset_id),
            fillColor = ~pal(dataset_id),
            fillOpacity = 0.5,
            popup = filtered_locs$popup
          ) %>%
          addLegend(
            position = "bottomright",
            pal = pal,
            values = ~dataset_id,
            title = "Dataset ID",
            opacity = 1
          )
      })
      
      setProgress(1, detail = "Done!")
      
    })
  })

}

# RUN APP ----------------------------------------------------------------------

shinyApp(ui, server)
