data<- read.csv("C:\\Users\\igorr\\Documents\\dane.csv")

library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(reticulate)
library(lubridate)
library(gridExtra)
library(gt)
library(kableExtra)
library(formattable)
library(DT)
library(patchwork)
library(gtExtras)
library(packcircles)
library(reshape2)


#let's begin with some basic analysis

#first let's check how many passengers are from each planet

head(data)

basic_planets_inhabitants_info<-data %>% group_by(HomePlanet) %>% 
  summarise(passengers= n()) %>% 
  arrange(desc(passengers))

max_passengers <- basic_planets_inhabitants_info$passengers[1]

basic_planets_inhabitants_info[4, 'HomePlanet']<- "???"

basic_planets_inhabitants_info$HomePlanet <- factor(
  basic_planets_inhabitants_info$HomePlanet, 
  levels = basic_planets_inhabitants_info$HomePlanet[order(-basic_planets_inhabitants_info$passengers)]
)

custom_colors_planets_inhabitants <- c("#0066ff", "dodgerblue", "lightblue", "skyblue")

ggplot(basic_planets_inhabitants_info, aes(x = reorder(HomePlanet, -passengers), y = passengers, fill = HomePlanet)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = custom_colors_planets_inhabitants) +
  theme_minimal() +
  labs(
    title = "HomePlanets inhabitants as passengers",
    x = "Home Planet",
    y = "Passengers amount"
  )+ theme(legend.position = "right",
           axis.title.y = element_text(vjust = 3),
           axis.title.x = element_text(vjust = -0.4),
           plot.title = element_text(hjust = 0.5)) +
  coord_cartesian(ylim = c(0, max_passengers))

#know if we know from which planets passengers come now it's good to know
#whether they know to which groups they belong to. Let's check the data

planets_to_groups <- data.frame(
  Planet = c("Europa", "Earth", "Mars", ""),
  Groups = rep(0, 4)
)

amount_of_rows<- length(data$PassengerId)

split_strings <- strsplit(data$PassengerId, "_")

splitted_groups<- sapply(split_strings, function(x) x[1])
splitted_pp<- sapply(split_strings, function(x) x[2])

for (i in 1:amount_of_rows){
  planet<- data$HomePlanet[i]
  group<- splitted_groups[i]
  pp<- splitted_pp[i]
  
  row_selected<- which(planets_to_groups$Planet==planet)
  
  prev_data<- planets_to_groups$Groups[row_selected]
  
  if(!is.list(prev_data)){
    
    planets_to_groups$Groups[row_selected]<- list(c(group))
    
  }else{
    u_list<- unlist(prev_data)
    to_add<- union(u_list, c(group))
    listed<- list(to_add)
    planets_to_groups$Groups[row_selected]<- listed
  }
}

planets_to_groups$Groups

#seems a lot of groups, now let's check what we can got from them

#first how many groups are from every planet

europa_groups<- unlist(planets_to_groups$Groups[1])
europa_groups<- intersect(europa_groups, splitted_groups)

earth_groups<- unlist(planets_to_groups$Groups[2])
earth_groups<- intersect(earth_groups, splitted_groups )

mars_groups<- unlist(planets_to_groups$Groups[3])
mars_groups<- intersect(mars_groups, splitted_groups)

noone_groups<- unlist(planets_to_groups$Groups[4])
noone_groups<- intersect(noone_groups, splitted_groups)

earth_groups<- setdiff(europa_groups, c("0"))
mars_groups<- setdiff(mars_groups, c("0"))

europa_groups_amount<-length(europa_groups)
earth_groups_amount<-length(earth_groups)
mars_groups_amount<- length(mars_groups)
noone_groups_amount<-length(noone_groups)

europa_groups

europa_groups_amount
earth_groups_amount
mars_groups_amount
noone_groups_amount

#quite interesting, the number of groups per planet is not that far
#away to number of passengers per planet. But what about the number of people
#which are in groups. How many can there be? Let's answer to these question later.

#first let's see if it is possible that inhabitants from different planets
#can be in the same group

intersection_list_4<- list(europa_groups, earth_groups, mars_groups, noone_groups)

intersection_4 <- Reduce(intersect, intersection_list_4)

intersections <- list()
groups_numbers_intersection<- list()

matrix_co_travelling <- matrix(0, nrow = 4, ncol = 4)
matrix_co_travelling <- as.data.frame(matrix_co_travelling)
row.names(matrix_co_travelling) <- c("europa", "earth", "mars", "???")
colnames(matrix_co_travelling) <- c("europa", "earth", "mars", "???")


