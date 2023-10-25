import pandas as pd

data = pd.read_csv('Rekrutacja_2023/spaceship_titanic/dane.csv')

print(len(data[data["HomePlanet"] == "Earth"]))
print(len(data[data["HomePlanet"] == "Europa"]))
print(len(data[data["HomePlanet"] == "Mars"]))

earth_destinations = data[data["HomePlanet"] == "Earth"].groupby("Destination")["HomePlanet"].count()
europa_destinations = data[data["HomePlanet"] == "Europa"].groupby("Destination")["HomePlanet"].count()
mars_destinations = data[data["HomePlanet"] == "Mars"].groupby("Destination")["HomePlanet"].count()
print()
print(earth_destinations)
print()
print(europa_destinations)
print()
print(mars_destinations)

#nothing worth to note in report