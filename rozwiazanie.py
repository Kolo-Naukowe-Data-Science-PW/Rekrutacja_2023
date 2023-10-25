from pandas import *
import csv
import matplotlib.pyplot as plt

with open('dane.csv', 'r') as file:
    csv_reader = csv.reader(file)
    with open("poprawne_dane.csv", "w", newline="") as f:
        writer = csv.writer(f)
        for row in csv_reader:
            for i in range(len(row)):
                if row[i] == '' or row[5] == '0.0':
                    break
                elif i == len(row) - 1:
                    writer.writerow(row)
                    break

data = read_csv("poprawne_dane.csv")
passenger_id = data['PassengerId'].tolist()
home_planet = data['HomePlanet'].tolist()
cryo_sleep = data['CryoSleep'].tolist()
cabin = data['Cabin'].tolist()
destination = data['Destination'].tolist()
age = data['Age'].tolist()
vip = data['VIP'].tolist()
room_service = data['RoomService'].tolist()
food_court = data['FoodCourt'].tolist()
shopping_mall = data['ShoppingMall'].tolist()
spa = data['Spa'].tolist()
vr_deck = data['VRDeck'].tolist()
name = data['Name'].tolist()
transported = data['Transported'].tolist()

dict_srednia = {1: 'age',
                2: 'room_service',
                3: 'food_court',
                4: 'shopping_mall',
                5: 'spa',
                6: 'vr_deck'}
d_srednia = {1: 'Średnia Age =',
                2: 'Średnie wydatki na RoomService =',
                3: 'Średnie wydatki na FoodCourt =',
                4: 'Średnie wydatki na ShoppingMall =',
                5: 'Średnie wydatki na spa =',
                6: 'Średnie wydatki na VRDeck ='}
d_wykres = {1: 'Age',
            2: 'RoomService',
            3: 'FoodCourt',
            4: 'ShoppingMall',
            5: 'Spa',
            6: 'VRDeck'}

def mozliwe_akcje():
    print("1 - oblicz średnią dla danego parametru\n"
          "2 - podaj liczbę osób, które spełniały dwa takie same warunki\n"
          "3 - wyświetl wykres dla danych parametrów")

def srednia_czego():
    #Age,VIP,RoomService,FoodCourt,ShoppingMall,Spa,VRDeck
    while True:
        parametr = int(input("Wybierz parametr spośród podanych:\n"
                             "1 - Age\n"
                             "2 - RoomService\n"
                             "3 - FoodCourt\n"
                             "4 - ShoppingMall\n"
                             "5 - Spa\n"
                             "6 - VRDeck\n"))
        if 1 > parametr > 6:
            print("Parametr musi być pomiędzy 1 a 6")
            continue
        else:
            return parametr

def srednia(parametr):
    list_name = dict_srednia[parametr]
    selected_list = globals()[list_name]
    avg = sum(selected_list) / len(selected_list)
    p = d_srednia[parametr]
    print(f"{p} {avg}")
def jakie_parametry():
    parametr1 = int(input("Wybierz parametr1:\n"
                          "1 - HomePlanet\n"
                          "2 - CryoSleep\n"
                          "4 - Destination\n"
                          "14 - Transported\n "))
    if parametr1 == 1:
        jaki1 = str(input("Wybierz i wpisz jedno z wybranych:\n"
                          "Europa, Earth, Mars\n"))
    if parametr1 == 2:
        jaki1 = str(input("Wybierz i wpisz jedno z wybranych:\n"
                          "True, False\n"))
    if parametr1 == 4:
        jaki1 = str(input("Wybierz i wpisz jedno z wybranych:\n"
                          "TRAPPIST-1e, PSO J318.5-22, 55 Cancri e\n"))
    if parametr1 == 14:
        jaki1 = str(input("Wybierz i wpisz jedno z wybranych:\n"
                          "True, False\n"))
    parametr2 = int(input("Wybierz parametr1:\n"
                          "1 - HomePlanet\n"
                          "2 - CryoSleep\n"
                          "4 - Destination\n"
                          "13 - Transported\n "))
    if parametr2 == 1:
        jaki2 = str(input("Wybierz i wpisz jedno z wybranych:\n"
                          "Europa, Earth, Mars\n"))
    if parametr2 == 2:
        jaki2 = str(input("Wybierz i wpisz jedno z wybranych:\n"
                          "True, False\n"))
    if parametr2 == 4:
        jaki2 = str(input("Wybierz i wpisz jedno z wybranych:\n"
                          "TRAPPIST-1e, PSO J318.5-22, 55 Cancri e\n"))
    if parametr2 == 13:
        jaki2 = str(input("Wybierz i wpisz jedno z wybranych:\n"
                          "True, False\n"))

    return parametr1, jaki1, parametr2, jaki2
