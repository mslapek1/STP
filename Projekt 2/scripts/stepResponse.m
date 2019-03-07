% calculate step response coefficient
% the best model was for tau = 6
[minError, index] = min(errors);
coefficient = w(index, :);

NOStep = 200;

% b_1 = coefficient(1), b_2 = coefficient(2), a_1 = - coefficient(3), a_2 =
% - coefficient(4)

b = [zeros(1, index - 1), coefficient(1), coefficient(2)];

% calcualte s(1) and s(2) (it can be use in loop)
s(1) = b(1);
a(1) = -1 * coefficient(3);
a(2) = -1 * coefficient(4);
s(2) = b(1) + b(2) - a(1) * s(1);

for j = 3:NOStep
    max = min(j, index+1);
    s(j) = sum(b(1:max)) - a(1)*s(j-1) - a(2) * s(j-2);
end

f = figure;
plot(s);
saveas(f, sprintf('stepResponse.jpg'));
close(f);

