#### THIS CODE WAS WRITTEN BY ALEXANDRE SANCHES ####

library(openxlsx)
library(stringr)
library(bizdays)
library(lubridate)
suppressMessages(library(xts))
library(dplyr)

# Import data

bc_ref <- read.xlsx('~/Alexandre/SECEX Comércio Exterior.xlsx',
		sheet = 2, detectDates = TRUE)

bc_ref <- bc_ref[-(1:7),-1]
date_arq <- bc_ref[nrow(bc_ref), 2]
semana <- as.numeric(str_sub(str_trim(bc_ref[nrow(bc_ref), 1]), end = 1))

if(semana < 4){
    semana = semana + 1
    mes = str_sub(date_arq, start = 6, end = 7)
    url = paste0("http://www.mdic.gov.br/images/balanca-semanal/", semana, "_Semana_", mes, "_Mes_BCB_Semanal.xlsx")
    bc = read.xlsx(url, sheet = 'BalGeral')
    bc_2 = read.xlsx(url, sheet = 'Bal_Mensal')
} else if(semana == 4){
    semana = 1
    mes = month(date_arq) + 1
    if(str_count(month(date_arq)) == 1){
	mes = (paste0(0, mes))
    }
    url = paste0("http://www.mdic.gov.br/images/balanca-semanal/", semana, "_Semana_", mes, "_Mes_BCB_Semanal.xlsx")
    try(bc <- read.xlsx(url, sheet = 'BalGeral'))
    if (class(err) == "try-error"){
	semana <- as.numeric(str_sub(str_trim(bc_ref[nrow(bc_ref), 1]), end = 1)) + 1
	mes = str_sub(date_arq, start = 6, end = 7) 
	url = paste0("http://www.mdic.gov.br/images/balanca-semanal/", semana, "_Semana_", mes, "_Mes_BCB_Semanal.xlsx")
	try(bc <- read.xlsx(url, sheet = 'BalGeral'))
	if (class(err) != "try-error"){
	    bc_2 = read.xlsx(url, sheet = 'Bal_Mensal')
	}
    } else {
	bc_2 = read.xlsx(url, sheet = 'Bal_Mensal')
    }
} else if(semana == 5){
    semana = 1
    mes = month(date_arq) + 1
    if(str_count(month(date_arq)) == 1){
	mes = (paste0(0, mes))
    }
    url = paste0("http://www.mdic.gov.br/images/balanca-semanal/", semana, "_Semana_", mes, "_Mes_BCB_Semanal.xlsx")
    try(bc <- read.xlsx(url, sheet = 'BalGeral'))
    if (class(err) != "try-error"){
	bc_2 = read.xlsx(url, sheet = 'Bal_Mensal')
    }
}

bc <- bc[c(8:5000),c(1:9)] %>%
    na.omit(bc)

date <- max(bc_ref[,2]) %>%
    floor_date("month")

# Make a working days calendar

dias_uteis <- bizseq(from = date, to = Sys.Date(), cal = "Brazil/ANBIMA")
dias_uteis <- xts(x = as.character(dias_uteis), order.by = dias_uteis)
names(dias_uteis) <- "dias_uteis"

dias_uteis <- Reduce(rbind, lapply(split(dias_uteis, "months"), FUN = function(x) apply.weekly(x, length)))

ano <- xts(x = year(dias_uteis), order.by = index(dias_uteis))
mes <- xts(x = month(dias_uteis), order.by = index(dias_uteis))
dia <- xts(x = day(dias_uteis), order.by = index(dias_uteis))
week <- Reduce(rbind, unlist(lapply(split(dias_uteis, "months"), FUN = function(x) seq(from = 1, to = nrow(x)))))


calendario_semanal <- merge(ano, mes, dia, week, dias_uteis)
calendario_semanal <- subset(calendario_semanal, calendario_semanal$week == semana)
rm(ano, mes, dia, week, dias_uteis)

# Import data to reference file

semana_df <- data.frame('X1' = paste(semana,"º semana", sep = ""), 'X3' = index(calendario_semanal), 'X4' = weekdays(as.Date(index(calendario_semanal),'%d-%m-%Y'), abbreviate = T), 'X5' = last(bc$X4),'X6' = last(bc$X5), 'X7' = last(bc$X6), 
                     'X8' = last(bc$X7), 'X9' = last(bc$X8), 'X10' = last(bc$X9))

names(semana_df) <- names(bc_ref)

if (semana == tail(calendario_semanal$week, 1L)){
    
    bc_ref <- rbind(bc_ref, semana_df)
    
}

for(i in c(4:9)){
    
    bc_ref[,i] <- as.numeric(bc_ref[,i])
}


# Export data

write.xlsx(bc_novo, file = '~/Alexandre/Balança Comercial.xlsx')
