library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(ggthemes)
dane <- read.csv("../../dane.csv")

unique(dane$HomePlanet)
unique(dane$Destination)

# dokad najczesciej lataja z Europy?
wykres1 <- dane %>% 
  filter(HomePlanet == "Europa" & Destination != "") %>% 
  ggplot(aes(Destination, fill = Destination)) +
  geom_bar(color = "black") +
  ggtitle("Liczba pasażerów odlatujących z Europy na daną planetę") +
  theme_minimal() +
  scale_fill_manual(values = c("TRAPPIST-1e" = "#F2EC9B", "PSO J318.5-22" = "#96FFBD", "55 Cancri e" = "#1803A5" )) +
  labs(x = "Planeta",
       y = "Liczba pasażerów") +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 20,
                              family = "mono",
                              face = "bold",
                              hjust = 0.5),
    axis.text = element_text(size = 16,
                             color = "black",
                             face = "bold"),
    axis.title = element_text(size = 18,
                              color = "#4f4f4f")
  ) 

ggsave("./wykresy/wykres1.jpg", plot = wykres1, height = 10, width =  16)

# dokad najczesciej lataja z Earth?
wykres2 <- dane %>% 
  filter(HomePlanet == "Earth" & Destination != "") %>% 
  ggplot(aes(Destination, fill = Destination)) +
  geom_bar(color = "black") +
  ggtitle("Liczba pasażerów odlatujących z Earth na daną planetę") +
  theme_minimal() +
  scale_fill_manual(values = c("TRAPPIST-1e" = "#F2EC9B", "PSO J318.5-22" = "#96FFBD", "55 Cancri e" = "#1803A5" )) +
  labs(x = "Planeta",
       y = "Liczba pasażerów") +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 20,
                              family = "mono",
                              face = "bold",
                              hjust = 0.5),
    axis.text = element_text(size = 16,
                             color = "black",
                             face = "bold"),
    axis.title = element_text(size = 18,
                              color = "#4f4f4f")
  ) 

ggsave("./wykresy/wykres2.jpg", plot = wykres2, height = 10, width =  16)


# dokad najczesciej lataja z Marsa?
wykres3 <- dane %>% 
  filter(HomePlanet == "Mars" & Destination != "") %>% 
  ggplot(aes(Destination, fill = Destination)) +
  geom_bar(color = "black") +
  ggtitle("Liczba pasażerów odlatujących z Marsa na daną planetę") +
  theme_minimal() +
  scale_fill_manual(values = c("TRAPPIST-1e" = "#F2EC9B", "PSO J318.5-22" = "#96FFBD", "55 Cancri e" = "#1803A5" )) +
  labs(x = "Planeta",
       y = "Liczba pasażerów") +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 20,
                              family = "mono",
                              face = "bold",
                              hjust = 0.5),
    axis.text = element_text(size = 16,
                             color = "black",
                             face = "bold"),
    axis.title = element_text(size = 18,
                              color = "#4f4f4f")
  ) +
  ggtitle("Liczba pasażerów odlatujących z Marsa na daną planetę") +
  theme_minimal() +
  labs(x = "Planeta",
       y = "Liczba pasażerów") +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 20,
                              family = "mono",
                              face = "bold",
                              hjust = 0.5),
    axis.text = element_text(size = 16,
                             color = "black",
                             face = "bold"),
    axis.title = element_text(size = 18,
                              color = "#4f4f4f")
  )
ggsave("./wykresy/wykres3.jpg", plot = wykres3, height = 10, width =  16)


# rozklad VIP-ow i nie VIP-ow?
dane %>% 
  filter(HomePlanet != "" & VIP != "") %>% 
  ggplot(aes(HomePlanet, fill = VIP)) +
  geom_bar()


# rozklad VIP-ow i nie VIP-ow na danych trasach?

# z Earth
dane %>% 
  filter(HomePlanet == "Earth" & Destination != "" & VIP != "") %>% 
  ggplot(aes(Destination, fill = VIP)) +
  geom_bar()

