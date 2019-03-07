% wyznaczyc numerycznie transmitancje dyskretne G(z) odpowiadajace
% transmitancji ciaglej G(s) dla okresow probkowania 0.1s, 0.5s, 1s, 5s, 10 s

T_1 = 0.05;
T_2 = 0.15;
T_3 = 0.25;
T_4 = 5;
T_5 = 10;


[licznik, mianownik] = ss2tf(A, B, C, D);
%licznik = 4 * licznik;
%mianownik = int8(4 * mianownik);

G = tf(licznik, mianownik);

transmitancja_1 = c2d(G, T_1, 'zoh');
transmitancja_2 = c2d(G, T_2, 'zoh');
transmitancja_3 = c2d(G, T_3, 'zoh');
transmitancja_4 = c2d(G, T_4, 'zoh');
transmitancja_5 = c2d(G, T_5, 'zoh');