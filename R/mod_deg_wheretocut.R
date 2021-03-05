#' deg_wheretocut UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_deg_wheretocut_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' deg_wheretocut Server Functions
#'
#' @noRd
mod_deg_wheretocut_server <- function(id,deg_data=""){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_deg_wheretocut_ui("deg_wheretocut_ui_1")

## To be copied in the server
# mod_deg_wheretocut_server("deg_wheretocut_ui_1")
