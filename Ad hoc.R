rm(mkt1)

library(Rserve)
Rserve()

na.zero <- function (x) {
  x[is.na(x)] <- 0
  return(x)
}

library(readxl)
mkt1 <- read_excel("C:/Users/awelden/Google Drive/MAD Science/Internal Tools/Tableau/Olympia Tacoma/Wash_Zips_Manip2.xlsx", sheet = 4)
mkt2 <- read_excel("C:/Users/awelden/Google Drive/MAD Science/Internal Tools/Tableau/Olympia Tacoma/Wash_Zips_Manip2.xlsx", sheet = 5)

names(mkt1)


# Split measure column into seperate columns - one for each measure
mkt1$Base.Count[mkt1$Col8=="Base Count"] <- as.numeric(mkt1$Col9[mkt1$Col8=="Base Count"])
mkt1$Base.Percent.Comp[mkt1$Col8=="Base % Comp"] <- as.numeric(mkt1$Col9[mkt1$Col8=="Base % Comp"])
mkt1$Median[mkt1$Col8=="Median"] <- as.numeric(mkt1$Col9[mkt1$Col8=="Median"])
mkt1$Average[mkt1$Col8=="Average"] <- as.numeric(mkt1$Col9[mkt1$Col8=="Average"])
mkt1$.Count[mkt1$Col8=="Count"] <- as.numeric(mkt1$Col9[mkt1$Col8=="Count"])
mkt1$Percent.Comp[mkt1$Col8=="% Comp"] <- as.numeric(mkt1$Col9[mkt1$Col8=="% Comp"])
mkt1$Percent.Pen[mkt1$Col8=="% Pen"] <- as.numeric(mkt1$Col9[mkt1$Col8=="% Pen"])
mkt1$Index[mkt1$Col8=="Index"] <- as.numeric(mkt1$Col9[mkt1$Col8=="Index"])

write.csv(mkt1, "C:/Users/awelden/Google Drive/MAD Science/Internal Tools/Tableau/Olympia Tacoma/Tacoma_Manip.csv", row.names = T)

# calculate weighted average for these cases
#2016 Avg Age (2016 Population)
#2016 Avg Age, Male (2016 Population)
#2016 Avg Age, Female (2016 Population)
#2016 Avg Year HU Structure Built (2016 Housing Units)
#2016 Avg HH Inc (2016 Households)



mkt1$wtd.avg[mkt1$Col7 %in% c("2016 Avg Age (2016 Population)", 
                              "2016 Avg Age, Male (2016 Population)", 
                              "2016 Avg Age, Female (2016 Population)",
                              "2016 Avg Year HU Structure Built (2016 Housing Units)", 
                              "2016 Avg HH Inc (2016 Households)")] <- 



write.csv(mkt1, "C:/Users/awelden/Google Drive/MAD Science/Internal Tools/Tableau/Olympia Tacoma/test.csv", row.names = T)
