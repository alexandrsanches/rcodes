#### THIS CODE WAS WRITEN BY ALEXANDRE SANCHES #####

# Get data

cpi_ref <- read.xlsx("~Alexandre/OECD Data.xlsm", 
                          sheet = "Data")

data <- as.Date.numeric(cpi_ref[1,2], origin = "1899-12-30")
ano = str_sub(data, start = 1, end = 4)
mes = str_sub(data, start = 6, end = 7)

mes <- ifelse(test = as.numeric(mes) < 9, 
       yes = paste0(0, as.numeric(mes) + 1), 
       no = as.numeric(mes) + 1)

if(as.numeric(mes) < 12){
    url = paste0("https://stats.oecd.org/sdmx-json/data/DP_LIVE/.CPI.TOT.AGRWTH.M/OECD?contentType=csv&detail=code&separator=comma&csv-lang=en&startPeriod=2011-01&endPeriod=",ano,"-",mes)
    oecd_cpi = read_csv(url)
} else if(as.numeric(mes) == 12){
    mes <- 1
    ano <- as.numeric(ano) + 1
    url <- paste0("https://stats.oecd.org/sdmx-json/data/DP_LIVE/.CPI.TOT.AGRWTH.M/OECD?contentType=csv&detail=code&separator=comma&csv-lang=en&startPeriod=2011-01&endPeriod=",ano,"-",mes)
    oecd_cpi <- read_csv(url)
}

# Remove unnecessary information and sort data

oecd_cpi <- oecd_cpi[, -c(2, 3, 5, 8)]

oecd_cpi <- oecd_cpi[order(oecd_cpi$LOCATION), ]
url
oecd_cpi <- oecd_cpi[, -2]

oecd_cpi$TIME <- as.yearmon(oecd_cpi$TIME, format = "%Y-%m")

oecd_cpi <- melt(oecd_cpi, id.vars = c("TIME", "LOCATION"))
oecd_cpi <- cast(oecd_cpi, formula = LOCATION ~ TIME, fill = NA)

# Export data

write.xlsx(oecd_cpi, file = "~/Alexandre/OECD_CPI.xlsx")

