clear all;

file = fopen('dane23.txt');

% A = fscanf(fileID,formatSpec,sizeA)
data = fscanf(file, '%f %f', [2 1000]);

u = data(1, :);
y = data(2, :);

fclose(file);


% model

maxTau = 10;
max = max(size(y));

w = zeros(maxTau, 4);

errors = zeros(maxTau, 1);

yMod = zeros(maxTau, max);

for tau = 1:maxTau
    Y = y(tau + 2 : max);
    clear 'M';
    M(:, 1) = u(2 : max - tau);
    M(:, 2) = u(1 : max - tau - 1);
    M(:, 3) = y(tau + 1 : max - 1);
    M(:, 4) = y(tau : max - 2);
    
    coeff = M\Y';
    coeff = coeff';
    
    w(tau, :) = coeff;
    
    % model error
    for k = tau + 2 : max
        yMod(tau, k) = coeff(1)* u(k-tau) + coeff(2) * u(k - tau - 1) + coeff(3) * yMod(tau, k - 1) + coeff(4) * yMod(tau, k - 2);
        errors(tau) = errors(tau) + (yMod(tau, k) - y(k))^2;
    end
    
end

% calculate step response coefficient
% the best model was for tau = 6
[minError, index] = min(errors);
coefficient = w(index, :);

% DMC parameters
N = 10;
D = 60;
Nu = 4;
lambda = 400;


% b_1 = coefficient(1), b_2 = coefficient(2), a_1 = - coefficient(3), a_2 =
% - coefficient(4)

b = [zeros(1, index - 1), coefficient(1), coefficient(2)];

% calcualte s(1) and s(2) (it can be use in loop)
s(1) = b(1);
a(1) = -1 * coefficient(3);
a(2) = -1 * coefficient(4);
s(2) = b(1) + b(2) - a(1) * s(1);

for j = 3:D
    max = min(j, index+1);
    s(j) = sum(b(1:max)) - a(1)*s(j-1) - a(2) * s(j-2);
end


% Algrithm PID simulation
% Ziegler-Nichols method - K = 0.6 Kkr, Ti = 0.5 Tkr, Td = 0.12 Tk
[minError, tau] = min(errors);
coefficient = w(tau, :);

a(1) = -1 * coefficient(3);
a(2) = -1 * coefficient(4);

KKr = 1.525;
TKr = 19;
T = 1;

K = 0.6 * KKr;
Ti = 0.5 * TKr;
%Td = 0;
Td = 0.12 * TKr;

% K = 0.915; Td = 9.5; Ti = 2.28;

% engineer method

K = 0.55; 
Ti = 19.0;
Td = 1.8;

r0 = K * (1 + T/(2*Ti) + Td/T);
r1 = K * (T/(2*Ti) - 2*Td/T - 1);
r2 = K * Td/T;

% errors variable

errorR0 = 0;
errorR1 = 0;
errorR2 = 0;

start = index + 2;
finish = 300;


yZad(1 : start - 1) = 0;
yZad(start : finish) = 1;
u(1 : start - 1) = 0;
yModel(1 : start - 1) = 0;


% Algrithm DMC without limitations - simulation

[minError, tau] = min(errors);
coefficient = w(tau, :);

a(1) = -1 * coefficient(3);
a(2) = -1 * coefficient(4);

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

regulator = 'DMCDisturption'; % value: DMC, PID, DMCLimit - z ograniczeniami, DMCDisturptions - z zak?óceniami

for k = start : finish
    
    % y(k) model equation
    yModel(k) = coefficient(1) * u(k - tau) + coefficient(2) * u(k - tau - 1) - a(1) * yModel(k - 1) - a(2) * yModel(k - 2);
    if strcmp(regulator,'PID')
        % calculate error 
        errorR0 = yModel(k) - yZad(k);
        % PID eqation
        u(k) = u(k-1) + r0 * errorR0 + r1 * errorR1 + r2 * errorR2;
        % after calculate u(k) update error
        errorR2 = errorR1;
        errorR1 = errorR0;
    end
   
    if strcmp(regulator,'DMC')
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
    if strcmp(regulator,'DMCLimit')
        limitU = 1;
        limitDU = 0.008;

        uMax = limitU;
        uMin = -limitU;

        dUMax = limitDU;
        dUMin = -limitDU;
        % DMC equations  
        dU=sum(K)*(yZad(k)-yModel(k))-K*MP*dUP;

        if dU(1) > dUMax
            dU(1) = dUMax;
        end

        if dU(1) < dUMin
            dU(1) = dUMin;
        end

        dUP(1)=dU(1);
        u(k)=u(k-1)+dU(1);

        if u(k) > uMax
            u(k) = uMax;
        end
        if u(k) < uMin
            u(k) = uMin;
        end

        % we have to change dU matrix ...
        for i = D - 1 : -1 : 2
            dUP(i) = dUP(i-1);
        end

        % ... and increase out errors
        JY = JY + (yZad(k) - yModel(k))^2;
        JU = JU + (u(k)-u(k-1))^2;
    end
    
    if strcmp(regulator,'DMCDisturption')
        disturption = zeros(finish, 1);

        % write value of disturption

        disturption(finish/2:finish) = -1.5;
        yModel(k) = yModel(k) + disturption(k);

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
    
    
end

f = figure;
plot(yModel);
hold on
plot(yZad);
hold off
xlabel('k');
legend('y', 'yZad')
saveas(f, sprintf('kiki.jpg'));
close(f);


