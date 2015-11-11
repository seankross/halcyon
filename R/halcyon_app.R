#' Halcyon App
#'
#' @importFrom dplyr group_by summarise
#' @importFrom shiny shinyApp headerPanel sidebarPanel sliderInput mainPanel uiOutput pageWithSidebar reactive
#' @importFrom ggvis ggvis layer_lines layer_points ggvisOutput bind_shiny
#' @export
halcyon_app <- function(outfmt10, ocf = function(x){as.numeric(quantile(x)[4])*1.5}){
  check_outfmt10(outfmt10)
  if(!("mscore" %in% colnames(outfmt10))){stop("Please specify mscore.")}
  
  shinyApp(
    ui = pageWithSidebar(
      headerPanel("Halcyon App"),
      sidebarPanel(
        sliderInput("cutoff", "m-score cutoff", 0, floor(max(outfmt10$mscore)), 1)
      ),
      mainPanel(
        uiOutput("ggvis_ui"),
        ggvisOutput("ggvis")
      )), 
    server = function(input, output) {
      # Percent OTUs with at least one hit at m-score cutoffs 0, 1, 2, ...
      withProgress(message = "Calculating Cutoffs", value = 0, {
        pOTU_1h <- sapply(0:floor(max(outfmt10$mscore)), function(x){
          incProgress(1/length(0:floor(max(outfmt10$mscore))))
          at_least_1 <- outfmt10 %>%
            group_by(qseqid) %>%
            # n in group greater than
            summarise(ngrt = sum(mscore > x))
          sum(at_least_1$ngrt > 1)/nrow(at_least_1)
        })
      })
      
      withProgress(message = "Calculating Outliers", value = 0, {
        # Percent OTUs with at least one outlier at m-score cutoffs 0, 1, 2, ...
        pOTU_1out <- sapply(0:floor(max(outfmt10$mscore)), function(x){
          incProgress(1/length(0:floor(max(outfmt10$mscore))))
          threshold_tbl <- outfmt10 %>%
            group_by(qseqid) %>%
            summarise(threshold = ocf(mscore))
          
          at_least_1 <- outfmt10 %>%
            left_join()
          group_by(qseqid) %>%
            # n in group greater than
            summarise(ngrt = sum(mscore > x))
          
          # n in group greater than
          summarise(ngrt = sum(mscore > ocf(.$mscore)))
          sum(at_least_1$ngrt > 1)/nrow(at_least_1)
        })
      })
      
      
      vis <- reactive({
        x <- input$cutoff
        y <- pOTU_1h[input$cutoff + 1]
        
        data.frame(mscore = 0:floor(max(outfmt10$mscore)), 
                   percent_of_OTUs_with_at_least_one_hit = pOTU_1h) %>% 
          ggvis(~mscore, ~percent_of_OTUs_with_at_least_one_hit) %>%
          layer_lines() %>%
          layer_points(~x, ~y, size = 1) %>%
          add_axis("x", title = "m-score", title_offset = 50) %>%
          add_axis("y", title = "% OTUs with at least one hit", title_offset = 50)
      })  
      
      vis %>% bind_shiny("ggvis", "ggvis_ui")
    }
  )
}