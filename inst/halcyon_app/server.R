shinyServer(function(input, output) {

  vis <- reactive({
    mn <- data.frame(m = seq(100, 1, -1), n = seq(100, 1, -1))
    x <- input$size
    b_ <- input$size

    data.frame(a = 1:100, b = 1:100) %>% 
      ggvis(~a, ~b) %>%
      layer_lines() %>%
      layer_points(~x, ~b_, size = 1)
  })  
  
  vis %>% bind_shiny("ggvis", "ggvis_ui")
  
  vis1 <- reactive({
    mn <- data.frame(m = seq(100, 1, -1), n = seq(100, 1, -1))
    x <- input$size
    b_ <- input$size
    
    data.frame(a = 1:100, b = 1:100) %>% 
      ggvis(~a, ~b) %>%
      layer_lines() %>%
      layer_points(~x, ~b_, size = 1)
  })  
  
  vis1 %>% bind_shiny("ggvis1", "ggvis_ui1")

})