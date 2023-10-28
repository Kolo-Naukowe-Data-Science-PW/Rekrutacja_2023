library(dplyr)
library(ggplot2)
library(fmsb)
library(viridis)
library(extrafont)

loadfonts()

df <- read.csv('dane.csv')

df %>%
  mutate(across(RoomService:VRDeck, ~ifelse(is.na(.), median(., na.rm = TRUE), .))) %>%
  mutate(TotalCost = RoomService + FoodCourt + ShoppingMall + Spa + VRDeck) -> t

################################################################################
# Jakieś przedstawienie danych, proste wykresiki
t %>%
  filter(HomePlanet != "") %>%
  ggplot(aes(x = HomePlanet)) +
  geom_bar(fill = "#517ee8") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  labs(title = "Ilość mieszkańców poszczególnych planet",
       x = "Planety",
       y = "Ilość mieszkańców") +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))
  

t %>%
  filter(Destination != "") %>%
  ggplot(aes(x = Destination)) +
  geom_bar(fill = "#517ee8") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  labs(title = "Ilość osób chcących przenieść się na daną planetę",
       x = "Planety docelowe",
       y = "Ilość osób") +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))


t %>%
  filter(VIP != "") %>%
  mutate(VIP = factor(VIP, levels = c("True", "False"))) %>%
  ggplot(aes(x = VIP)) +
  geom_bar(fill = "#517ee8") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  scale_x_discrete(labels = c("Tak" , "Nie")) +
  labs(title = "Ilość osób z danym statusem VIP",
       x = "Status VIP",
       y = "Ilość osób") +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))

t %>%
  filter(!is.na(Age), HomePlanet != "") %>%
  ggplot(aes(x = Age, fill = HomePlanet)) +
  geom_density(size = 0.5, alpha = 0.7) +
  scale_x_continuous(expand = expansion(mult = c(0, .1))) +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  labs(title = "Wykres gęstości wieku pasażerów",
       x = "Wiek",
       y = "Gęstość",
       fill = "Planeta") +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18)) +
  facet_wrap(~ HomePlanet, ncol = 1) +
  theme(strip.text = element_text(size = 16)) +
  scale_fill_manual(values = c("Earth" = "#eb0e0e",
                               "Europa" = "#128717",
                               "Mars" = "#1227e0"))
t %>%
  ggplot(aes(x = Transported)) +
  geom_bar(fill = "#517ee8") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  scale_x_discrete(labels = c("Nie", "Tak")) +
  labs(title = "Ilość osób przetransportowanych",
       x = "Status przetransportowania",
       y = "Ilość osób") +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))

#Kabiny
t %>%
  filter(Cabin != "") %>%
  mutate(Deck = substr(Cabin, 1, 1)) %>%
  ggplot(aes(x = Deck)) +
  geom_bar(fill = "#517ee8") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  labs(title = "Ilość osób na poszczególnych pokładach",
       x = "Pokład",
       y = "Ilość osób") +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))

################################################################################
# Coś tam o kosztach

# Czy osoby posiadające status VIP wydają więcej?
ggplot(t[t$VIP != "", ], aes(x = TotalCost, y = VIP, fill = VIP)) +
  geom_boxplot() +
  scale_y_discrete(labels = c("Nie", "Tak")) +
  labs(title = "Łączne wydatki a posiadanie statusu VIP",
       x = "Łączny wydatek",
       y = "Status VIP") +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 22, face = "bold"),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    panel.background = element_rect(fill = '#EBE9E1'),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none")

# Wydatki w zależności od wieku
 t %>%
  filter(!is.na(Age)) %>%
  ggplot(aes(x = Age, y = TotalCost)) +
    geom_point(size = 3, color = '#c91c1c', alpha = 0.7) +
    geom_smooth(method = "gam", color = "#282096", se = FALSE, linewidth = 1.8) +
    labs(title = "Łączne wydatki w zależności od wieku",
         x = "Wiek",
         y = "Łączny wydadek") +
    theme_set(theme_bw(base_family = "Roboto")) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 22, face = "bold"),
      axis.title.x = element_text(size = 18),
      axis.title.y = element_text(size = 18),
      axis.text.x = element_text(size = 14),
      axis.text.y = element_text(size = 14),
      panel.background = element_rect(fill = '#F0EDE4'),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank())



# Radarchart wydatki na każde udogodnienie w zal. od planety docelowej
max_values <- data.frame(A = "Max",
                         B = 500,
                         C = 1000,
                         D = 400,
                         E = 600,
                         G = 600)

min_values <- data.frame(A = "Min",
                         B = 0,
                         C = 0,
                         D = 0,
                         E = 0,
                         G = 0)

avg_values <- t %>%
  filter(Destination != "") %>%
  select(Destination, RoomService:VRDeck) %>%
  group_by(Destination) %>%
  summarise(across(RoomService:VRDeck, list(Avg = ~round(mean(.))))) %>%
  rename(Row = Destination)

colnames(max_values) <- colnames(avg_values)
colnames(min_values) <- colnames(avg_values)

rc <- rbind(max_values, min_values, avg_values)
row.names(rc) <- rc$Row
rc <- rc[, -1]
colnames(rc) <- gsub("_Avg", "", colnames(rc))

colors_fill = c(scales::alpha("#0f34ab", 0.2),
                scales::alpha("#cf0808", 0.2),
                scales::alpha("#128717", 0.2))

colors_line <- c(scales::alpha("#0f34ab", 0.9),
                scales::alpha("#cf0808", 0.9),
                scales::alpha("#128717", 0.9))

