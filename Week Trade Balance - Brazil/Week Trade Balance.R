#### THIS CODE WAS WRITTEN BY ALEXANDRE SANCHES ####

library(lubridate)
library(bizdays)
library(xts)
library(openxlsx)

# Import data

bc_ref <- read.xlsx('~/Alexandre/Week Trade Balance - Brazil/Week Trade Balance.xlsx',
                    detectDates = TRUE)
date <- floor_date(as.Date(bc_ref[nrow(bc_ref), 3]), "month")
mes <- month(date)
semana <- as.numeric(str_sub(bc_ref[nrow(bc_ref), 2], end = 1))

# Make a calendar

data <- seq(as.Date(date), length = 2, by = "+11 months")[2]

dias_uteis <- bizseq(from = date, to = data, cal = "Brazil/ANBIMA")
dias_uteis <- xts(x = as.character(dias_uteis), order.by = dias_uteis)
names(dias_uteis) <- "dias_uteis"

dias_uteis <- Reduce(rbind, lapply(split(dias_uteis, "months"), FUN = function(x) apply.weekly(x, length)))

ano <- xts(x = year(dias_uteis), order.by = index(dias_uteis))
month <- xts(x = month(dias_uteis), order.by = index(dias_uteis))
dia <- xts(x = day(dias_uteis), order.by = index(dias_uteis))
week <- Reduce(rbind, unlist(lapply(split(dias_uteis, "months"), FUN = function(x) seq(from = 1, to = nrow(x)))))

calendario_semanal <- merge(ano, month, dia, week, dias_uteis)
meses_5 <- subset(calendario_semanal, calendario_semanal$week == 5)
calendario_semanal <- subset(calendario_semanal, calendario_semanal$week == semana + 1 & calendario_semanal$month == mes)
rm(ano, month, dia, week, dias_uteis)

# Download file

if (semana < 4) {
    semana <- semana + 1
} else if (semana == 4) {
    ifelse(test = mes %in% meses_5$month, yes = semana <- 5, no = semana <- 1)
    ifelse(test = semana == 1, yes = mes <- month(date) + 1, no = mes <- month(date))
} else if (semana == 5) {
    semana <- 1
    mes <- month(date) + 1
}

if (str_count(month(date) == 1)) { 
    mes <- paste0(0, mes) 
}

url <- "http://www.mdic.gov.br/balanca/semanal/Tabela_Resumo.xlsx"

dados <- read.xlsx(url, sheet = "Bal_Mensal")

# Process data

valor <- paste0(semana, "a.semana")
dados <- dados %>%
    filter(str_detect(Minist?rio.da.Economia, valor))

semanat <- data.frame("Mes" = floor_date(index(calendario_semanal), "month"),"Semana" = paste0(semana,"? semana"), "Data" = if (weekdays(index(calendario_semanal)) == "sexta-feira") {index(calendario_semanal) + 2} else {index(calendario_semanal)}, 
                      "Dia" = weekdays(as.Date(index(calendario_semanal),'%d-%m-%Y'), abbreviate = T), "Dias uteis" = dados$X2, "Export total" = dados$X3, 
                      "Export media" = dados$X4, "Import total" = dados$X5, "Import media" = dados$X6, "Saldo" = dados$X9)

colnames(semanat) <- colnames(bc_ref)

bc_ref <- rbind(bc_ref, semanat)

for(i in c(5:10)){
    
    bc_ref[,i] <- as.numeric(bc_ref[,i])
}

# Export data

write.xlsx(bc_novo, file = '~/Alexandre/Week Trade Balance - Brazil/Week Trade Balance.xlsx')