for (i in 1:length(intersection_list_4)) {
  for (j in 1:length(intersection_list_4)) {
    if (i != j) {
      common_values <- intersect(intersection_list_4[[i]], intersection_list_4[[j]])
      if (length(common_values) > 0) {
        intersections <- append(intersections, list(common_values))
        matrix_co_travelling[i,j]<- length(common_values)
      }
    }
  }
}

intersections

#from the results ones may see that people from different planets
#might be in the same group

intersections
matrix_co_travelling

planet<-row.names(matrix_co_travelling)

result<-  cbind(row,matrix_co_travelling )

colnames(result)[colnames(result) == "row"] <- "planet"

summary_groups_together<- gt(result) 

summary_groups_together %>%  tab_header(
  title = md("Group amount relationship"),
  subtitle = md("`interplanetary  passengers`")
)

summary_groups_together_marked<-summary_groups_together %>%  tab_style(
  style = cell_fill(color = 'lightblue'),
  locations = cells_body(
    columns = c(5), 
    rows = c(1:2)
  )) %>% tab_style(
    style = cell_fill(color = 'lightblue'),
    locations = cells_body(
      columns = c(2:3), 
      rows = c(4)
    )) %>% tab_style(
        style = cell_fill(color = 'dodgerblue'),
        locations = cells_body(
          columns = c(3), 
          rows = c(1)
        )) %>% tab_style(
          style = cell_fill(color = 'dodgerblue'),
          locations = cells_body(
            columns = c(2), 
            rows = c(2)
          )) %>% tab_style(
            style = cell_fill(color = 'skyblue'),
            locations = cells_body(
              columns = c(5), 
              rows = c(3)
            )) %>% tab_style(
              style = cell_fill(color = 'skyblue'),
              locations = cells_body(
                columns = c(4), 
                rows = c(4)
              )) %>%  tab_header(
          title = md("Group amount relationship"),
          subtitle = md("`interplanetary  passengers`")
        ) 

summary_groups_together_marked


#think about being a passenger from different planet, you bought a ticket
#and you know to which group you belong. How to find out strictly looking
#by digits whether you are with somebody from another planet or not,
#i may want to know what's the chance of being in group with someone different

noone_meeting_groups_europa<- intersect(noone_groups, europa_groups)
noone_meeting_groups_earth<- intersect(noone_groups, earth_groups)

noone_meeting_groups_europa
noone_meeting_groups_earth

#interesting fact
#we may see that every flight where there are passengers from "europa" is with
#passengers from "earth" and mayby with people from different planets that have not been mentioned

mars_groups_amount

#quite interesting fact is that people from "mars" do not flight with people from "europa" and "earth"
#there are over 1234 of marsjans but only 28 groups flight with people from planet which name is unknown
#we assume that by name "". The rest 1234-28 flights might be only by marsjans or with the others uknown group

#now, let's present that information

total_groups <- data.frame(
  planet = c("europa", "earth", "mars", "???"),
  groups = c(europa_groups_amount, earth_groups_amount, mars_groups_amount, noone_groups_amount)
)

gt_total_groups<- gt(total_groups)

gt_total_groups

#now when we gathered info about interplanetary passengers and their flights
#it's good to know kow many people are in the group

#let's start from "earth" and "europa"

groups_and_places<-data.frame(
  groups= europa_groups,
  current_passengers= 0
)

for (i in 1:amount_of_rows){
  group<- splitted_groups[i]
  condition<- group %in% europa_groups 
  
  if(condition){
    row_selected<- which(groups_and_places$groups==group)
    
    pp<- splitted_pp[i]
    
    prev_data<- groups_and_places$current_passengers[row_selected]
    
    if(!is.list(prev_data)){
      groups_and_places$current_passengers[row_selected]<- list(c(pp))
    }else{
      u_list<- unlist(prev_data)
      to_add<- union(u_list, c(pp))
      listed<- list(to_add)
      groups_and_places$current_passengers[row_selected]<- listed
    }
    
  }
}

groups_and_places$lengths <- sapply(groups_and_places$current_passengers, length)

places_reversed_order<-groups_and_places %>% arrange(desc(lengths))
#we have to consider that 



total_places<- places_reversed_order %>% group_by(lengths) %>% summarize(Amount= n())

total_places$lengths<- as.character(total_places$lengths)

total_places$fraction <- total_places$Amount / sum(total_places$Amount)

total_places$ymax <- cumsum(total_places$fraction)

total_places$ymin <- c(0, head(total_places$ymax, n=-1))

total_places$labelPosition <- (total_places$ymax + total_places$ymin) / 2

total_places$label <- paste0(total_places$lengths)


percents<-as.character(round(total_places$fraction*100,2))

percents_characters <- paste(percents, "%", sep = "")


total_places