# z Europa
dane %>% 
  filter(HomePlanet == "Europa" & Destination != "" & VIP != "") %>% 
  ggplot(aes(Destination, fill = VIP)) +
  geom_bar()

# z Mars
dane %>% 
  filter(HomePlanet == "Mars" & Destination != "" & VIP != "") %>% 
  ggplot(aes(Destination, fill = VIP)) +
  geom_bar()




# ile kasy zostawiaja srednio na osobe na dana trase?

# z Earth
dane %>% 
  filter(HomePlanet == "Earth" & Destination != "") %>% 
  mutate(suma = rowSums(select(., RoomService, FoodCourt, ShoppingMall, Spa, VRDeck), na.rm = TRUE)) %>% 
  group_by(Destination) %>% 
  summarise(srednia_suma = mean(suma)) %>% 
  arrange(-srednia_suma) %>% 
  ggplot(aes(x = Destination, y = srednia_suma)) +
  geom_col() 

# z Europa
dane %>% 
  filter(HomePlanet == "Europa" & Destination != "") %>% 
  mutate(suma = rowSums(select(., RoomService, FoodCourt, ShoppingMall, Spa, VRDeck), na.rm = TRUE)) %>% 
  group_by(Destination) %>% 
  summarise(srednia_suma = mean(suma)) %>% 
  arrange(-srednia_suma) %>% 
  ggplot(aes(x = Destination, y = srednia_suma)) +
  geom_col() 

# z Marsa
dane %>% 
  filter(HomePlanet == "Mars" & Destination != "") %>% 
  mutate(suma = rowSums(select(., RoomService, FoodCourt, ShoppingMall, Spa, VRDeck), na.rm = TRUE)) %>% 
  group_by(Destination) %>% 
  summarise(srednia_suma = mean(suma)) %>% 
  arrange(-srednia_suma) %>% 
  ggplot(aes(x = Destination, y = srednia_suma)) +
  geom_col() 

# kto wydal najwiecej i szczegoly o nim?
dane %>% 
  mutate(suma = rowSums(select(., RoomService, FoodCourt, ShoppingMall, Spa, VRDeck), na.rm = TRUE)) %>% 
  arrange(-suma) %>% 
  top_n(1, suma)

# ktory VIP wydal najwiecej i szczegoly o nim?
dane %>% 
  filter(VIP == "True") %>% 
  mutate(suma = rowSums(select(., RoomService, FoodCourt, ShoppingMall, Spa, VRDeck), na.rm = TRUE)) %>% 
  arrange(-suma) %>% 
  top_n(1)

# ile kasy zostawiaja srednio na osobe na dana trase w danym przedziale wiekowym?

wykres4 <- dane %>% 
  filter(HomePlanet != "" & Destination != "" & CryoSleep == "False") %>% 
  mutate(trasa = paste(HomePlanet, Destination, sep = " -> ")) %>%   
  mutate(suma = rowSums(select(., RoomService, FoodCourt, ShoppingMall, Spa, VRDeck), na.rm = TRUE)) %>% 
  ggplot(aes(x = Age, y = suma, color = Transported)) +
  geom_point() +
  facet_wrap(~trasa, scale = "free_y") +
  ggtitle("Kwoty wydane przez podróżnych w danym wieku na różnych trasach") +
  scale_color_manual(values = c("False" = "#C7395F", "True" = "#00246B"),
                    labels = c("True" = "transportował", "False" = "nie transportował"),
                    breaks = c("True", "False")) +
  theme_bw() +
  labs(x = "Wiek",
       y = "Wydana przez podróżnego kwota",
       color = "Podróżny, który się: ") +
  theme(
    legend.position="bottom",
    strip.text.x = element_text(size = 14,
                                family = "mono",
                                face = "bold"),
    plot.title = element_text(size = 20,
                              family = "mono",
                              face = "bold",
                              hjust = 0.5)
  ) 

