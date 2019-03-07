% zadanie nad?zania za zmianami warto?ci zadanej sygna?u wyj?ciowego. 

% u(t) = - K * x(t) + (N_u + K * N_x) *y_zad

X = inv([A, B; C, D]) * [0 0 0 1]';

Nu = X(4, 1);
Nx = X(1:3, 1);

wyr = K_x * Nx + Nu;
