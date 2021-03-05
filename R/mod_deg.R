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
    bs4Dash::bs4TabCard(
      id = NULL,
      status = "success",
      solidHeader = FALSE,
      background = NULL,
      width = 12,
      height = NULL,
      side = "right",
      collapsible = TRUE,
      collapsed = FALSE,
      closable = FALSE,
      maximizable = TRUE,
      type = "tabs",
      tabPanel(
        "Matrix",
        icon = icon("calculator"),
        mod_deg_matrix_ui("deg_matrix_ui_1")
      ),
      tabPanel(
        "Where to Cut",
        icon = icon("utensils"),
        mod_deg_wheretocut_ui("deg_wheretocut_ui_1")
      ),
      tabPanel(
        "Volcano",
        icon = icon("crosshairs"),
        mod_deg_volcanol_ui("deg_volcanol_ui_1")
      ),
      tabPanel(
        "Heatmap",
        icon = icon("map-signs"),
        mod_deg_heat_ui("deg_heat_ui_1")
      )
    )
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
