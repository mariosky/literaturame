## ----setup, include=FALSE------------------------------------------------
library(ggplot2)
library("ggfortify")
library(dplyr)
library(TTR)
library(plotly)
#use 
file <- "/home/jmerelo/proyectos/literaturame/data/books/words-granada-off.csv"
# for testing here
words <- read.csv(file) # File should be established from an R script
lines <- words[-1,]
lines$Delta <- abs(lines$Delta)
lines$SMA5 <- SMA(lines$Delta,n=5)
lines$SMA10 <- SMA(lines$Delta,n=10)

## ----summary-------------------------------------------------------------
summary(lines)

## ----timeline, echo=FALSE------------------------------------------------
gg.lines = ggplot(lines)
gg.lines+geom_point(aes(x=Commit,y=Delta))
gg.lines+geom_line(aes(x=Commit,y=Delta,group=1))
gg.lines+geom_point(aes(x=Commit,y=Delta))+scale_y_log10()
gg.changes <- gg.lines+geom_line(aes(x=Commit,y=Delta,group=1))+scale_y_log10()
gg.changes
ggsave('granada-off-word-changes.png',width=1024,height=768)

## ----smoothie, echo=FALSE------------------------------------------------
gg.lines+geom_line(aes(x=Commit,y=SMA5,color='SMA5'))+geom_line(aes(x=Commit,y=SMA10,color='SMA10'))+scale_y_log10()

## ----linecount, echo=FALSE-----------------------------------------------
by.lines <- group_by(lines,Delta)
lines.count <- summarize(by.lines, count=n())
ggplot(lines.count, aes(x=Delta, y=count))+geom_point()+scale_x_log10()+scale_y_log10()

## ----powerlaw, echo=FALSE------------------------------------------------
ggplot(data=lines, aes(lines$Delta)) + geom_histogram(bins=100)+scale_x_log10()
sorted.lines <- data.frame(x=1:length(lines$Delta),Delta=as.numeric(lines[order(-lines$Delta),]$Delta))
ggplot()+geom_point(data=sorted.lines,aes(x=x,y=Delta))
ggplot()+geom_point(data=sorted.lines,aes(x=x,y=Delta))+scale_y_log10()
sorted.lines.no0 <- sorted.lines[sorted.lines$Delta>0,]
zipf.fit <- lm(log(sorted.lines.no0$Delta) ~ sorted.lines.no0$x)

## ----autocorrelation, echo=FALSE-----------------------------------------
autoplot(pacf(lines$Delta, plot=FALSE) )

## ----spectrum, echo=FALSE------------------------------------------------
autoplot(spectrum(lines$Delta, plot=FALSE) )
