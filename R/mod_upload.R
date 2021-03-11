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
      checkboxInput(ns("normarry"), "normalizeBetweenArrays",value = FALSE),
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
        mode(dat)="numeric"
<<<<<<< HEAD
        if(input$normarry) {
          limma::normalizeBetweenArrays(dat)
        } else {
          dat
        }
    }) # return the matrix if normalization
=======
        limma::normalizeBetweenArrays(dat)
    }) # return the matrix after normalization
>>>>>>> 917fc4b932ceb47c93f648911007f3cea1681e28
    genes_expr <- reactive({
      genes_expr <- matrix()
      if(input$log) {
        log(genes_expr)
      } else {
        genes_expr
      }
    })#access the expression of assay data and do log step or not
    group_list <- reactive({
      file <- input$grouplist
      ext <- tools::file_ext(file$datapath)
      req(file)
      #if the file format is not .csv,then put the hint line:Please upload your matrix in csv format file
      validate(need(ext == "csv", "Please upload your matrix in csv format file"))
      group_list=vroom::vroom(file$datapath,delim = ",")
      n_index <- data.frame(
        ID = colnames(matrix()),
        inx = 1:ncol(matrix())
      )
      group_list <- merge(n_index,group_list,by="ID")
      group_list <- group_list[order(group_list$inx),]
      group_list[,-2]
    })


      # boxplot -----------------------------------------------------------------
      output$boxplot1 <- renderPlot({
        genes_expr <- genes_expr()
        par(mar = c(6,2,2,2))
        boxplot(genes_expr,las=2)
      })


    output$preview1 <- DT::renderDataTable({
      DT::datatable( group_list(),
                     rownames = FALSE,
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

    # load(file = 'tests/step1-output.Rdata')
    #
    # dd <- data.frame(
    #   ID = colnames(dat),
    #   group = group_list
    # )
    #
    # write.csv(dat,file = "inst/app/www/matrix.csv")
    # write.csv(dd,file = "inst/app/www/grouplist.csv", row.names = FALSE)


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

<<<<<<< HEAD
    group_list2 <- reactive({
      group_list <- group_list()
      group_list[,2]
=======
    dat <- reactive({
>>>>>>> 917fc4b932ceb47c93f648911007f3cea1681e28

    })

    return(
      list(
        genes_expr = reactive({
          genes_expr()
        }),
        group_list = reactive({
<<<<<<< HEAD
          group_list2()
=======
          group_list()
>>>>>>> 917fc4b932ceb47c93f648911007f3cea1681e28
        })
      )
    )

  }) #download example group list
}
## To be copied in the UI
# mod_upload_ui("upload_ui_1")

## To be copied in the server
# mod_upload_server("upload_ui_1")
