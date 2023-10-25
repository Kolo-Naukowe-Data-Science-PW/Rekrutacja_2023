#Analiza danyych z titanic
library(tidyr)
library(dplyr)
library(ggplot2)

df <- read.csv('dane.csv')


#Najpopularniejsza planeta startu podrozy (Homeplanet)

ilosc_pasazerow_z <- df %>% 
  filter(HomePlanet != "") %>%
  group_by(HomePlanet) %>% 
  summarise(ilosc_pasazerow = n()) %>% 
  arrange(-ilosc_pasazerow)

ggplot(ilosc_pasazerow_z, aes(x="", y=ilosc_pasazerow, fill=HomePlanet)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  ggtitle("Popularność planet startu")+
  xlab("") +
  ylab("")

#Najpopularniejsza jest Ziemia - wiecej niz polowa pasazerow

#Najpopularniejszy cel podrozy (Destination)

ilosc_pasazerow_do <- df %>% 
  filter(Destination != "") %>% 
  group_by(Destination) %>% 
  summarise(ilosc_pasazerow = n()) %>% 
  arrange(-ilosc_pasazerow)

ggplot(ilosc_pasazerow_do, aes(x="", y=ilosc_pasazerow, fill=Destination)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  ggtitle("Popularność celi podroży") +
  xlab("") +
  ylab("")

#ajpopularniejsze jest TRAPPIST-1e - prawie 3/4 pasazerow

#Najpopularniejsza trasa

najpopularniejsze_trasy <- df %>% 
  filter(HomePlanet != "" & Destination != "") %>% 
  select(HomePlanet, Destination) %>% 
  unite(col = "trasa", HomePlanet:Destination, sep = " -> ") %>% 
  group_by(trasa) %>% 
  summarise(ilosc_pasazerow = n()) %>% 
  arrange(-ilosc_pasazerow)

ggplot(najpopularniejsze_trasy, aes(x=trasa, y=ilosc_pasazerow, fill = trasa)) +
  geom_bar(stat="identity", width=0.5) +
  ggtitle("Popularność tras") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1), legend.position = "none")    
  
#ajpopularniejszea jest Earth -> TRAPPIST-1e 


# Zależność trasa a VIP

trasa_a_vip <- df %>% 
  filter(HomePlanet != "" & Destination != "" & VIP != "") %>% 
  select(HomePlanet, Destination, VIP) %>% 
  unite(col = "trasa", HomePlanet:Destination, sep = " -> ") %>% 
  group_by(trasa, VIP) %>% 
  summarise(ilosc_pasazerow = n()) %>% 
  pivot_wider(names_from = VIP, values_from = ilosc_pasazerow, values_fill = 0) %>% 
  group_by(trasa) %>% 
  summarise(procent_VIP_na_trasie = 100*True/(True + False))

ggplot(trasa_a_vip, aes(x=trasa, y=procent_VIP_na_trasie, fill = trasa)) + 
  geom_bar(stat = "identity") +
  ggtitle("Procent pasazerow VIP na danej trasie") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1), legend.position = "none")

# najwiecej VIP jest na trasie Europa -> 55 Can cri e

# Zależność trasa a wiek

trasy <- df %>% 
  filter(HomePlanet != "" & Destination != "") %>% 
  select(HomePlanet, Destination, PassengerId) %>% 
  unite(col = "trasa", HomePlanet:Destination, sep = " -> ")

przedzialy_wiekowe <- df %>% 
  mutate(przedzial_wiek = ifelse(Age<11, 1, 
                                 ifelse(Age<21, 2, 
                                        ifelse(Age<31, 3, 
                                               ifelse(Age<41, 4, 
                                                      ifelse(Age<51, 5, 
                                                             ifelse(Age<61, 6, 
                                                                    ifelse(Age<71, 7, 8))))))))

trasa_a_wiek <- przedzialy_wiekowe %>% 
  inner_join(trasy) %>% 
  group_by(trasa, przedzial_wiek) %>%
  summarise(ilosc_pasazerow_w_danym_przedziale_wiekowym = n())
  
ggplot(trasa_a_wiek, aes(x=przedzial_wiek, y=ilosc_pasazerow_w_danym_przedziale_wiekowym, color = trasa)) + 
  geom_point(position = "dodge", size=3) +
  ggtitle("Ilość pasażerów w danym przedziale wiekowym w zależności od trasy", 
          subtitle = "przedziały wiekowe: (1)0-10, (2)11-20, (3)21-30, (4)31-40, (5)41-50, (6)51-60, (7)61-70, (8)71-80")

