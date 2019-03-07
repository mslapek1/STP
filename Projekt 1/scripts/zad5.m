% wyznaczyc symbolicznie regulator ze sprzezeniem od stanu

K = sym('k', [1 3]);

% s_b - biegun ukladu zamknietego

syms s_b;

L = (s - s_b)^(3);
P = det(s * eye(size(A)) - A + B*K);

% MATLAB: a = ( b == c ) <-- assign true to a when b equals c, false in
% another case, but when we have expression with symbol, it solve us this
% equation

zeroL = ( L == 0 );
zeroP = ( P == 0 );

sol = ( coeffs(L, s, 'All') == coeffs(P, s, 'All') );

out = solve(sol, K);

% dla 3 przykladowych wartosci bieguna sprawdzic otrzymane wyniki
% numerycznie

s_b1 = -0.01;
s_b2 = -0.05;
s_b3 = -0.1;
s_b4 = -0.15;
s_b5 = -0.25;
s_b6 = -0.5;
s_b7 = -0.75;
s_b8 = -1;
s_b9 = -2;
s_b10 = -3;
s_b11 = -10;
s_b12 = -15;

K_1 = acker(A, B, [ s_b1, s_b1, s_b1 ]);
K_2 = acker(A, B, [ s_b2, s_b2, s_b2 ]);
K_3 = acker(A, B, [ s_b3, s_b3, s_b3 ]);
K_4 = acker(A, B, [ s_b4, s_b4, s_b4 ]);
K_5 = acker(A, B, [ s_b5, s_b5, s_b5 ]);
K_6 = acker(A, B, [ s_b6, s_b6, s_b6 ]);
K_7 = acker(A, B, [ s_b7, s_b7, s_b7 ]);
K_8 = acker(A, B, [ s_b8, s_b8, s_b8 ]);
K_9 = acker(A, B, [ s_b9, s_b9, s_b9 ]);
K_10 = acker(A, B, [ s_b10, s_b10, s_b10 ]);
K_11 = acker(A, B, [ s_b11, s_b11, s_b11 ]);
K_12 = acker(A, B, [ s_b12, s_b12, s_b12 ]);
% wartosc podowana do Matlaba w celu uniwersalnosci pomiarow

% 2(-0.05) 5(-0.25) 6(-0.5) 7(-0.75)  8 (-1) 9(-2) 10(-5)
K_x = K_9;



