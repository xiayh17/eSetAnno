#' deg_volcanol UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_deg_volcanol_ui <- function(id){
  ns <- NS(id)
  tagList(
  fluidRow(
    column(6,sliderInput(ns("pvaluecut"), "P Value for stable", min = 0.01, max = 0.05,value = 0.01, step = 0.5)),
    column(6,sliderInput(ns("logFCcut"), "logFC for up genes", min = 0.5, max = 2,value = 0.5, step = 0.5)),
    column(6,sliderInput(ns("height"),"Height", min = 100, max = 1000, value = 874)),
    column(6,sliderInput(ns("width"), "Width", min = 100, max = 1500, value = 1240))
  ),
  downloadLink(ns('dlvolPlot'), 'Download plot as PDF'),
  plotOutput(ns("volcanoPlot")) %>% shinycustomloader::withLoader()
  #plotOutput(ns("maPlot")),

  )
}

#' deg_volcanol Server Functions
#'
#' @noRd
mod_deg_volcanol_server <- function(id,deg_data=""){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    df <- reactive({
      df <- deg_data$deg()
      df$v <- -log10(df$P.Value) #df新增加一列'v',值为-log10(P.Value)
      df$g=ifelse(df$P.Value>input$pvaluecut,'stable', #if 判断：如果这一基因的P.Value>0.01，则为stable基因
                  ifelse( df$logFC >input$logFCcut,'up', #接上句else 否则：接下来开始判断那些P.Value<0.01的基因，再if 判断：如果logFC >1.5,则为up（上调）基因
                          ifelse( df$logFC <input$logFCcut,'down','stable') )#接上句else 否则：接下来开始判断那些logFC <1.5 的基因，再if 判断：如果logFC <1.5，则为down（下调）基因，否则为stable基因
      )
      df
    })

    plotvol <- function() {
      df <- df()
      EnhancedVolcano::EnhancedVolcano(df,
                                       lab = rownames(df),
                                       x = 'logFC',
                                       y = 'P.Value', pCutoff = input$pvaluecut, FCcutoff = input$logFCcut)
    }

    output$volcanoPlot <- renderPlot(width = function() input$width,
                                     height = function() input$height,
                                     res = 100,
                                     {
                                       plotvol()
    })

    # Create the button to download the plot as PDF
    output$dlvolPlot <- downloadHandler(
      filename = function() {
        paste('volcanoPlot_', Sys.Date(), '.pdf', sep='')
      },
      content = function(file) {
        ggplot2::ggsave(file, plotvol(), width = input$width/100, height = input$height/100, dpi = 300, units = "in", limitsize = FALSE)
      }
    )

  })
}

## To be copied in the UI
# mod_deg_volcanol_ui("deg_volcanol_ui_1")

## To be copied in the server
# mod_deg_volcanol_server("deg_volcanol_ui_1")