# Zależność trasa a wydatki


dodatkowe_uslugi <- df%>% 
  inner_join(trasy, by="PassengerId") %>% 
  filter(RoomService != "" & FoodCourt != "" & ShoppingMall != "" & Spa != "" & VRDeck != "") %>% 
  group_by(trasa) %>% 
  summarise(srRoomService = mean(RoomService), srFoodCourt = mean(FoodCourt), 
            srShoppingMall = mean(ShoppingMall), srSpa = mean(Spa), srVRDeck = mean(VRDeck)) %>% 
  pivot_longer(srRoomService:srVRDeck, names_to = "serwis", values_to = "srednia_kwota")

ggplot(dodatkowe_uslugi, aes(x=serwis, y=srednia_kwota, fill = trasa)) + 
  geom_bar(position="dodge", stat = "identity") +
  ggtitle("Wydatki na serwisy pasazerow na danych trasach") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

# Zależność trasa a licznosc grup

grupy_numery_pasazerow <- df %>% 
  separate(PassengerId , sep= "_", into = c("nrgrupy", "nrpasazer"))

trasa_a_licznosc_grupy <- df %>% 
  inner_join(grupy_numery_pasazerow) %>% 
  inner_join(trasy) %>% 
  group_by(trasa, nrgrupy) %>% 
  summarise(licznosc_grupy = n()) %>% 
  group_by(trasa) %>% 
  summarise(srednia_licznosc_grupy_na_trasie = mean(licznosc_grupy))

ggplot(trasa_a_licznosc_grupy, aes(x=trasa, y=srednia_licznosc_grupy_na_trasie, fill = trasa)) + 
  geom_bar(position="dodge", stat = "identity") +
  ggtitle("Średnia liczność grup na danych trasach") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1), legend.position = "none")
#Brak znacznych roznic

# Zależność trasa a Cryosleep

trasa_a_cryosleep <- df %>% 
  filter(CryoSleep != "") %>% 
  inner_join(trasy) %>% 
  group_by(trasa, CryoSleep) %>% 
  summarise(ilosc_pasazerow_z_cryosleep_na_trasie = n())

ggplot(trasa_a_cryosleep, aes(x=trasa, y=ilosc_pasazerow_z_cryosleep_na_trasie, fill = CryoSleep)) + 
  geom_bar(position="dodge", stat = "identity") +
  ggtitle("Ilość pasażerów w cryoSleep na danej trasie") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

# Zależność trasa a Cryosleep (Procent) 

trasa_a_cryosleep_procent <- trasa_a_cryosleep %>% 
  pivot_wider(names_from = CryoSleep, values_from = ilosc_pasazerow_z_cryosleep_na_trasie, values_fill = 0) %>% 
  group_by(trasa) %>% 
  summarise(procent_cryosleep_na_trasie = 100*True/(True + False))


ggplot(trasa_a_cryosleep_procent, aes(x=trasa, y=procent_cryosleep_na_trasie, fill = trasa)) + 
  geom_bar(stat = "identity") +
  ggtitle("Procent pasażerow w cryoSleep na danej trasie") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1), legend.position = "none")

# Zależność VIP a Cryosleep

VIP_a_CryoSleep <- df %>% 
  filter(VIP != "" & CryoSleep != "") %>% 
  group_by(VIP, CryoSleep) %>% 
  summarise(ilosc_takich_pasazerow = n()) %>% 
  pivot_wider(names_from = CryoSleep, values_from = ilosc_takich_pasazerow) %>% 
  group_by(VIP) %>% 
  summarise(procent_pasazerow_w_CryoSleep = 100*True/(True + False))

ggplot(VIP_a_CryoSleep, aes(x=VIP, y=procent_pasazerow_w_CryoSleep, fill = VIP)) + 
  geom_bar(position = "dodge", stat = "identity") +
  ggtitle("Procent pasażerów w cryoSleep w zależności od statusu VIP") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1), legend.position = "none")

# Zależność VIP a wiek

VIP_a_wiek <- df %>% 
  filter(VIP != "" & Age != "") %>% 
  group_by(VIP, Age) %>% 
  summarise(ilosc_takich_pasazerow = n())

ggplot(VIP_a_wiek, aes(x=Age, y=ilosc_takich_pasazerow, color = VIP)) + 
  geom_point(size=2) +
  ggtitle("Ilość pasażerów w danym wieku w zależności od statusu VIP")

