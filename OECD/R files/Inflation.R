#### THIS CODE WAS WRITEN BY ALEXANDRE SANCHES #####

# Get data

cpi_ref <- read.xlsx("~Alexandre/OECD Data.xlsm", 
                          sheet = "Data")

data <- as.Date.numeric(cpi_ref[1,2], origin = "1899-12-30")

ano <- year(data)
mes <- ifelse(test = month(data) < 9, 
              yes = str_c(0, month(data) + 1), 
              no = month(data) + month(1))

if(as.numeric(mes) == 12 | as.numeric(mes) < 12){
    url = paste0("https://stats.oecd.org/sdmx-json/data/DP_LIVE/.CPI.TOT.AGRWTH.M/OECD?contentType=csv&detail=code&separator=comma&csv-lang=en&startPeriod=2011-01&endPeriod=",ano,"-",mes)
    oecd_cpi = read_csv(url)
} else if(as.numeric(mes) > 12){
    mes <- str_c(0, 1)
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

write.xlsx(oecd_cpi, file = "~/Alexandre/OECD/Downloaded files/Inflation.xlsx")

rm(list = ls())
