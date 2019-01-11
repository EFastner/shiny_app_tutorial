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
                 radioButtons(inputId = "typeInput",
                              label = "Product Type",
                              choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                              selected = "WINE"),
                 selectInput(inputId = "countryInput",
                             label = "Country",
                             choices = c("CANADA", "FRANCE", "ITALY"))),
    mainPanel(plotOutput("coolplot"),
              br(), br(),
              h3(textOutput("available_products")),
              tableOutput("results"))
  )
)

server <- function(input, output) {
  output$available_products <- renderText({
    filtered <- 
      bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
    
    if(nrow(filtered) == 1){
      paste(nrow(filtered), " available product")
    }else{
      paste(nrow(filtered), " available products")
    }
  })
  
  output$coolplot <- renderPlot({
    filtered <- 
      bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
    
    ggplot(filtered, aes(Alcohol_Content)) +
      geom_histogram(fill = "deepskyblue3") +
      ggtitle(label = "Number of Available Products by Alcohol Content", 
              subtitle = paste("$",input$priceInput[1], 
                               " to $", input$priceInput[2], 
                               ", ", input$typeInput, 
                               ", ", input$countryInput))
  })
  
  output$results <- renderTable({
    filtered <- 
      bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
    filtered
  })
}

shinyApp(ui = ui, server = server)