def jaki_wykres():
    #Age,RoomService,FoodCourt,ShoppingMall,Spa,VRDeck
    y_axis = int(input("Wybierz co ma znajdować się na osi Y:\n"
                       "1 - Age\n"
                       "2 - RoomService\n"
                       "3 - FoodCourt\n"
                       "4 - ShoppingMall\n"
                       "5 - Spa\n"
                       "6 - VRDeck\n"))
    x_axis = int(input("Wybierz co ma znajdować się na osi X:\n"
                             "1 - Age\n"
                             "2 - RoomService\n"
                             "3 - FoodCourt\n"
                             "4 - ShoppingMall\n"
                             "5 - Spa\n"
                             "6 - VRDeck\n"))

    par_x = d_wykres[x_axis]
    par_y = d_wykres[y_axis]
    y_min = int(input(f"Podaj minimalną wartość {par_y}:\n"))
    y_max = int(input(f"Podaj maksymalną wartość {par_y}:\n"))
    x_min = int(input(f"Podaj minimalną wartość {par_x}:\n"))
    x_max = int(input(f"Podaj maksymalną wartość {par_x}:\n"))

    # age_min = int(input("Podaj minimalny wiek:\n"))
    # age_max = int(input("Podaj maksymalny wiek: \n"))
    return x_axis, y_axis, y_min, y_max, x_min, x_max

def wykres(x_axis, y_axis, y_min, y_max, x_min, x_max):
    list_x = dict_srednia[x_axis]
    x = globals()[list_x]
    x_copy = x.copy()  # Create a copy of x
    list_y = dict_srednia[y_axis]
    y = globals()[list_y]
    y_copy = y.copy()  # Create a copy of y
    i = 0  # Initialize an index for the new lists
    while i < len(x_copy):
        if not (y_min <= y_copy[i] <= y_max) or not (x_min <= x_copy[i] <= x_max):
            # If the conditions are met, remove the elements from both lists
            del x_copy[i]
            del y_copy[i]
        else:
            i += 1  # Move to the next element if no removal is done

    plt.xlabel(list_x)
    # # naming the y axis
    plt.ylabel(list_y)
    # giving a title to my graph
    plt.scatter(x_copy, y_copy)

    plt.title(f'Wykres punktowy {list_y} w zakresie ({y_min} - {y_max}) od {list_x} w zakresie ({x_min} - {x_max}) ')
    # function to show the plot
    plt.show()

def ile_wybralo(parametr1, jaki1, parametr2, jaki2):#parametr1,jaki1,parametr2,jaki2
    #HomePlanet-1,CryoSleep-2,Destination-4,Transported-14
    with open("poprawne_dane.csv", newline="") as f:
        reader = csv.reader(f)
        ile = 0
        for row in reader:
            if row[parametr1] == jaki1 and row[parametr2] == jaki2:
                ile += 1
    print(f"{ile} ({ile/6467}%) osób spełnia obydwa podane warunki")


def main():
    while True:
        mozliwe_akcje()
        numer_akcji = int(input("Wybierz akcję \n"))
        if numer_akcji == 1:
            (srednia(srednia_czego()))
        if numer_akcji == 2:
            params = jakie_parametry()
            ile_wybralo(*params)
        if numer_akcji == 3:
            paramss = jaki_wykres()
            wykres(*paramss)
        continue


if __name__ == "__main__":
    main()
