library(plotly)

#procvip
WYKprocVIP <- plot_ly(data = IleProcVIP, x = ~HomePlanet, y = ~proc, type = "bar")
WYKprocVIP <- WYKprocVIP %>% style(marker.color = c("black","green","blue","red"))
WYKprocVIP <- WYKprocVIP %>% layout(
  title = "Procent VIP-ów z danych planet",
  xaxis = list(title = "Planeta"),
  yaxis = list(title = "Procent VIP")
)
WYKprocVIP
#Vippokład
deckVIP <- plot_ly(data = Vipynievipy, x = ~deck, y = ~proc, type = "bar")
deckVIP <- deckVIP %>% style(marker.color = c("green", "orange", "orange","orange","red","red","red","red"))
deckVIP <- deckVIP %>% layout(
  title = "Procent VIP-ów na danym pokładzie",
  xaxis = list(title = "pokład"),
  yaxis = list(title = "Procent VIP")
)
deckVIP
#VR
WYKVR <- plot_ly(data = razemVR, x = ~HomePlanet, y = ~mVRnaglowe, type = "bar", name = "młodzi")
WYKVR <- WYKVR %>% layout(
  title = "Średni wydatek na korzystanie z VR na osobę",
  xaxis = list(title = "Planeta pochodzenia"),
  yaxis = list(title = "Dolary"),
  colorway = "red",
  legend = list(title = list(text = "grupa wiekowa"))
)
WYKVR <- WYKVR %>%
  add_bars(data = razemVR, x = ~HomePlanet, y = ~średnio, marker = list(color = "green"), name = "wszyscy")
WYKVR <- WYKVR %>%
  add_bars(data = razemVR, x = ~HomePlanet, y = ~sVRnaglowe, marker = list(color = "blue"), name = "osoby starsze")
WYKVR
#Cryo
WYKCRYO <- plot_ly(data = razemCryo, x = ~HomePlanet, y = ~mprocspiacych, type = "bar", name = "młodzi")
WYKCRYO <- WYKCRYO %>% layout(
  title = "Procent osób wybierających hibernację",
  xaxis = list(title = "Planeta pochodzenia"),
  yaxis = list(title = "Procent"),
  colorway = "red",
  legend = list(title = list(text = "grupa wiekowa"))
)
WYKCRYO <- WYKCRYO %>%
  add_bars(data = razemCryo, x = ~HomePlanet, y = ~procspiacych, marker = list(color = "green"), name = "wszyscy")
WYKCRYO <- WYKCRYO %>%
  add_bars(data = razemCryo, x = ~HomePlanet, y = ~sprocspiacych, marker = list(color = "blue"), name = "osoby starsze")
WYKCRYO
#finanse
WYKhajs <- plot_ly(data = Podfin, x = ~HomePlanet, y = ~totalnaosobe, type = "bar")
WYKhajs <- WYKhajs %>% style(marker.color = c("blue","green","red","black"))
WYKhajs <- WYKhajs %>% layout(
  title = "Średnie wydatki na luksusy 
  na osobę z danej planety",
  xaxis = list(title = "Planeta pochodzenia"),
  yaxis = list(title = "Dolary")
)
WYKhajs
#różne rozrywki
sumy <- c(sum(Podfin[, 3]), sum(Podfin[, 4]), sum(Podfin[, 5]),sum(Podfin[, 6]),sum(Podfin[, 7]))
osx <- c("VR", "RoomService", "FoodCourt", "ShoppingMall", "Spa")
WYKpitos <- plot_ly(x = osx, y = sumy, type = "bar")
WYKpitos <- WYKpitos %>% layout(
  title = "Całkowite wydatki na dane udogodnienie",
  xaxis = list(title = "Udogodnienie"),
  yaxis = list(title = "Dolary")
)
WYKpitos




