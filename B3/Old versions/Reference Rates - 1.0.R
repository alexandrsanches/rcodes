#### THIS CODE WAS WRITTEN BY ALEXANDRE SANCHES ####

library(tidyverse)
library(rvest)
library(bizdays)
library(dplyr)
library(lubridate)

#### Carregar dados ####

url <- "http://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenciais-bm-fbovespa/" 

html <- read_html(url) 

dados <- html %>%
  html_nodes(xpath = "text-right") %>%
  html_text() %>%
  str_replace(",", ".") %>%
  as.numeric() %>%
  matrix(ncol = 3, byrow = TRUE) %>%
  as.data.frame() 

names(dados) <- c("Dias corridos", "252", "360")

rm(html)

Dia <- bizseq(from = "2019-01-01", to = Sys.Date(), cal = "Brazil/ANBIMA") %>%
  last() %>%
  floor_date("month")

dados <- cbind(Dia, dados[,c(1:2)])

#### Formatar dados ####

dia30 <- dados[dados$`Dias corridos` == min(dados[dados$`Dias corridos` >= 30 & dados$`Dias corridos` <= 35,][,2]),]
dia60 <- dados[dados$`Dias corridos` == min(dados[dados$`Dias corridos` >= 60 & dados$`Dias corridos` <= 65,][,2]),]
dia90 <- dados[dados$`Dias corridos` == min(dados[dados$`Dias corridos` >= 90 & dados$`Dias corridos` <= 95,][,2]),]
dia120 <- dados[dados$`Dias corridos` == min(dados[dados$`Dias corridos` >= 120 & dados$`Dias corridos` <= 125,][,2]),]
dia180 <- dados[dados$`Dias corridos` == min(dados[dados$`Dias corridos` >= 180 & dados$`Dias corridos` <= 185,][,2]),]
dia360 <- dados[dados$`Dias corridos` == min(dados[dados$`Dias corridos` >= 360 & dados$`Dias corridos` <= 365,][,2]),]

dados <- data.frame(atualizada = Dia, Valor = dia30[,3], Valor = dia60[,3], Valor = dia90[,3], 
                    Valor = dia120[,3], Valor = dia180[,3], Valor = dia360[,3])

names(dados) <- c( "atualizada", "30","60","90","120","180","360")

remove(list = ls(pattern = "dia"))
