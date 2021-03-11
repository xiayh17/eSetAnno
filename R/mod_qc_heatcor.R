#' qc_heatcor UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_qc_heatcor_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(4,sliderInput(ns("height"),"Height", min = 100, max = 1000, value = 300)),
      column(2),
      column(4, sliderInput(ns("width"), "Width", min = 100, max = 1000, value = 400)),
      column(2)
    ),
    downloadLink(ns('dlcorPlot'), 'Download plot as PDF'),
    shinycustomloader::withLoader(
      plotOutput(ns("heatcor"))
    )

  )
}

#' qc_heatcor Server Functions
#' @importFrom stats mad
mod_qc_heatcor_server <- function(id,updata=""){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    #load(file = 'tests/step1-output.Rdata')

    exprSet <- reactive({
      updata$genes_expr()
    })

    group_list <- reactive({
      updata$group_list()
    })


    colD <- reactive({
      exprSet <- exprSet()
      group_list <- group_list()
      colD=data.frame(group=group_list)
      rownames(colD)=colnames(exprSet)
      colD
    })

    M <- reactive({
      exprSet <- exprSet()
      exprSet=exprSet[names(sort(apply(exprSet, 1,mad),decreasing = T)[1:500]),]
      stats::cor(exprSet)
    })

    plotcor <- function() {
      M <- M()
      colD <- colD()
      pheatmap::pheatmap(M,
                         show_rownames = F,
                         annotation_col = colD)
    }

    output$heatcor <- renderPlot(width = function() input$width,
                                 height = function() input$height,
                                 res = 100,
                                 {
                                   plotcor()
                                 })

    # Create the button to download the plot as PDF
    output$dlcorPlot <- downloadHandler(
      filename = function() {
        paste('heatcorPlot_', Sys.Date(), '.pdf', sep='')
      },
      content = function(file) {
        ggplot2::ggsave(file, plotcor(), width = input$width/100, height = input$height/100, dpi = 300, units = "in", limitsize = FALSE)
      }
    )
  })
}

## To be copied in the UI
# mod_qc_heatcor_ui("qc_heatcor_ui_1")

## To be copied in the server
# mod_qc_heatcor_server("qc_heatcor_ui_1")
