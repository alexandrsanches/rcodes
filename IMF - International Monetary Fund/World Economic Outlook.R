#### THIS CODE WAS WRITTEN BY ALEXANDRE SANCHES ####

library(openxlsx)
library(stringr)
library(lubridate)
library(dplyr)

# Fix date

setwd("~/Alexandre/IMF - International Monetary Fund")

ref <- read.xlsx("WEO.xlsx", sheet = "Data")
data_ref <- paste(ref[2,], ref[1,], "01", sep = "/")
data_ref <- as.Date(data_ref, format = "%Y/%b/%d")

mes_ref <- month(data_ref) 
ano_ref <- year(data_ref)


mes_i <- ifelse(test = mes_ref == 4 | mes_ref == 5 | mes_ref == 6 | mes_ref == 7 | mes_ref == 8 | mes_ref == 9,
                yes = "02",
                no = "01")

ano_i <- ifelse(test = mes_ref == 1 | mes_ref == 2 | mes_ref == 3,
                yes = ano_ref - 1,
                no = ano_ref)

start_ano <- ano_i - 5
final_ano <- ano_i + 5

anos <- seq(start_ano, final_ano)

paises <- c("China", "Japan", "United States")
blocos <- c("Euro area ", "World", "Advanced economies", "Emerging market and developing economies", "Latin America and the Caribbean", "European Union")

if(mes_i == 1){
    mensagem <- paste0("Projeções FMI: World Economic Outlook Abril/", ano_i)
}else{
    mensagem <- paste0("Projeções FMI: World Economic Outlook Outubro/", ano_i)
}

# Download and process data

url_paises <- paste0("https://www.imf.org/external/pubs/ft/weo/", ano_i,"/", mes_i,"/weodata/weoreptc.aspx?sy=", start_ano,"&ey=", final_ano,"&scsm=1&ssd=1&sort=country&ds=.&br=1&pr1.x=45&pr1.y=17&c=512%2C668%2C914%2C672%2C612%2C946%2C614%2C137%2C311%2C546%2C213%2C674%2C911%2C676%2C314%2C548%2C193%2C556%2C122%2C678%2C912%2C181%2C313%2C867%2C419%2C682%2C513%2C684%2C316%2C273%2C913%2C868%2C124%2C921%2C339%2C948%2C638%2C943%2C514%2C686%2C218%2C688%2C963%2C518%2C616%2C728%2C223%2C836%2C516%2C558%2C918%2C138%2C748%2C196%2C618%2C278%2C624%2C692%2C522%2C694%2C622%2C962%2C156%2C142%2C626%2C449%2C628%2C564%2C228%2C565%2C924%2C283%2C233%2C853%2C632%2C288%2C636%2C293%2C634%2C566%2C238%2C964%2C662%2C182%2C960%2C359%2C423%2C453%2C935%2C968%2C128%2C922%2C611%2C714%2C321%2C862%2C243%2C135%2C248%2C716%2C469%2C456%2C253%2C722%2C642%2C942%2C643%2C718%2C939%2C724%2C734%2C576%2C644%2C936%2C819%2C961%2C172%2C813%2C132%2C726%2C646%2C199%2C648%2C733%2C915%2C184%2C134%2C524%2C652%2C361%2C174%2C362%2C328%2C364%2C258%2C732%2C656%2C366%2C654%2C144%2C336%2C146%2C263%2C463%2C268%2C528%2C532%2C923%2C944%2C738%2C176%2C578%2C534%2C537%2C536%2C742%2C429%2C866%2C433%2C369%2C178%2C744%2C436%2C186%2C136%2C925%2C343%2C869%2C158%2C746%2C439%2C926%2C916%2C466%2C664%2C112%2C826%2C111%2C542%2C298%2C967%2C927%2C443%2C846%2C917%2C299%2C544%2C582%2C941%2C474%2C446%2C754%2C666%2C698&s=NGDP_RPCH%2CPCPIPCH%2CLUR&grp=0&a=")
dados_paises <- read.delim(url_paises)

url_blocos <- paste0("https://www.imf.org/external/pubs/ft/weo/",ano_i,"/", mes_i,"/weodata/weoreptc.aspx?pr.x=43&pr.y=14&sy=", start_ano,"&ey=", final_ano,"&scsm=1&ssd=1&sort=country&ds=.&br=1&c=001%2C110%2C163%2C119%2C123%2C998%2C200%2C505%2C511%2C903%2C205%2C400%2C603&s=NGDP_RPCH%2CPCPIEPCH%2CTRADEPCH%2CLUR&grp=1&a=1")
dados_blocos <- read.delim(url_blocos)

dados_paises <- dados_paises[,c(1:2,6:16)]
dados_paises <- subset(dados_paises, Country %in% paises)
names(dados_paises) <- c(mensagem, "Descrição", anos)

dados_blocos <- dados_blocos[,c(1:2,6:16)]
dados_blocos <- subset(dados_blocos,Country.Group.Name %in% blocos)
names(dados_blocos) <- names(dados_paises)
dados_blocos <- na.omit(dados_blocos)

for(i in c(3:13)){
    dados_blocos[,i] <- as.numeric(as.character(dados_blocos[,i]))
    dados_paises[,i] <- as.numeric(as.character(dados_paises[,i]))
}

for(i in c(1:2)){
    dados_blocos[,i] <- as.character(dados_blocos[,i])
    dados_paises[,i] <- as.character(dados_paises[,i])
}

dados <- full_join(dados_blocos, dados_paises)

# Export data

write.xlsx(dados, file = "WEO data.xlsx")
