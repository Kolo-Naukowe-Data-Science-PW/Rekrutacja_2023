library(dplyr)
library(tidyr)
library(ggplot2)
library(caret)
library(randomForest)
library(pheatmap)
library(stringr)

dane <- read.csv('dane.csv')
View(dane)

#1
d1 <- dane %>%
  mutate(Age_group = cut(Age, breaks = c(-Inf, 18, 25, 35, 45, 55, 65, Inf),
                         labels = c("0-18", "19-25", "26-35", "36-45", "46-55", "56-65", "66+")))

procenty <- d1 %>%
  group_by(Age_group) %>%
  summarise(Procent = n() / nrow(d1) * 100)


ggplot(procenty, aes(x = Age_group, y = Procent, fill = Age_group)) +
  geom_col() +
  geom_text(aes(label = sprintf("%.1f%%", Procent)), position = position_stack(vjust = 0.5), size = 3) +
  labs(title = "Procentowy Udział Grup Wiekowych",
       x = "Grupa Wiekowa",
       y = "Procentowy Udział",
       fill = "Grupa Wiekowa") +
  scale_fill_manual(values = c("0-18" = "gray", "19-25" = "cyan", "26-35" = "green",
                               "36-45" = "orange", "46-55" = "pink", "56-65" = "purple", "66+" = "red")) +
  theme_minimal() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), axis.title.x = element_blank()) 
  


#2
d1 <- dane %>%
  filter(!is.na(Age)) %>% 
  mutate(Age_group = cut(Age, c(-Inf, 18, 25, 35, 45, 55, 65, Inf),
                         labels = c("0-18", "19-25", "26-35", "36-45", "46-55", "56-65", "66+")))

d2 <- d1 %>% 
  group_by(Age_group) %>% 
  summarise(n = n())

d3 <- d1 %>% 
  filter(Transported == "True") %>% 
  group_by(Age_group) %>% 
  summarise(n = n())

d4 <- merge(d2, d3, by = "Age_group", suffixes = c("_d2", "_d3")) %>% 
  mutate(coefficient = (n_d3 / n_d2) * 100)

ggplot(d4, aes(x = Age_group, y = coefficient, fill = Age_group)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = sprintf("%.1f", coefficient)), 
            position = position_dodge(width = 0.7), 
            vjust = -0.5, size = 3) +
  labs(title = "Współczynnik dotarcia do celu w zależności od grupy wiekowej w %",
       x = NULL,
       y = "Współczynnik (%)",
       fill = "Grupa Wiekowa") +
  scale_fill_manual(values = c("0-18" = "red", "19-25" = "green", "26-35" = "blue", "36-45" = "purple", "46-55" = "orange", "56-65" = "pink", "66+" = "gray")) +
  theme_minimal() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())




#3
d1 <- dane %>%
  filter(!is.na(Age)) %>% 
  mutate(Age_group = cut(Age, c(-Inf, 18, 25, 35, 45, 55, 65, Inf), 
                         labels = c("0-18", "19-25", "26-35", "36-45", "46-55", "56-65", "66+"), na.rm = TRUE)) %>% 
  mutate(expenses_sum = rowSums(select(., RoomService:VRDeck))) %>% 
  na.omit(expenses_sum) %>%
  group_by(Age_group) %>% 
  summarize(
    avg_RoomService = mean(RoomService),
    avg_FoodCourt = mean(FoodCourt),
    avg_ShoppingMall = mean(ShoppingMall),
    avg_Spa = mean(Spa),
    avg_VRDeck = mean(VRDeck)
  ) %>% 
  pivot_longer(cols = c(avg_RoomService, avg_FoodCourt, avg_ShoppingMall, avg_Spa, avg_VRDeck), names_to = "ExpenseType", values_to = "AverageExpense")


