library(shiny)
library(datasets)

# Define server logic required to summarize and view the 
# selected dataset
function(input, output) {
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  choiceX <- reactive({
    (input$scatterplotX)
           
  })
  
  choiceY <- reactive({
    (input$scatterplotY)
    
  })
  
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
    #print(ncol(dataset))
    
  })
  
  output$numberofattributes <- renderPrint({
    dataset <- datasetInput()
    print(ncol(dataset))
    print(colnames(dataset))
    
  })
  
  # Show the first "5" observations
  output$view <- renderTable({
    head(datasetInput(), n = 20)
  })
  
  
  output$histogram <- renderPlot({
    dataset = datasetInput()
    attribute = input$obs
    x    <- dataset[,attribute]
    attribute_names = colnames(dataset)
    x_name= attribute_names[attribute]
    print(x_name)
    bins <- seq(min(x), max(x), length.out = input$Attributes) # 
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'green', border = 'white' , xlab = x_name, main = paste("Histogram of " , (x_name)))
  })
  
  
  output$scatterplot <- renderPlot({
    dataset = datasetInput()
    attribute_names = colnames(dataset)
    x=as.integer(choiceX())
    y=as.integer(choiceY())
    print(typeof(x))
    plot(dataset[,x], dataset[,y],xlab = attribute_names[x],ylab = attribute_names[y],col= "blue",type = "p" )
    
  })
  
  output$correlation <- renderPrint({
    dataset = datasetInput()
    attribute_names = colnames(dataset)
    x=as.integer(choiceX())
    y=as.integer(choiceY())
    c = (cor(dataset[,x], dataset[,y]))
    print(c)
    
  })
 
  output$corrmat <- renderPlot({
    dataset = datasetInput()
    attribute_names = colnames(dataset)
    M <- cor(dataset) # get correlations
    
    library('corrplot') #package corrplot
    corrplot(M, method = "circle") #plot matrix
    
    
  })
  
  
}