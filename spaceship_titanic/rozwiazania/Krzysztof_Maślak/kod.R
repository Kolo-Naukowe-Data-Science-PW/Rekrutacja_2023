library("readr")
library("dplyr")
library("plotrix")
library("ggplot2")
ramka <- read.csv("../../dane.csv")

unique(ramka$HomePlanet)
unique(ramka$Cabin)
unique(ramka$VRDeck)
unique(ramka$Destination)
unique(ramka$Destination)
unique(ramka$Destination)

homeplanety <- ramka %>%           
  group_by(HomePlanet) %>%   
  summarize(Sum = n()) %>%      
  arrange(desc(Sum))


destinaty <- ramka %>%           
  group_by(Destination) %>%   
  summarize(Sum = n()) %>%      
  arrange(desc(Sum))



trasy <-ramka %>%
  filter(!is.na(RoomService), !is.na(FoodCourt), !is.na(ShoppingMall), !is.na(Spa), !is.na(VRDeck)) %>%
  filter(HomePlanet != "") %>%
  group_by(HomePlanet) %>%  
  summarize(liczba = n(), SumRoomService = sum(RoomService) / liczba, SumFoodCourt = sum(FoodCourt) / liczba, 
            SumShoppingMall = sum(ShoppingMall) / liczba, SumSpa = sum(Spa) / liczba, SumVRDeck = sum(VRDeck) / liczba)
  
  
                      
trasy$Suma <- rowSums(trasy[, 3:7])

trasy <-trasy %>%
  arrange(desc(Suma))

normalized <- trasy

normalized$Suma <- normalized$Suma * 100 / sum(normalized$Suma)
normalized$SumRoomService <- normalized$SumRoomService * 100 / sum(normalized$SumRoomService)
normalized$SumFoodCourt <- normalized$SumFoodCourt * 100 / sum(normalized$SumFoodCourt)
normalized$SumShoppingMall <- normalized$SumShoppingMall * 100 / sum(normalized$SumShoppingMall)
normalized$SumSpa <- normalized$SumSpa * 100 / sum(normalized$SumSpa)
normalized$SumVRDeck <- normalized$SumVRDeck * 100 / sum(normalized$SumVRDeck)


color2D.matplot(normalized[, 3:8], 
                show.values = TRUE,
                axes = FALSE,
                xlab = "",
                ylab = "",
                vcex = 1.25,
                vcol = "black",
                extremes = c("white", "red"),
                show.legend = TRUE)
axis(3, at = seq_len(ncol(normalized[, 3:8])) - 0.5,
     labels = names(normalized[, 3:8]), tick = FALSE, cex.axis = 0.7)
axis(2, at = seq_len(nrow(normalized[, 3:8])) -0.5,
     labels = c("Earth", "Mars", "Europa"), tick = FALSE, las = 1, cex.axis = 1.5)

#########################################################
par(mar = c(5, 8, 5, 6))

color2D.matplot(trasy[, 3:8], 
                show.values = TRUE,
                axes = FALSE,
                xlab = "",
                ylab = "",
                vcex = 1.2,
                vcol = "black",
                show.legend = TRUE,
                extremes = c("white", "green"))
axis(3, at = seq_len(ncol(trasy[, 3:8])) - 0.5,
     labels = names(trasy[, 3:8]), tick = FALSE, cex.axis = 0.7)
axis(2, at = seq_len(nrow(trasy[, 3:8])) -0.5,
     labels = c("Earth", "Mars", "Europa"), tick = FALSE, las = 1, cex.axis = 1.5)




##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################


wiek_nie <-ramka %>%
  filter(Transported == "False", !is.na(Age))
sum(wiek_nie$Age) / length(wiek_nie$PassengerId)


wiek_tak <-ramka %>%
  filter(Transported == "True", !is.na(Age))
sum(wiek_tak$Age) / length(wiek_tak$PassengerId)




vip_tak <- ramka %>%
  filter(Transported == "True", !is.na(VIP), VIP !="")

length(vip_tak[vip_tak$VIP == "True", ]$VIP) / length(vip_tak$VIP)


