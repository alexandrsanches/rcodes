#### THIS CODE WAS WRITEN BY ALEXANDRE SANCHES #####

# Get data

tx_ref <- read.xlsx("~Alexandre/OECD Data.xlsm", 
                          sheet = "Data")

data <- as.Date.numeric(tx_ref[1,3], origin = "1899-12-30")
ano = str_sub(data, start = 1, end = 4)
mes = str_sub(data, start = 6, end = 7)

mes <- ifelse(test = as.numeric(mes) < 9, 
              yes = paste0(0, as.numeric(mes) + 1), 
              no = as.numeric(mes) + 1)

if(as.numeric(mes) < 12){
    url <- paste0("https://stats.oecd.org/sdmx-json/data/DP_LIVE/.HUR.TOT.PC_LF.M/OECD?contentType=csv&detail=code&separator=comma&csv-lang=en&startPeriod=2000-01&endPeriod=",ano,"-",mes)
    oecd_tx = read_csv(url)
} else if(as.numeric(mes) == 12){
    mes <- 1
    ano <- as.numeric(ano) + 1
    url <- paste0("https://stats.oecd.org/sdmx-json/data/DP_LIVE/.HUR.TOT.PC_LF.M/OECD?contentType=csv&detail=code&separator=comma&csv-lang=en&startPeriod=2000-01&endPeriod=",ano,"-",mes)
    oecd_tx <- read_csv(url)
}


# Remove unnecessary information and sort data

oecd_tx <- oecd_tx[, -c(2, 3, 5, 8)]
oecd_tx <- oecd_tx[order(oecd_tx$LOCATION), ]
oecd_tx_new <- oecd_tx[, -2]

oecd_tx$TIME <- as.yearqtr(oecd_tx_new$TIME, format = "%Y-M%m")

oecd_tx_new <- melt(oecd_tx_new, id.vars = c("TIME", "LOCATION"))
oecd_tx_new <- cast(oecd_tx_new, formula = LOCATION ~ TIME, fill = NA)

# Export data

write.xlsx(oecd_tx_new, file = "~/Alexandre/OECD_TX_Un.xlsx")

