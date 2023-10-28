import pandas as pd
import matplotlib.pyplot as plt
import random
import numpy as np

df = pd.read_csv('dane.csv')
random.seed(997)

# usuwanie wierszy z age=0 i brakiem numeru kabiny
df = df[df['Age']!=0.0]
df.dropna(subset=['Cabin'], inplace=True)
df.reset_index(drop=True, inplace=True)

# zamiana NaN'ow w kolumnach
to_interpolate = ['RoomService', 'FoodCourt', 'ShoppingMall', 'Spa', 'VRDeck', 'Age']
for col in to_interpolate:
    df[col] = df[col].interpolate(method='linear')

# cryosleep i VIP dostaja losowe wartosci true/false zgodne z prawdopodobienstwem danego zdarzenia na podstawie dostepnych danych
t_f_cols = ['CryoSleep', 'VIP']
for col in t_f_cols:
    true_prob = df[col].value_counts(normalize=True).get(True, 0)
    df[col].fillna(pd.Series(np.random.choice([True, False], size=len(df), p=[true_prob, 1-true_prob])), inplace=True)

#dodawanie kolumny z sumą wszystkich wydatków danej osoby
df['Sum'] = df.iloc[:, 6:12].sum(axis=1)

# Pasazer nie ma planety pochodzenia ale ktos z grupy ma:
df['Group'] = df['PassengerId'].str[0:4]
for index, row in df.iterrows():
    if pd.isna(row['HomePlanet']):
        sm_group = df[df['Group']==row['Group']]
        sm_group = sm_group['HomePlanet'].dropna()
        if not sm_group.empty:
            df.at[index, 'HomePlanet'] = sm_group.iloc[0]

# Przydzial pasazerom krajow pochodzenia
occs = {}
df['Deck'] = df['Cabin'].str[0]
planets = ['Europa', 'Earth', 'Mars']
for p in planets:
    filtered_df = df[df['HomePlanet'] == p]
    deck_counts = filtered_df['Deck'].value_counts()
    for ind in deck_counts.index:
        if ind not in occs: occs[ind] = []
        for i in range(deck_counts[ind]):
            occs[ind].append(p)

# danej kabinie przydzielamy najbardziej prawdopodobna HomePlanet
for ind in deck_counts.index:
    random.shuffle(occs[ind])
for i in range(len(df)):
    if pd.isna(df.at[i, 'HomePlanet']):
        val = df.at[i, 'Deck']
        df.at[i, 'HomePlanet'] = occs[val][0]

#nan w: nname, destination
df['Name'] = df['Name'].fillna('# #') # neutralny znak

dest_prob = df['Destination'].value_counts(normalize=True) # prawdpodobienstwo wylosowania danego celu
rfill = pd.Series(np.random.choice(dest_prob.index, p=dest_prob.values, size=len(df)), index=df.index)
df['Destination'].fillna(rfill, inplace=True)

# Wykresy i analiza

# wiek vs średnia suma wydanych pieniędzy
ranges = []
mid = []
avgs = []
r=1.0
while (r<=79.0):
    ranges.append((r, r+1.0))
    r += 1.0
for lo, hi in ranges:
    mid.append((lo+hi)/2)
    rng_df = df[(df['Age']<hi) & (df['Age']>=lo) & (df['Age']<76.0) & (df['Age']>13.5)]
    avgs.append(rng_df['Sum'].mean())
plt.scatter(mid, avgs, color='MediumSeaGreen')
plt.axhline(y=1250, color='r', linestyle='--')
plt.title("Average money spent based on age")
plt.xlabel('Age')
plt.ylabel('Money spent')
plt.ylim(0, 7000)
plt.show()

# homeplanet vs srednia suma wydanych pieniedzy
avgs = []
for p in planets:
    pdf = df[df['HomePlanet']==p]
    avgs.append(pdf['Sum'].mean())
plt.bar(planets, avgs, color='DarkSeaGreen')
plt.xlabel('Planet')
plt.ylabel('Money spent')
plt.title("Money spent by planets")
plt.show()

# vip, reg vs srednia suma wydanych pieniedzy
avgs = []
for b in [True, False]:
    bdf = df[df['VIP']==b]
    avgs.append(bdf['Sum'].mean())
plt.bar(['VIP', 'Regular'], avgs, color='MidnightBlue')
plt.xlabel('Type')
plt.ylabel('Money spent')
plt.title("VIP vs regular passenger")
plt.show()

# kasa za kazda atrakcje
sums = []
services = ['RoomService', 'FoodCourt', 'ShoppingMall', 'Spa', 'VRDeck']
for s in services:
    sums.append(df[s].sum())
colors = plt.cm.Pastel1.colors
plt.pie(sums, labels=services, autopct='%1.0f%%', colors=colors)
plt.title('Sales of available services')
plt.show()

# wiek v rodzaje atrakcji
avg_data = {'Midpoint': mid}
colors = ['r', 'c', 'b', 'y', 'm']
for service in services:
    avg_data[service] = []

for start, end in ranges:
    age_group = df[(df['Age'] >= start) & (df['Age'] <= end) & (df['Age']<76.0) & (df['Age']>13.5)]
    for service in services:
        avg_spend = age_group[service].mean()
        avg_data[service].append(avg_spend)

avg_df = pd.DataFrame(avg_data)
plt.figure(figsize=(10, 6))
for i, service in enumerate(services):
    plt.scatter(avg_df['Midpoint'], avg_df[service], label=service, c=[colors[i] for _ in avg_df['Midpoint']], s=30)

plt.xlabel('Age')
plt.ylabel('Average money spent')
plt.title('Average money spent by age groups for each service')
plt.legend()
plt.grid(True)
plt.show()



