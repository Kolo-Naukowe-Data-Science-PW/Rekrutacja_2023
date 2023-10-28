library(dplyr)

df <- read.csv("dane.csv")
df_separated<- read.csv("data_separated.csv")

df <- df %>% 
  mutate(Transported = ifelse(Transported=="True", TRUE, FALSE), 
         VIP = ifelse(VIP=="True", TRUE, FALSE), 
         CryoSleep = ifelse(CryoSleep=="True", TRUE, FALSE))

df %>% 
  group_by(Cabin) %>% 
  summarize(tranported_coeff = mean(Transported, na.rm=TRUE), number_of_transportion = sum(Transported, na.rm = TRUE)) %>% 
  arrange(desc(number_of_transportion)) %>% 
  View()


df %>% 
  group_by(Destination) %>% 
  summarize(tranported_coeff = mean(Transported, na.rm=TRUE), number_of_transportion = sum(Transported, na.rm = TRUE)) %>% 
  arrange(desc(number_of_transportion)) %>% 
  View()

df %>% 
  group_by(HomePlanet) %>% 
  summarize(tranported_coeff = mean(Transported, na.rm=TRUE), number_of_transportion = sum(Transported, na.rm = TRUE)) %>% 
  arrange(desc(number_of_transportion)) %>% 
  View()

df %>% 
  group_by(Destination, HomePlanet) %>% 
  summarize(tranported_coeff = mean(Transported, na.rm=TRUE), number_of_transportion = sum(Transported, na.rm = TRUE)) %>% 
  arrange(desc(number_of_transportion)) %>% 
  View()

dd <- df %>% 
  group_by(Age) %>% 
  summarize(tranported_coeff = mean(Transported, na.rm=TRUE), number_of_transportion = sum(Transported, na.rm = TRUE)) %>% 
  arrange(desc(Age)) %>% 
  View()

scatter.smooth(dd$Age, dd$tranported_coeff)

ddd <- df %>% 
  group_by(CryoSleep, Destination, HomePlanet) %>% 
  summarize(tranported_coeff = mean(Transported, na.rm=TRUE), number_of_transportion = sum(Transported, na.rm = TRUE)) %>% 
  arrange(desc(tranported_coeff)) 
  

# однофамильцы одинаково путешествуют?
# посмотреть номер кабины разъединить все 3 данные в них
# посмотреть passengerId


df_separated <- df_separated %>% 
  mutate(Transported = ifelse(Transported=="True", TRUE, FALSE), 
         VIP = ifelse(VIP=="True", TRUE, FALSE), 
         CryoSleep = ifelse(CryoSleep=="True", TRUE, FALSE))

df_separated %>% 
  group_by(CabinDeck, CryoSleep) %>% 
  summarise(mean_transportation = mean(Transported), number_of_opservations = n()) %>% 
  View()


df_separated %>% 
  filter(CabinDeck =="T")

df_separated %>% 
  group_by(First.Name, Last.Name) %>% 
  summarise(mean_transportation = mean(Transported), number_of_opservations = n()) %>% 
  View()

df_separated <- df_separated %>% 
  mutate(Transported = ifelse(Transported=="True", TRUE, FALSE), 
         VIP = ifelse(VIP=="True", TRUE, FALSE), 
         CryoSleep = ifelse(CryoSleep=="True", TRUE, FALSE), 
         Age = as.numeric(Age))

w1 <- df_separated %>% 
  mutate(Age = as.numeric(Age)) %>% 
  group_by(Age) %>% 
  summarise(transportation_coeff = mean(Transported, na.rm = TRUE))

library("ggplot2")
ggplot(w1, aes(x = as.factor(Age), y = transportation_coeff))+
  geom_bar()

df_separated %>%  
  group_by(CabinDeck) %>% 
  summarise(mean_spends = mean(Transported, na.rm = TRUE)) %>% 
  arrange(desc(mean_spends))

df_separated %>%  
  group_by(CabinDeck, CabinSide) %>% 
  summarise(mean_spends = mean(Spa, na.rm = TRUE)) %>% 
  arrange(desc(mean_spends))

df_separated %>%  
  group_by(CabinDeck, CabinSide) %>% 
  summarise(mean_spends = mean(RoomService, na.rm = TRUE)) %>% 
  arrange(desc(mean_spends))

df_separated %>%  
  group_by(CabinDeck, CabinSide) %>% 
  summarise(mean_spends = mean(VRDeck, na.rm = TRUE)) %>% 
  arrange(desc(mean_spends))

### Jakie Decki są dla bogatych?

# W jakich deckach procentowo jest najwięcej VIP?
df_separated %>% 
  group_by(CabinDeck) %>% 
  summarise(percenteVip = mean(VIP))

# W jakich deckach najwięcej płacą za. pewne rzeczy ?
df_separated %>% 
  group_by(CabinDeck) %>% 
  summarise(n())
  
