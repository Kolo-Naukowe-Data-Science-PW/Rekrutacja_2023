library(tidyverse)

df <- read_csv("../../dane.csv")

df <- df %>% mutate(SumPrice = RoomService+FoodCourt+ShoppingMall+Spa+VRDeck)

df <- df %>% separate(PassengerId, into=c("Group","GroupNr"),sep="_") %>%
  group_by(Group) %>%
  mutate(GroupSize=length(Group)) 


age_ranges <- seq(-1,80,10)  # Specify the bin edges (modify as needed)
df1 <- df %>%
  mutate(Age_Range = cut(Age, breaks = age_ranges,labels=paste(seq(0,70,10),seq(9,79,10),sep="-")))

df1 <- df1 %>% mutate(GroupSize2 = case_when(
  GroupSize %in% c(1,2) ~ "small",
  GroupSize %in% c(3,4) ~ "medium",
  T ~ "big"
))

df1 <- df1 %>% mutate(PriceRange = case_when(SumPrice<500~"low",
                                             SumPrice<1000~"lowmedium",
                                             SumPrice<2000~"medium",
                                             SumPrice<3000~"mediumhigh",
                                             SumPrice<5000~"high",
                                             T~"veryhigh"))

df1$PriceRange <- factor(df1$PriceRange,
                         levels = c("low", "lowmedium", "medium", "mediumhigh", "high","veryhigh"))

df1$GroupSize2 <- factor(df1$GroupSize2,levels=c("small","medium","big"))

########plots#########

df1 %>% mutate(VIP = ifelse(VIP,"VIP","NOT VIP")) %>% 
  filter(!is.na(CryoSleep),!is.na(HomePlanet),!is.na(VIP)) %>% 
  ggplot(aes(x=HomePlanet,fill=CryoSleep)) + 
  geom_bar() + 
  facet_wrap(vars(VIP),scales = "free_y")


df1 %>% na.omit() %>%
  ggplot(aes(x=fct_infreq(Destination),fill=CryoSleep)) + geom_bar() +
  labs(x="Destination")

df1 %>% na.omit() %>% mutate(VIP = ifelse(VIP,"VIP","NOT VIP")) %>%
  ggplot(aes(x=Age_Range, fill=CryoSleep)) + geom_bar() + 
  facet_wrap(vars(VIP),scales = "free_y")+
  theme(axis.text.x = element_text(angle = 90,hjust=1,vjust=0.2))


df1 %>% na.omit() %>% ggplot(aes(x=Age_Range,fill=GroupSize2)) +
  geom_bar(position=position_dodge2()) +
  labs(fill = "Group Size")+scale_y_continuous(expand=c(0,10))


a<-df1 %>% na.omit() %>% group_by(GroupSize) %>% summarise(gn=n())
b<-df1 %>% group_by(GroupSize,Age_Range) %>% summarise(gan=n())
left_join(b,a,by= join_by(GroupSize)) %>% filter(!is.na(Age_Range)) %>% mutate(PcrAgeSize=gan/gn*100) %>%
  ggplot(aes(x=as.factor(GroupSize),y=Age_Range,fill=PcrAgeSize)) +
  geom_tile() + scale_fill_gradient(high = "black", low = "lightyellow")+
  labs(title="Jaki procent grupy stanowią ludzie w danym wieku",
       x="Group Size")


k<-df1 %>% na.omit() %>% group_by(Age_Range) %>% summarise(an=n())
p<-df1 %>% group_by(GroupSize,Age_Range) %>% summarise(gan=n())
left_join(p,k,by= join_by(Age_Range)) %>% filter(!is.na(Age_Range)) %>% 
  mutate(PcrAgeSize=gan/an*100) %>%
  ggplot(aes(x=Age_Range,y=as.factor(GroupSize),fill=PcrAgeSize)) +
  geom_tile() + scale_fill_gradient(high = "black", low = "lightyellow")+
  labs(title="Jaki procent ludzi w daneym wieku stanowi grupa",
       y="Group Size")


df1 %>% na.omit() %>% ggplot(aes(x=Age,y=..count..,fill=Transported)) + 
  geom_density(alpha=0.2) + facet_wrap(vars(GroupSize2),scales = "free_y")+
  labs(title="Transportowanie w zaleznosci od rozmiaru grupy i wieku")


df1 %>% ggplot(aes(SumPrice)) + 
  geom_histogram(bins=30,fill="orange",col="black") +
  scale_x_log10() + scale_y_continuous(expand=c(0,10))+
  labs(x="Suma wydatkow na uslugi")


df1 %>% na.omit() %>% ggplot(aes(x=HomePlanet,fill=PriceRange)) + 
  geom_bar()

df1 %>% na.omit() %>% ggplot(aes(x=Destination,fill=PriceRange)) + 
  geom_bar()


df1 %>% filter(!is.na(Age_Range)) %>% ggplot(aes(x=Age_Range,y=SumPrice))+
  geom_boxplot(aes(col=Age_Range))+scale_y_log10()+
  labs(y="Suma wydatkow na uslugi")+
  theme(legend.position = "none")

df1 %>% na.omit() %>% ggplot(aes(x=HomePlanet,fill=Destination))+
  geom_bar()+facet_wrap(vars(PriceRange),scales = "free_y")+
  labs(title="Rozklady dla roznych grup wydatkow")


#########ML##########
#jakis gowniany ml ale jest

library(randomForest)
library(caTools) 

df<- read_csv("../../dane.csv")
df<-na.omit(df)
factor_cols<-c(2,3,5,7,14)
df[factor_cols] <- lapply(df[factor_cols], as.factor)


set.seed(123)
sample_indices <- sample(1:nrow(df), 0.7 * nrow(df))
train_data <- df[sample_indices, ]
test_data <- df[-sample_indices, ]


rf_model <- randomForest(Transported~.,data=train_data)
predictions <- predict(rf_model, test_data)
confusion_matrix <- table(Actual = test_data$Transported, Predicted = predictions)
accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
print(confusion_matrix)




