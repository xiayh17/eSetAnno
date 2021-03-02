#' qc_heatcor UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_qc_heatcor_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' qc_heatcor Server Functions
#'
#' @noRd 
mod_qc_heatcor_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_qc_heatcor_ui("qc_heatcor_ui_1")
    
## To be copied in the server
# mod_qc_heatcor_server("qc_heatcor_ui_1")
