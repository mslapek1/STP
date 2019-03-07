clear all;

syms s;

G_s = (s + 0.5)*(s + 3.5)/( (s+6) * (s+4) * (s+5));

G_s  = collect(G_s);


% pierwsza metoda

licznik = [ 1 4 1.75 ];
mianownik = [ 1 15 74 120 ];


[A B C D ] = tf2ss(licznik, mianownik);

% druga metoda

A_2 = A';
B_2 = C';
C_2 = B';
D_2 = D;



