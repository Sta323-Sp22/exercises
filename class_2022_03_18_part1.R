# Approximate Bayesian Computation


## App

library(tidyverse)
library(shiny)

shinyApp(
  ui = fluidPage(
    title = "Beta-Binomial Shiny App",
    titlePanel("Beta-Binomial Shiny App"),
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        h4("Likelihood (data):"),
        sliderInput("n", "# of flips", min=1, max=100, value=20),
        sliderInput("x", "# of heads", min=0, max=100, value=10),
        h4("Prior:"),
        numericInput("a", "Prior # of heads", min=0, value=5),
        numericInput("b", "Prior # of tails", min=0, value=5)
      ),
      mainPanel = mainPanel(
        plotOutput("plot")
      )
    )
  ),
  server = function(input, output, session) {
    
    observeEvent(input$n, {
       updateSliderInput(session, "x", max = input$n)
    })
    
    d = reactive({
      tibble::tibble(
        p = seq(0, 1, length.out = 1001)
      ) %>%
        mutate(
          prior = dbeta(p, input$a, input$b),
          likelihood = dbinom(input$x, size = input$n, prob = p),
          posterior = dbeta(p, input$a + input$x, input$b + input$n - input$x)
        )
    })
    
    output$plot = renderPlot({
      df = d() %>%
        pivot_longer(
          -p, names_to = "distribution", values_to = "density"
        ) %>%
        group_by(distribution) %>%
        mutate(
          density = density / sum(density / n())
        )
        
      ggplot(df, aes(x=p, y=density, color=distribution)) + 
        geom_line(size=2) + 
        scale_color_manual(values = c("#7fc97f", "#beaed4", "#dfc086", "#e78ac3"))
    })
  }
)

