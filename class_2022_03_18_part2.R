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
        selectInput("prior", "Select prior", choices = c("Beta"="beta", "Truncated Norm" = "tnorm")),
        uiOutput("prior_param"),
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
    
    observe({
      if (input$prior == "beta") {
        output$prior_param = renderUI({
          list(
            numericInput("a", "Prior # of heads", min=0, value=5),
            numericInput("b", "Prior # of tails", min=0, value=5)
          )
        })
      } else if (input$prior == "tnorm") {
        output$prior_param = renderUI({
          list(
            numericInput("mu", "Prior mu", min=0, value=0.5),
            numericInput("sigma", "Prior sigma", min=0, value=0.25)
          )
        })
      } else {
        stop("Bad input value selected for prior.")
      }
    })
    
    abc_prior = reactive({
      req(input$n_sim, input$a, input$b)
      req(input$mu, input$sigma)
      
      
      if (input$prior == "beta") {
        abc_prior = rbeta(input$n_sim, input$a, input$b)
      } else if (input$prior == "tnorm") {
        abc_prior = truncnorm::rtruncnorm(input$n_sim, 0, 1, mean = input$mu, sd = input$sigma)
      } else {
        stop("Bad input value selected for prior.")
      }
      
      abc_prior
    })
    
    abc_gen_sim = reactive({
      rbinom(input$n_sim, size = input$n, prob = abc_prior())
    })
    
    abc_post = reactive({
      abc_prior()[ abc_gen_sim() == input$x ]
    })
    
    output$summary = renderText({
      glue::glue(
        "Ran {input$n_sim} generative simulations and obtained {length(abc_post())} ",
        "posterior samples.\nEfficiency of {100*length(abc_post())/input$n_sim}%."
      )
    })
    
    output$plot = renderPlot({
      
      validate(
        need(
          length(abc_post()) >= input$n_min, 
          "Insufficient posterior draws, try increasing the number of simulations"
        )
      )

      prior_dens = density(abc_prior())
      post_dens = density(abc_post())
      
      df = bind_rows(
        tibble(
          p = prior_dens$x,
          distribution = "ABC Prior",
          density = prior_dens$y
        ),
        tibble(
          p = seq(0,1,length.out=1000),
          distribution = "ABC Likelihood"
        ) %>%
          mutate(
            density = dbinom(input$x, input$n, p),
            density = density / sum(density / n())
          ),
        tibble(
          p = post_dens$x,
          distribution = "ABC Posterior",
          density = post_dens$y
        ) 
      )
      
      ggplot(df, aes(x=p, y=density, color=distribution)) + 
        geom_line(size=2) + 
        scale_color_manual(values = c("#7fc97f", "#beaed4", "#dfc086", "#e78ac3"))
    })
  }
)


