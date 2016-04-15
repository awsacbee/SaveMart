library(Rserve)
Rserve()

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
mkt.combo$Count[mkt.combo$Measure=="Count"] <- mkt.combo$Value[mkt.combo$Measure=="Count"]
mkt.combo[mkt.combo$Measure=="% Total", "% Total"] <- mkt.combo$Value[mkt.combo$Measure=="% Total"]
mkt.combo[mkt.combo$Measure=="Users/100 HHs", "Users/100 HHs"] <- mkt.combo$Value[mkt.combo$Measure=="Users/100 HHs"]
mkt.combo$Index[mkt.combo$Measure=="Index"] <- mkt.combo$Value[mkt.combo$Measure=="Index"]

names(mkt.combo )

#fix merged cell problem
mkt.combo$`Profile List 2`[mkt.combo$`Profile List 1` %in% "Profile List"] <- "Profile List"

write.csv(mkt.combo, "M:/Anna Welden/Tableau/SaveMart/HHLD Grocery spending_Stacked CBSA.csv", row.names = T)

rm(mkt1, mkt2, mkt3)