ggsave("./wykresy/wykres4.jpg", plot = wykres4, height = 10, width =  16)


# rozlozenie wieku na danej trasie
wykres5 <- dane %>% 
  filter(HomePlanet != "" & Destination != "") %>% 
  mutate(trasa = paste(HomePlanet, Destination, sep = " -> ")) %>%
  ggplot(aes(x = Age, fill = trasa)) +
  geom_density() +
  facet_wrap(~trasa, scales = "fixed") +
  ggtitle("Rozkład wiekowy podróżnych na danych trasach") +
  theme_bw() +
  labs(x = "Wiek",
       y = "Częstość") +
  theme(
    legend.position="none",
    strip.text.x = element_text(size = 14,
                                family = "mono",
                                face = "bold"),
    plot.title = element_text(size = 20,
                              family = "mono",
                              face = "bold",
                              hjust = 0.5)
  ) 

ggsave("./wykresy/wykres5.jpg", plot = wykres5, height = 10, width =  16)


# czy mlodzi wydaja rozrzutniej pieniadze?
wykres6 <- dane %>% 
  mutate(suma = rowSums(select(., RoomService, FoodCourt, ShoppingMall, Spa, VRDeck), na.rm = TRUE)) %>% 
  group_by(Age) %>% 
  summarise(srednia_suma = mean(suma)) %>% 
  ggplot(aes(x = Age, y = srednia_suma)) +
  geom_segment(aes(x = Age, 
                   xend = Age, 
                   y = 0, 
                   yend = srednia_suma),
              size = 1)+
  geom_point(size = 5, color = "#b803ff") +
  geom_point(data = . %>% filter(srednia_suma == min(srednia_suma, na.rm = TRUE)), size = 5, color = "red") +
  ggtitle("Średnia kwota wydana przez pasażera w zależności od wieku") +
  theme_minimal() +
  labs(x = "Wiek",
       y = "Średnia kwota") +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 20,
                              family = "mono",
                              face = "bold",
                              hjust = 0.5),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 18)
  ) 

ggsave("./wykresy/wykres6.jpg", plot = wykres6, height = 10, width =  16)



# czy gdy ktos byl w kriosnie, ktos mial do niego dostep?
dane %>% 
  group_by(Cabin) %>% 
  summarise(suma = sum(ifelse(CryoSleep == "True", 1,0)),
            iloczyn = prod(ifelse(CryoSleep == "True", 1,0))) %>% 
  filter(suma != 0 & iloczyn == 0 ) %>% 
  arrange(-suma)
  
dane %>% 
  filter(Cabin == "C/21/P")

# teleportacja na danych trasach
wykres7 <- dane %>% 
  filter(HomePlanet != "" & Destination != "") %>% 
  mutate(trasa = paste(HomePlanet, Destination, sep = " -> ")) %>%
  ggplot(aes(x = Destination, fill = Transported)) +
  geom_bar(color = "black") +
  scale_fill_manual(values = c("False" = "#003f5c", "True" = "#ffa600"),
                    labels = c("True" = "transportowała", "False" = "nie transportowała"),
                    breaks = c("True", "False")) +
  coord_flip() +
  facet_wrap(~trasa, scales = "free") +
  ggtitle("Jaka część podróżnych transportowała się do innego wymiaru na danych trasach?") +
  theme_bw() +
  labs(x = NULL,
       y = NULL,
       fill = "Część podróżnych, która się: ") +
  theme(
    legend.position = "bottom",
    legend.title = element_text(),
    strip.text.x = element_text(size = 14,
                                family = "mono",
                                face = "bold"),
    plot.title = element_text(size = 20,
                              family = "mono",
                              face = "bold",
                              hjust = 0.5),
    axis.title.x = element_text()
  ) +
  scale_y_continuous(labels = NULL) +
  scale_x_discrete(labels = NULL) 

ggsave("./wykresy/wykres7.jpg", plot = wykres7, height = 10, width =  16)

  



