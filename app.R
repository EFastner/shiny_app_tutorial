library(shiny)

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
                              choices = c("Beer", "Refreshment", "Spirits", "Wine"),
                              selected = "Wine"),
                 selectInput(inputId = "countryInput",
                             label = "Country",
                             choices = c("Canada", "France", "Italy"))),
    mainPanel(plotOutput("coolplot"),
              br(), br(),
              tableOutput("results"))
  )
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)