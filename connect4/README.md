## Connect 4

Proponujemy zabawę z grą Connect 4. Waszym zadaniem jest stworzenie programu (algorytm, model ML), który będzie potrafił: 
 
**Level I:** Wykryć potencjalną wygraną w 3 kolejnych ruchach. 
 
**Level II:** Ocenić pozycję (np. podać prawdopodobieństwo wygranej). 
 
**Level III:** Proponować kolejne ruchy (BOT do gry). 
 
**Level \*:** Proponować kolejne ruchy na n-wymiarowej planszy (zamiast standardowej planszy 2D). 

---

Program jako wejście powinien przyjmować macierz zaprezentują pozycję w grze: 

```
[ [‘’, ‘’, ‘’, ‘’, ‘’, ‘’,‘’],  
  [‘’, ‘’, ‘’, ‘’, ‘R’, ‘’,‘’],  
  [‘’, ‘’, ‘Y’, ‘Y’, ‘Y’, ‘’,‘’],  
  [‘’, ‘’, ‘R’, ‘Y’, ‘Y’, ‘’,‘’],  
  [‘’, ‘Y’, ‘R’, ‘R’, ‘Y’, ‘R’,‘’], 
  [‘’, ‘R’, ‘Y’, ‘R’, ‘R’, ‘Y’, ‘R’]]
```

gdzie R oznacza czerwony dysk, Y dysk żółty. 

---

**Spróbujcie pokonać jak najwięcej level’i! Powodzenia!**
