#' upload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_upload_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::bs4Card(
      title = "Expression matrix Upload",
      width = NULL,
      maximizable = TRUE,
      boxToolSize = "xs",
      elevation = 3,
      headerBorder = FALSE,
      downloadLink(ns("matrix"),"example matrix file"),
      fileInput(ns("matrix"), "Upload your file ONLY IN txt format", accept = ".txt")
    ),
    bs4Dash::bs4Card(
      title = "Group Info Upload",
      width = NULL,
      maximizable = TRUE,
      boxToolSize = "xs",
      elevation = 3,
      headerBorder = FALSE,
      downloadLink(ns("grouplist.csv"),"example group file"),
      fileInput(ns("grouplist"), "Upload your file ONLY IN csv format", accept = ".csv")
    )
  )
}

#' upload Server Functions
#'
#' @noRd
mod_upload_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$matrix <- downloadHandler(
      filename = 'GSE42872_series_matrix.txt.gz',
      content = function(file) {
        file.copy('inst/app/www/GSE42872_series_matrix.txt.gz',file)
      }
      )
    output$grouplist.csv <-downloadHandler(
      filename = 'grouplist.csv',
      content = function(file) {
        file.copy('inst/app/www/grouplist.csv',file)
      }
    )
  }
              )
                                }

## To be copied in the UI
# mod_upload_ui("upload_ui_1")

## To be copied in the server
# mod_upload_server("upload_ui_1")
