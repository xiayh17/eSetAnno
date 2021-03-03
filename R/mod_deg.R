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
      width = NULL,
      height = 1300,
      side = "right",
      collapsible = TRUE,
      collapsed = FALSE,
      closable = FALSE,
      maximizable = TRUE,
      type = "tabs",
      tabPanel(
<<<<<<< HEAD
        "Matrix",
        icon = icon("calculator"),
        mod_deg_matrix_ui("deg_matrix_ui_1")
      ),
      tabPanel(
        "Volcanol",
        icon = icon("crosshairs"),
        mod_deg_volcanol_ui("deg_volcanol_ui_1")
      ),
      tabPanel(
        "Heatmap",
        icon = icon("map-signs"),
        mod_deg_heat_ui("deg_heat_ui_1")
=======
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
>>>>>>> 925a23963840062f45d65cfd77e67352da6d86d5
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
