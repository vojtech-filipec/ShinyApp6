# server.R

library(quantmod)
source("helpers.R")

# ORIGINAL with no tuning
#
# shinyServer(function(input, output) {
# 
#   output$plot <- renderPlot({
#     data <- getSymbols(input$symb, src = "yahoo", 
#       from = input$dates[1],
#       to = input$dates[2],
#       auto.assign = FALSE)
#                  
#     chartSeries(data, theme = chartTheme("white"), 
#       type = "line", log.scale = input$log, TA = NULL)
#   })
#   
# })


# MODIFIED using reactive expression

shinyServer(function(input, output) {
  
  dataInput <- reactive({  # <-- this is updated only upon a change in input$dates
    getSymbols(input$symb, src = "yahoo", 
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })

  # specimen code with non-optimal combination of two independent inputs: adjust and log  
  # output$plot <- renderPlot({   
  #   data <- dataInput()
  #   if (input$adjust) data <- adjust(dataInput())
  #   
  #   chartSeries(data, theme = chartTheme("white"), 
  #               type = "line", log.scale = input$log, TA = NULL)
  # })
  
  # one-off adjustment
  dataInputAdj <- reactive({ 
    data <- dataInput()
    if (input$adjust) data <- adjust(dataInput())
    return(data)
    })
  
  output$plot <- renderPlot({
    chartSeries( dataInputAdj(), theme= chartTheme("white"),
                 type= "line", log.scale = input$log, TA = NULL)
  })
})