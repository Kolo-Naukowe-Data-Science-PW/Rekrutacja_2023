import pandas as pd
from collections import Counter
from sklearn.svm import NuSVC
from math import isnan

def main():
    df = pd.read_csv("titanic.csv") #7000 rows x 14 columns
    #dataset do trenowania modelu
    dftest = pd.read_csv("titanictest.csv")
    #dataset do testowania modelu

    group = []
    for i in df["PassengerId"]:
        group.append(int(i[0:4]))
    norm = max(group)
    for i in range(len(group)):
        group[i] /= norm

    grouptest = []
    for i in dftest["PassengerId"]:
        grouptest.append(int(i[0:4]))
    norm = max(grouptest)
    for i in range(len(grouptest)):
        grouptest[i] /= norm

    #Algorytm liczący ile procent osób z każdej planety przeżyło
    """planet = []
    for i in range(6999):
        planet.append(str(df["HomePlanet"][i]) + str(df["Transported"][i]))
    print(Counter(planet))"""

    Earth = 1610 / 3691
    Europa = 1130 / 1715
    Mars = 744 / 1432
    PlanetNan = 88 / 161

    Earth, Europa, Mars, PlanetNan = Earth/Europa, 1, Mars/Europa, PlanetNan/Europa

    planet = []
    for i in df["HomePlanet"]:
        if i == "Earth":
            planet.append(Earth)
        elif i == "Europa":
            planet.append(Europa)
        elif i == "Mars":
            planet.append(Mars)
        else:
            planet.append(PlanetNan)

    planettest = []
    for i in dftest["HomePlanet"]:
        if i == "Earth":
            planettest.append(Earth)
        elif i == "Europa":
            planettest.append(Europa)
        elif i == "Mars":
            planettest.append(Mars)
        else:
            planettest.append(PlanetNan)

    #Algorytm liczący ile procent osób w każdym stanie snu przeżyło
    """sleep = []
    for i in range(6999):
        sleep.append(str(df["CryoSleep"][i]) + str(df["Transported"][i]))
    print(Counter(sleep))"""

    SleepFalse = 1485 / 4391
    SleepTrue = 1996 / 2433
    SleepNan = 91 / 175

    SleepFalse, SleepTrue, SleepNan = SleepFalse / SleepTrue, 1, SleepNan / SleepTrue

    sleep = []
    for i in df["CryoSleep"]:
        if i == True:
            sleep.append(SleepTrue)
        elif i == False:
            sleep.append(SleepFalse)
        else:
            sleep.append(SleepNan)

    sleeptest = []
    for i in dftest["CryoSleep"]:
        if i == True:
            sleeptest.append(SleepTrue)
        elif i == False:
            sleeptest.append(SleepFalse)
        else:
            sleeptest.append(SleepNan)

    #Kabiny nie będą brane pod uwagę


    #Algorytm liczący ile procent osób przeżyło w zależności od celu podróży
    """dest = []
    for i in range(6999):
        dest.append(str(df["Destination"][i]) + str(df["Transported"][i]))
    print(Counter(dest))"""

    T = 2285 / 4775
    C = 888 / 1452
    P = 319 / 620
    destNan = 80 / 152

    T, C, P, destNan = T / C, 1, P / C, destNan / C

    dest = []
    for i in df["Destination"]:
        if i == "55 Cancri e":
            dest.append(C)
        elif i == "TRAPPIST-1e":
            dest.append(T)
        elif i == "PSO J318.5-22":
            dest.append(P)
        else:
            dest.append(destNan)

    desttest = []
    for i in dftest["Destination"]:
        if i == "55 Cancri e":
            desttest.append(C)
        elif i == "TRAPPIST-1e":
            desttest.append(T)
        elif i == "PSO J318.5-22":
            desttest.append(P)
        else:
            desttest.append(destNan)

    age = []
    for i in df["Age"]:
        if not isnan(i):
            age.append(i)
        else:
            age.append(0)
    norm = max(age)
    for i in range(len(age)):
        age[i] /= norm

    agetest = []
    for i in dftest["Age"]:
        if not isnan(i):
            agetest.append(i)
        else:
            agetest.append(0)
    norm = max(agetest)
    for i in range(len(agetest)):
        agetest[i] /= norm


    #Algorytm liczący ile procent osób przeżyło w zależności od statusu
    """vip = []
    for i in range(6999):
        vip.append(str(df["VIP"][i]) + str(df["Transported"][i]))
    print(Counter(vip))"""

    NoVip = 3430 / 6691
    YesVip = 59 / 148
    NanVip = 83 / 160

    NoVip, YesVip, NanVip = NoVip / NanVip, YesVip / NanVip, 1

    vip = []
    for i in df["VIP"]:
        if i == False:
            vip.append(NoVip)
        elif i == True:
            vip.append(YesVip)
        else:
            vip.append(NanVip)

    viptest = []
    for i in dftest["VIP"]:
        if i == False:
            viptest.append(NoVip)
        elif i == True:
            viptest.append(YesVip)
        else:
            viptest.append(NanVip)

    roomserv = []
    for i in df["RoomService"]:
        if not isnan(i):
            roomserv.append(i)
        else:
            roomserv.append(0)
    norm = max(roomserv)
    for i in range(len(roomserv)):
        roomserv[i] /= norm

    roomservtest = []
    for i in dftest["RoomService"]:
        if not isnan(i):
            roomservtest.append(i)
        else:
            roomservtest.append(0)
    norm = max(roomservtest)
    for i in range(len(roomservtest)):
        roomservtest[i] /= norm

    food = []
    for i in df["FoodCourt"]:
        if not isnan(i):
            food.append(i)
        else:
            food.append(0)
    norm = max(food)
    for i in range(len(food)):
        food[i] /= norm

    foodtest = []
    for i in dftest["FoodCourt"]:
        if not isnan(i):
            foodtest.append(i)
        else:
            foodtest.append(0)
    norm = max(foodtest)
    for i in range(len(foodtest)):
        foodtest[i] /= norm

    mall = []
    for i in df["ShoppingMall"]:
        if not isnan(i):
            mall.append(i)
        else:
            mall.append(0)
    norm = max(mall)
    for i in range(len(mall)):
        mall[i] /= norm

    malltest = []
    for i in dftest["ShoppingMall"]:
        if not isnan(i):
            malltest.append(i)
        else:
            malltest.append(0)
    norm = max(malltest)
    for i in range(len(malltest)):
        malltest[i] /= norm

    spa = []
    for i in df["Spa"]:
        if not isnan(i):
            spa.append(i)
        else:
            spa.append(0)
    norm = max(spa)
    for i in range(len(spa)):
        spa[i] /= norm

    spatest = []
    for i in dftest["Spa"]:
        if not isnan(i):
            spatest.append(i)
        else:
            spatest.append(0)
    norm = max(spatest)
    for i in range(len(spatest)):
        spatest[i] /= norm

    vr = []
    for i in df["VRDeck"]:
        if not isnan(i):
            vr.append(i)
        else:
            vr.append(0)
    norm = max(vr)
    for i in range(len(vr)):
        vr[i] /= norm

    vrtest = []
    for i in dftest["VRDeck"]:
        if not isnan(i):
            vrtest.append(i)
        else:
            vrtest.append(0)
    norm = max(vrtest)
    for i in range(len(vrtest)):
        vrtest[i] /= norm

    #Imiona i nazwiska nie będą brane pod uwagę

    df_norm = pd.DataFrame(list(zip(group, planet, sleep, dest, age, vip, roomserv, food, mall, spa, vr)), columns=["PassengerId", "HomePlanet", "CryoSleep", "Destination", "Age", "VIP", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck"])
    x = df_norm[["PassengerId", "HomePlanet", "CryoSleep", "Destination", "Age", "VIP", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck"]].values
    y = df["Transported"].values
    #input, output do trenowania modelu
    dftest_norm = pd.DataFrame(list(zip(grouptest, planettest, sleeptest, desttest, agetest, viptest, roomservtest, foodtest, malltest, spatest, vrtest)), columns=["PassengerId", "HomePlanet", "CryoSleep", "Destination", "Age", "VIP", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck"])
    xtest = dftest_norm[["PassengerId", "HomePlanet", "CryoSleep", "Destination", "Age", "VIP", "RoomService", "FoodCourt", "ShoppingMall", "Spa", "VRDeck"]].values
    ytest = dftest["Transported"].values

    model = NuSVC()
    model.fit(x, y)
    output = model.predict(xtest)

    correct = 0
    incorrect = 0

    for i in range(len(output)):
        if output[i] == ytest[i]:
            correct += 1
        else:
            incorrect += 1

    print(f"Celność modelu to {(correct/(correct + incorrect))*100}%")

if __name__ == "__main__":
    main()