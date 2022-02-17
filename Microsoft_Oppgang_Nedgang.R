library(writexl)

install.packages("caTools")

library(caTools)

Data <- MicrosoftFørTrening

sample = sample.split(Data$X, SplitRatio = .80)
train = subset(Data, sample == TRUE)
test  = subset(Data, sample == FALSE)

colnames(MicrosoftDato) <- MicrosoftDato[1, ]

MicrosoftDato <- MicrosoftDato[-1, ]

MicrosoftDato1 <- MicrosoftDato[order(MicrosoftDato$Date), ]

rows = nrow(MicrosoftDato1)

index = 0.80*rows

train = MicrosoftDato1[1:index, ]

test = MicrosoftDato1[-(1:index),]

write.csv(train, "TrainMicrosoft.csv", row.names = FALSE)

write.csv(test, "TestMicrosoft.csv", row.names = FALSE)

