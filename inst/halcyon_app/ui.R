shinyUI(pageWithSidebar(
  headerPanel("Halcyon App"),
  sidebarPanel(
    sliderInput("size", "Area", 1, 100, 1)
  ),
  mainPanel(
    uiOutput("ggvis_ui"),
    ggvisOutput("ggvis"),
    uiOutput("ggvis_ui1"),
    ggvisOutput("ggvis1")
  )
))