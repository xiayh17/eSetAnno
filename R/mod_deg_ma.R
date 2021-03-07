#' deg_ma UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_deg_ma_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(6,sliderInput(ns("height"),"Height", min = 100, max = 420, value = 400)),
      column(6,sliderInput(ns("width"), "Width", min = 100, max = 1500, value = 800))
    ),
    downloadLink(ns('dlmaPlot'), 'Download plot as PDF'),
    fluidRow(
      column(12,plotOutput(ns("ma")) %>% shinycustomloader::withLoader()),
      column(12,hr(),
             helpText("Explore your data with mouse"),
             ggiraph::girafeOutput(ns("plot")))
    )
  )
}

#' deg_ma Server Functions
#' @importFrom ggplot2 ggsave ggplot geom_point aes theme theme_bw scale_y_continuous scale_colour_manual element_text geom_hline element_rect guides guide_legend labs
#' @noRd
mod_deg_ma_server <- function(id,deg_data=""){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    df <- reactive({
      df <- deg_data$deg()
      df$name=rownames(df)
      df$p_c = ifelse(df$P.Value<0.001,'p<0.001',
                      ifelse(df$P.Value<0.01,'0.001<p<0.01','p>0.01'))
      df$onclick <- sprintf("window.open(\"%s%s\")","https://www.genecards.org/cgi-bin/carddisp.pl?gene=", df$name)
      df
    })

    plotma <- function() {
      df <- df()
      statinfo <- table(df$p_c)
      statname <- names(statinfo)
      ggplot(df, aes(AveExpr, logFC, colour=p_c)) +
        geom_point(size=1,alpha=1) +
        scale_y_continuous(limits=c(-4, 4)) +
        scale_colour_manual(name = "FDR Cut",
                            values=c('#fc8d59','#91bfdb','#ffffbf'),
                            breaks = c('p<0.001','0.001<p<0.01','p>0.01')) +
        geom_hline(yintercept = 0, colour="darkorchid4", size=1, linetype="longdash") +
        theme_bw() +
        theme(
          plot.subtitle = element_text(family = "mono"),
          plot.caption = element_text(family = "mono"),
          axis.title = element_text(family = "mono", size = 18),
          axis.text = element_text(family = "mono", size = 16),
          plot.title = element_text(family = "mono", size = 18),
          legend.text = element_text(size = 14, family = "mono"),
          legend.title = element_text(size = 16, family = "mono"),
          legend.key = element_rect(fill = "lightgrey", color = NA),
          legend.position = "top",
          legend.direction = "horizontal") +
        guides(color = guide_legend(override.aes = list(size=5))) +
        labs(colour = NULL, subtitle = "MA-plot", caption = (paste0("Total ",length(df$p_c), "\n",
                                                                    statname[1], "  ", statinfo[1], "\n",
                                                                    statname[2], "  ", statinfo[2], "\n",
                                                                    statname[3], "  ", statinfo[3], "\n")))
    }

    output$ma <- renderPlot(width = function() input$width,
                            height = function() input$height,
                            res = 100,
                            {
                              plotma()
                            })

    # Create the button to download the plot as PDF
    output$dlmaPlot <- downloadHandler(
      filename = function() {
        paste('maPlot_', Sys.Date(), '.pdf', sep='')
      },
      content = function(file) {
        ggplot2::ggsave(file, plotma(), width = input$width/100, height = input$height/100, dpi = 300, units = "in", limitsize = FALSE)
      }
    )

    plotmaI <- function() {
      df <- df()
      statinfo <- table(df$p_c)
      statname <- names(statinfo)
      ggplot(df, aes(AveExpr, logFC, colour=p_c, tooltip = name,
                     data_id = name,onclick=onclick)) +
        ggiraph::geom_point_interactive(size=1.5,alpha=0.6) +
        scale_y_continuous(limits=c(-4, 4)) +
        scale_colour_manual(name = "FDR Cut",
                            values=c('#fc8d59','#91bfdb','#ffffbf'),
                            breaks = c('p<0.001','0.001<p<0.01','p>0.01')) +
        geom_hline(yintercept = 0, colour="darkorchid4", size=1, linetype="longdash") +
        theme_bw() +
        theme(
          plot.subtitle = element_text(family = "mono"),
          plot.caption = element_text(family = "mono"),
          axis.title = element_text(family = "mono", size = 18),
          axis.text = element_text(family = "mono", size = 16),
          plot.title = element_text(family = "mono", size = 18),
          legend.text = element_text(size = 14, family = "mono"),
          legend.title = element_text(size = 16, family = "mono"),
          legend.key = element_rect(fill = "lightgrey", color = NA),
          legend.position = "top",
          legend.direction = "horizontal") +
        guides(color = guide_legend(override.aes = list(size=5))) +
        labs(colour = NULL, subtitle = "MA-plot", caption = (paste0("Total ",length(df$p_c), "\n",
                                                                    statname[1], "  ", statinfo[1], "\n",
                                                                    statname[2], "  ", statinfo[2], "\n",
                                                                    statname[3], "  ", statinfo[3], "\n")))
    }

    output$plot <- ggiraph::renderGirafe({
      ggiraph::girafe(ggobj = plotmaI(),width_svg=input$width/100, height_svg=input$height/100)
    })
  })
}

## To be copied in the UI
# mod_deg_ma_ui("deg_ma_ui_1")

## To be copied in the server
# mod_deg_ma_server("deg_ma_ui_1")
