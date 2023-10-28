library(ggplot2)
library(dplyr)
library(tidyr)
install.packages("viridis")
library(viridis)
dane <- read.csv("dane.csv")
str(dane)
unique(dane$HomePlanet)
unique(dane$Destination)
unique(dane$Transported)

dane %>% 
  na.omit() %>% 
  filter(VIP != "", HomePlanet != "") %>% 
  group_by(VIP, HomePlanet) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=HomePlanet, y=n, fill = VIP)) + geom_col( position = position_dodge()) +
  labs(title = "Liczba pasażerów z danym statusem pochodzących z danych planet",
       x = "HomePlanet",
       y = "Liczba pasażerów") + 
  theme(plot.title = element_text(hjust = 0.5))
  

#Jaka osoba najwiecej wydala ? Czy byla VIPem ? 
#Czy VIPy wydają najwiecej? 


#Mamy top 10 osob ktore najwiecej wydaly, tu tez jest info czy osoba jest vipem czy nie
dane %>% 
  na.omit() %>% 
  filter(Name != "", VIP != "") %>% 
  group_by(Name, VIP, HomePlanet) %>% 
  summarise(expenses = sum(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck)) %>% 
  arrange(-expenses) -> passengers_with_most_expenses_with_vip_info

#wykresy wstepnie

passengers_with_most_expenses_with_vip_info %>% 
  ggplot(aes(x = expenses, fill = VIP)) + 
  geom_histogram(position = position_dodge(), bins=15) +
  xlim(0,20000) +
  labs(title = "Ilość pasażerów, którzy wydali pewną sumę na luksusowe udogodnienia",
       x = "Wydatki",
       y = "Liczba pasażerów") + 
  theme(plot.title = element_text(hjust = 0.5))

passengers_with_most_expenses_with_vip_info %>% 
  ggplot(aes(x = expenses, fill = VIP)) + 
  geom_density(position = position_dodge(), alpha = 0.5) +
  xlim(0,20000) +
  labs(title = "Gęstość wydatków, które pasażerowie wydali na luksusowe udogodnienia",
       x = "Wydatki",
       y = "Liczba pasażerów") + 
  theme(plot.title = element_text(hjust = 0.5))



####################################################################################################

#Zestawienie ile wydaly vipy a ile zwykli
dane %>% 
  na.omit() %>% 
  filter(VIP != "") %>%
  group_by(VIP) %>% 
  summarise(expenses = sum(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck), number_of_passengers = n()) -> vip_and_non_vip_expenses_overall

#wykresy wstepnie

vip_and_non_vip_expenses_overall %>% 
  ggplot(aes(x = VIP, y = expenses, fill = VIP)) + geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) + 
  labs(title = "Ile pasażerowie wydali na udogodnienia",
       x = "Czy jest VIPem ?",
       y = "Wydatki") + 
  theme(plot.title = element_text(hjust = 0.5))




####################################################################################################



#Zestawienie ile wydaly vipy a ile zwykli w przeliczeniu na jednego pasazera
dane %>% 
  na.omit() %>% 
  filter(VIP != "") %>%
  group_by(VIP) %>% 
  summarise(expenses = sum(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck), number_of_passengers = n()) %>% 
  mutate(expenses_per_person = expenses/number_of_passengers) -> vip_and_non_vip_expenses_per_person

#wykresy wstepnie

vip_and_non_vip_expenses_per_person %>% 
  ggplot(aes(x = VIP, y = expenses_per_person, fill = VIP)) + geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) + 
  labs(title = "Ile pasażerowie wydali na udogodnienia (na osobę)",
       x = "Czy jest VIPem ?",
       y = "Wydatki") + 
  theme(plot.title = element_text(hjust = 0.5))

####################################################################################################

