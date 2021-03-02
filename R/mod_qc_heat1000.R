#' qc_heat1000 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_qc_heat1000_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' qc_heat1000 Server Functions
#'
#' @noRd 
mod_qc_heat1000_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_qc_heat1000_ui("qc_heat1000_ui_1")
    
## To be copied in the server
# mod_qc_heat1000_server("qc_heat1000_ui_1")
