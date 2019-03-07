% wyprowadzam rownania obserwatora pelnego rzedu o potrojnym biegunie s_o

L = sym('l', [3 1]);
syms s_o;

P_o = (s - s_o)^3;
L_o = det(s*eye(size(A)) - A + L * C);

sol = ( coeffs(L_o, s, 'All') == coeffs(P_o, s, 'All') );
out2 = solve(sol, L);

% bieguny obserwatora

s_o2 = -5;
s_o3 = -10;
s_o4 = -15;
s_o5 = -2;
s_o6 = -7;

L_1 = acker(A', C', [ s_o1, s_o1, s_o1 ]);
L_2 = acker(A', C', [ s_o2, s_o2, s_o2 ]);
L_3 = acker(A', C', [ s_o3, s_o3, s_o3 ]);
L_4 = acker(A', C', [ s_o4, s_o4, s_o4 ]);
L_5 = acker(A', C', [ s_o5, s_o5, s_o5 ]);
L_6 = acker(A', C', [ s_o6, s_o6, s_o6 ]);

% przy symulacji mo?emy zmie? aktualnie wy?wietlany wykres
L_x = L_6; 

