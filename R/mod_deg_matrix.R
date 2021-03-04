#' deg_matrix UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_deg_matrix_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::bs4Card(
      label = "Expression Matrix",
      width = 12,
      height = NULL,
      DT::DTOutput(ns("pretable"))
    )



    # uiOutput(ns("boxControls")),
    # shinycustomloader::withLoader(
    #   plotOutput(ns("boxtest"))
    # )
  )
}

#' deg_matrix Server Functions
#'
#' @noRd
mod_deg_matrix_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    load(file = 'tests/step1-output.Rdata')

    options(digits = 4)

    design <- reactive({
      stats::model.matrix(~factor( group_list ))
    })

    fit <- reactive({
      design <- design()
      fit <- limma::lmFit(dat,design)
      limma::eBayes(fit)
    })

    deg <- reactive({
      fit = fit()
      limma::topTable(fit,coef=2,adjust='BH',number = Inf)
    })

    output$dldegtable <- downloadHandler(
      deg <- deg(),
      filename = "DEG_table.csv",
      content = utils::write.csv(deg,row.names = F)
    )
    output$pretable <- DT::renderDT({
      DT::datatable( deg(), escape = FALSE,filter="top", selection="multiple",
                     rownames = TRUE,
                     style = "bootstrap4",
                     options=list(
                       sDom  = '<"top">flrt<"bottom">ip',
                       #columnDefs = list(list(className = 'dt-center', targets = 5)),
                       pageLength = 15,
                       lengthMenu = list(c(15, 50, 100, -1),c(15, 50, 100, "ALL")),
                       dom = 'Blfrtip',
                       scrollX = TRUE,
                       scrollY = TRUE,
                       fixedColumns = TRUE,
                       fixedHeader = TRUE
                     )
      )
    })

    return(
      list(
        deg = reactive({
          deg()
        })
      )
    )

  })
}

## To be copied in the UI
# mod_deg_matrix_ui("deg_matrix_ui_1")

## To be copied in the server
# mod_deg_matrix_server("deg_matrix_ui_1")