#Jaki HomeTown wydal ile i na co
dane %>% 
  na.omit() %>% 
  group_by(HomePlanet, VIP) %>% 
  filter(HomePlanet != "", VIP != "") %>% 
  summarise(number_of_people = n(), sum_payment = sum(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck),
            RoomService = mean(RoomService),
            FoodCourt = mean(FoodCourt), ShoppingMall = mean(ShoppingMall),
            Spa = mean(Spa), VRDeck = mean(VRDeck)) %>% 
  mutate(mean_payment = sum_payment/number_of_people) -> mean_payments_in_each_HomePlanet

#wykresy wstepne

library(fmsb)

mean_payments_in_each_HomePlanet %>% 
  filter(VIP == "False") -> mean_payments_in_each_HomePlanet_non_vip
mean_payments_in_each_HomePlanet_non_vip <- as.data.frame(mean_payments_in_each_HomePlanet_non_vip)
rownames(mean_payments_in_each_HomePlanet_non_vip) <- c("Earth", "Europa", "Mars")
mean_payments_in_each_HomePlanet_non_vip %>% select(-c(HomePlanet, VIP, number_of_people, sum_payment, mean_payment)) -> mean_payments_in_each_HomePlanet_non_vip
mean_payments_in_each_HomePlanet_non_vip <- rbind(rep(1500,5), rep(0,5), mean_payments_in_each_HomePlanet_non_vip)
radarchart(mean_payments_in_each_HomePlanet_non_vip)

colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
radarchart( mean_payments_in_each_HomePlanet_non_vip  , axistype=1 , 
            #custom polygon
            pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,1500,375), cglwd=0.8,
            #custom labels
            vlcex=0.8,title = paste("Rozkład średnich wydatków na poszczególne luksusowe udogodnienia (pasażerowie bez statusu VIP)")
)
legend(x=1, y=1, legend = rownames(mean_payments_in_each_HomePlanet_non_vip[-c(1,2),]), bty = "n", pch=20 , col=colors_in , text.col = "grey", cex=1.2, pt.cex=3)



mean_payments_in_each_HomePlanet %>% 
  filter(VIP == "True") -> mean_payments_in_each_HomePlanet_vip
mean_payments_in_each_HomePlanet_vip <- as.data.frame(mean_payments_in_each_HomePlanet_vip)
rownames(mean_payments_in_each_HomePlanet_vip) <- c("Europa", "Mars")
mean_payments_in_each_HomePlanet_vip %>% select(-c(HomePlanet, VIP, number_of_people, sum_payment, mean_payment)) -> mean_payments_in_each_HomePlanet_vip
mean_payments_in_each_HomePlanet_vip <- rbind(rep(2800,5), rep(0,5), mean_payments_in_each_HomePlanet_vip)


radarchart( mean_payments_in_each_HomePlanet_vip  , axistype=1 , 
            #custom polygon
            pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,2800,700), cglwd=0.8,
            #custom labels
            vlcex=1,,title = paste("Rozkład średnich wydatków na poszczególne luksusowe udogodnienia (pasażerowie ze statusem VIP)")
)
legend(x=1, y=1, legend = rownames(mean_payments_in_each_HomePlanet_vip[-c(1,2),]), bty = "n", pch=20 , col=colors_in , text.col = "grey", cex=1.2, pt.cex=3)

####################################################################################################


#Ktora grupa wydała najwiecej

dane %>% 
  na.omit() %>% 
  filter(Name != "", VIP != "") %>% 
  mutate(PassengerGroup = gsub("_(\\w+)$", "", PassengerId)) %>% 
  group_by(PassengerGroup) %>% 
  summarise(sum_RoomService = sum(RoomService), sum_FoodCourt = sum(FoodCourt), sum_ShoppingMall = sum(ShoppingMall),
            sum_Spa = sum(Spa), sum_VRDeck = sum(VRDeck), total_sum = sum(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck), size_of_group = n()) %>% 
  mutate(total_sum_per_person_in_group = total_sum/size_of_group) %>% 
  arrange(-total_sum_per_person_in_group) -> which_group_payed_the_most

