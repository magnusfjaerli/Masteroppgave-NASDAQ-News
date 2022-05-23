#Alle bibliotekene vi trenger for å kjøre koden

library(sqldf)
library(tidyverse)
library(readxl)
library(stringr)
library(tidyr)
library(tibble)
library(ggplot2)
library(dplyr)
library(withr)
library(tidytext)
library(syuzhet)
library(textdata)

#Stegene under er demonstrert på et av selskapene

#Gjør om datasettet til navnet "Data"

Data <- MasterOppgave_NewsPerfekt

#Filtrerer ut artikler på bakgrunn av tickeren

TestChevron <- Data %>% filter(grepl("CVX", symbols))

#Lager csv fil av "Data"

write.csv(TestChevron, "BareChevron.csv")

#Lager dato kolonne

BareChevron$Date = BareChevron$article_time

FjerningChevron = substr(BareChevron$Date,1,nchar(BareChevron$Date)-12)

FjerningChevron1 <- cbind(FjerningChevron, BareChevron)

FjerningChevron2 <- substring(FjerningChevron1$FjerningChevron, 11)

BareChevron <- cbind(FjerningChevron2, BareChevron)

FjerningChevron3 <- substring(BareChevron$FjerningChevron2, 2)

BareChevron <- cbind(FjerningChevron3, BareChevron)

BareChevron = subset(BareChevron, select = -c(FjerningChevron2))

BareChevron = subset(BareChevron, select = -c(Date))

names(BareChevron)[names(BareChevron) == 'FjerningChevron3'] <- "Date"

#Lager klokkeslett kolonne

BareChevron$Time = BareChevron$article_time

FjerningChevron = substr(BareChevron$Time, 1, nchar(BareChevron$Time)-3)

FjerningChevron1 = cbind(FjerningChevron, BareChevron)

FjerningChevron2 = substring(FjerningChevron1$FjerningChevron, 21)

BareChevron = cbind(FjerningChevron2, BareChevron)

FjerningChevron3 = substring(BareChevron$FjerningChevron2, 3)

BareChevron = cbind(FjerningChevron3, BareChevron)

BareChevron = subset(BareChevron, select = -c(FjerningChevron2))

names(BareChevron)[names(BareChevron) =="FjerningChevron3"] <- "Time"

#Lager for sen og tidlig

ChevronSen = subset(BareChevron, Time > "16:00:01")

ChevronTidlig = subset(BareChevron, Time < "08:00:00")

ChevronSen1 = as.Date(ChevronSen$Date) + 1

ChevronSen = cbind(ChevronSen1, ChevronSen)

names(ChevronSen)[names(ChevronSen)=="Date"]<- "Original_Date"

names(ChevronSen)[names(ChevronSen)=="ChevronSen1"]<- "Date"

ChevronSen = subset(ChevronSen, select = -c (Original_Date))

ChevronFerdig = rbind(ChevronSen, ChevronTidlig)

#Lager csv fil av datasettet

write.csv(ChevronFerdig,"Chevron_Ferdig.csv")

#Filtrerer datasettet med hensyn på 80% treningssett og 20% testsett
#For KNN var også et valideringssett på 10% inkludert, der treningssettet var 80% og testsettet 10%

Data <- ChevronFørTrening

ChevronDato1 <- Data[order(Data$Date), ]

rows = nrow(ChevronDato1)

index = 0.80*rows

train = ChevronDato1[1:index, ]

test = ChevronDato1[-(1:index),]

#Sortere på dato, bare unike

TrainChevronUnik <- train[!duplicated(train[,c("Date")]),]

TestChevronUnik <-  test[!duplicated(test[,c("Date")]),]

write.csv(TrainChevronUnik, "TrainChevronUnik.csv", row.names = FALSE)

write.csv(TestChevronUnik, "TestChevronUnik.csv", row.names = FALSE)

#Kombinerer alle 6 for den gitte sektoren som train

TrainEnergi = rbind(TrainBPUnik, TrainChevronUnik, TrainConocoUnik, TrainEnbridgeUnik, TrainExxonUnik, TrainSchlumbergerUnik)

write.csv(TrainEnergi, "TrainEnergi.csv", row.names = FALSE)

#Kombinerer alle 6 for den gitte sektoren som test

TestEnergi = rbind(TestBPUnik, TestChevronUnik, TestConocoUnik, TestEnbridgeUnik, TestExxonUnik, TestSchlumbergerUnik)

write.csv(TestEnergi, "TestEnergi.csv", row.names = FALSE)

