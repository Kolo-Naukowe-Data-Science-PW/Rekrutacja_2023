import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

with open("dane.txt", "r+") as czytany_plik:
    czytany_plik.readline()
    mars = 0
    europa = 0
    earth = 0
    cryo_sen_tak = 0
    cryo_sen_nie = 0
    cryo_ogolnie = 0
    pieniadze_RoomService = 0
    liczba_RoomService = 0
    wiek = 0
    liczba_wiek = 0
    tak_vip = 0
    nie_vip = 0
    trappist = 0
    cancri_e = 0
    pso = 0

    for line in czytany_plik:
        lista = line.split(",")
        #print(lista)

        #liczba osob z danej planety
        if lista[1] == "Mars":
            mars+=1
        elif lista[1] == "Earth":
            earth+=1
        elif lista[1] == "Europa":
            europa+=1

        #liczba osob w CryoSleep
        if lista[2] == "True":
            cryo_sen_tak+=1
            cryo_ogolnie+=1
        elif lista[2] == "False":
            cryo_sen_nie+=1
            cryo_ogolnie+=1

        #srednia liczba pieniedzy wydana na RoomService
        if len(lista[7]) == 0:
            czytany_plik.readline()
        elif float((lista[7])) > 0.0:
            pieniadze_RoomService+=float(lista[7])
            liczba_RoomService+=1

        #sredni wiek pasazerow
        if len(lista[5]) == 0:
            czytany_plik.readline()
        elif float(lista[5])!= 0.0:
            wiek+=float(lista[5])
            liczba_wiek+=1

        #liczba vipow
        if len(lista[6]) == 0:
            czytany_plik.readline()
        elif lista[6] == "True":
            tak_vip+=1
        elif lista[6] == "False":
            nie_vip+=1

        #destination
        if len(lista[4]) == 0:
            czytany_plik.readline()
        elif lista[4] == "TRAPPIST-1e":
            trappist+=1
        elif lista[4] == "PSO J318.5-22":
            pso+=1
        elif lista[4] == "55 Cancri e":
            cancri_e+=1





print(f"Liczba osob ktore skorzystaly z Room Serivce wynosi {liczba_RoomService}")
print(f"W sumie te osob wydały {pieniadze_RoomService}")
print(f"Kazda osoba wydała średnio : {pieniadze_RoomService/liczba_RoomService}")
print (f"Sredni wiek wynosil: {wiek/liczba_wiek}")
    #print(cryo_ogolnie)
    #print(cryo_sen_tak)
    #print(cryo_sen_nie)

    #print(mars)
    #print(earth)
    #print(europa)

#wykres slupkowy - planeta domowa
height = [mars, europa, earth]
bars = ["Mars", "Europa", "Ziemia"]
y_pos = range(len(height))

plt.bar(y_pos, height)

plt.xticks(y_pos, bars)

plt.xlabel("Planeta")
plt.ylabel("Liczba mieszkancow")
plt.title("Liczba mieszkancow z danej planety")

plt.show()

#wykres kolowy - CryoSleep

y = np.array([cryo_sen_tak,cryo_sen_nie])
mylabels = ["Weszły", "Nie weszły"]
mycolors = ["red", "green"]


plt.pie(y, labels = mylabels, colors = mycolors)
plt.legend(title = "Stosunek liczby osob, które weszły w Cryo sen do tych, które nie weszły")
plt.show()

#czy kosmonauta jest vipem - wykres slupkowy
height = [tak_vip, nie_vip]
bars = ["Tak", "Nie"]
y_pos = range(len(height))
color = (0.2,0.4)

plt.bar(y_pos, height)

plt.xticks(y_pos, bars)

plt.xlabel("Czy pasażer jest VIPem?")
plt.ylabel("Liczba VIPów")
plt.title("Czy pasażer jest VIPem?")

plt.show()

#wykres kolowy - destination

y = np.array([trappist,pso,cancri_e])
mylabels = ["TRAPPIST-1e", "PSO J318.5-22", "55 Cancri e"]
mycolors = ['#4F6272', '#B7C3F3', '#DD7596']


plt.pie(y, labels = mylabels, colors = mycolors)
plt.legend(title = "Miejsce docelowe")
plt.show()