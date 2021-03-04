bp=function(g){         #定义一个函数g，函数为{}里的内容
  df=data.frame(gene=g,stage=group_list)
  p <- ggpubr::ggboxplot(df, x = "stage", y = "gene",
                 color = "stage", palette = "jco",
                 add = "jitter")
  #  Add p-value
  p + ggpubr::stat_compare_means()
}