which_group_payed_the_most <- which_group_payed_the_most[c(1:100),]
which_group_payed_the_most %>% 
  group_by(size_of_group) %>% 
  summarise(n= n()) %>% 
  ggplot(aes(x=size_of_group, y=n)) + geom_col(fill = "orange", color = "Black") +
  geom_text(aes(label = n), vjust = -0.5, color = "black") +
  labs(title = "Grupy iluosobowe znajdują się w top 100 pod względem wydatków",
       x = "Liczność grupy",
       y = "Ilość") + 
  theme(plot.title = element_text(hjust = 0.5))
  

dane %>% 
  na.omit() %>% 
  filter(Name != "", VIP != "") %>% 
  mutate(PassengerGroup = gsub("_(\\w+)$", "", PassengerId)) -> dane_z_grupa

which_group_payed_the_most %>% 
  filter(size_of_group == 1) %>% 
  inner_join(dane_z_grupa, by="PassengerGroup") %>% 
  select(PassengerGroup, VIP) %>% 
  group_by(VIP) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=VIP, y=n)) + geom_col(fill = "orange", color = "Black") +
  geom_text(aes(label = n), vjust = -0.5, color = "black") +
  labs(title = "Czy grupy jednoosobowe to VIPy ?",
       x = "VIP",
       y = "Ilość") + 
  theme(plot.title = element_text(hjust = 0.5))

####################################################################################################
#ciekawa rzecz - w kabinach EFG podrozuje tyle samo ludzi prawie do konkretnej destynacji i rozkladaja sie po rowno po lewej
# i prawej stronie

dane %>%
  separate(Cabin, into = c('Cabin_Deck', 'Cabin_Number', 'Cabin_Side'), sep = '/') %>% 
  na.omit() %>% 
  filter(Cabin_Deck == "E"| Cabin_Deck == "F" | Cabin_Deck == "G", Destination != "") %>% 
  group_by(Cabin_Side, Destination) %>% 
  summarise(n = n()) %>% 
  arrange(-n) %>% 
  ggplot(aes(x = Destination,y = n, fill = Cabin_Side)) + geom_col(position = position_dodge()) +
  labs(title = "Liczba osób w kabinach E,F,G podróżujących do danej planety w zależności od Cabin Side",
       x = "Destination",
       y = "Liczba osób",
       fill = "Cabin Side") +
  theme(plot.title = element_text(hjust = 0.5))

####################################################################################################

dane %>% 
  mutate(AgeLimit = case_when((Age < 10 & Age >= 0)  ~ '0-10',
                              (Age < 20 & Age >= 10)  ~ '10-20',
                              (Age < 30 & Age >= 20)  ~ '20-30',
                              (Age < 40 & Age >= 30)  ~ '30-40',
                              (Age < 50 & Age >= 40)  ~ '40-50',
                              (Age < 60 & Age >= 50)  ~ '50-60',
                              (Age < 70 & Age >= 60)  ~ '60-70',
                              (Age < 80 & Age >= 70)  ~ '70-80',
                               TRUE  ~ "Other")) %>% 
  filter(CryoSleep != "", AgeLimit != "Other")-> data_AgeLimit


data_AgeLimit %>% 
  group_by(CryoSleep, AgeLimit) %>% 
  summarise(number_of_people = n()) -> tmp

data_AgeLimit %>% 
  group_by(AgeLimit) %>% 
  summarise(n = n()) -> tmp2

tmp %>% 
  left_join(tmp2, by="AgeLimit") %>% 
  mutate(percent = number_of_people/n, mean_percent = mean(percent)) %>% 
  filter(CryoSleep == "True") %>% 
  ggplot(aes(x=AgeLimit, y=percent, fill = percent)) + geom_col() + 
  scale_fill_gradient(low = "darkred", high = "lightsalmon", na.value = "white", guide = "legend") +
  geom_hline(aes(yintercept = mean_percent, color = "Średnia wartość"), linetype = "dashed", size = 1) +
  labs(title = "Procentowa liczba osób, która zdecydowała się na Kriosen w zależności od przedziału wiekowego",
       x = "Przedział wiekowy",
       y = "Procent",
       color = "") + 
  theme(plot.title = element_text(hjust = 0.5))


