import pandas as pd

data = pd.read_csv('Rekrutacja_2023/spaceship_titanic/dane.csv')

print("Ilosc pasazerow: ", len(data))


homePlanets = data['HomePlanet'].unique()
destinationPlanets = data['Destination'].unique()
crioCounter = len(data[data['CryoSleep'] == False])
awakeCounter = len(data[data['CryoSleep'] == True])
mediumAge = data['Age'].mean()
stdDevAge = data['Age'].std()
vip = len(data[data['VIP'] == True])
notVip = len(data[data['VIP'] == False])
transported = len(data[data['Transported'] == True])
notTransported = len(data[data['Transported'] == False])

earth = len(data[data['HomePlanet'] == 'Earth'])
europa = len(data[data['HomePlanet'] == 'Europa'])
mars = len(data[data['HomePlanet'] == 'Mars'])
dest1 = len(data[data['Destination'] == 'TRAPPIST-1e'])
dest2 = len(data[data['Destination'] == 'PSO J318.5-22'])
dest3 = len(data[data['Destination'] == '55 Cancri e'])

print("Planets: ", homePlanets)
print("CryoSleep: ", crioCounter)
print("Awaken: ", awakeCounter)
print("Destinations: ", destinationPlanets)
print("Sredni wiek: ", mediumAge, "Odchylenie standardowe: ", stdDevAge)
print("VIP: ", vip)
print("Not VIP: ", notVip)
print("Transported: ", transported)
print("Not transported: ", notTransported)
print("Earth: ", earth)
print("Europa: ", europa)
print("Mars: ", mars)
print("TRAPPIST-1e: ", dest1)
print("PSO J318.5-22:", dest2)
print("55 Cancri e:", dest3)

