#' deg_wheretocut UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
# button1 <-
# echarts4r theme #3d444c
mod_deg_wheretocut_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyjs::useShinyjs(),
    fluidRow(
      column(12,
             helpText("The False Discovery Rate (FDR) in the summary statistics table"),
             shinyWidgets::prettyRadioButtons(
               inputId = ns("fdrType"),
               label = "Choices False Discovery Rate : ",
               choices = c("adj.P.Val" = "adj.P.Val", "P.Value" = "P.Value"),
               selected = "P.Value",
               icon = icon("eye-dropper"),
               bigger = TRUE,
               inline = TRUE,
               fill = TRUE,
               plain = TRUE,
               status = "success",
               animation = "pulse"
             )
      )
    ),
    fluidRow(
      column(4,
             helpText("The minimum starting FDR cutoff to be checked"),
             sliderInput(ns("p.min"), "p.min", min = 0, max = 0.2, value = 0.01, step=0.001)
            ),
      column(4,
             helpText("The maximum starting FDR cutoff to be checked"),
             sliderInput(ns("p.max"), "p.max", min = 0, max = 0.2, value = 0.2, step=0.001)
             ),
      column(4,
             helpText("The step from the minimum to maximum FDR cutoff"),
             sliderInput(ns("p.step"), "p.step", min = 0, max = 0.2, value = 0.005, step=0.001)
      ),
      column(4,
             helpText("The minimum starting fold change cutoff to be checked"),
             sliderInput(ns("FCmin"), "FCmin", min = 0, max = 4, value = 2, step=0.1)
            ),
      column(4,
             helpText("The maximum fold change cutoff to be checked"),
             sliderInput(ns("FCmax"), "FCmax", min = 0, max = 4, value = 4, step=0.1)
             ),
      column(4,
             helpText("The step from the minimum to maximum fold change cutoff"),
             sliderInput(ns("step"), "Step", min = 0, max = 1, value = 0.1)
            )
    ),
    hr(),
    helpText("After all be set properly, Click to Start Analysis"),
    actionButton(ns("start"),"Start Analysis"),
    hr(),
    downloadLink(ns('dlcutData'), 'Download Analysis Data as CSV'),
    hr(),
    #div(id = ns('show_3d'), plotly::plotlyOutput(ns("cutoff3d"))) %>% shinycustomloader::withLoader() %>% shinyjs::hidden(),
    # plotly::plotlyOutput(ns("cutoff3d")),
    shinyjs::hidden(div(id = ns("show_3d"),plotly::plotlyOutput(ns("cutoff3d")))),
    # div(id = ns('show_3d'), plotOutput(ns("cutoff3d")) %>% shinycssloaders::withSpinner(type = 6)) %>% shinyjs::hide(),
    #plotly::plotlyOutput(ns("cutoff3d")),
    hr(),
    fluidRow(
      column(4,
             sliderInput(ns("height"),"Height of plot", min = 100, max = 1000, value = 400)
             ),
      column(4,
             sliderInput(ns("width"), "Width of plot", min = 100, max = 1200, value = 800)
             )
    ),
    downloadLink(ns('dlbarPlot'), 'Download Plot as PDF'),
    #div(id = ns('show_bar'), plotOutput(ns("cutoffbar"))) %>% shinycustomloader::withLoader() %>% shinyjs::hidden()
    plotOutput(ns("cutoffbar"))
  )
}

#' deg_wheretocut Server Functions
#' @importFrom ggplot2 ggsave ggplot geom_bar geom_text aes theme theme_minimal labs position_dodge element_text scale_fill_viridis_d facet_grid xlab ylab
#' @noRd
mod_deg_wheretocut_server <- function(id,deg_data=""){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    df <- reactive({
      df <- deg_data$deg()
    })

    #output$cutoff3d <- renderUI({plotly::plotlyOutput(ns("cutoff3d"))})

    analyseData <- function(df) {
      cutoff.result <- reactive({
        cutdata <- RVA::plot_cutoff(data = df,
                                    FCflag = "logFC",
                                    FDRflag = input$fdrType,
                                    FCmin = input$FCmin,
                                    FCmax = input$FCmax,
                                    FCstep = input$step,
                                    p.min = input$p.min,
                                    p.max = input$p.max,
                                    p.step = input$p.step,
                                    gen.plot = TRUE,
                                    gen.3d.plot = TRUE)
        cutdata[-3]
      })

      return(
        list(
          cutoff.result = reactive({
            cutoff.result()
          })
        )
      )
    }

    plotbar <- function(cutoff.result) {
      FCs <- seq(from = input$FCmin, to = input$FCmax, by = input$step)
      pvalues <- c(0.01, 0.05, 0.1, 0.2)
      data <- cutoff.result
      df.sub <- data[[1]] %>%
        dplyr::filter(.data$FC %in% FCs, .data$pvalue %in% c(0.01, 0.05, 0.1, 0.2))

      ggplot(df.sub, aes(x=.data$FC, y=.data$Number_of_Genes, fill=.data$pvalue)) +
        geom_bar(stat="identity", position=position_dodge()) +
        geom_text(aes(label=.data$Number_of_Genes), vjust=0.5, color="black",hjust = "left",
                  position = position_dodge(0.9), size=3.5, angle = 90) +
        labs(x = "logFC", fill = input$fdrType) +
        ylab("Number of Genes under cutoff") +
        xlab("FC") +
        labs(fill = 'FDR') +
        theme(strip.text.y = element_text(angle = 0)) +
        scale_fill_viridis_d()
    }


    observeEvent(input$start, {
      shinyjs::show("show_3d")
      df <- df()
      # analyse data for plot
      result <- analyseData(df)
      cutoff.result <- result$cutoff.result()

      # plot 3d
      output$cutoff3d <- plotly::renderPlotly({
        cutoff.result[[2]]
      })
      # plot bar
      # shinyjs::show("show_bar")
      output$cutoffbar <- renderPlot(
        width = function() input$width,
        height = function() input$height,
        res = 100,
        {
          plotbar(cutoff.result)
        })

      # output$dlbarPlot <- downloadHandler(
      #   filename = function() {
      #     paste('cutPlot_', Sys.Date(), '.pdf', sep='')
      #   },
      #   content = function(file) {
      #     ggplot2::ggsave(file, plot, width = input$width/100, height = input$height/100, dpi = 300, units = "in", limitsize = FALSE)
      #   }
      # )
      #
      # output$dlcutData <- downloadHandler(
      #   filename = "cutAnalysis_table.csv",
      #   content = utils::write.csv(cutoff.result[[1]],row.names = F)
      # )
    })

  })
}

## To be copied in the UI
# mod_deg_wheretocut_ui("deg_wheretocut_ui_1")

## To be copied in the server
# mod_deg_wheretocut_server("deg_wheretocut_ui_1")