places_dependencies<-ggplot(total_places, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=lengths )) +
  geom_rect() +
  geom_text( x=4.5, aes(y=labelPosition, label=label, color=lengths), size=6)+
  geom_text( x=2, aes(y=labelPosition, label=percents_characters, color=lengths), size=5, alpha= ifelse(seq_along(percents_characters) >= 6, 0, 1)      )+
  
  scale_fill_brewer(palette=1) +
  scale_color_brewer(palette=1) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none",
        plot.title = element_text(family = "Arial", color = "skyblue")
        ) + labs(title = "Percentage share of groups sizes in the flights", subtitle = "of people from \"earth\" and \"europa\"  ")

places_dependencies


#now let's take a closer look on CryoSleep
#one of the most basic questions is, how many people are there in cryosleep

cryo_sleep_false_data<- data %>% filter(CryoSleep =="False")
cryo_sleep_true_data<- data  %>% filter(CryoSleep== "True")

cryo_sleep_false_amount<- length(cryo_sleep_false_data$PassengerId)
cryo_sleep_true_amount<- length(cryo_sleep_true_data$PassengerId)

basic_cryo_sleep<- data.frame(
  group= c("is in", "is not in"),
  value= c(cryo_sleep_true_amount,cryo_sleep_false_amount )
)

percent_is<- cryo_sleep_true_amount*100/(cryo_sleep_true_amount+cryo_sleep_false_amount)

percent_is<-round(percent_is, 2)

percent_is_not<- as.character(100-percent_is)

percent_is<- as.character(percent_is)

percent_is<- paste(percent_is, "%")

percent_is_not<- paste(percent_is_not, "%")


packing <- circleProgressiveLayout(basic_cryo_sleep$value, sizetype='area')

basic_cryo_sleep <- cbind(basic_cryo_sleep, packing)

dat.gg <- circleLayoutVertices(packing, npoints=10000)

ggplot() + 
  
  geom_polygon(data = dat.gg, aes(x, y, group = id, fill=as.factor(id)),alpha = 0.95) +
  
  geom_text(data = basic_cryo_sleep, aes(x, y, label = group), size=6, color="white") +
  scale_size_continuous(range = c(1,4)) +
  scale_fill_brewer(palette = 1) +
  theme_void() + 
  theme(legend.position="none",
        plot.title = element_text(family = "Arial", color = "black", hjust = 0.5, vjust = 2)) +
  coord_equal() + labs(title = expression( ~ bold("CryoSleep") ~ "and percent of passengers in this state"))+
  annotate("text", x = -29, y = -10, label = percent_is, color = "white", size = 6, family = "Arial", face = "bold")+
  annotate("text", x = 43, y = -10, label = percent_is_not, color = "white", size = 6, family = "Arial", face = "bold")


head(data)

#now let's try to see if there is any correlation between CryoSleep and
#Cabin, Destination and Age


needed_cabins_cryosleep_info<- data %>% select(CryoSleep, Cabin)

#now let's select only not empty Cabin and CryoSleep

needed_cabins_cryosleep_info<- needed_cabins_cryosleep_info %>% 
  filter(CryoSleep!="" & Cabin!="")


cabins_summary<- data.frame(
  condition= c("True", "False")
  
)

homeplanet_and_cabin<- data.frame(
  "B"= c(0,0,0,0),
  "F"= c(0,0,0,0),
  "A"= c(0,0,0,0),
  "G"= c(0,0,0,0),
  "E"= c(0,0,0,0),
  "D"= c(0,0,0,0),
  "C"= c(0,0,0,0),
  "T"= c(0,0,0,0)
)

homeplanet_and_cabin[["planet"]]<- c("Europa", "Earth", "Mars", "")


homeplanet_and_cabin



for (i in 1:length(needed_cabins_cryosleep_info$CryoSleep)) {
  
  is_cryosleeped<-needed_cabins_cryosleep_info$CryoSleep[i] 
  
  cabin_data<- needed_cabins_cryosleep_info$Cabin[i]
  
  split_parts <- unlist(strsplit(cabin_data, "/"))
  
  planeted<- data$HomePlanet[i]
  
  deck <- split_parts[1]
  num <- split_parts[2]
  side <- split_parts[3]
  
  
  if(is_cryosleeped=="True"){
    row_selected_2<-which(homeplanet_and_cabin$planet==planeted)
    
    homeplanet_and_cabin[row_selected_2, deck]<- homeplanet_and_cabin[row_selected_2, deck]+1
  }
  
  
  if (!(deck %in% colnames(cabins_summary))) {
    
    if(is_cryosleeped=="True"){
      cabins_summary[[deck]] <- c(1,0)
    }else{
      cabins_summary[[deck]] <- c(0,1)
    }
  }else{
    
    row_selected<- which(cabins_summary$condition==is_cryosleeped)
    cabins_summary[row_selected, deck]<- cabins_summary[row_selected, deck]+1
  }
}

