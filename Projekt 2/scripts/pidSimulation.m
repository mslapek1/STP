
clear 'yModel';
clear 'u';
clear 'yZad';

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



for k = start : finish
    % y(k) model equation
    yModel(k) = coefficient(1) * u(k - tau) + coefficient(2) * u(k - tau - 1) - a(1) * yModel(k - 1) - a(2) * yModel(k - 2);
    % calculate error 
    errorR0 = yModel(k) - yZad(k);
    % PID eqation
    u(k) = u(k-1) + r0 * errorR0 + r1 * errorR1 + r2 * errorR2;
    % after calculate u(k) update error
    errorR2 = errorR1;
    errorR1 = errorR0;
    
end

f = figure;
plot(yModel);
hold on
plot(yZad);
hold off
xlabel('k');
legend('y', 'yZad')
saveas(f, sprintf('K=%d_Td=%d_Ti=%d.jpg', K, Td, Ti));
close(f);






