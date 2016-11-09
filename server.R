library(shiny)
library(datasets)

data <- getCSV()

# Define server logic required to summarize and view the 
# selected dataset
function(input, output,session) {
  
  #################################################################
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "German Bank data" = data,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  choiceX <- reactive({
    (input$scatterplotX)
           
  })
  
  choiceY <- reactive({
    (input$scatterplotY)
    
  })
  
  choiceHist <- reactive({
    (input$obs)
    
  })
  
  #################################################################
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
    
  })
  #################################################################
  output$numberofattributes <- renderPrint({
    dataset <- datasetInput()
    print(ncol(dataset))
    print(colnames(dataset))
    
  })
  #################################################################
  # Show the first "5" observations
  output$view <- renderTable({
    head(datasetInput(), n = 20)
  })
  
  #################################################################
  output$histogram <- renderPlot({
    # draw the histogram with the specified number of bins
    
    x_name = choiceHist()
    x    <- data[,x_name]
    bins <- seq(min(x), max(x), length.out = input$Attributes) # 
    hist(data[,x_name], breaks = bins, col = 'green', border = 'white' , xlab = x_name, main = paste("Histogram of " , (x_name)))
  })
  
  #################################################################
  output$scatterplot <- renderPlot({
    x = choiceX()
    y = choiceY()
    plot(data[,x], data[,y],xlab = x,ylab = y,col= "blue",type = "p" ,cex=1,cex.lab=1,cex.axis=1)
    
  })
  #################################################################
  output$correlation <- renderPrint({
    x = choiceX()
    y = choiceY()
    c = (cor(data[,x], data[,y]))
    print(c)
    
  })
  #################################################################
  output$corrmat <- renderPlot({
    dataset = datasetInput()
    attribute_names = colnames(dataset)
    M <- cor(dataset) # get correlations
    
    library('corrplot') #package corrplot
    
    corrplot(M, method = "circle",title = "correlation matrix",diag = F) #plot matrix
    
  })
  #################################################################
  output$value <- renderText({ input$somevalue })
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    data[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$clustering <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  #######################################
  
  output$variable_importance <- renderPlot({
    credit =data
    i_test=sample(1:nrow(credit),size=33)
    i_calibration=(1:nrow(credit))[-i_test]
    
    library(randomForest)
    RF <- randomForest(RESPONSE ~ ., data = credit[i_calibration,])
    variable_importance =RF
    varImpPlot(variable_importance)
    
  })
  #######################################
  
  output$Boruta <- renderPlot({
    library(Boruta)
    
    set.seed(123)
    boruta.train <- Boruta(data$RESPONSE~., data = data, doTrace = 2)
    print(boruta.train)
    
    plot(boruta.train, xlab = "", xaxt = "n")
    lz<-lapply(1:ncol(boruta.train$ImpHistory),function(i)
      boruta.train$ImpHistory[is.finite(boruta.train$ImpHistory[,i]),i])
    names(lz) <- colnames(boruta.train$ImpHistory)
    Labels <- sort(sapply(lz,median))
    axis(side = 1,las=2,labels = names(Labels),
         at = 1:ncol(boruta.train$ImpHistory), cex.axis = 0.5)
    
    final.boruta <- TentativeRoughFix(boruta.train)
    print(final.boruta)
    
    final_attributes= getSelectedAttributes(final.boruta, withTentative = F)
    
    assign('selected_variables',final_attributes,envir=.GlobalEnv)
    
    
    #boruta.df <- attStats(final.boruta)
    #print(boruta.df)
    
    
    
  })
  
  ##########################################################
  
  output$gini <- renderPlot({
    library(ineq)
    dataset=data
    data_names=colnames(data)
    variable_importance = rep(0,times = ncol(dataset)-1)
    entropy = rep(0,times = ncol(dataset)-1)
    
    for(i in 1:ncol(dataset)-1) {
      var= dataset[,i+1]
      variable_importance[i]=ineq(var,type="Gini")
      entropy[i]= entropy(var)
      plot(Lc(var)) 
    }
    barplot((variable_importance), type ="h")
    x=variable_importance
    normalized = (x-min(x))/(max(x)-min(x))
    barplot((normalized), type ="h")
    
    barplot((entropy), type ="h")
    x=entropy
    normalized = (x-min(x))/(max(x)-min(x))
    
    barplot((normalized), type ="h",names.arg = data_names[1:(length(data_names)-1)] )
  })
  # plot(1:10,asp = 4/3,cex=5,cex.lab=3,cex.axis=4)
  
  ##########################################################
  
  output$model <- renderPrint({
    
    print(selected_variables)
    
  })
  ##########################################################
  
  output$model1 <- renderPlot({
    credit =data
    i_test=sample(1:nrow(credit),size=33)
    i_calibration=(1:nrow(credit))[-i_test]
    
    LogisticModel <- glm(RESPONSE ~ ., family=binomial, data = credit[i_calibration,])
    
    #We might overfit, here, and we should observe that on the ROC curve
    library(ROCR)
    fitLog <- predict(LogisticModel,type="response", newdata=credit[i_test,])
    pred = prediction( fitLog, credit$RESPONSE[i_test])
    perf <- performance(pred, "tpr", "fpr")
    plot(perf)
  })
  ##########################################################
  
  
}