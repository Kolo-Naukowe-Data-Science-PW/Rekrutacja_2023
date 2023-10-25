library(dplyr)
library(tidyr)
library(sf)
library(ggplot2)
library(stringr)
library(forcats)

dane <- read.csv('./TWD/dane.csv')

########################################### WYKRES 1 ####################################
dane1 <- dane %>% group_by(HomePlanet) %>% summarise(n = n())
dane1$HomePlanet[1] <- "None"
pie(x = dane1$n,labels = dane1$HomePlanet)
# Najwięcej z ziemi

dane12 <- dane %>% group_by(Destination) %>% summarise(n = n())
dane12$Destination[1] <- "None"
pie(x = dane12$n,labels = dane12$Destination)
# Najwięcej na TRAPPIST-1e


########################################### WYKRES 2 ####################################
dane %>% filter(HomePlanet!="",Destination!="") %>%
  mutate(path = fct_infreq(paste(HomePlanet,Destination, sep = " - "))) %>% 
  ggplot(aes(x = path)) + geom_bar() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Ilość ludzi lecących z - do",x = "z - do",y = "Ilość pasażerów")

#Najwięcej leci z ziemi , i zdecydowanie najwięcej leci na TRAPPIST-1e
########################################### WYKRES 3 ####################################
dane3 <-  dane %>% group_by(HomePlanet,CryoSleep) %>% summarise(n = n()) 

dane3 %>% group_by(HomePlanet) %>%
  mutate(suma = sum(n)) %>%
  filter(CryoSleep=="False") %>%
  summarise(Procent = n/suma) %>% ggplot(aes(x = HomePlanet,y = Procent)) +
  geom_bar(stat = "identity") + 
  labs(title = "Procent ludzi lecących bez CryoSleep")
#Opd: Najżadziej ludzie z Ziemi używają cryo


########################################### WYKRES 4 ####################################
#średni wiek cryoSleep
dane %>% filter(CryoSleep!="") %>% 
  group_by(Destination,CryoSleep) %>% summarise(n = n()) %>% 
  ggplot(aes(x = Destination,fill = CryoSleep,y = n)) +
  geom_bar(stat = "identity",position = "dodge") + 
  labs(y =  "Ilość ludzi",x = "Destination") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


dane %>% filter(CryoSleep!="") %>% 
  group_by(HomePlanet,Destination,CryoSleep) %>% summarise(n = n()) %>% 
  ggplot(aes(x = HomePlanet,fill = CryoSleep,y = n)) +
  geom_bar(stat = "identity",position = "dodge") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


dane %>% filter(CryoSleep=="True") %>% summarise(mean = mean(Age,na.rm = TRUE))
# Średni wiek

dane %>% filter(CryoSleep=="True") %>%
  ggplot(aes(x = HomePlanet,y = Age)) +
  geom_violin() + 
  stat_summary(fun = mean, geom = "crossbar") +
  labs(title = "Rozkład wieku podróżników", y = "Wiek")

dane %>% filter(CryoSleep=="True") %>%
  ggplot(aes(x = Destination,y = Age)) +
  geom_violin() + 
  stat_summary(fun = mean, geom = "crossbar") +
  labs(title = "Rozkład wieku podróżników", y = "Wiek")



#Odp: Wiek ludzi z ziemi decydujących się na CryoSen jest niższy od ludzi z pozostałych planet, być może spowodowane 
#spowolnionym starzeniem na innych planetach

########################################### WYKRES 5 ####################################
dane %>% ggplot(aes(x = Age,y = HomePlanet)) + geom_boxplot()

dane %>% ggplot(aes(x = Age,fill = HomePlanet)) +
  scale_fill_manual(values = c("red","orange","steelblue3","green")) +
  geom_density(alpha = 0.3) + 
  labs(title = "Rozkład ludzi(wiek)") + theme_minimal()

