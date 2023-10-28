import numpy as np
import matplotlib.pyplot as plt
import math
def czypoprawna(a):
    for i in range (0, 14):
        if a[i] == '':
            return False
    return True
def wykres2():
    # creating the dataset

    grupywiek = ["0-20", "21-35", "36-60", "61-100"]
    values = [43.3, 32.4, 31.6, 31.3]

    fig = plt.figure(figsize=(10, 5))

    # creating the bar plot
    plt.bar(grupywiek, values, color='maroon',
            width=0.4)

    plt.xlabel("Grupy wiekowe")
    plt.ylabel("% ludzi z grup wiekowych który zgodzili się na kriosen")
    plt.title("wiek a skłonność do zgody na kriosen.")
    plt.show()

def wykres1():
    # creating the dataset

    grupywiek = ["0-20", "21-35", "36-60", "61-100"]
    values = [640, 1650, 2114, 1964]

    fig = plt.figure(figsize=(10, 5))

    # creating the bar plot
    plt.bar(grupywiek, values, color='maroon',
            width=0.4)

    plt.xlabel("grupy wiekowe")
    plt.ylabel("średnie wydatki razem")
    plt.title("wiek a średnie wydatki")
    plt.show()
def wykres3():
    # creating the dataset
    y = np.array([54, 21, 25])
    mylabels = ["Earth - 54%", "Mars - 21%", "Europa - 25%"]

    plt.pie(y, labels=mylabels)
    plt.show()
def wykres4():
    # creating the dataset
    y = np.array([69, 9.5, 21.5])
    mylabels = ["TRAPPIST-1e - 69%", "PSO J318.5-22 - 9,5%", "Cancri e - 21.5% "]

    plt.pie(y, labels=mylabels)
    plt.show()
def wykresy():
    print("Jaki wykres cie interesuje?")
    n = int(input("średnie wydatki a grupy wiekowe - podaj 1\n"
                  " % zgody na kriosen a grupy wiekowe - podaj 2 \n"
                  " % pasażerów z danej planety - podaj 3\n"
                  " % pasażerów lecących na daną planetę - podaj 4\n"))
    if n ==1:
        wykres1()
    if n ==2:
        wykres2()
    if n ==3:
        wykres3()
    if n ==4:
        wykres4()
def menu_główne():
    wybor = int(input("Zakie zagadnienie chcesz zgłębić? \n"
            "Średnia wartość  - wybierz 1 \n"
            "Najbardziej popularny wybór - wybierz 2 \n"
            "Procent i liczba danych pasażerów którzy zgodzili się na - wybierz 3 \n"
            "Zakończ program - wybierz 4\n"
            "Wykres - wybierz 5\n"))
    return wybor
def srednia_wartość():
    wybor1 = int(input("Średnia jakiej danej cie interesuje?\n"
                       "wiek - wybierz 5\n"
                       "foodcourt - wybierz 8 \n"
                       "spa - wybierz 10\n "
                       "roomservice - wybierz 7\n"
                       "vrdeck - wybierz 11\n"
                       "wszystkie razem (bez wieku) - wybierz 69\n"))
    wybor2 = str(input("Podaj nazwe planety dla której mieszkańców chciałbyś to wiedzieć \n Earth lub Europa lub Mars:"
                       "Jeśli chcesz wiedzieć dla wszystkich podaj 1  "))
    wiek1 = int(input("Jaka kategoria wiekowa cie interesuje? Podaj dolny jej całkowity dolny koniec \n "))
    wiek2 = int(input("Teraz górny\n"))

    with open("dane.txt", "r") as wpisuje_dane:

        wpisuje_dane.readline()
        suma = 0
        licznik_linijek = 0
        for line in wpisuje_dane:
            lista = line.split(",")
            if czypoprawna(lista) == True:
                if wiek1 <= float(lista[5]) <= wiek2 and wybor1 != 69:
                    if lista[1] == wybor2 or wybor2 == str(1):
                        lista[wybor1] = lista[wybor1].strip()
                        suma += float(lista[wybor1])
                        licznik_linijek +=1
                if wiek1 <= float(lista[5]) <= wiek2 and wybor1 == 69:
                    if lista[1] == wybor2 or wybor2 == str(1):
                        suma = suma + float(lista[7]) + float(lista[8]) + float(lista[9]) + float(lista[10]) + float(lista[11])
                        licznik_linijek +=1
    print(f"wybrana średnia to {suma/licznik_linijek}")
