clear all;

maxTau = 10;
dane23;
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
    
    % plot 
    f = figure;
    plot(yMod(tau, :));
    hold on
    plot(y);
    hold off
    xlabel('k');
    ylabel('Y');
    legend('model','dane')
    saveas(f, sprintf('tau=%d.jpg', tau));
    close(f);
end