df_separated %>% 
  group_by(CabinDeck) %>% 
  summarise(mean_room_service = mean(RoomService, na.rm = TRUE), mean_spa = mean(Spa, na.rm = TRUE), mean_vrdeck = mean(VRDeck, na.rm = TRUE), mean_foodCourt = mean(FoodCourt, na.rm = TRUE), mean_shopping_mall = mean(ShoppingMall, na.rm = TRUE))

# we wszystkich kategoriach decka G płaci najmniej

### Jak wzrost wpływa na spędzanie pieniądzy?

### Czy można tracić pieniądze będąc w cryosnie?

df_separated %>% 
  filter(CryoSleep ==TRUE) %>% 
  summarise(sum(RoomService, na.rm = TRUE))

### nie można spędzać pieniądze będąc w Cryosnie.

df_separated %>% 
  filter(CryoSleep!=TRUE) %>% 
  group_by(CabinDeck) %>% 
  summarise(mean_room_service = mean(RoomService, na.rm = TRUE), mean_spa = mean(Spa, na.rm = TRUE), mean_vrdeck = mean(VRDeck, na.rm = TRUE), mean_foodCourt = mean(FoodCourt, na.rm = TRUE), mean_shopping_mall = mean(ShoppingMall, na.rm = TRUE))


df_separated<- read.csv("data_separated.csv")

df_separated <- df_separated %>% 
  mutate(Transported = ifelse(Transported=="True", 1, 0), 
         VIP = ifelse(VIP=="True", 1, 0), 
         CryoSleep = ifelse(CryoSleep=="True", 1, 0), 
         TotalSpendings = rowSums(select(df_separated, RoomService, Spa, ShoppingMall, FoodCourt, VRDeck), na.rm=TRUE));

df_separated %>%  
  filter(CryoSleep==TRUE) %>% 
  View()
?rowSums


df <- df_separated %>% 
  filter(CryoSleep!=TRUE) %>% 
  group_by(Age) %>% 
  summarise(mean_room_service = mean(RoomService, na.rm = TRUE), mean_spa = mean(Spa, na.rm = TRUE), mean_vrdeck = mean(VRDeck, na.rm = TRUE), mean_foodCourt = mean(FoodCourt, na.rm = TRUE), mean_shopping_mall = mean(ShoppingMall, na.rm = TRUE)) 

data_mean_spendings_age %>% 
  group_by()

df_separated<- read.csv("data_separated.csv")

df_separated <- df_separated %>% 
  mutate(Transported = ifelse(Transported=="True", 1, 0), 
         VIP = ifelse(VIP=="True", 1, 0), 
         CryoSleep = ifelse(CryoSleep=="True", 1, 0), 
         TotalSpendings = rowSums(select(df_separated, RoomService, Spa, ShoppingMall, FoodCourt, VRDeck), na.rm=TRUE));

df<-df_separated %>% 
  filter(CryoSleep==TRUE) %>% 
  group_by(Age) %>% 
  summarise(transportation_coeff =mean(Transported), number_of_people = n())

df<-df_separated %>% 
  filter(CryoSleep==FALSE) %>% 
  group_by(Age, HomePlanet, Destination) %>% 
  summarise(transportation_coeff =mean(Transported), number_of_people = n())


df_separated<- read.csv("data_separated.csv")

df_separated <- df_separated %>% 
  mutate(Transported = ifelse(Transported=="True", 1, 0), 
         VIP = ifelse(VIP=="True", 1, 0), 
         CryoSleep = ifelse(CryoSleep=="True", 1, 0), 
         TotalSpendings = rowSums(select(df_separated, RoomService, Spa, ShoppingMall, FoodCourt, VRDeck), na.rm=TRUE));

df_separated %>%  
  group_by(CryoSleep) %>% 
  summarise(mean_tr = mean(Transported))


data_cryosleep<-df_separated %>% 
  filter(CryoSleep==TRUE) 

data_not_cryosleep <-df_separated %>% 
  filter(CryoSleep==FALSE) %>% 
  summarise(n())

df_separated %>% group_by(CabinDeck) %>% 
  summarise(transportation_coeff = mean(Transported), number_of_observations = n()) %>% 
  arrange(desc(transportation_coeff))



data_not_cryosleep %>% 
  group_by(CabinDeck) %>% 
  summarise(transportation_coeff = mean(Transported), number_of_observations = n()) %>% 
  arrange(desc(transportation_coeff))

#жители какой планеты меньше всего тратят?
df_separated %>% 
  filter(CryoSleep==FALSE) %>% 
  group_by(Destination) %>% 
  summarise(mean_cost = mean(TotalSpendings))

df_separated %>% 
  group_by(Destination, HomePlanet) %>% 
  summarise(mean = mean(TotalSpendings)) %>% 
  View()

df_separated %>% 
  group_by(IdInGroup, CabinDeck) %>% 
  summarise(mean(Transported), number_of_o=n()) %>% 
  View()

df_separated %>% 
  group_by(Age) %>% 
  summarise(n()) %>% 
  View()

df
  