def popularny_wybór():
    kto = str(input("Jeśli obchodzi cię wybór pośród mieszkańców konkretnej planety - wpisz jej nazwę.\n"
              " Jeśli wszystkich - podaj 1"))
    n = int(input("najpopularniejsze miejsce zamieszkania - wybierz 1 \n"
                  "najpopularniejsza destynacja - wybierz 4 \n"))
    wiek1 = int(input("Jaka kategoria wiekowa cie interesuje? Podaj dolny jej całkowity dolny koniec \n "))
    wiek2 = int(input("Teraz górny\n"))
    with open("dane.txt", "r") as wpisuje_dane:
        wpisuje_dane.readline()
        slownik = {}
        licznik = 0
        for line in wpisuje_dane:
            lista = line.split(",")
            if czypoprawna(lista) == True:
                if wiek1 <= float(lista[5]) <= wiek2:
                    if lista[1] == kto or kto == str(1):
                        if lista[n] in slownik:
                            slownik[lista[n]] +=1
                        else:
                            slownik[lista[n]] = 1
                        licznik +=1
        top_wybor = max(slownik, key=slownik.get)
        min_wybor = min(slownik, key=slownik.get)
        pro = (slownik[top_wybor])/licznik*100
        pro1 = (slownik[min_wybor])/licznik*100

        print(f"Najpopularniejszym wyborem z wybranej kategorii był {top_wybor} - wybrało go aż {pro}% pasażerów \n"
              f"było ich {slownik[top_wybor]}"
              f"Najmniej popularnym był {min_wybor} - wybralo go tylko {pro1}% pasażerów\n"
              f"było ich {slownik[min_wybor]}")
def procent_liczność():
    grupa = str(input("Mieszkańcy jakiej planety cię interesują? Podaj jej nazwę.\n Jeśli wszyscy podaj 1"))

    wybor = int(input(f"Jaki procent takich pasażerów zdecydowało się na...\n"
                "kriosen - wybierz 2\n"
                "karte VIP - wybierz 6\n"
                "podróż w czasie - wybierz 13\n"))
    wiek1 = int(input("Jaka kategoria wiekowa cie interesuje? Podaj dolny jej całkowity dolny koniec \n "))
    wiek2 = int(input("Teraz górny\n"))
    with open("dane.txt", "r") as wpisuje_dane:
        wpisuje_dane.readline()
        suma = 0
        licznik_linijek = 0
        licznik = 0
        for line in wpisuje_dane:
            lista = line.split(",")

            if czypoprawna(lista) == True:
                if wiek1 <= float(lista[5]) <= wiek2:
                    if lista[1] == grupa or grupa ==str(1):
                        lista[wybor] = lista[wybor].strip()
                        if lista[wybor] == 'True':
                            licznik +=1
                        licznik_linijek +=1
        print(f"Na wybraną przez ciebie usługę zgodziło się {licznik/licznik_linijek*100}% takich pasażerów \n"
              f"Było ich {licznik}")

def stworz_liste_pionowa(n):
    with open("dane.txt", "r") as dane:
        dane.readline()  # Skip the header line

        lista2 = [line.strip().split(",")[n] for line in dane if czypoprawna(line.strip().split(",")) and n < len(line.strip().split(","))]

        return(lista2)
def analizadanych():
    n = menu_główne()
    if n == 1:
        srednia_wartość()
    if n == 2:
        popularny_wybór()
    if n == 3:
        procent_liczność()
    if n == 4:
        exit()
    if n ==5:
        wykresy()


if __name__ == "__main__":
    analizadanych()