vip_nie <- ramka %>%
  filter(Transported == "False", !is.na(VIP), VIP !="")

length(vip_nie[vip_nie$VIP == "True", ]$VIP) / length(vip_nie$VIP)



vipp_tak <- ramka %>%
  filter(VIP == "True")

length(vipp_tak[vipp_tak$Transported == "True", ]$Transported) / length(vipp_tak$Transported)

vipp_nie <- ramka %>%
  filter(VIP == "False")

length(vipp_nie[vipp_nie$Transported == "True", ]$Transported) / length(vipp_nie$Transported)

#############################################################################################

vip_hajs <-ramka %>%
  filter(!is.na(RoomService), !is.na(FoodCourt), !is.na(ShoppingMall), !is.na(Spa), !is.na(VRDeck)) %>%
  filter(VIP != "") %>%
  group_by(VIP) %>%  
  summarize(liczba = n(), SumRoomService = sum(RoomService) / liczba, SumFoodCourt = sum(FoodCourt) / liczba, 
            SumShoppingMall = sum(ShoppingMall) / liczba, SumSpa = sum(Spa) / liczba, SumVRDeck = sum(VRDeck) / liczba)

vip_hajs$suma <- rowSums(vip_hajs[, 3:7])

#############################################################################################

vip_age_yes <- ramka %>%
  filter(VIP == "True", !is.na(Age))

sum(vip_age_yes$Age) / length(vip_age_yes$Age)


vip_age_no <- ramka %>%
  filter(VIP == "False", !is.na(Age))

sum(vip_age_no$Age) / length(vip_age_no$Age)


ogl <- ramka %>%
  filter(!is.na(Age))

sum(ogl$Age) / length(ogl$Age)


#############################################################################################

df = data.frame(matrix(nrow = 80, ncol = 9)) 

colnames(df) <- c("Wiek", "Liczność", "Transported", "Hibernacja", "VIP", "Trappist", "PSO", "Cancri", "Wydatki")

for (age in 0:79) {
  
  df[age+1, 1] <- age
  
  
  selected <- ramka %>%
    filter(!is.na(Age), Age != "") %>%
    filter(Age == age)
  
  df[age+1, 2] <- length(selected$Age)
  
  
  transport <- selected %>%
    filter(Transported != "", !is.na(Transported))
  df[age+1, 3] <- length(transport[transport$Transported == "True", ]$Transported) * 100 / length(transport$Transported)
  
  
  sleep <- selected %>%
    filter(CryoSleep != "", !is.na(CryoSleep))
  df[age+1, 4] <- length(sleep[sleep$CryoSleep == "True", ]$CryoSleep) * 100 / length(sleep$CryoSleep)
  
  
  vip <- selected %>%
    filter(VIP != "", !is.na(VIP))
  df[age+1, 5] <- length(vip[vip$VIP == "True", ]$VIP) * 100 / length(vip$VIP)
  
  trappist <- selected %>%
    filter(Destination != "", !is.na(Destination))
  df[age+1, 6] <- length(trappist[trappist$Destination == "TRAPPIST-1e", ]$Destination) * 100 / length(trappist$Destination)
  
  pso <- selected %>%
    filter(Destination != "", !is.na(Destination))
  df[age+1, 7] <- length(pso[pso$Destination == "PSO J318.5-22", ]$Destination) * 100 / length(pso$Destination)
  
  cancri <- selected %>%
    filter(Destination != "", !is.na(Destination))
  df[age+1, 8] <- length(cancri[cancri$Destination == "55 Cancri e", ]$Destination) * 100 / length(cancri$Destination)
  
  hajs <- selected %>%
    filter(!is.na(RoomService), !is.na(FoodCourt), !is.na(ShoppingMall), !is.na(Spa), !is.na(VRDeck)) %>%
    group_by(Age) %>%
    summarize(liczba = n(), SumRoomService = sum(RoomService) / liczba, SumFoodCourt = sum(FoodCourt) / liczba, 
              SumShoppingMall = sum(ShoppingMall) / liczba, SumSpa = sum(Spa) / liczba, SumVRDeck = sum(VRDeck) / liczba)
  hajs$suma <- rowSums(hajs[, 3:7])
  df[age+1, 9] <- hajs$suma
  
}


