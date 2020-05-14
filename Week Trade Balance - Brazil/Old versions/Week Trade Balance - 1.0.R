#### THIS CODE WAS WRITTEN BY ALEXANDRE SANCHES ####

library(openxlsx)
library(stringr)

# Import data

bc <- read.xlsx('http://www.mdic.gov.br/images/balanca-semanal/3_Semana_08_Mes_BCB_Semanal.xlsx', 
                 sheet = 'BalGeral')

# Sort data

bc_novo <- bc[c(8:5000),c(1:9)]

names(bc_novo)[1:9] <- c('Year', 'Month', 'Week', 'Working days','Export','Export Mean','Import','Import Mean','Total')

bc_novo$Year <- as.numeric(bc_novo$Year)
bc_novo$Month <- as.numeric(bc_novo$Month)
bc_novo$Week <- as.numeric(bc_novo$Week)
bc_novo$`Working days` <- as.numeric(bc_novo$`Working days`)
bc_novo$Export <- as.numeric(bc_novo$Export)
bc_novo$`Export Mean` <- as.numeric(bc_novo$`Export Mean`)
bc_novo$Import <- as.numeric(bc_novo$Import)
bc_novo$`Import Mean` <- as.numeric(bc_novo$`Import Mean`)
bc_novo$Total <- as.numeric(bc_novo$Total)

bc_novo <- na.omit(bc_novo)

# Exportar dados

write.xlsx(bc_novo, file = '~/Alexandre/Balança Comercial.xlsx')
