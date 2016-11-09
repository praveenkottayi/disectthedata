# Final demo version


library(shiny)
library(shinythemes)

data <- getCSV()

narrowSidebar <- HTML('<style>.span16 {min-width: 265px; max-width: 265px; }</style>')

# Define UI for dataset viewer application
fluidPage(
  #theme = shinytheme("superhero"), #superhero
  # Application title.
  titlePanel("Disect the data: Demo data analytics"),
  
  tags$style(HTML("
        .tabs-above > .nav > li[class=active] > a {
                  background-color: #000;
                  color: #FFF;
                  }")),
  

  sidebarLayout(
    sidebarPanel( tags$head(narrowSidebar),
      
      selectInput("dataset", "Choose a dataset:", 
                  choices = c("German Bank data")),
                  #choices = list.files(pattern = ".csv")) ,
      
      #############################################
      helpText("--------------- HISTOGRAM --------------------"), 
      
      #numericInput("obs", "Histogram of which attribute to view:", 1),
      selectInput("obs", "Histogram of attribute :", 
                  choices = names(data)),
      
      helpText("Note: After updating , please open histogram tab"),
      
      submitButton("View Histogram"),
      
      sliderInput("Attributes",
                  "Number of bins for histogram:",
                  min = 1,
                  max = 100,
                  value = 10),
      #############################################
      helpText("--------------- SCATTER PLOT --------------------"),
      selectInput("scatterplotX", "Choose X-axis:", 
                  choices = names(data)),
      
      selectInput("scatterplotY", "Choose Y-axis:", 
                  choices = names(data)),
      
      submitButton("View Scatter plot"),
      
      #############################################
      helpText("--------------- CLUSTERING --------------------"),
      selectInput('xcol', 'X Variable', names(data)),
      selectInput('ycol', 'Y Variable', names(data),
                  selected=names(data)[[2]]),
      numericInput('clusters', 'Cluster count', 3,min = 1, max = 9),
      submitButton("View Clusters"),
      width = 3
    ),
    
   
    
    # Show a summary of the dataset and an HTML table with the
    # requested number of observations. Note the use of the h4
    # function to provide an additional header above each output
    # section.
    mainPanel(
      tabsetPanel(
        
        tabPanel("Sample data",
                 h4("Observations"),
                 tableOutput("view")),
        
        tabPanel("Summary",
        h4("Summary"),
        verbatimTextOutput("summary"),
        h4("number of attributes"),
        verbatimTextOutput("numberofattributes")),
        
        
        
        
        tabPanel("Exploratory: Histogram",
        plotOutput("histogram")),
        
        tabPanel("Exploratory: Scatterplot",
                 plotOutput("scatterplot"),
                 h4("Correlation coefficient "),
                 verbatimTextOutput("correlation")
                 
                 
        ),
        
        tabPanel("correlation matrix",
                 plotOutput("corrmat")),
        
        tabPanel("clustering",
                 h4("Clusters"),
                 plotOutput('clustering')),
        tabPanel("gini",
                 h4("Gini score"),
                 plotOutput('gini')),
        tabPanel("variable_importance",
                 h4("Variable importance"),
                 plotOutput('variable_importance')),
        tabPanel("Boruta",
                 h4("Boruta "),
                 plotOutput('Boruta'),
                 h4("Best features selected by boruta algorithm"),
                 verbatimTextOutput("model")),
        tabPanel("model",h4("Performance of models"),
                 
                 plotOutput('model1'))
  )
)
)
)