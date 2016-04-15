library(Rserve)
Rserve()

na.zero <- function (x) {
  x[is.na(x)] <- 0
  return(x)
}

library(readxl)
mkt1 <- read_excel("M:/Anna Welden/Tableau/SaveMart/HHLD Grocery spending_Fresno CBSA.xlsx", sheet = 2)
mkt2 <- read_excel("M:/Anna Welden/Tableau/SaveMart/HHLD Grocery spending_Modesto CBSA.xlsx", sheet = 2)
mkt3 <- read_excel("M:/Anna Welden/Tableau/SaveMart/HHLD Grocery spending_Sac CBSA.xlsx", sheet = 2)

names(mkt1) <- c("Profile List Order", "Profile List Title", "Profile List 1", "Profile List 2", "Measure", "Value")
names(mkt2) <- c("Profile List Order", "Profile List Title", "Profile List 1", "Profile List 2", "Measure", "Value")
names(mkt3) <- c("Profile List Order", "Profile List Title", "Profile List 1", "Profile List 2", "Measure", "Value")

# stack the three markets
mkt1$Cbsa <- rep("Fresno", nrow(mkt1))
mkt2$Cbsa <- rep("Modesto", nrow(mkt2))
mkt3$Cbsa <- rep("Sacramento", nrow(mkt3))

mkt.combo <- rbind(mkt1, mkt2, mkt3)
head(mkt.combo)

# create 3 buckets
mkt.combo$Spending <- ifelse(mkt.combo$`Profile List Title`=="Scarborough Base Households","Scarborough Base Households",
                             ifelse(mkt.combo$`Profile List Title`=="Amount household spent on groceries past 7 days (HHLD) $150 - $199" | mkt.combo$`Profile List Title`=="Amount household spent on groceries past 7 days (HHLD) $200 or more", "$150+",
                              ifelse(mkt.combo$`Profile List Title`=="Amount household spent on groceries past 7 days (HHLD) $125 - $149" | mkt.combo$`Profile List Title`=="Amount household spent on groceries past 7 days (HHLD) $100 - $124" | mkt.combo$`Profile List Title`=="Amount household spent on groceries past 7 days (HHLD) $75 - $99" | mkt.combo$`Profile List Title`=="Amount household spent on groceries past 7 days (HHLD) $50 - $74", "$50 - $149", 
                                ifelse(mkt.combo$`Profile List Title`=="Amount household spent on groceries past 7 days (HHLD) Less than $50", "Less than $50", "BLANK"))))
table(mkt.combo$spending)    

# Split measure column into seperate columns - one for each measure
mkt.combo$Count[mkt.combo$Measure=="Count"] <- as.numeric(mkt.combo$Value[mkt.combo$Measure=="Count"])
mkt.combo[mkt.combo$Measure=="% Total", "% Total"] <- as.numeric(mkt.combo$Value[mkt.combo$Measure=="% Total"])
mkt.combo[mkt.combo$Measure=="Users/100 HHs", "Users/100 HHs"] <- as.numeric(mkt.combo$Value[mkt.combo$Measure=="Users/100 HHs"])
mkt.combo$Index[mkt.combo$Measure=="Index"] <- as.numeric(mkt.combo$Value[mkt.combo$Measure=="Index"])

# Base measures
names(mkt.combo)
table(mkt.combo$Measure)
mkt.combo[mkt.combo$Measure=="Total Profile Count", "Total Profile Count"]                  <- as.numeric(mkt.combo$Value[mkt.combo$Measure=="Total Profile Count"])
mkt.combo[mkt.combo$Measure=="Total Profile Users/100 HHs", "Total Profile Users/100 HHs"]  <- as.numeric(mkt.combo$Value[mkt.combo$Measure=="Total Profile Users/100 HHs"])

mkt.combo$Count <- na.zero(mkt.combo$Count)
mkt.combo["% Total"] <- na.zero(mkt.combo["% Total"])
mkt.combo["Users/100 HHs"] <- na.zero(mkt.combo["Users/100 HHs"])
mkt.combo$Index <- na.zero(mkt.combo$Index)
mkt.combo["Total Profile Count"] <- na.zero(mkt.combo["Total Profile Count"])
mkt.combo["Total Profile Users/100 HHs"] <- na.zero(mkt.combo["Total Profile Users/100 HHs"])


summary(mkt.combo$Count[mkt.combo$Count>0])
summary(mkt.combo["% Total"][mkt.combo["% Total"]>0])
summary(mkt.combo["Users/100 HHs"][mkt.combo["Users/100 HHs"]>0])
summary(mkt.combo$Index[mkt.combo$Index>0])
summary(mkt.combo["Total Profile Count"][mkt.combo["Total Profile Count"]>0])
summary(mkt.combo["Total Profile Users/100 HHs"][mkt.combo["Total Profile Users/100 HHs"]>0])

#fix merged cell problem
mkt.combo$`Profile List 2`[mkt.combo$`Profile List 1` %in% "Profile List"] <- "Total Profile"
mkt.combo$`Profile List 1`[mkt.combo$`Profile List 1` %in% "Profile List"] <- "Total Profile"

write.csv(mkt.combo, "M:/Anna Welden/Tableau/SaveMart/HHLD Grocery spending_Stacked CBSA.csv", row.names = T)

rm(mkt1, mkt2, mkt3)