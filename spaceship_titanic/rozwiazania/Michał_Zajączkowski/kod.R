library(ggplot2)
library(dplyr)
library(tidyr)

df <- read.csv("dane.csv")
head(df)

# Data processing
df$CryoSleep <- as.logical(df$CryoSleep)
df$VIP <- as.logical(df$VIP)
df$Transported <- as.logical(df$Transported)
df <- na.omit(df)
df <- df[df$HomePlanet != "", ]

# Percentage of transported people
df %>%
    group_by(Transported) %>%
    summarise(percentage = n() / nrow(df) * 100) %>%
    ggplot(aes(x = "", y = percentage, fill = Transported)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar(theta = "y") +
    labs(title = "Percentage of Transported People",
         x = "",
         y = "") +
    theme_void() +
    geom_text(aes(label = paste0(round(percentage, 2), "%")), position = position_stack(vjust = 0.5), size = 5) +
    scale_fill_brewer() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 20),
      legend.title = element_text(size = 14),
      legend.text = element_text(size = 14, color = "black")
    )
  
# Transported passengers percentage by VIP Status
df %>%
  select(VIP, Transported) %>%
  group_by(VIP) %>%
  summarize(PercentageTransported = mean(Transported) * 100) %>%
  ggplot(aes(x = VIP, y = PercentageTransported)) +
  geom_bar(fill = "deepskyblue", stat = "identity", width = 0.7, position = "dodge") +
  labs(
    title = "Transported passengers percentage by VIP status",
    x = "VIP Status",
    y = "Transported (%)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title.x = element_text(hjust = 0.5, size = 14),
    axis.title.y = element_text(hjust = 0.5, size = 14),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black"),
    axis.text = element_text(size = 12, color = "black"),
    legend.title = element_blank()
  )

# Number of VIPs by home planet
df %>%
  group_by(HomePlanet) %>%
  summarise(VipCount = n()) %>%
  ggplot(aes(x = reorder(HomePlanet, VipCount), y = VipCount)) +
  geom_col(fill = "skyblue") +
  labs(title = "Number of VIPs by home planet",
       x = "Home planet",
       y = "Count") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title.x = element_text(hjust = 0.5, size = 14),
    axis.title.y = element_text(hjust = 0.5, size = 14),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black"),
    axis.text = element_text(size = 12, color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1),
  )


# Transported percentage by home planet
df %>%
  group_by(HomePlanet) %>%
  summarise(PercentageTransported = mean(Transported) * 100) %>%
  ggplot(aes(x = reorder(HomePlanet, PercentageTransported), y = PercentageTransported)) +
  geom_col(fill = "lightcoral") +
  labs(title = "Transported percentage by home planet",
       x = "Home planet",
       y = "Transported (%)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title.x = element_text(hjust = 0.5, size = 14),
    axis.title.y = element_text(hjust = 0.5, size = 14),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black"),
    axis.text = element_text(size = 12, color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1),
  )

# Transported percentage by destination
df %>%
  group_by(Destination) %>%
  summarise(PercentageTransported = mean(Transported) * 100) %>%
  ggplot(aes(x = reorder(Destination, PercentageTransported), y = PercentageTransported)) +
  geom_col(fill = "lightseagreen") +
  labs(title = "Transported percentage by destination",
       x = "Destination",
       y = "Transported (%)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title.x = element_text(hjust = 0.5, size = 14),
    axis.title.y = element_text(hjust = 0.5, size = 14),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black"),
    axis.text = element_text(size = 12, color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1)
    
  )

# Transported percentage by age
df %>% 
  group_by(Age) %>% 
  summarise(PercentageTransported = mean(Transported)*100) %>% 
  ggplot(aes(x = Age, y = PercentageTransported)) +
    geom_bar(stat = "identity", fill = "blue") +
    labs(title = "Transported percentage by age",
      x = "Age",
      y = "Transported (%)") +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16),
      axis.title.x = element_text(hjust = 0.5, size = 14),
      axis.title.y = element_text(hjust = 0.5, size = 14),
      panel.grid.minor = element_blank(),
      axis.line = element_line(color = "black"),
      axis.text = element_text(size = 12, color = "black"),
      )

# Heatmap of correlations
correlation_data <- df %>%
  na.omit() %>% 
  select(c("CryoSleep", "VIP", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck", "Transported"))

correlation_matrix <- cor(correlation_data, use = "complete.obs")

correlation_df <- as.data.frame(correlation_matrix)
correlation_df$variable1 <- rownames(correlation_matrix)

correlation_df_long <- tidyr::gather(correlation_df, variable2, value, -variable1)

ggplot(correlation_df_long, aes(variable1, variable2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0) +
  theme_minimal() +
  labs(
    title = "Heatmap of correlations",
    x = "",
    y = ""
  ) + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 16)
  )

# VIPs percentage in Each deck
OverallPercentVIPs = round(mean(df$VIP) * 100, 2)
df %>%
  separate(Cabin, into = c("Deck", "Num", "Side"), sep = "/") %>%
  group_by(Deck) %>%
  summarise(percentOfVIPs = mean(VIP) * 100) %>%
  ggplot(aes(x = Deck, y = percentOfVIPs)) +
  geom_col(fill = "royalblue") +
  labs(title = paste("VIPs percentage in Each deck (Overall:", OverallPercentVIPs, "%)", sep = " "),
       x = "Deck",
       y = "%") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16), 
    axis.title.x = element_text(hjust = 0.5, size = 14), 
    axis.title.y = element_text(hjust = 0.5, size = 14), 
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black"),
  )

# Transported percentage in Each Deck
df %>%
  separate(Cabin, into = c("Deck", "Num", "Side"), sep = "/") %>%
  group_by(Deck) %>%
  summarise(percentTransported = mean(Transported) * 100) %>%
  ggplot(aes(x = Deck, y = percentTransported)) +
  geom_col(fill = "lightseagreen") +
  labs(title = "Transported percentage in Each Deck",
       x = "Deck",
       y = "Transported (%)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.title.x = element_text(hjust = 0.5),
    axis.title.y = element_text(hjust = 0.5),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black"),
  )

# VIPs percentage by age
df %>%
  select(VIP, Age) %>%
  filter(Age > 15) %>% 
  group_by(Age) %>%
  summarise(percentOfVIPs = mean(VIP) * 100) %>%
  ggplot(aes(x = Age, y = percentOfVIPs)) +
  geom_col(fill = "steelblue") +
  labs(title = "VIPs percentage by age",
       x = "Age",
       y = "VIPs (%)") +  
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.title.x = element_text(hjust = 0.5),
    axis.title.y = element_text(hjust = 0.5),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black")
  )