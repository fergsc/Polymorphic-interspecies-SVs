# classes of SV
SD = c("fixed-absent", "absent-fixed")
SPP = c("hete-hete")
SP = c("hete-fixed", "fixed-hete", "hete-absent", "absent-hete")
# private/error = c("absent-absent", "fixed-fixed")
# unGeno in both = c("absent-", "fixed-", "hete-", "-absent", "-fixed", "-hete")


for (csv in c("/data/association/melliodora.csv", "/data/association/sideroxylon.csv"))
{
  tmp = unlist(strsplit(csv, "/"))
  name = unlist(strsplit(tmp[length(tmp)], ".csv"))[1]
  print(name)
  
  # load in main data
  df = data.frame(read.csv(csv))
  row.names(df) = df$SV
  
  for(geno in c("/data/paragraph/inv.csv", "/data/paragraph/trans.csv"))
  {
    tmp = unlist(strsplit(geno, "/"))
    svType = unlist(strsplit(tmp[length(tmp)], "-g"))[1]
    print(sprintf(" %s",svType))
    
    dfState = data.frame(read.csv(geno))
    dfState['combined'] = paste(dfState$melliodora, dfState$sideroxylon, sep ="-")
    SD = dfState[dfState['combined'] == "fixed-absent" | dfState['combined'] == "absent-fixed",]$id
    SSP = dfState[dfState['combined'] == "hete-hete",]$id
    SP = dfState[dfState['combined'] == "hete-fixed" | dfState['combined'] == "fixed-hete" | dfState['combined'] == "hete-absent" | dfState['combined'] == "absent-hete",]$id
    
    # SD
    if(length(SD) != 0)
    {
      print("  SD")
      df2 = df[row.names(df) %in% SD,]
      df2 = df2[,!names(df) %in% c("SV", "noGeno", "homoR", "hete", "homoQ")]
      df3 = cor(t(df2), use="pairwise.complete.obs")
      df3[row(df3)==col(df3)] = NA
      df4 = df3[, colSums(is.na(df3)) < nrow(df3)]
      keep = colnames(df4)
      write.table(keep, sprintf("%s/SD-%s~%s.csv", saveDir, name, svType),quote = FALSE, row.names = FALSE, col.names = FALSE)
      df4 = df4[keep,]
      df4 = df4^2
      df4[row(df4)==col(df4)] = NA
      png(filename=sprintf("%s/SD-%s~%s.png", saveDir, name, svType), width = 2000, height = 2000, pointsize = 24)
      heatmap(df4, main = "SD", scale = "column", symm = TRUE)
      dev.off()
    }
    
    # SSP
    print("  SSP")
    df2 = df[row.names(df) %in% SSP,]
    df2 = df2[,!names(df) %in% c("SV", "noGeno", "homoR", "hete", "homoQ")]
    df3 = cor(t(df2), use="pairwise.complete.obs")
    df3[row(df3)==col(df3)] = NA
    df4 = df3[, colSums(is.na(df3)) < nrow(df3)]
    keep = colnames(df4)
    write.table(keep, sprintf("%s/SSP-%s~%s.csv", saveDir, name, svType),quote = FALSE, row.names = FALSE, col.names = FALSE)
    df4 = df4[keep,]
    df4 = df4^2
    df4[row(df4)==col(df4)] = NA
    png(filename=sprintf("%s/SSP-%s~%s.png", saveDir, name, svType), width = 2000, height = 2000, pointsize = 24)
    heatmap(df4, main = "SSP", scale = "column", symm = TRUE)
    dev.off()
    
    # SP
    print("  SP")
    df2 = df[row.names(df) %in% SP,]
    df2 = df2[,!names(df) %in% c("SV", "noGeno", "homoR", "hete", "homoQ")]
    df3 = cor(t(df2), use="pairwise.complete.obs")
    df3[row(df3)==col(df3)] = NA
    df4 = df3[, colSums(is.na(df3)) < nrow(df3)]
    keep = colnames(df4)
    write.table(keep, sprintf("%s/SP-%s~%s.csv", saveDir, name, svType),quote = FALSE, row.names = FALSE, col.names = FALSE)
    df4 = df4[keep,]
    df4 = df4^2
    df4[row(df4)==col(df4)] = NA
    png(filename=sprintf("%s/SP-%s~%s.png", saveDir, name, svType), width = 2000, height = 2000, pointsize = 24)
    heatmap(df4, main = "SP", scale = "column", symm = TRUE)
    dev.off()
    
  }
}

