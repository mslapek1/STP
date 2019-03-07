clear 'yModel';
clear 'u';
clear 'yZad';

% Algrithm DMC without limitations - simulation

[minError, tau] = min(errors);
coefficient = w(tau, :);

a(1) = -1 * coefficient(3);
a(2) = -1 * coefficient(4);

D = 60;
N = 10;
Nu = 2;
lambda = 10;
alfa = 0.2;

for iterator = 1:10

stepResponse;

% calculate matrix

M = zeros(N, Nu);
MP = zeros(N, D - 1);

% M

for i=1:N           
    for j=1:Nu
        if (i >= j)
            M(i,j)=s(i-j+1);
        end
    end
end

% MP

for i = 1 : N
    for j = 1 : D-1
        if (i + j < D)
            MP(i, j) = s(i + j) - s(j); 
        else
            MP(i, j) = s(D) - s(j);
        end
    end
end


K = (( M' * M + lambda * eye(Nu))^(-1)) * M';
K = K(1, :);

% errors variable

JY = 0;
JU = 0;

% antoher variables

uPre = 0;
dU = zeros(Nu, 1);
dUP = zeros(D-1, 1);

start = index + 2;
finish = 300;

yZad=zeros(finish,1);
yZad(start : finish) = 1;
u(1 : start - 1) = 0;
yModel = zeros(finish,1);


for k = start : finish
    % y(k) model equation
    yModel(k) = alfa*(coefficient(1) * u(k - tau) + coefficient(2) * u(k - tau - 1)) - a(1) * yModel(k - 1) - a(2) * yModel(k - 2);

    % DMC equations  
    dU=sum(K)*(yZad(k)-yModel(k))-K*MP*dUP;
    
    
    dUP(1)=dU(1);
    u(k)=u(k-1)+dU(1);


    % we have to change dU matrix ...
    for i = D - 1 : -1 : 2
        dUP(i) = dUP(i-1);
    end
    
    % ... and increase out errors
    JY = JY + (yZad(k) - yModel(k))^2;
    JU = JU + (u(k)-u(k-1))^2;
    
end

f = figure;
plot(yModel);
hold on
plot(yZad);
hold off
xlabel('k');
legend('y', 'yZad')
saveas(f, sprintf('./dodatkowe/D_wyjscie_D=%d_N=%d_Nu=%d_alfa=%d.jpg', D, N, Nu, alfa));
close(f);

f = figure;
plot(u);
xlabel('k');
legend('u')
saveas(f, sprintf('./dodatkowe/D_Sterowanie_D=%d_N=%d_Nu=%d_alfa=%d.jpg', D, N, Nu, alfa));
close(f);

alfa = alfa + 0.2;
end