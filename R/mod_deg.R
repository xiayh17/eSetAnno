#' deg UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_deg_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' deg Server Functions
#'
#' @noRd 
mod_deg_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_deg_ui("deg_ui_1")
    
## To be copied in the server
# mod_deg_server("deg_ui_1")
