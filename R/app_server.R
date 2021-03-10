#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic
  updata <- mod_upload_server("upload_ui_1")
  mod_qc_pca_server("qc_pca_ui_1",updata=updata)
  mod_qc_heat1000_server("qc_heat1000_ui_1")
  mod_qc_heatcor_server("qc_heatcor_ui_1")
  deg_data <- mod_deg_matrix_server("deg_matrix_ui_1")
  mod_deg_wheretocut_server("deg_wheretocut_ui_1", deg_data=deg_data)
  mod_deg_ma_server("deg_ma_ui_1", deg_data=deg_data)
  mod_deg_volcanol_server("deg_volcanol_ui_1", deg_data=deg_data)
  mod_deg_heat_server("deg_heat_ui_1", deg_data=deg_data)
}
