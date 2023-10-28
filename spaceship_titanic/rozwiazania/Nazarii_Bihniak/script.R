data <- read.csv('dane.csv')
View(data)

library(dplyr)
library(ggplot2)
library(tidyr)

#choosing data for the first chart
tocnt_all <- data[,c('HomePlanet','Transported')]

tocnt_alive <- tocnt_all %>% 
  filter(Transported == 'True')

df_alive <- as.data.frame(table(tocnt_alive))
df_alive <- df_alive[,c(1,3)]

df_all <- as.data.frame(table(tocnt_all))

# number of passengers by HomePlanet
ggplot(df_alive, aes(x = Freq, fill = HomePlanet)) +
  geom_histogram(binwidth = 20, color = "black", alpha = 0.5) +
  labs(title = "Histogram of Transported Passengers by Home Planet", x = "Number of Transported Passengers", y = "Frequency") +
  facet_grid(HomePlanet ~ ., scales = "free", switch = "y") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# number of passengers by HomePlanet
ggplot(df_alive, aes(x = 1, y = Freq, fill = HomePlanet)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  theme_void() +
  geom_text(aes(label = paste0(HomePlanet, ": ", Freq)), position = position_stack(vjust = 0.5)) +
  scale_fill_brewer(palette = "Set3")

# Transported vs Not Transported by the HomePlanet
ggplot(df_all, aes(x = HomePlanet, y = Freq, fill = Transported)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("True" = "lightgreen", "False" = "red")) +
  labs(title = "Passengers Transported vs. Not Transported by HomePlanet", x = "HomePlanet", y = "Passengers number") +
  theme_minimal()

cryosleeps <- data[,c('CryoSleep','Transported')]
cryosleeps <- as.data.frame(table(cryosleeps))

# Transported vs Not Transported by the CryoSleep
ggplot(cryosleeps, aes(x = CryoSleep, y = Freq, fill = Transported)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("True" = "lightgreen", "False" = "red")) +
  labs(title = "Passengers Transported vs. Not Transported by CryoSleep", x = "CryoSleep", y = "Passengers number")


age_trans <- data[,c('Age','Transported')]
age_trans <- as.data.frame(table(age_trans))
age_trans$Age = as.numeric(age_trans$Age)


# Transported vs Not Transported by the Age
ggplot(age_trans, aes(x = Age, y = Freq, fill = Transported)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("True" = "lightgreen", "False" = "red")) +
  labs(title = "Passengers Transported vs. Not Transported by Age", x = "CryoSleep", y = "Passengers number")

#Transported vs Not Transported by VIP
vips <- data[,c('VIP','Transported')]
vips <- as.data.frame(table(vips))


ggplot(vips, aes(x = VIP, y = Freq, fill = Transported)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("True" = "lightgreen", "False" = "red")) +
  labs(title = "Passengers Transported vs. Not Transported by VIP", x = "VIP", y = "Passengers number")


#chisq test
RS_FC <- data[,8:12]
RS_FC$RoomService <- ifelse(is.na(RS_FC$RoomService), 0, RS_FC$RoomService)
RS_FC$FoodCourt <- ifelse(is.na(RS_FC$FoodCourt), 0, RS_FC$FoodCourt)
RS_FC$ShoppingMall <- ifelse(is.na(RS_FC$ShoppingMall), 0, RS_FC$ShoppingMall)
RS_FC$Spa <- ifelse(is.na(RS_FC$Spa), 0, RS_FC$Spa)
RS_FC$VRDeck <- ifelse(is.na(RS_FC$VRDeck), 0, RS_FC$VRDeck)

chisq_test <- chisq.test(RS_FC)

print(chisq_test$p.value)
