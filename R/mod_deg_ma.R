#' deg_ma UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_deg_ma_ui <- function(id,deg_data=""){
  ns <- NS(id)
  tagList(

  )
}

#' deg_ma Server Functions
#'
#' @noRd
mod_deg_ma_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_deg_ma_ui("deg_ma_ui_1")

## To be copied in the server
# mod_deg_ma_server("deg_ma_ui_1")
