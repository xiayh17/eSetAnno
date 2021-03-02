#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic
  mod_upload_server("upload_ui_1")
<<<<<<< HEAD
=======
  mod_qc_pca_server("qc_pca_ui_1")
>>>>>>> a136aa786d9f64649fd54793aa6bd8a1a61ded22
}
