#' gsaanno UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_gsaanno_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' gsaanno Server Functions
#'
#' @noRd 
mod_gsaanno_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_gsaanno_ui("gsaanno_ui_1")
    
## To be copied in the server
# mod_gsaanno_server("gsaanno_ui_1")
