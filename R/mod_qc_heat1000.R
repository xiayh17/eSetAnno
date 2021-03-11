#' qc_heat1000 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_qc_heat1000_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(6,sliderInput(ns("height"),"Height", min = 100, max = 1000, value = 300)),
      column(6, sliderInput(ns("width"), "Width", min = 100, max = 1000, value = 400))
    ),
    downloadLink(ns('dlheatPlot'), 'Download plot as PDF'),
    shinycustomloader::withLoader(
      plotOutput(ns("heat1000"))
    )

  )
}

#' qc_heat1000 Server Functions
#' @importFrom utils head tail
#' @importFrom stats sd

mod_qc_heat1000_server <- function(id,updata=""){

  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # load(file = 'tests/step1-output.Rdata')
    dat <- reactive({
      updata$genes_expr()
    })

    group_list <- reactive({
      updata$group_list()
    })

    n <- reactive({
      dat <- dat()
      cg=names(tail(sort(apply(dat,1,sd)),1000))
      n=t(scale(t(dat[cg,]))) # 'scale'可以对log-ratio数值进行归一化
      n[n>2]=2
      n[n< -2]= -2
      n
    })

    ac <- reactive({
      n <- n()
      group_list <- group_list()
      ac <- data.frame(group=group_list)
      rownames(ac)=colnames(n)
      ac
    })

    heatmap <- function() {
      n <- n()
      ac <- ac()
      p <- pheatmap::pheatmap(n,show_colnames =F,show_rownames = F,
               annotation_col=ac)
      p
    }

    output$heat1000 <- renderPlot(
      width = function() input$width,
      height = function() input$height,
      res = 100,
      {
      heatmap()
    })

    # Create the button to download the plot as PDF
    output$dlheatPlot <- downloadHandler(
      filename = function() {
        paste('heatmap1000Plot_', Sys.Date(), '.pdf', sep='')
      },
      content = function(file) {
        ggplot2::ggsave(file, heatmap(), width = input$width/100, height = input$height/100, dpi = 300, units = "in")
      }
    )
  })
}

## To be copied in the UI
# mod_qc_heat1000_ui("qc_heat1000_ui_1")

## To be copied in the server
# mod_qc_heat1000_server("qc_heat1000_ui_1")
