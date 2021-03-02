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
    plotOutput(ns("pca")),
    downloadLink(ns('dlScatPlot'), 'Download plot as PDF')
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

    output$pca <- renderPlot({
      pcaplot()
    })

    # Create the button to download the scatterplot as PDF
    output$dlScatPlot <- downloadHandler(
      filename = function() {
        paste('pcaPlot_', Sys.Date(), '.pdf', sep='')
      },
      content = function(file) {
        ggplot2::ggsave(file, pcaplot(), width = 11, height = 4, dpi = 300, units = "in")
      }
    )
  })
}

## To be copied in the UI
# mod_qc_pca_ui("qc_pca_ui_1")

## To be copied in the server
# mod_qc_pca_server("qc_pca_ui_1")