ggplot(d1, aes(x = Age_group, y = AverageExpense, fill = ExpenseType)) +
  geom_bar(position = "dodge", stat = "identity", width = 0.7) +
  labs(title = "Średnie wydatki na poszczególne rzeczy w zależności od grupy wiekowej",
       x = "Grupa wiekowa",
       y = "Średnie wydatki",
       fill = "Rodzaj wydatków") +
  theme_minimal() +
  scale_fill_manual(values = c("blue", "red", "green", "orange", "purple"),
                    labels = c("RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck"))

#3a
d1 <- dane %>%
  filter(!is.na(Age)) %>% 
  mutate(Age_group = cut(Age, c(-Inf, 18, 25, 35, 45, 55, 65, Inf), 
                         labels = c("0-18", "19-25", "26-35", "36-45", "46-55", "56-65", "66+"), na.rm = TRUE)) %>% 
  mutate(expenses_sum = rowSums(select(., RoomService:VRDeck))) %>% 
  na.omit(expenses_sum) %>%
  filter(expenses_sum != 0) %>%
  group_by(Age_group) %>% 
  summarize(
    avg_RoomService = mean(RoomService),
    avg_FoodCourt = mean(FoodCourt),
    avg_ShoppingMall = mean(ShoppingMall),
    avg_Spa = mean(Spa),
    avg_VRDeck = mean(VRDeck)
  ) %>% 
  pivot_longer(cols = c(avg_RoomService, avg_FoodCourt, avg_ShoppingMall, avg_Spa, avg_VRDeck), names_to = "ExpenseType", values_to = "AverageExpense")


ggplot(d1, aes(x = Age_group, y = AverageExpense, fill = ExpenseType)) +
  geom_bar(position = "dodge", stat = "identity", width = 0.7) +
  labs(title = "Średnie wydatki na poszczególne rzeczy w zależności od grupy wiekowej",
       x = "Grupa wiekowa",
       y = "Średnie wydatki",
       fill = "Rodzaj wydatków") +
  theme_minimal() +
  scale_fill_manual(values = c("blue", "red", "green", "orange", "purple"),
                    labels = c("RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck"))
#4
d1 <- dane %>%
  filter(HomePlanet %in% c("Europa", "Mars", "Earth")) %>%
  filter(Destination %in% c("TRAPPIST-1e", "55 Cancri e", "PSO J318.5-22")) %>% 
  mutate(voyage = paste(HomePlanet, Destination, sep = "-")) %>%
  group_by(voyage)

d2 <- d1 %>% 
  summarise(n = n())

d3 <- d1 %>% 
  filter(Transported == "True") %>%
  summarise(n = n())

d4 <- merge(d2, d3, by = "voyage", suffixes = c("_d2", "_d3")) %>% 
  mutate(coefficient = (n_d3 / n_d2) * 100)
  
ggplot(d4, aes(x = voyage, y = coefficient)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "blue", width = 0.7) +
  labs(title = "Współczynnik dotarcia do celu w zależności od połączenia",
       x = "Połączenie",
       y = "Współczynnik (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_flip()

#5
d1 <- dane %>% 
  mutate(expenses_sum = rowSums(select(.,RoomService:VRDeck))) %>% 
  na.omit(expenses_sum) %>%
  mutate(expenses_group = cut(expenses_sum,
                             breaks = c(-Inf, 0, 1000, 5000, 10000, Inf),
                             labels = c("0", "1-1000", "1000-5000", "5000-10000", ">10000")))

ggplot(d1, aes(x = expenses_group, fill = expenses_group)) +
  geom_bar() +
  labs(title = "Rozkład wydatków",
       x = "Wydatki",
       y = "Liczba Pasażerów",
       fill = " ") +
  scale_fill_manual(values = c("0" = "gray", "1-1000" = "blue", "1000-5000" = "green", 
                               "5000-10000" = "orange", ">10000" = "red")) +
  theme_minimal() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), axis.title.x = element_blank()) 


