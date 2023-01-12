#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
#> This application takes a data set input and calculates the mean and outputs 
#> basic statistical summary and plots, such as scatter plot, density histogram,
#> and Q-Q plot, as well as statistical test method, Shapiro-Wilk Test, p-value 
#> result for normality. The application also allows user to perform common 
#> transformations, such as, log, square root and cube root, to the data set to 
#> make it more normally distributed.
#> Source: Statology R Guides, How to Test for Normality in R 
#> (https://www.statology.org/test-for-normality-in-r/)
#


library(shiny);library(ggpubr)

# Define server logic required to plot
shinyServer(function(input, output) {
      output$value <- renderPrint({ input$text })
      output$tran.txt <- renderText({
            HTML(paste("You chose", "<b>",input$tran, "</b>","transformation"))
      })
      output$plot.scat <- renderPlot({
            x <- seq(1, length(unlist(strsplit(input$text,','))))
            y <- as.numeric(as.character(unlist(strsplit(input$text,','))))
            switch(input$tran,
                   no = y <- y,
                   'Log base 10' = y <- log10(y),
                   'Square Root' = y <- sqrt(y),
                   'Cube Root' = y <- y^(1/3),
                   paste("NULL"))      
            plot(x,y, 
                 main='Scatter Plot of Input Values', 
                 xlab = "Input Value Sequence Number", ylab = "Input Value"
            )
            # Add line and legend for mean
            abline(h = mean(y), col = "blue3",lwd = 2.5)
            legend(x = "topright", lty = 1, lwd = 2, col = "blue3", 
                   legend = paste("Mean =", round(mean(y),3)), text.font = 4
            )
      })
      output$plot.hist <- renderPlot({
            x <- as.numeric(as.character(unlist(strsplit(input$text,','))))
            n <- length(unlist(strsplit(input$text,',')))
            switch(input$tran,
                   no = x <- x,
                   'Log base 10' = x <- log10(x),
                   'Square Root' = x <- sqrt(x),
                   'Cube Root' = x <- x^(1/3),
                   paste("NULL"))      
            hist(x, breaks=n, prob=TRUE, main='Distribution of Input Values', 
                 xlab = "Input Value")
            # Add line for mean
            abline(v = mean(x), col = "blue3",lwd = 2.5)
            # define x and y values to use for normal curve
            x_values <- seq(min(x), max(x), length = 100)
            y_values <- dnorm(x_values, mean = mean(x), sd = sd(x))
            # overlay normal curve on histogram plot
            lines(density(x), col="green3", lwd=2)
            lines(x_values, y_values, col="tomato", lwd = 2, lty=2)
            legend("topright", c(paste("Mean =", round(mean(x),3)), 
                                 "Sample Distribution", 
                                 "Normal Distribution"),
                   col=c("blue3","green3","tomato"), lty=c(1,1,2), lwd=3, 
                   text.font = 4)
      })
      output$plot.QQ <- renderPlot({
            x <- as.numeric(as.character(unlist(strsplit(input$text,','))))
            switch(input$tran,
                   no = x <- x,
                   'Log base 10' = x <- log10(x),
                   'Square Root' = x <- sqrt(x),
                   'Cube Root' = x <- x^(1/3),
                   paste("NULL"))
            ggqqplot(x, main='Q-Q plot with ggpubr library')
      })
      output$n.x <- renderText({
            paste("N = ", 
                  length(unlist(strsplit(input$text,','))))
      })
      output$max.x <- renderText({
            paste("Max = ", 
                  max(unlist(strsplit(input$text,','))))
      })
      output$min.x <- renderText({
            paste("Min = ", 
                  min(unlist(strsplit(input$text,','))))
      })
      output$mean.x <- renderText({
         x <- as.numeric(as.character(unlist(strsplit(input$text,','))))
         paste("Mean = ", 
               switch(input$tran,
                      no = mean(x),
                      'Log base 10' = 10^(mean(log10(x))),
                      'Square Root' = mean(sqrt(x))**2,
                      'Cube Root' = mean(x^(1/3))**3,
                      paste("NULL")))      
      })
      output$shapiro.test.x <- renderText({
            x <- as.numeric(as.character(unlist(strsplit(input$text,','))))
            switch(input$tran,
                no = x <- x,
                'Log base 10' = x <- log10(x),
                'Square Root' = x <- sqrt(x),
                'Cube Root' = x <- x^(1/3),
                paste("NULL"))      
            paste("p-value =", p.value<-paste(shapiro.test(x)[[2]]))
      })
})
