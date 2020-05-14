#### THIS CODE WAS WRITTEN BY ALEXANDRE SANCHES ####

library(openxlsx)
library(stringr)
library(bizdays)
library(lubridate)

# Import data

bc_ref <- read.xlsx('~/Alexandre/SECEX Comércio Exterior.xlsx',
		sheet = 2, detectDates = TRUE)

bc_ref <- bc_ref[-(1:7), -c(1, 6:10)]
date_arq <- bc_ref[nrow(bc_ref), 2]
semana <- as.numeric(str_sub(str_trim(bc_ref[nrow(bc_ref), 1]), end = 1))

if(semana < 4){
    semana = semana + 1
    mes = str_sub(date_arq, start = 6, end = 7)
    url = paste0("http://www.mdic.gov.br/images/balanca-semanal/", semana, "_Semana_", mes, "_Mes_BCB_Semanal.xlsx")
    bc <- read.xlsx(url, sheet = 'BalGeral')
} else if(semana = 4){
    semana = 1
    mes = month(date_arq) + 1
    if(str_count(month(date_arq)) == 1){
	mes = (paste0(0, mes))
    }
    url = paste0("http://www.mdic.gov.br/images/balanca-semanal/", semana, "_Semana_", mes, "_Mes_BCB_Semanal.xlsx")
    try(bc <- read.xlsx(url, sheet = 'BalGeral'))
    if (class(err) == "try-error") {
	semana <- as.numeric(str_sub(str_trim(bc_ref[nrow(bc_ref), 1]), end = 1)) + 1
	mes = str_sub(date_arq, start = 6, end = 7) 
	url = paste0("http://www.mdic.gov.br/images/balanca-semanal/", semana, "_Semana_", mes, "_Mes_BCB_Semanal.xlsx")
	try(bc <- read.xlsx(url, sheet = 'BalGeral'))
    }
} else if(semana = 5){
    semana = 1
    mes = month(date_arq) + 1
    if(str_count(month(date_arq)) == 1){
	mes = (paste0(0, mes))
    }
    url = paste0("http://www.mdic.gov.br/images/balanca-semanal/", semana, "_Semana_", mes, "_Mes_BCB_Semanal.xlsx")
    try(bc <- read.xlsx(url, sheet = 'BalGeral'))    
}

if(is.bizday(date_segunda, "Brazil/ANBIMA")){
}

data_fim_sem <- ymd(date_arq)

for(i in 1:8){ 
    data_fim_sem <- ymd(data_fim_sem) + days(1)
    if(day(data_fim_sem) == 1){break}
    if(wday(data_fim_sem) == "Fri"){break}
}

if(!is.bizday(data_fim_sem, "Brazil/ANBIMA")){
    for(i in 1:4){
	data_fim_sem = ymd(data_fim_sem) - days(1)
	if(is.bizday(data_fim_sem, "Brazil/ANBIMA")){break}
    }
}

# Process data

bc_novo <- bc[c(8:5000),c(1:9)]

names(bc_novo)[1:9] <- c('Ano', 'Mês', 'Semana', 'Dias úteis','Exportação','Export Média','Importação','Import Média','Total')
bc_novo <- na.omit(bc_novo)

bc_novo <- data.frame(as.numeric(bc_novo$Ano), as.numeric(bc_novo$Mês), as.numeric(bc_novo$Semana), as.numeric(bc_novo$`Dias úteis`),
	as.numeric(bc_novo$Exportação), as.numeric(bc_novo$`Export Média`), as.numeric(bc_novo$Importação), 
	as.numeric(bc_novo$Importação), as.numeric(bc_novo$`Import Média`), as.numeric(bc_novo$Total))

names(bc_novo)[1:9] <- c('Ano', 'Mês', 'Semana', 'Dias úteis','Exportação','Export Média','Importação','Import Média','Total')
bc_novo <- na.omit(bc_novo)

date <- paste0(bc_novo[nrow(bc_novo), 1], "-", bc_novo[nrow(bc_novo), 2], "-", format(Sys.Date(), "%d"))
date_ant = date
for(i in 1:6){
    date_ant <- ymd(date) - days(i)
    if(is.bizday(date_ant, "Brazil/ANBIMA")){break}
}

# Export data

write.xlsx(bc_novo, file = '~/Alexandre/Balança Comercial.xlsx')