# Zależność VIP a grupa

grupa_a_vip_czy_spojne <- df %>% 
  filter(VIP != "") %>% 
  separate(PassengerId , sep= "_", into = c("nrgrupy", "nrpasazer")) %>% 
  group_by(nrgrupy, VIP) %>% 
  count() %>% 
  mutate(numer = ifelse(VIP, 1, 2)) %>% 
  group_by(nrgrupy) %>% 
  summarise(typ = sum(numer)) %>% 
  group_by(typ) %>% 
  count() %>% 
  mutate(rodzaje = ifelse(typ == 1, "VIP", ifelse(typ == 2, "NIE VIP", "MIESZANA")))

ggplot(grupa_a_vip_czy_spojne, aes(x="", y=n, fill=rodzaje)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  ggtitle("Jaka cześć grup ma status vip?") +
  xlab("") +
  ylab("")
  
# Wydatki a wiek

wydatki_a_wiek <- df%>% 
  filter(RoomService != "" & FoodCourt != "" & ShoppingMall != "" & Spa != "" & VRDeck != "") %>% 
  group_by(Age) %>% 
  summarise(srRoomService = mean(RoomService), srFoodCourt = mean(FoodCourt), 
            srShoppingMall = mean(ShoppingMall), srSpa = mean(Spa), srVRDeck = mean(VRDeck)) %>% 
  pivot_longer(srRoomService:srVRDeck, names_to = "serwis", values_to = "srednia_kwota") %>% 
  group_by(Age) %>% 
  summarise(srednia_calkowita_kwota = mean(srednia_kwota))

ggplot(wydatki_a_wiek, aes(x=Age, y=srednia_calkowita_kwota)) + 
  geom_point(size=2) +
  ggtitle("Średnia całkowita wydana kwota w zależności od wieku")

# Wydatki a CryoSleep

wydatki_a_CryoSleep <- df%>% 
  filter(RoomService != "" & FoodCourt != "" & ShoppingMall != "" & Spa != "" & VRDeck != "" & CryoSleep != "") %>% 
  group_by(CryoSleep) %>% 
  summarise(srRoomService = mean(RoomService), srFoodCourt = mean(FoodCourt), 
            srShoppingMall = mean(ShoppingMall), srSpa = mean(Spa), srVRDeck = mean(VRDeck)) %>% 
  pivot_longer(srRoomService:srVRDeck, names_to = "serwis", values_to = "srednia_kwota") %>% 
  group_by(CryoSleep) %>% 
  summarise(srednia_calkowita_kwota = mean(srednia_kwota))

ggplot(wydatki_a_CryoSleep, aes(x=CryoSleep, y=srednia_calkowita_kwota, fill = CryoSleep)) + 
  geom_bar(stat = "identity") +
  ggtitle("Średnia całkowita wydana kwota w zależności od CryoSleep") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1), legend.position = "none")

# Jak pasażerowie są w CryoSleep to nie placa za dodatkowe uslugi

# Najpopularniejsze Cabin:
kabiny <- df %>% 
  filter(Cabin != "") %>% 
  separate(Cabin, sep= "/", into = c("deck", "num", "side")) %>% 
  group_by(deck, num, side) %>% 
  count()

# Najpopularniejsza strona:

strona <- kabiny %>% 
  group_by(side) %>% 
  summarise(ilosc_pasazerow_po_danej_stronie = sum(n))

ggplot(strona, aes(x=side, y=ilosc_pasazerow_po_danej_stronie, fill = side)) + 
  geom_bar(position = "dodge", stat = "identity") +
  ggtitle("Jak rozmieszczeni byli pasażerowie na stronach statku?") +
  theme(legend.position = "none")

# Pasazerowie sa rozlozeni bardzo rowno pomiedzy stronami statku
  
# Najpopularniejsza poklad:

poklad <- kabiny %>% 
  group_by(deck) %>% 
  summarise(ilosc_pasazerow_na_danym_pokladzie = sum(n))

ggplot(poklad, aes(x=deck, y=ilosc_pasazerow_na_danym_pokladzie, fill = deck)) + 
  geom_bar(position = "dodge", stat = "identity") +
  ggtitle("Jak rozmieszczeni byli pasażerowie na pokładach statku?")+
  theme(legend.position = "none")
# Pokład T jest prawie nieużywany, zaś najwiecej pasażerów jest na pokładach F i G