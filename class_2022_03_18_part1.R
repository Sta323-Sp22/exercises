# Approximate Bayesian Computation

# 1. Define a prior and have the ability to sample from it (efficiently)
#
# 2. Define a data generative process (likelihood but more of a simulation)
#
# 3. Generate a bunch of priors which are then used to generate data draws (simulations)
# 
# 4. Filter the prior draws keep on datas that (approximately) match the observed data
#
# 5. Resulting prior draws will be the posterior


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
        numericInput("b", "Prior # of tails", min=0, value=5),
        h4("ABC:"),
        numericInput("n_sim", "# of simulations", value=100000),
        numericInput("n_min", "Min # of posterior draws", value=1000),
        h4("Run:"),
        actionButton("run", "Run Simulations")
      ),
      mainPanel = mainPanel(
        plotOutput("plot"),
        textOutput("summary")
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
    }) %>%
      bindEvent(input$run)
    
    abc_post = reactive({
      req(input$n_sim, input$a, input$b)
      
      abc_prior = rbeta(input$n_sim, input$a, input$b)
    
      abc_data_gen = rbinom(input$n_sim, size = input$n, prob = abc_prior)
      
      abc_post = abc_prior[ abc_data_gen == input$x ]
      
      abc_post
    }) %>% 
      bindEvent(input$run)
      
    abc_post_dens = reactive({
      validate(
        need(
          length(abc_post()) >= input$n_min, 
          "Insufficient posterior draws, try increasing the number of simulations"
        )
      )
      
      abc_dens = density(abc_post())
      
      tibble(
        p = abc_dens$x,
        distribution = "ABC Posterior",
        density = abc_dens$y
      )
    })
    
    output$summary = renderText({
      glue::glue(
        "Ran {input$n_sim} generative simulations and obtained {length(abc_post())} ",
        "posterior samples.\nEfficiency of {100*length(abc_post())/input$n_sim}%."
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
        ) %>%
        bind_rows(
          abc_post_dens()
        )
      
      ggplot(df, aes(x=p, y=density, color=distribution)) + 
        geom_line(size=2) + 
        scale_color_manual(values = c("#7fc97f", "#beaed4", "#dfc086", "#e78ac3"))
    })
  }
)