plot(df$Wiek, df$Liczność)
plot(df$Wiek, df$Transported)
plot(df$Wiek, df$Hibernacja)
plot(df$Wiek, df$VIP)
plot(df$Wiek, df$Trappist)
plot(df$Wiek, df$PSO)
plot(df$Wiek, df$Cancri)
plot(df$Wiek, df$Wydatki)



plot(df$Wiek,df$Transported,col=rgb(0.4,0.4,0.8,0.6),pch=16 , cex=1.3, main="Procent osób wysłanych w inny wymiar w zależności od wieku",
     xlab="Wiek",
     ylab="Procent osób") 



model <- lm(df$Transported ~ df$Wiek + I(df$Wiek^2) + I(df$Wiek^3))

myPredict <- predict( model ) 
ix <- sort(df$Wiek,index.return=T)$ix
lines(df$Wiek[ix], myPredict[ix], col=2, lwd=2 )  


coeff <- round(model$coefficients , 2)
text(3, -70 , paste("Model : ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "P-value adjusted = ",round(summary(model)$adj.r.squared,2)))

#######################################################
par(mar = c(5, 5, 5, 5))
plot(df$Wiek, df$Liczność, col=rgb(0.4,0.4,0.8,0.6),pch=16 , cex=1.3, main="Liczba osób w każdym wieku podróżująca w przestrzeni kosmicznej",
     xlab="Wiek",
     ylab="Liczba osób") 



model <- lm(df$Liczność ~ df$Wiek + I(df$Wiek^2) + I(df$Wiek^3))

myPredict <- predict( model ) 
ix <- sort(df$Wiek,index.return=T)$ix
lines(df$Wiek[ix], myPredict[ix], col=2, lwd=2 )  


coeff <- round(model$coefficients , 2)
text(3, -70 , paste("Model : ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "P-value adjusted = ",round(summary(model)$adj.r.squared,2)))





ggplot(df, aes(x=Wiek, y=Liczność)) + 
  geom_point() +
  labs(y = "Liczba osób", x = "Wiek") + 
  ggtitle("Liczba osób w każdym wieku podróżująca w przestrzeni kosmicznej")

ggplot(df, aes(x=Wiek, y=Transported)) + 
  geom_point() +
  labs(y = "Procent osób", x = "Wiek") + 
  ggtitle("Procent osób wysłanych w inny wymiar w zależności od wieku")

ggplot(df, aes(x=Wiek, y=Hibernacja)) + 
  geom_point() + 
  labs(y = "Procent osób", x = "Wiek") + 
  ggtitle("Procent osób będących w stanie hibernacji w zależności od wieku")

ggplot(df, aes(x=Wiek, y=VIP)) + 
  geom_point() + 
  labs(y = "Procent osób", x = "Wiek") + 
  ggtitle("Procent osób będących VIP w zależności od wieku")

ggplot(df, aes(x=Wiek, y=Trappist)) + 
  geom_point() +
  labs(y = "Liczba osób", x = "Wiek") + 
  ggtitle("Liczba osób w każdym wieku lecących na TRAPPIST-1e")

ggplot(df, aes(x=Wiek, y=PSO)) + 
  geom_point() + 
  labs(y = "Liczba osób", x = "Wiek") + 
  ggtitle("Liczba osób w każdym wieku lecących na PSO J318.5-22")

ggplot(df, aes(x=Wiek, y=Cancri)) + 
  geom_point() +
  labs(y = "Liczba osób", x = "Wiek") + 
  ggtitle("Liczba osób w każdym wieku lecących na 55 Cancri e")


ggplot(df, aes(x=Wiek, y=Wydatki)) + 
  geom_point() + 
  labs(y = "Łączna średnia wydana kwota", x = "Wiek") + 
  ggtitle("Średnie wydatki w przeliczeniu na osobę w każdym wieku")
  
                  
