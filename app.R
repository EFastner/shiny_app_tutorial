library(shiny)
library(ggplot2)
library(dplyr)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel(title = "BC Liquor Store prices", 
             windowTitle = "Store Prices"),
  sidebarLayout(
    sidebarPanel(sliderInput(inputId = "priceInput",
                             label = "Price",
                             min = 0,
                             max = 100,
                             value = c(25, 40),
                             pre ="$"),
                 uiOutput("typeOutput"),
                 uiOutput("subOutput"),
                 uiOutput("countryOutput")),
    mainPanel(plotOutput("coolplot"),
              br(), br(),
              h3(textOutput("available_products")),
              tableOutput("results"))
  )
)

server <- function(input, output) {
  filtered <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }
    
    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput,
             Subtype == input$subInput
      )
  })
  
  output$available_products <- renderText({
    if (is.null(filtered())) {
      return()
    }
    
    if(nrow(filtered()) == 1){
      paste(nrow(filtered()), " available product")
    }else{
      paste(nrow(filtered()), " available products")
    }
  })
  
  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return()
    }
    ggplot(filtered(), aes(Alcohol_Content)) +
      geom_histogram(fill = "deepskyblue3") +
      ggtitle(label = "Number of Available Products by Alcohol Content", 
              subtitle = paste("$",input$priceInput[1], 
                               " to $", input$priceInput[2], 
                               ", ", input$typeInput, 
                               ", ", input$countryInput))
  })
  
  output$results <- renderTable({
    filtered()
  })
  
  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                sort(unique(bcl$Country)),
                selected = "CANADA")
  })
  
  output$typeOutput <- renderUI({
    radioButtons("typeInput", "Type",
                 sort(unique(bcl$Type)),
                 selected = "BEER")
  })
  
  output$subOutput <- renderUI({
    selectInput("subInput", "Subtype",
                sort(unique(filter(bcl, Type == input$typeInput)$Subtype)))
  })
}

shinyApp(ui = ui, server = server)