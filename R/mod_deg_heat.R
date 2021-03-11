#' deg_heat UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
assignInNamespace("pheatmap", ComplexHeatmap::pheatmap, ns = "pheatmap")
mod_deg_heat_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(3,shinyWidgets::materialSwitch(
        inputId = ns("colname"),
        label = "Shown Column Names",
        value = FALSE,
        status = "success"
      )),
      column(3,shinyWidgets::materialSwitch(
        inputId = ns("rowname"),
        label = "Shown Row Names",
        value = FALSE,
        status = "success"
      )),
      column(3,shinyWidgets::materialSwitch(
        inputId = ns("clusc"),
        label = "Cluster Columns",
        value = TRUE,
        status = "success"
      )),
      column(3,shinyWidgets::materialSwitch(
        inputId = ns("clusr"),
        label = "Cluster Rows",
        value = TRUE,
        status = "success"
      )),
      column(6,sliderInput(ns("head"),"Head Genes of LogFC", min = 1, max = 1000, value = 100)),
      column(6,sliderInput(ns("tail"), "Tail Genes of LogFC", min = 1, max = 1000, value = 100)),
      column(6,sliderInput(ns("height"),"Height", min = 100, max = 1000, value = 400)),
      column(6,sliderInput(ns("width"), "Width", min = 100, max = 1500, value = 800))
    ),
    downloadLink(ns('dlheatPlot'), 'Download plot as PDF'),
    plotOutput(ns("heat")) %>% shinycustomloader::withLoader()
  )
}

#' deg_heat Server Functions
#' @importFrom utils head
#' @importFrom utils tail
mod_deg_heat_server <- function(id,deg_data="",updata=""){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    #load(file = 'tests/step1-output.Rdata')

    dat <- reactive({
      updata$genes_expr()
    })

    group_list <- reactive({
      updata$group_list()
    })

    n <- reactive({
      dat <- dat()
      deg <- deg_data$deg()
      x=deg$logFC
      names(x)=rownames(deg)
      cg=c(names(head(sort(x),input$head)),#对x进行从小到大排列，取前100及后100，并取其对应的探针名，作为向量赋值给cg
           names(tail(sort(x),input$tail)))
      n=t(scale(t(dat[cg,])))
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
    #assignInNamespace("pheatmap", ComplexHeatmap::pheatmap, ns = "pheatmap")
    plotheat <- function() {
      n <- n()
      ac <- ac()
      p <- ComplexHeatmap::pheatmap(n,
                              show_colnames =input$colname,
                              show_rownames = input$rowname,
                              cluster_rows = input$clusr,
                              cluster_cols = input$clusc,
                              annotation_col=ac)
      p
    }

    output$heat <- renderPlot(
      width = function() input$width,
      height = function() input$height,
      res = 100,
      {
        plotheat()
      })

    # Create the button to download the plot as PDF
    output$dlheatPlot <- downloadHandler(
      filename = function() {
        paste('heatmapPlot_', Sys.Date(), '.pdf', sep='')
      },
      content = function(file) {
        ggplot2::ggsave(file, plotheat(), width = input$width/100, height = input$height/100, dpi = 300, units = "in")
      }
    )

  })
}

## To be copied in the UI
# mod_deg_heat_ui("deg_heat_ui_1")

## To be copied in the server
# mod_deg_heat_server("deg_heat_ui_1")