dane %>% ggplot(aes(x = Age,fill = Destination)) +
  scale_fill_manual(values = c("red","orange","steelblue3","green")) +
  geom_density(alpha = 0.3) + 
  labs(title = "Rozkład ludzi(wiek)") + theme_minimal()

#Odp: Najwięcej lata osób między 20-30 rokiem życia

#na jaką planetę lata najwięcej dzieci
########################################### WYKRES 6 ####################################
dane4 <- dane %>% filter(!is.na(Age)) %>%
  mutate(age_category = ifelse(Age<=12,"<13",
                               ifelse(Age<=18,"13-18",
                                                    ifelse(Age<=26,"19-26",
                                                                           ifelse(Age<=45,"27-45",
                                                                                                  ifelse(Age<=60,"46-60","60+"))))))
dane4 %>% group_by(Destination,age_category) %>% summarise(n = n()) %>% 
  mutate(all = sum(n)) %>% mutate(n = n/all) %>% select(Destination,age_category,n) %>%
  ggplot(aes(x = Destination,y = n,fill = age_category)) +
  geom_bar(stat = "identity",show.legend = TRUE) +
  coord_flip() +
  theme_minimal() + 
  labs(x = "Procent",y = "Część")

# na planetę "PSO J318.5-22" decyduje się lecien procentowo najwięcej ludzi z przedziału wiekowego 12-18 i 18-26 (wiek w którym się studiuje),
# być może ta planeta jest rajem dla studentów, z koleji na pozostałę decydują się ludzie starsi i rodziny z dziećmi
  
########################################### WYKRES 7 ####################################
#BURŻUAZJA EUROPY

dane %>% filter(VIP=="True") %>% ggplot(aes(x = Age,fill = HomePlanet)) + geom_density(alpha = 0.4)
#Odp z planety Ziemia nie leci rzaden VIP

dane %>% filter(VIP=="True") %>% ggplot(aes(x = Age,fill = Destination)) + geom_density(alpha = 0.4)

dane %>% filter(VIP=="True") %>% group_by(HomePlanet,Destination) %>% summarise(n = n())

#Odp do nikąd latają głównie VIPOWIe starsi > 40 lat O_O


dane %>% filter(VIP!="") %>% group_by(VIP,HomePlanet) %>%
  summarise(n = n()) %>%
  group_by(HomePlanet) %>%
  mutate(suma = sum(n)) %>% mutate(n = n/suma)

dane %>% filter(VIP!="") %>% group_by(VIP,Destination) %>%
  summarise(n = n()) %>%
  group_by(Destination) %>%
  mutate(suma = sum(n)) %>% mutate(n = n/suma)

dane %>% group_by(PassengerId) %>%
  mutate(wydatki = sum(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck, na.rm = TRUE)) %>%
  filter(CryoSleep=="False") %>%
  group_by(HomePlanet) %>% summarise(mean = mean(wydatki,na.rm = TRUE))

dane %>% group_by(PassengerId) %>%
  mutate(wydatki = sum(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck, na.rm = TRUE)) %>%
  filter(CryoSleep=="False")%>%
  ggplot(aes(x = HomePlanet,y = wydatki)) + geom_boxplot()


# LUDZIE Z EUROPY TO BURŻUJE,procentowo stosunek VIPOW/reszty najwyzszy jest dla ludzi z Europy,
#z WYKRESU 2 mają najwyższy stosunek CryoSleep=="True"/wszyscy i 
#z pośrów nieśpiących średnio wydają najwwięcej, ludzie z europy są również 
#średnio starsi niż z pozostałych planet są to więc burżuje,
#którzy najpierw się dorobili ,przenieśli na planetę Europa i jeżdzą na wakacje za pieniądze z
#innych planet >:(


# WNIOSKI Z WYKRES 1, WYKRES 7 WYKRES i WYKRESU 6
#planeta TRAPPIST-1e jest planetą na, którą wybiera się najwięcej osób, w szczególności dzieci i  ludzi w wieku ok 22-40 lat 
#oraz ludzi starszych , do tego w porównaniu z innymi planetami na tą planetę najmniej ludzi procentowo wybiera
#lot VIP, być może planeta ta jest typowym wakacyjnym resortem na, który decydują się rodziny i starsi ludzie, 
#

