#' deg_volcanol UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_deg_volcanol_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' deg_volcanol Server Functions
#'
#' @noRd 
mod_deg_volcanol_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_deg_volcanol_ui("deg_volcanol_ui_1")
    
## To be copied in the server
# mod_deg_volcanol_server("deg_volcanol_ui_1")