cus
tom_color_scale <- function(column) {
  
  min_val <- min(column)
  max_val <- max(column)
  
  color_palette <- colorRampPalette(c("skyblue", "dodgerblue"))(100)
  
  colors <- color_palette[cut(column, breaks = 100)]
  
  return(colors)
}

cabins_summary

cabins_visualization <- cabins_summary %>%
  gt() %>%
  data_color(
    columns = -1, 
    colors = custom_color_scale
  )

cabins_visualization


#we might see that there are some cabins, where number of people in
#cryosleep is greather then those who are not in the cryosleep

#now let's see how those in the cryosleep look like in lollipop chart

x_cabins<- colnames(cabins_summary)[2:length(colnames(cabins_summary))]

y_cabins<-cabins_summary[cabins_summary$CryoSleep=="True",c(-1)]

colnames(y_cabins)<-NULL

y_cabins<- unlist(y_cabins)

cabins_lollipop_data<- data.frame(
  x= x_cabins,
  y=y_cabins
)

cabins_lollipop_plot<- ggplot(cabins_lollipop_data, aes(x = x, y = y)) +
  geom_segment(aes(x = x, xend = x, y = 0, yend = y),
               color = "skyblue", lwd = 1.3) +
  theme_light() +
  geom_point(size = 10, pch = 21, bg = 4, color="dodgerblue") +
  geom_text(aes(label = y), color = "white", size = 3) +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Dependency of passengers in CryoSleep",
    subtitle = "to the belonging deck"
  )+
  ylab("")+ xlab("") +
  theme(
    plot.title = element_text(size = 12, face = "bold"),     # Change font size and style for title
    plot.subtitle = element_text(size = 8, face = "italic")  # Change font size and style for subtitle
  )

cabins_lollipop_plot

#but we can look deeper into data and check if cryoSleep cabins are somehow
#seperated depending on passenger homeplanet. Mayby 'earth' only goes for [B, F,A]
#and the rest for the other, we have to check that

#home_planet_and_cabin
#add heatmap there

homeplanet_and_cabin$planet[4]<- "???"

rownames(homeplanet_and_cabin)<- homeplanet_and_cabin$planet


homeplanet_and_cabin_sel<- homeplanet_and_cabin %>% select(-planet)

homeplanet_and_cabin_sel<-homeplanet_and_cabin_sel %>% select(-T)

homeplanet_and_cabin_sel$rownames<-rownames(homeplanet_and_cabin_sel)

melted_data <- melt(data = homeplanet_and_cabin_sel, id.vars = "rownames")

colnames(melted_data)[3]<- "Amount"

heat_map <- ggplot(melted_data, aes(rownames , variable )) +
  geom_tile(aes(fill = Amount))+scale_fill_gradient(low = "lightblue", high = "dodgerblue") +
  labs(x = "Planet", y = "Deck", fill = "Amount", title = "Planets inhabitants to belonging group") +
  theme_minimal()+theme(
    plot.title = element_text(size = 12, face = "bold")  # Change font size and style for subtitle
  )

heat_map


#now let's take cabins and see if in some cabins there are more "P" then "S"

p_s_to_group<- data.frame(
  side= c("P", "S")
)

data_group<- data %>% filter(Cabin!="")


for (i in 1:length(data$HomePlanet)) {
  to_be_splitted_cabin <- data$Cabin[i]
  split_elements <- unlist(strsplit(to_be_splitted_cabin, "/", fixed = TRUE))
  deck <- split_elements[1]
  num <- split_elements[2]
  side <- split_elements[3]
  
  cryo <- data$CryoSleep[i]
  
  if (cryo == "True") {
    if (!is.na(side)) {  # Check for missing values
      if (deck %in% colnames(p_s_to_group)) {
        row_selected <- which(p_s_to_group$side == side)
        p_s_to_group[row_selected, deck] <- p_s_to_group[row_selected, deck] + 1
      } else {
        if (side == "P") {
          p_s_to_group[[deck]] <- c(1, 0)
        } else {
          p_s_to_group[[deck]] <- c(0, 1)
        }
      }
    } else {
    }
  }
}

head(data)

#now let's compare this data by using bar plot
p_s_to_group

melted_p_s <- melt(data = p_s_to_group, id.vars = "side")

ggplot(melted_p_s, aes(variable , value, fill = side )) +
  geom_bar(stat="identity", position = "dodge") + 
  labs(title="Passengers in cryoSleep to group and side they belong to")+scale_fill_manual(values = c("dodgerblue", "skyblue"))+
  xlab("Passengers decks") +
  ylab("People in CryoSleep ")+
  theme(
    plot.title = element_text(family = "Arial", face = "bold", size = 12)
  )


