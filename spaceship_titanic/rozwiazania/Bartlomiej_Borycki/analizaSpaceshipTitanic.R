library(dplyr)
library(ggplot2)
library(stringr)
install.packages("gridExtra")
library(gridExtra)

library(randomForest)

data <- read.csv("../../dane.csv")

View(data)

# Data cleaning

# Checking how many rows have missing data

data %>% 
  filter(Cabin ==""|CryoSleep =="" | is.na(Transported) | HomePlanet=="" | Destination=="" | is.na(Age)) %>% 
  nrow()

# a lot of them are missing


# helping function to calculate mode

find_mode <- function(x) {
  tbl <- table(x)
  mode_values <- names(tbl[tbl == max(tbl)])
  return(mode_values)
}


data <- data %>% 
  
  #deleting NA cabins
  filter(Cabin != "") %>% 
  
  #inserting mode into other missing variables
  mutate(CryoSleep = ifelse(CryoSleep == "",find_mode(CryoSleep),CryoSleep)) %>% 
  mutate(Transported = ifelse(is.na(Transported),find_mode(Transported),Transported)) %>% 
  mutate(HomePlanet = ifelse(HomePlanet == "", find_mode(HomePlanet),HomePlanet)) %>% 
  mutate(Destination = ifelse(Destination == "", find_mode(Destination), Destination)) %>% 
  
  #inserting mean age into NA
  mutate(Age = ifelse(!is.na(Age), Age, round(mean(data$Age, na.rm = T)))) %>% 
  
  #Inserting missing data
  mutate(VRDeck = ifelse(!is.na(VRDeck), VRDeck, 0)) %>% 
  mutate(RoomService = ifelse(!is.na(RoomService), RoomService, 0)) %>% 
  mutate(Spa = ifelse(!is.na(Spa), Spa, 0)) %>% 
  mutate(FoodCourt = ifelse(!is.na(FoodCourt), FoodCourt, 0)) %>% 
  mutate(ShoppingMall = ifelse(!is.na(ShoppingMall), ShoppingMall, 0)) 







# Relationship between being transported and CryoSleep

freq <- data.frame(xtabs(~Transported + CryoSleep,data))

View(freq)

freq %>% 
  group_by(CryoSleep) %>% 
  summarize(perc = (Freq/sum(Freq))*100, Transported =Transported) %>% 
  ggplot(aes(x = CryoSleep,
             y = perc,
             fill = Transported))+
  geom_bar(stat= "identity",
           position = "dodge")+
  ylab("Percent")



# Relationship between age group and being transported safely

# what was the distribution of peoples age?

data %>% 
  ggplot(aes(x = Age)) + 
  geom_histogram()

data <- data %>% 
  mutate(age_group = case_when(Age<10~"0-10",Age<20~"10-20",
                               Age<30~"20-30",Age<40~"30-40",
                               Age<50~"40-50",Age<60~"50-60",
                               Age<70~"60-70",Age<80~"70-80")) 


# How many people survived in each age group?

data %>% 
  group_by(age_group,Transported) %>% 
  summarize(count = n()) %>% 
  group_by(age_group) %>% 
  summarize(perc = (count/sum(count))*100, 
            Transported = Transported,
            count = count) %>% 
  ggplot(aes(x = age_group, y = perc,fill = Transported))+
  geom_bar(stat = "identity",position="stack")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  ylab("Percent")+
  xlab("Age Group")






# Relationship between spending and being Transported

# How amount of money spent affected Transported?

roomService <- data %>% 
  ggplot(aes(x= RoomService,y=Transported))+
  geom_boxplot()+
  xlim(0,5000)+
  ggtitle("Room Service costs")+
  xlab("")

foodCourt <- data %>% 
  ggplot(aes(x= FoodCourt,y=Transported))+
  geom_boxplot()+
  xlim(0,5000)+
  ggtitle("Food Court costs")+
  xlab("")

shoppingMall <- data %>% 
  ggplot(aes(x= ShoppingMall,y=Transported))+
  geom_boxplot()+
  xlim(0,5000)+
  ggtitle("Shopping Mall costs")+
  xlab("")


spa <- data %>% 
  ggplot(aes(x= Spa,y=Transported))+
  geom_boxplot()+
  xlim(0,5000)+
  ggtitle("SPA costs")+
  xlab("")

grid.arrange(roomService, foodCourt, shoppingMall,spa,ncol = 2, nrow = 2)








# Relationship between route and being Transported
data <- data %>% 
  mutate(route = paste(HomePlanet,"-",Destination))

# How many people travelled each route?
data %>% 
  ggplot(aes(x = route)) +
  geom_histogram(stat = "count")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  xlab("Route")+
  ylab("Count")

#how many people from each route survived?
data %>% 
  group_by(route,Transported) %>% 
  summarise(n = n()) %>% 
  group_by(route)%>%
  summarise(allcat = sum(n),Transported =  Transported, percentage = n) %>% 
  mutate(percentage = (percentage/allcat)*100) %>% 
  ggplot(aes(x = route,
             y = percentage,
             fill = Transported)) +
  geom_bar(stat= "identity",
           position = "stack") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  xlab("Route")+
  ylab("Percentage")



# Relationship between deck and cabin number and being Transported

data <- data %>% 
  mutate(deck = substr(Cabin,1,1)) %>% 
  mutate(cabin_nr = as.numeric(substr(Cabin,3,nchar(Cabin)-2)))

data %>% 
  ggplot(aes(x = deck, fill = Transported))+
  geom_bar(position = "dodge")+
  ylab("Count")+
  xlab("Deck")

data %>% 
  ggplot(aes(x = cabin_nr,fill= Transported)) +
  geom_histogram(alpha = 0.5, binwidth = 20)+
  xlab("Cabin number")+
  ylab("Count")


# IMPLEMENTING ML MODEL

# selecting variables i want to predict form

dataForModel <- data[,c("CryoSleep","route","Age","VIP","RoomService",
                        "FoodCourt","ShoppingMall","Spa","Transported","deck","cabin_nr")] 

#factorizing data
non_numeric_columns <- sapply(dataForModel, function(x) !is.numeric(x))
dataForModel[,non_numeric_columns] <- lapply(dataForModel[,non_numeric_columns], as.factor)



# splitting data for training and test
trainsample <- sample(1:nrow(dataForModel), 0.8 * nrow(dataForModel))
training <- dataForModel[trainsample, ]
testing <- dataForModel[-trainsample, ]

#model

model <- randomForest(Transported ~ ., data = training, ntree = 100, importance = TRUE)
predictions <- predict(model, newdata = testing)


# model efficiency overview

accuracy <- sum(predictions == testing$Transported) / nrow(testing)
accuracy
confusion_matrix <- table(predictions, testing$Transported)
print(confusion_matrix)


  