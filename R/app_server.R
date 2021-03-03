#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic
  mod_upload_server("upload_ui_1")
  mod_qc_pca_server("qc_pca_ui_1")
  mod_qc_heat1000_server("qc_heat1000_ui_1")
  mod_qc_heatcor_server("qc_heatcor_ui_1")
}
