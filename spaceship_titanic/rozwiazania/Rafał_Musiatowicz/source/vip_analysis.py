import pandas as pd

data = pd.read_csv('Rekrutacja_2023/spaceship_titanic/dane.csv')

vip = data[data["VIP"] == True]
not_vip = data[data["VIP"] == False]

room_service_vip = vip["RoomService"].mean()
room_service_not_vip = not_vip["RoomService"].mean()

columns_of_interest = ["RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck"]

avg_vip = vip[columns_of_interest].mean()
avg_not_vip = not_vip[columns_of_interest].mean()
print(avg_vip)
print(avg_not_vip)

sum_vip1 = vip[columns_of_interest].sum(axis=1)
sum_not_vip1 = not_vip[columns_of_interest].sum(axis=1)

avg_sum_vip1 = sum_vip1.mean()
avg_sum_not_vip1 = sum_not_vip1.mean()

print()
print(avg_sum_vip1)
print(avg_sum_not_vip1)

print("VIP sleep: ", len( (data[ (data["VIP"] == True) & (data["CryoSleep"] == True) ]) ))
print("VIP not sleep: ", len( (data[ (data["VIP"] == True) & (data["CryoSleep"] == False) ]) ))
print("not VIP sleep: ", len( (data[ (data["VIP"] == False) & (data["CryoSleep"] == True) ]) ))
print("not VIP not sleep: ", len( (data[ (data["VIP"] == False) & (data["CryoSleep"] == False) ]) ))

print("Precentage of VIP sleeping: ", 21/175)
print("Precentage of not VIP sleeping: ", 2941/5143)

print()
print("Relationship between age and VIP:")
step = 5
sum = 0
for i in range (0, 80, step):
    age_filter = (vip["Age"] >= i) & (vip["Age"] < i+step)
    print("<" + str(i) + "," + str(i+step-1) + ">", len(vip[age_filter]) )


homePlanets = data["HomePlanet"].unique()
homePlanets_vip_count = data[data["VIP"] == True].groupby("HomePlanet")["VIP"].count()

print("Home Planets:", homePlanets)
print(homePlanets_vip_count)