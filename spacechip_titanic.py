import numpy as np
import matplotlib.pyplot as plt
import plotly.express as px

def main():
    suma=0
    licznik_linijek=0
    '''for line in dane:
        lista = line.split(",")         #dzielnik to znak ze zaczyna sie kolejny wyraz listy, pokazuje gdzie konczy sie jeden wyraz i zaczyna sie drugi
        for i in range (14):
            if lista[i]==None:
                break
            else:
                dane1=open("dane1.txt","w")
                dane1.write(lista[i])
                dane1.close()
                licznik_linijek+=1
        dane.close()'''
    with (open("dane.txt") as dane):
        dane.readline()
        mars=0
        earth=0
        europa=0
        vip=0
        nonvip=0
        sleep=0
        nosleep=0
        pso=0
        canc=0
        trap=0
        n=0
        room=0
        food=0
        shop=0
        spa=0
        vr=0
        wiek=0
        k7=0
        k8=0
        k9=0
        k10=0
        k11=0
        dzieci=0
        mlodziez=0
        d1=0
        d2=0
        d3=0
        for line in dane:
            lista = line.split(",")
            #if len(lista[i])==0:

            if lista[1]=="Mars":
                mars+=1
            elif lista[1]=="Earth":
                earth+=1
            elif lista[1]=="Europa":
                europa+=1
            if lista[6]=="True":
                vip+=1
            elif lista[6]=="False":
                nonvip+=1
            if lista[2]=="True":
                sleep+=1
            elif lista[2]=="False":
                nosleep+=1
            if lista[4]=="TRAPPIST-1e":
                trap+=1
            elif lista[4]=="PSO J318.5-22":
                pso+=1
            elif lista[4]=="55 Cancri e":
                canc+=1
            if len(lista[5]) !=0.0:
                wiek+=float(lista[5])
                n+=1
                if float(lista[5])<=10:
                    dzieci+=1
                if 10<float(lista[5])<=20:
                    mlodziez+=1
                if 20<float(lista[5]) <=40:
                    d1+=1
                if 40<float(lista[5])<=60:
                    d2+=1
                if float(lista[5]) > 60:
                    d3+=1
            if len(lista[7])!=0.0:
                room+=float(lista[7])
                k7+=1
            if len(lista[8]) != 0.0:
                food += float(lista[8])
                k8+=1
            if len(lista[9])!=0.0:
                shop+=float(lista[9])
                k9+=1
            if len(lista[10])!=0.0:
                spa+=float(lista[10])
                k10+=1
            if len(lista[11])!=0.0:
                vr+=float(lista[11])
                k11+=1




#wykres slupkowy planet
        wysokosc=[mars, europa, earth]
        planety=["Mars", "Europa","Earth"]
        y_pos = np.arange(len(wysokosc))
        plt.bar(y_pos, wysokosc)
        plt.bar(y_pos, wysokosc)
        plt.xticks(y_pos, planety)
        plt.xlabel("Planeta, z której pochodzą.")
        plt.ylabel("Liczba kosmonautów.")
        plt.title("Pochodzenie kosmonautów")
        plt.show()
#wykres paczkowy planet
        labels=["Europa", "Mars","Earth"]
        values=[europa, mars, earth]
        fig = px.pie(values=values, names=labels, color_discrete_sequence=px.colors.sequential.RdBu, hole=0.5)
        fig.show()
#wykres slupkowy poziomy vipow
        wysokosc = [vip,nonvip]
        bars = ["Tak", "Nie"]
        y_pos = np.arange(len(wysokosc))
        plt.bar(y_pos, wysokosc)
        plt.bar(y_pos, wysokosc)
        plt.xticks(y_pos, bars)
        plt.xlabel(" ")
        plt.ylabel("Liczba kosmonautów.")
        plt.title("Czy kosmonauta posiada usługę vip?")
        plt.show()

#wykres slupkowy cryosleep
        wysokosc = [sleep, nosleep]
        bars = ["Tak", "Nie"]
        y_pos = np.arange(len(wysokosc))
        plt.bar(y_pos, wysokosc)
        plt.bar(y_pos, wysokosc)
        plt.xticks(y_pos, bars)
        plt.xlabel(" ")
        plt.ylabel("Liczba kosmonautów.")
        plt.title("Czy kosmonauta został wprowadzony w stan hibernacji?")
        plt.show()
#wykres kolowy destination
        labels=["TRAPPIST-1e", "PSO J318.5-22","55 Cancri e"]
        values=[trap, pso, canc]
        fig = px.pie(values=values, names=labels, color_discrete_sequence=px.colors.sequential.RdBu)
        fig.show()
#wykres wieku
        wysokosc = [dzieci, mlodziez, d1,d2,d3]
        bars = ["0-10 lat","10-20 lat","20-40 lat","40-60 lat", "60+ lat" ]
        y_pos = np.arange(len(wysokosc))
        plt.bar(y_pos, wysokosc)
        plt.bar(y_pos, wysokosc)
        plt.xticks(y_pos, bars)
        plt.xlabel(" ")
        plt.ylabel("Liczba kosmonautów.")
        plt.title("Wiek kosmonautów")
        plt.show()

#srednie
        print(f"Średnia wieku kosmonautów to: {int(wiek/n)}")
        print(f"Średnia kwota wydana na RoomService przez korzystających z tej usługi: {int(room /k7) }")
        print(f"Średnia kwota wydana na FoodCourt przez korzystających z tej usługi: {(food / k8)} zl")
        print(f"Średnia kwota wydana na ShoppingMall przez korzystających z tej usługi: {(shop / k9)} zl")
        print(f"Średnia kwota wydana na Spa przez korzystających z tej usługi: {(spa / k10)} zl")
        print(f"Średnia kwota wydana na VRDeck przez korzystających z tej usługi: {(vr / k11)} zl")

if __name__=="__main__":
    main()