########################################### WYKRES 8,9,10 ####################################
#czy VIPowie wydają więcej, ile lat
dane %>% filter(VIP!="",CryoSleep=="False") %>% group_by(PassengerId) %>%
  mutate(wydatki = sum(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck, na.rm = TRUE)) %>%
  group_by(VIP) %>% summarise(mean = mean(wydatki))
#Odp VIPowie wydają ponad 3 krotnie więcej

dane8 <- dane %>% filter(CryoSleep=="False") %>% group_by(PassengerId) %>% 
  mutate(wydatki = sum(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck, na.rm = TRUE),
         floor = substring(Cabin,1,1),type = substring(Cabin,nchar(Cabin),nchar(Cabin)))

dane8 %>% filter(VIP!="") %>% group_by(VIP,floor) %>% summarise(n = n()) %>% 
  ggplot(aes(x = floor,y = n,fill = VIP)) +
  geom_bar(stat = "identity",position = "dodge")

dane8 %>% group_by(floor) %>% summarise(mean = mean(wydatki)) %>%
  ggplot(aes(x = floor,y = mean)) + geom_bar(stat = "identity") +  
  labs(title = "Wykres średnich wydatków",y = "Średnie wydatki") + theme_minimal()

#Klasy A,B,C wydają średnio na osobę o wiele więcej niż klasy niższe (T to klasa specjalna) 
#!!!!!
dane82 <- dane8 %>% select(RoomService,FoodCourt,ShoppingMall,Spa,VRDeck,floor,wydatki) %>%
  group_by(floor) %>% summarise(RoomService = sum(RoomService,na.rm = TRUE)/sum(wydatki),
                                FoodCourt = sum(FoodCourt,na.rm = TRUE)/sum(wydatki),
                                ShoppingMall = sum(ShoppingMall,na.rm = TRUE)/sum(wydatki),
                                Spa = sum(Spa,na.rm = TRUE)/sum(wydatki),
                                VRDeck = sum(VRDeck,na.rm = TRUE)/sum(wydatki))

dane83 <- dane82 %>% pivot_longer(!floor,names_to = "type",values_to = "procent")
dane83 %>% filter(floor!="") %>% ggplot(aes(x = floor,y = procent, fill = type)) +
  geom_bar(stat = "identity",show.legend = TRUE) +
  theme_minimal() +
  labs(y = "Część",x = "Floor", title = "Wykres części wydatków na konkretnych poziomach") + 
  coord_flip()


dane8 %>% ggplot(aes(x = floor,fill = HomePlanet)) +
  geom_bar() +
  theme_minimal() + 
  labs(title = "WYKRES ŻE EUROPA TO KRAINA BURŻUAZJI",x = "Floor",y = "Ilość")

# klasy A,B,C wydają ponad 2 razy więcej na jedzenie w stosunku do klas niższych,i
# o wiele mniej na RoomServise i ShoppingMall , to może nasuwać domysły, że klasy A,B,C są
# klasami eksklusywnymi. Klasa T zawiera 5 osób, nie wydają pieniędzy w sm, być może nie muszą,
# 
dane8 %>% filter(CryoSleep=="False",HomePlanet!="",Destination!="") %>%
  group_by(HomePlanet,Destination) %>%
  summarise(mean = mean(wydatki)) %>% 
  mutate(path = fct_infreq(paste(HomePlanet,Destination, sep = " - "))) %>% ggplot(aes(x = path,y = mean)) +
  geom_bar(stat = "identity") + theme_minimal() + theme(axis.text.x = element_text(angle = 45, hjust = 1))

#A 55Cancri e jest jakimś murżujskim resortem, ludzie lecący tam wydają średnio wiecej,
# stosunek (ludzie lecący na 55)/wszyscy ludzie, dla HomePlanet==Europa jest również najwyższy



