#### THIS CODE WAS WRITTEN BY ALEXANDRE SANCHES ####

library(tidyverse)
library(rvest)
library(bizdays)
library(dplyr)
library(lubridate)

filtro <- function(dado, min) {
  dado[dado$`Dias corridos` == min(dado[dado$`Dias corridos` >= min & dados$`Dias corridos` <= min + 7,][,2]),]
}

# Download data

html_url <- "http://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenciais-bm-fbovespa/"

html_iframe <- read_html(x = html_url) %>%
  html_nodes(css = "#bvmf_iframe") %>%
  html_attr("src")

html <- read_html(html_iframe)

dados <- html %>%
  html_nodes("td") %>%
  html_text() %>%
  str_replace(",", ".") %>%
  as.numeric() %>%
  matrix(ncol = 3, byrow = TRUE) %>%
  as.data.frame()

names(dados) <- c("Dias corridos", "252", "360")

rm(list = ls(pattern = "html"))

dia <- bizseq(from = "2019-01-01", to = Sys.Date(), cal = "Brazil/ANBIMA") %>%
  last() %>%
  floor_date("month")

dados <- cbind(dia, dados[,c(1:2)])

# Process data

dia30 <- filtro(dados, 30)
dia60 <- filtro(dados, 60)
dia90 <- filtro(dados, 90)
dia30 <- filtro(dados, 30)
dia120 <- filtro(dados, 120)
dia180 <- filtro(dados, 180)
dia360 <- filtro(dados, 360)

dados <- data.frame(atualizada = dia, Valor = dia30[,3], Valor = dia60[,3], Valor = dia90[,3],
                    Valor = dia120[,3], Valor = dia180[,3], Valor = dia360[,3])

names(dados) <- c( "atualizada", "30","60","90","120","180","360")

remove(list = ls(pattern = "dia"))
