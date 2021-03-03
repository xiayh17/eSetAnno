#' qc_pca UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_qc_pca_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(6,sliderInput(ns("height"),"Height", min = 100, max = 1000, value = 300)),
      column(6, sliderInput(ns("width"), "Width", min = 100, max = 1000, value = 400))
    ),
    downloadLink(ns('dlpcaPlot'), 'Download plot as PDF'),
    shinycustomloader::withLoader(
      plotOutput(ns("pca"))
    )


  )
}

#' qc_pca Server Functions
#'
#' @noRd
mod_qc_pca_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    load(file = 'tests/step1-output.Rdata')

    t.dat <- reactive({
      dat=t(dat)
      as.data.frame(dat)
    })

    dat.pca <- reactive({
      dat <- t.dat()
      FactoMineR::PCA(dat, graph = FALSE)
    })

    pcaplot <- function() {
      dat.pca <- dat.pca()
      factoextra::fviz_pca_ind(dat.pca,
                               geom.ind = "point", # show points only (nbut not "text")
                               col.ind =  group_list, # color by groups
                               addEllipses = T,
                               legend.title = "Groups"
      )
    }

    output$pca <- renderPlot(width = function() input$width,
                             height = function() input$height,
                             res = 100,
                             {
                               pcaplot()
                             })

    # Create the button to download the plot as PDF
    output$dlpcaPlot <- downloadHandler(
      filename = function() {
        paste('pcaPlot_', Sys.Date(), '.pdf', sep='')
      },
      content = function(file) {
        ggplot2::ggsave(file, pcaplot(), width = input$width/100, height = input$height/100, dpi = 300, units = "in", limitsize = FALSE)
      }
    )
  })
}

## To be copied in the UI
# mod_qc_pca_ui("qc_pca_ui_1")

## To be copied in the server
# mod_qc_pca_server("qc_pca_ui_1")
