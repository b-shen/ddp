#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

library(shiny)

# Define UI for application
shinyUI(fluidPage(
      
      # Application title
      titlePanel("Explore Data: Calculate Mean and Check for Normality"),
      
      # Sidebar with text box to input values
      sidebarLayout(
            sidebarPanel(
                  textInput("text", label = h3("Input Value*"), value = "67,72,74,62,56,66,65,59,61,69,74,69"),
                  p("*Please separate each value using comma (,)"),
                  hr(),
                  p("You entered the following data..."),
                  verbatimTextOutput("value", placeholder = FALSE),
                  tags$head(tags$style("#value{color:blue; font-size:12px; font-style:italic;
                                   overflow-y:scroll; max-height: 200px; 
                                   background: ghostwhite; white-space: pre-wrap;}")
                           ),
                  radioButtons("tran", "Transformation type:",
                               c("None" = "no",
                                 "Log base 10 Transformation: Transform the values from x to log10(x)." = "Log base 10",
                                 "Square Root Transformation: Transform the values from x to √x." = "Square Root",
                                 "Cube Root Transformation: Transform the values from x to x1/3." = "Cube Root")),
                  #textOutput("tran.txt"),
                  htmlOutput("tran.txt")
            ),
            # Show a plot of the input values
            mainPanel(
                  tabsetPanel(type = "tabs",
                              tabPanel("Data Summary",
                                       br(),
                                       textOutput("n.x"),
                                       br(),
                                       textOutput("max.x"),
                                       br(),
                                       textOutput("min.x"),
                                       br(),
                                       textOutput("mean.x"),
                                       hr(),
                                       strong("Shapiro-Wilk Test"),
                                       verbatimTextOutput("shapiro.test.x"),
                                       p("If the p-value of the test is greater than α = .05, then the data is assumed to be normally distributed.")
                              ),
                              tabPanel("Plot", 
                                       plotOutput("plot.scat"), 
                                       plotOutput("plot.hist"),
                                       plotOutput("plot.QQ")
                              )
                  )
            )
      )
))
