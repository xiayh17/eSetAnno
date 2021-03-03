#' deg_heat UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_deg_heat_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' deg_heat Server Functions
#'
#' @noRd 
mod_deg_heat_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_deg_heat_ui("deg_heat_ui_1")
    
## To be copied in the server
# mod_deg_heat_server("deg_heat_ui_1")
