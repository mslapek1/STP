% Wykazac symbolicznie, ce obie wersje modelu w przestrzeni stanu mocna
% sprowadzic do tej samej transmitancji

syms s;

disp(size(A));
disp(size(A_2));

G_s1 = C * ((s*eye(size(A)) - A)^(-1)) * B + D;
G_s2 = C_2 * ((s*eye(size(A_2)) - A_2)^(-1)) * B_2 + D_2;

G_s1 = collect(G_s1);
G_s2 = collect(G_s2);

if G_s1 == G_s2
   disp("Transmitancje sa takie same");
else 
    disp("Transmitancje sa ró?ne");
end

% out: Transmitancje sa takie same