#6
d1 <- dane %>%
  filter(!is.na(Age)) %>% 
  mutate(Age_group = cut(Age, c(-Inf, 18, 25, 35, 45, 55, 65, Inf), 
                         labels = c("0-18", "19-25", "26-35", "36-45", "46-55", "56-65", "66+"), na.rm = TRUE)) %>% 
  mutate(expenses_sum = rowSums(select(., RoomService:VRDeck))) %>% 
  na.omit(expenses_sum) %>%
  group_by(Age_group) %>%
  summarise(mean_expenses = mean(expenses_sum))

ggplot(d1, aes(x = Age_group, y = mean_expenses)) +
  geom_bar(stat = "identity", fill = "steelblue1", color = "black") +
  labs(title = "Średnie wydatki w poszczególnych grupach wiekowych",
       x = "Grupa wiekowa",
       y = "Średnie wydatki") +
  theme_minimal()

#6a
d1 <- dane %>%
  filter(!is.na(Age)) %>% 
  mutate(Age_group = cut(Age, c(-Inf, 18, 25, 35, 45, 55, 65, Inf), 
                         labels = c("0-18", "19-25", "26-35", "36-45", "46-55", "56-65", "66+"), na.rm = TRUE)) %>% 
  mutate(expenses_sum = rowSums(select(., RoomService:VRDeck))) %>% 
  na.omit(expenses_sum) %>%
  filter(expenses_sum != 0) %>% 
  group_by(Age_group) %>%
  summarise(mean_expenses = mean(expenses_sum))

ggplot(d1, aes(x = Age_group, y = mean_expenses)) +
  geom_bar(stat = "identity", fill = "firebrick1", color = "green") +
  labs(title = "Średnie wydatki w poszczególnych grupach wiekowych",
       x = "Grupa wiekowa",
       y = "Średnie wydatki") +
  theme_minimal()

#7
d1 <- dane %>%
  filter(!is.na(Age)) %>% 
  mutate(Age_group = cut(Age, c(-Inf, 18, 25, 35, 45, 55, 65, Inf), 
                         labels = c("0-18", "19-25", "26-35", "36-45", "46-55", "56-65", "66+"), na.rm = TRUE)) %>% 
  group_by(Age_group)


d2 <- d1 %>%
  summarise(n_d2 = n())


d3 <- d1 %>% 
  filter(CryoSleep == "True") %>% 
  summarise(n_d3 = n())


d4 <- merge(d2, d3, by = "Age_group") %>% 
  mutate(coefficient = (n_d3 / n_d2) * 100)

ggplot(d4, aes(x = Age_group, y = coefficient)) +
  geom_bar(stat = "identity", fill = "magenta", color = "purple") +
  labs(title = "Procent osób korzystających z Kriosnu w poszczególnych grupach wiekowych",
       x = "Grupa wiekowa",
       y = "Procent osób w CryoSleep") +
  theme_minimal()

#8
d1 <- dane %>%
  filter(!is.na(Age)) %>% 
  mutate(Age_group = cut(Age, c(-Inf, 18, 25, 35, 45, 55, 65, Inf), 
                         labels = c("0-18", "19-25", "26-35", "36-45", "46-55", "56-65", "66+"), na.rm = TRUE)) %>% 
  group_by(Age_group)


d2 <- d1 %>%
  summarise(n_d2 = n())


d3 <- d1 %>% 
  filter(VIP == "True") %>% 
  summarise(n_d3 = n())


d4 <- merge(d2, d3, by = "Age_group") %>% 
  mutate(coefficient = (n_d3 / n_d2) * 100)

ggplot(d4, aes(x = Age_group, y = coefficient)) +
  geom_bar(stat = "identity", fill = "greenyellow", color = "navyblue") +
  labs(title = "Procent osób które wykupiły pakiet VIP w poszczególnych grupach wiekowych",
       x = "Grupa wiekowa",
       y = "Procent osób w CryoSleep") +
  theme_minimal()

