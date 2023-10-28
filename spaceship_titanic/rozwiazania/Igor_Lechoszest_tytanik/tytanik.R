dane <- read.csv("C:/Users/Nitro/Desktop/tytanik/dane.csv")

library('data.table')
library('sqldf')
library('dplyr')

table <- as.data.table(dane)
#planety
#VR
planety <- table
IleSianaNaVR <- planety[CryoSleep != "True" & VRDeck != "NA", .(totalVR = sum(VRDeck)), by = HomePlanet]
LiczbaPasZPlanet <- planety[, .(ile = .N), by = HomePlanet]
VrIPlanety <- merge.data.table(IleSianaNaVR, LiczbaPasZPlanet)[, .(HomePlanet,totalVR,ile,średnio = round(totalVR/ile,2))]

MlodziVR <- planety[CryoSleep != "True" & Age < 20 & VRDeck != "NA", .(mtotalludzi = .N, mtotalVR = sum(VRDeck), mVRnaglowe =  round(sum(VRDeck)/.N,2)), by = HomePlanet]
StarzyVR <- planety[CryoSleep != "True" & Age > 60 & VRDeck != "NA", .(stotalludzi = .N, stotalVR = sum(VRDeck), sVRnaglowe =  round(sum(VRDeck)/.N,2)), by = HomePlanet]
razemVR <- merge.data.table(MlodziVR[, c(1,4)], StarzyVR[, c(1,4)])
razemVR <- merge.data.table(razemVR, VrIPlanety[, c(1,4)])
razemVR[HomePlanet == "", 1] <- "nieznane"

ilemlodych <- planety[Age < 20, .(total = .N), by = HomePlanet]
ilestarych <- planety[Age > 60, .(total = .N), by = HomePlanet]

#Cryo
MlodziCryo <- unique(merge.data.table(planety, ilemlodych)[CryoSleep == "True" & Age < 20, .(mtotalludzi = total, spiochy = .N, mprocspiacych =  round(.N/total,2)*100), by = HomePlanet])
StarzyCryo <- unique(merge.data.table(planety, ilestarych)[CryoSleep == "True" & Age > 60, .(stotalludzi = total, spiochy = .N, sprocspiacych =  round(.N/total,2)*100), by = HomePlanet])
wszyscyCryo <- planety[CryoSleep == "True", .(ilewszystkich = .N), by = HomePlanet]
wszyscyCryo <- merge.data.table(wszyscyCryo, LiczbaPasZPlanet)
wszyscyCryo <- wszyscyCryo[, .(HomePlanet, procspiacych = round(ilewszystkich/ile,2)*100)]
wszyscyCryo[HomePlanet == "", 1] <- "nieznane"
razemCryo <- merge.data.table(StarzyCryo[,c(1,4)], MlodziCryo[,c(1,4)])
razemCryo[HomePlanet == "", 1] <- "nieznane"
razemCryo <- merge.data.table(razemCryo, wszyscyCryo)
#Podsumowanie pitosu
Podfin <- planety[CryoSleep != "True" & VRDeck != "NA" & RoomService != "NA" & FoodCourt != "NA" & ShoppingMall != "NA" & Spa != "NA",
                  .(ludnosc = .N,totalVR = sum(VRDeck), totalRS = sum(RoomService), totalFC = sum(FoodCourt), totalSM = sum(ShoppingMall), totalSpa = sum(Spa),
                    totaltotal = sum(VRDeck) + sum(RoomService) + sum(FoodCourt) + sum(ShoppingMall) + sum(Spa), 
                    totalnaosobe = round((sum(VRDeck) + sum(RoomService) + sum(FoodCourt) + sum(ShoppingMall) + sum(Spa))/.N,2)
                    ), by = HomePlanet]
Podfin[HomePlanet == "", 1] <- "nieznane"

#VIP
IleVIP <- planety[VIP != "False", .(ilevip = .N), by = HomePlanet]
IleProcVIP <- merge.data.table(IleVIP, LiczbaPasZPlanet)[, .(HomePlanet,ilevip,ile,proc = round(ilevip/ile,3)*100)][,c(1,4)]
IleProcVIP[1,1] <- "nieznane"
#iledebili <- as.numeric(planety[CryoSleep == "True" & VIP == "True", .(total = .N)][1,1]) #prawie wszyscy z Europy

#ustawienie na statku
VIP <- planety[VIP == "True" & Cabin != "", .(Cabin, deck = substr(Cabin, 1, 1))]
VIP <- VIP[, .(deck, vipy = .N), by = deck][,c(2,3)] #wniosek E w dół dla plebsu, A dla "elity", B-D normalne
nieVIP <-  planety[Cabin != "", .(Cabin, deck = substr(Cabin, 1, 1))]
nieVIP <- nieVIP[, .(deck, wszyscy = .N), by = deck][,c(2,3)]
Vipynievipy <- merge.data.table(VIP, nieVIP)[, .(deck, vipy, wszyscy, proc = round(vipy/wszyscy,3)*100)]

#domino   :C
imionanazwiska <- planety[Name != "", .(Name)]
imiona <- as.data.table(sapply(strsplit(imionanazwiska$Name, " "), `[`, 1))
domino <- imiona[substr(V1, 1, 3) == "Dom", ]
# :CCCC



