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
  tagList(#upload expression matrix,download example matrix,apply boxplot
    bs4Dash::bs4Card(
      title = "Expression matrix Upload",
      width = NULL,
      maximizable = TRUE,
      boxToolSize = "xs",
      elevation = 3,
      headerBorder = FALSE,
      downloadLink(ns("matrix"),"example matrix file"),
      fileInput(ns("matrix_csv"), "Upload your file ONLY IN csv format", accept = ".csv"),
      checkboxInput(ns("log"), "log gene expression",value = FALSE),
      shinycustomloader::withLoader(plotOutput(ns("boxplot1")))
    ),
    bs4Dash::bs4Card(
      title = "Group Info Upload",
      width = NULL,
      maximizable = TRUE,
      boxToolSize = "xs",
      elevation = 3,
      headerBorder = FALSE,
      downloadLink(ns("grouplist.csv"),"example group file"),
      fileInput(ns("grouplist"), "Upload your file ONLY IN csv format", accept = ".csv"),
      DT::dataTableOutput(ns("preview1"))
    )
  )
}

#' upload Server Functions
#' @importFrom graphics par boxplot
mod_upload_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    matrix <- reactive({
        file <- input$matrix_csv
        ext <- tools::file_ext(file$datapath)
        req(file)
        #if the file format is not .csv,then put the hint line:Please upload your matrix in csv format file
        validate(need(ext == "csv", "Please upload your matrix in csv format file"))
        dat=as.matrix(vroom::vroom(file$datapath))
        rownames(dat)=dat[,1]
        dat=dat[,-1]
        dat[1:4,1:4]
        mode(dat)="numeric"
        limma::normalizeBetweenArrays(dat)
    }) # return the matrix after normalization
    probes_expr <- reactive({
      probes_expr <- matrix()
      if(input$log) {
        log(probes_expr)
      } else {
        probes_expr
      }
    })#access the expression of assay data and do log step or not
    group_list <- reactive({
      file <- input$grouplist
      ext <- tools::file_ext(file$datapath)
      req(file)
      #if the file format is not .csv,then put the hint line:Please upload your matrix in csv format file
      validate(need(ext == "csv", "Please upload your matrix in csv format file"))
      group_list=vroom::vroom(file$datapath)
      group_list[,-1]
    })


      # boxplot -----------------------------------------------------------------
      output$boxplot1 <- renderPlot({
        probes_expr <- probes_expr()
        par(mar = c(6,2,2,2))
        boxplot(probes_expr,las=2)
      })


    output$preview1 <- DT::renderDataTable({
      DT::datatable( group_list(),
                     rownames = TRUE,
                     extensions = 'Buttons',
                     options=list(
                       dom = 'Bfrtip',
                       buttons = list(list(extend ='collection',
                buttons =  c('csv', 'excel', 'pdf'),text = 'Download View')),
                       scrollX = TRUE,
                       scrollY = TRUE,
                       fixedColumns = TRUE,
                       fixedHeader = TRUE
                     )
      )
    })
    output$matrix <- downloadHandler(
      filename = 'matrix.csv',
      content = function(file) {
        file.copy('inst/app/www/matrix.csv',file)
      })#download example matrix
    output$grouplist.csv <-downloadHandler(
      filename = 'grouplist.csv',
      content = function(file) {
        file.copy('inst/app/www/grouplist.csv',file)
      })
  })
#download example group list
  return(
    list(
      probes_expr = reactive({
        probes_expr()
      }),
      group_list = reactive({
        group_list()
      })
    )
  )
}
## To be copied in the UI
# mod_upload_ui("upload_ui_1")

## To be copied in the server
# mod_upload_server("upload_ui_1")
