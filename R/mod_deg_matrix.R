#' deg_matrix UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_deg_matrix_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' deg_matrix Server Functions
#'
#' @noRd 
mod_deg_matrix_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_deg_matrix_ui("deg_matrix_ui_1")
    
## To be copied in the server
# mod_deg_matrix_server("deg_matrix_ui_1")