#9
d1 <- dane %>% 
  separate(PassengerId, into=c("Group","Number"),sep="_") %>%
  separate(Name, into = c("Name", "Surname"), sep = " ") %>% 
  na.omit(Surname) %>% 
  mutate(family = paste(Group, Surname, sep = "-")) %>%
  group_by(family) %>%
  mutate(family_size = n()) %>%
  group_by(family_size)

d2 <- d1 %>% 
  summarise(n_d2 = n())

d3 <- d1 %>% 
  filter(Transported == "True") %>% 
  summarise(n_d3 = n())

d4 <- merge(d2, d3, by = "family_size") %>% 
  mutate(coefficient = (n_d3 / n_d2) * 100)

ggplot(d4, aes(x = family_size, y = coefficient)) +
  geom_bar(stat = "identity", fill = "lightcoral", color = "navyblue") +
  labs(title = "Procent osób które dotarły do celu w zależności od członków rodziny jako współpasażerów",
       x = "Liczba osób w rodzinie w podróży",
       y = "Współczynnik dotarcia do celu") +
  theme_minimal()

#10
d1 <- dane %>%
  filter(HomePlanet %in% c("Europa", "Mars", "Earth")) %>%
  filter(Destination %in% c("TRAPPIST-1e", "55 Cancri e", "PSO J318.5-22")) %>% 
  mutate(voyage = paste(HomePlanet, Destination, sep = "-")) %>%
  group_by(voyage)

d2 <- d1 %>% 
  summarise(n = n())

d3 <- d1 %>% 
  filter(CryoSleep == "True") %>%
  summarise(n = n())

d4 <- merge(d2, d3, by = "voyage", suffixes = c("_d2", "_d3")) %>% 
  mutate(coefficient = (n_d3 / n_d2) * 100)

ggplot(d4, aes(x = voyage, y = coefficient)) +
  geom_bar(stat = "identity", fill = "navyblue", width = 0.7) +
  labs(title = "Współczynnik ilości osób w Kriośnie w zależności od połączenia",
       x = "Połączenie",
       y = "Współczynnik (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_flip()

#11
d1 <- dane %>% 
  mutate(expenses_sum = rowSums(select(.,RoomService:VRDeck))) %>%
  filter(CryoSleep == "True") %>% 
  na.omit(expenses_sum) %>%
  mutate(expenses_group = cut(expenses_sum,
                              breaks = c(-Inf, 0, 1000, 5000, 10000, Inf),
                              labels = c("0", "1-1000", "1000-5000", "5000-10000", ">10000")))

ggplot(d1, aes(x = expenses_group, fill = expenses_group)) +
  geom_bar() +
  labs(title = "Rozkład wydatków dla osób w Kriośnie",
       x = "Wydatki",
       y = "Liczba Pasażerów",
       fill = " ") +
  scale_fill_manual(values = c("0" = "orchid4", "1-1000" = "blue", "1000-5000" = "green", 
                               "5000-10000" = "orange", ">10000" = "red")) +
  theme_minimal() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), axis.title.x = element_blank())


#ML 
dane <- na.omit(dane)
dane$Transported <- as.factor(dane$Transported)
cechy <- c("HomePlanet", "CryoSleep", "Destination", "Age", "VIP")
set.seed(123)
indeksy <- createDataPartition(dane$Transported, p = 0.8, list = FALSE)
dane_treningowe <- dane[indeksy, ]
dane_testowe <- dane[-indeksy, ]
model_rf <- randomForest(Transported ~ ., data = dane_treningowe[, c("Transported", cechy)])
predykcje <- predict(model_rf, newdata = dane_testowe[, cechy])
dokladnosc <- confusionMatrix(predykcje, dane_testowe$Transported)$overall["Accuracy"]
print(paste("Dokładność modelu:", dokladnosc))
conf_matrix <- confusionMatrix(predykcje, dane_testowe$Transported)

# Heatmapa
pheatmap(conf_matrix$table, 
         fontsize = 10, 
         color = colorRampPalette(c("white", "firebrick"))(20),
         main = "Heatmapa Macierzy Pomyłek",
         border_color = "black")