radarchart(rc,
           seg = 3,
           title = "Średnie wydatki na każde udogodnienie, w zależności od docelowych planet",
           pcol = colors_line,
           pfcol = colors_fill,
           plwd = 2,
           plty = c(1, 1, 1),
           title.cex = 2)

legend("topright",
       title = "Planety",
       legend = c("55 Cancri e", "PSO J318.5-22", "TRAPPIST-1e"),
       bty = "n", pch = 20, col = colors_line,
       text.col = "grey25", pt.cex = 2)




################################################################################
# Docieranie do celu


# Ile osób lecących na daną planetę dociera do celu
t %>%
  filter(Destination != "") %>%
  mutate(Transported = factor(Transported, levels = c("True", "False"))) %>%
  ggplot(aes(x = Destination, fill = Transported)) +
  geom_bar(position = "dodge", stat = "count") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  labs(title = "Liczba pasażerów w zależności czy dotarli na docelową planetę czy nie",
       x = "Planeta",
       y = "Liczba pasażerów") +
  scale_fill_manual(name = "Przetransportowanie",
                    labels = c("Tak", "Nie"),
                    values = c("True" = "#24b324", "False" = "#e63c3c")
                      ) +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))



# Rozkład wieku w zależności od przetransportowania
t %>%
  filter(!is.na(Age)) %>%
  mutate(Transported = ifelse(Transported == "True", "Tak", "Nie")) %>%
  ggplot(aes(x = Transported, y = Age, fill = Transported)) +
    geom_boxplot() +
    labs(title = "Rozkład wieku w zależności od przetransportowania",
         x = "Przetransportowanie", y = "Wiek") +
    scale_fill_manual(values = c("Tak" = "#24b324", "Nie" = "#e63c3c")) +
    theme_minimal() +
    theme_set(theme_minimal(base_family = "Roboto")) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 26),
      axis.title.x = element_text(size = 16),
      axis.title.y = element_text(size = 16),
      axis.text.x = element_text(size = 14),
      axis.text.y = element_text(size = 14),
      panel.background = element_rect(fill = '#EBE9E1'),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "none",
    ) +
  coord_flip()

# Zależność przetransportowania od statusu VIP
t %>%
  filter(VIP != "") %>%
  mutate(Transported = factor(Transported, levels = c("True", "False"))) %>%
  ggplot(aes(x = VIP, fill = Transported)) +
  geom_bar(position = "dodge", stat = "count") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  labs(title = "Docieranie do celu w zależności od statusu VIP",
       x = "Status VIP",
       y = "Liczba pasażerów") +
  scale_fill_manual(name = "Przetransportowanie",
                    labels = c("Tak", "Nie"),
                    values = c("True" = "#24b324", "False" = "#e63c3c")
                      ) +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))


# Zależność przetransportowania od literki Pokładu
t %>%
  filter(Cabin != "") %>%
  mutate(Deck = substr(Cabin, 1, 1)) %>%
  group_by(Deck) %>%
  mutate(Ratio = sum(Transported == "True") / sum(Transported == "False")) %>%
  ungroup() %>%
  mutate(Transported = factor(Transported, levels = c("True", "False"))) %>%
  ggplot(aes(x = reorder(Deck, -Ratio), fill = Transported)) +
  geom_bar(position = "dodge", stat = "count") +
  labs(title = "Docieranie do celu w zależności od rodzaju pokładu",
       x = "Pokład",
       y = "Liczba pasażerów") +
  scale_fill_manual(name = "Przetransportowanie",
                    values = c("True" = "#24b324", "False" = "#e63c3c"),
                    labels = c("Tak", "Nie")) +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))


################################################################################
# Teraz ten śmieszny sen

# Podczas podróży na którą planetę sen jest najpopularniejszy
t %>%
  filter(CryoSleep != "") %>%
  filter(Destination != "") %>%
  mutate(CryoSleep = factor(CryoSleep, levels = c("True", "False"))) %>%
  ggplot(aes(x = Destination, fill = CryoSleep)) +
  geom_bar(position = "dodge") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  labs(title = "Popularność hibernacji względem destynacji",
       x = "Planeta docelowa",
       y = "Ilość osób") +
  scale_fill_manual(name = "Hibernacja",
                    values = c("True" = "#24b324", "False" = "#e63c3c"),
                    labels = c("Tak", "Nie")) +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))
  

# Sen od docierania
t %>%
  filter(CryoSleep != "") %>%
  mutate(Transported = factor(Transported, levels = c("True", "False")),
         CryoSleep = factor(CryoSleep, levels = c("True", "False"))) %>%
  ggplot(aes(x = CryoSleep, fill = Transported)) +
  geom_bar(position = "dodge") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  scale_x_discrete(labels = c("Tak", "Nie")) +
  labs(title = "Hibernacja a docieranie do celu",
       x = "Hibernacja",
       y = "Ilość osób") +
  scale_fill_manual(name = "Dotarcie do celu",
                    values = c("True" = "#24b324", "False" = "#e63c3c"),
                    labels = c("Tak", "Nie")) +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 26),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 18))


# Popularność snu w zależności od wieku
t %>%
  filter(!is.na(Age), CryoSleep != "") %>%
  ggplot(aes(x = Age, y = CryoSleep, fill = CryoSleep)) +
  geom_boxplot() +
  scale_y_discrete(labels = c("Nie", "Tak")) +
  labs(title = "Popularność hibernacji w zależności od wieku",
       x = "Wiek",
       y = "Hibernacja") +
  theme_set(theme_bw(base_family = "Roboto")) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 22, face = "bold"),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    panel.background = element_rect(fill = '#EBE9E1'),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none")
  
#########


