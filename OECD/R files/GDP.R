#### THIS CODE WAS WRITTEN BY ALEXANDRE SANCHES ####

# Get data

oecd_pib <- read_csv("https://stats.oecd.org/sdmx-json/data/DP_LIVE/.QGDP.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en")

oecd_pib <- oecd_pib[oecd_pib$FREQUENCY == "Q", ]
oecd_pib <- oecd_pib[, -c(2, 3, 5, 8)]

# Sort data

oecd_pib <- oecd_pib[order(oecd_pib$LOCATION), ]

# Classify in t-1 and t-4

oecd_tt1 <- oecd_pib[oecd_pib$MEASURE == "PC_CHGPP", ]
oecd_tt4 <- oecd_pib[oecd_pib$MEASURE == "PC_CHGPY", ]

oecd_tt1 <- oecd_tt1[, -2]
oecd_tt4 <- oecd_tt4[, -2]

oecd_tt1$TIME <- as.yearqtr(oecd_tt1$TIME, format = "%Y-Q%q")
oecd_tt4$TIME <- as.yearqtr(oecd_tt4$TIME, format = "%Y-Q%q")

oecd_tt1 <- oecd_tt1[year(oecd_tt1$TIME) >= 2010, ]
oecd_tt4 <- oecd_tt4[year(oecd_tt4$TIME) >= 2010, ]

oecd_tt1 <- melt(oecd_tt1, id.vars = c("TIME", "LOCATION"))
oecd_tt1 <- cast(oecd_tt1, formula = LOCATION ~ TIME, fill = NA)

oecd_tt4 <- melt(oecd_tt4, id.vars = c("TIME", "LOCATION"))
oecd_tt4 <- cast(oecd_tt4, formula = LOCATION ~ TIME, fill = NA)

# Sort pib t-1 & t-4

oecd_rank_tt1 <- oecd_tt1[,c(1,ncol(oecd_tt1))]
oecd_rank_tt1 <- na.omit(oecd_rank_tt1)
oecd_rank_tt1 <- oecd_rank_tt1[order(oecd_rank_tt1[,2]),]
oecd_rank_tt1 <- data.frame(oecd_rank_tt1, ANUALIZADO = NA)
oecd_rank_tt1$ANUALIZADO <- (((1 + oecd_rank_tt1[,2]/100)^4)-1)*100

oecd_rank_tt4 <- oecd_tt4[,c(1,ncol(oecd_tt4))]
oecd_rank_tt4 <- na.omit(oecd_rank_tt4)
oecd_rank_tt4 <- oecd_rank_tt4[order(oecd_rank_tt4[,2]),]
oecd_rank_tt4 <- data.frame(oecd_rank_tt4, ANUALIZADO = NA)
oecd_rank_tt4$ANUALIZADO <- (((1 + oecd_rank_tt4[,2]/100)^4)-1)*100

# Export data

oecd <- list(PIB_TT1 = oecd_tt1, PIB_TT4 = oecd_tt4,Rank_TT1 = oecd_rank_tt1, Rank_TT4 = oecd_rank_tt4)

write.xlsx(oecd, file = "~/Alexandre/OECD/Downloaded files/GDP.xlsx")

#rm(list = ls())
