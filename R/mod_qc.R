#' qc UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_qc_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::tabsetPanel(
      id = NULL,
      tabPanel(
        "Principal component analysis",
        icon = icon("spa"),
        mod_qc_pca_ui("qc_pca_ui_1")
      ),
      tabPanel(
        "Heatmaps of the Top 1000 Genes",
        icon = icon("autoprefixer"),
        mod_qc_heat1000_ui("qc_heat1000_ui_1")
      ),
      tabPanel(
        "Heatmaps of the Correlation Matrix",
        icon = icon("octopus-deploy"),
        mod_qc_heatcor_ui("qc_heatcor_ui_1")
      )
    )
  )
}

#' qc Server Functions
#'
#' @noRd
mod_qc_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
  })
}

## To be copied in the UI
# mod_qc_ui("qc_ui_1")

## To be copied in the server
# mod_qc_server("qc_ui_1")
