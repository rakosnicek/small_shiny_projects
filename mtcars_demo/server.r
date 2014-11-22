mtc <- mtcars
mtc$id <- 1:nrow(mtc)  # Add an id column to use ask the key

library(shiny)
shinyServer(function(input, output, session) {
 
  get_id <- function(x) {
    if(is.null(x)) return(NULL)
    sel <- x["id"]
    updateTextInput(session, "selected", value = paste(sel))
    NULL
  }
  
  # myplot1
  reactive({
    mtc %>%   
      transform(red = id == as.numeric(input$selected)) %>%
      ggvis(x=~mpg, y=~disp, fill=~factor(red), key := ~id, size :=100) %>% 
      layer_points() %>% 
      hide_legend("fill") %>% hide_legend("size") %>%
      add_tooltip(get_id, "click")}) %>% bind_shiny("myplot1")
    
  # myplot2
  reactive({ 
    mtc %>%   
      transform(red = id == as.numeric(input$selected)) %>%
      ggvis(x=~mpg, y=~drat, fill=~factor(red), key := ~id, size :=100) %>% 
      layer_points() %>% 
      hide_legend("fill") %>% hide_legend("size") %>%
      add_tooltip(get_id, "click")}) %>% bind_shiny("myplot2")
  
})
