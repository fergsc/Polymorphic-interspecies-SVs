# get filenames
args = commandArgs(trailingOnly = TRUE)
pcangsd = args[1]
names = args[2]
saveName = args[3]

if(is.na(pcangsd) || is.na(names) || is.na(saveName))
{
    stop("need: <PCAngsd covarince> <list of sample names> <save name>")
}

library(tidyverse)
library(ggplot2)

cov = as.matrix(read.table(pcangsd, header = F))
pop = read.table(names, header = F)$V1

pca <- eigen(cov)
eigenvectors = pca$vectors #extract eigenvectors 
pca.vectors = as_tibble(cbind(pop, data.frame(eigenvectors))) #combine with our population assignments

pca.eigenval.sum = sum(pca$values) #sum of eigenvalues
varPC1 = round((pca$values[1]/pca.eigenval.sum)*100, 2) #Variance explained by PC1
varPC2 = round((pca$values[2]/pca.eigenval.sum)*100, 2) #Variance explained by PC2
varPC3 = round((pca$values[3]/pca.eigenval.sum)*100, 2) #Variance explained by PC3
varPC4 = round((pca$values[4]/pca.eigenval.sum)*100, 2) #Variance explained by PC4

sprintf("PC1:%s", varPC1)
sprintf("PC2:%s", varPC2)
sprintf("PC3:%s", varPC3)
sprintf("PC4:%s", varPC4)

# save plot with smaple names, not dots
pcaPlot = ggplot(data = pca.vectors, aes(x=X1, y=X2, colour = pop)) +
    geom_point() +
    xlab(sprintf("PC1(%#.2f%%)", varPC1)) +
    ylab(sprintf("PC1(%#.2f%%)", varPC2)) +
    ggtitle(sprintf("E. %s", saveName)) +
    theme_linedraw() +
    theme(legend.position="none",
    plot.title = element_text(size=20, face="bold.italic")) +
    geom_text(aes(label=pop), size=2,vjust=2)
ggsave(filename = sprintf("%s~labels.png", saveName), plot = pcaPlot, height=28, width=28)

# save plot with species coloured dots, not smaple names
pcaPlot = ggplot(data = pca.vectors, aes(x=X1, y=X2, colour = pop)) +
    geom_point() +
    xlab(sprintf("PC1(%#.2f%%)", varPC1)) +
    ylab(sprintf("PC1(%#.2f%%)", varPC2)) +
    ggtitle(sprintf("E. %s", saveName)) +
    theme_linedraw() +
    theme(legend.position="none",
    plot.title = element_text(size=20, face="bold.italic")) +
ggsave(filename = sprintf("%s~pops.png", saveName), plot = pcaPlot, height=28, width=28)

