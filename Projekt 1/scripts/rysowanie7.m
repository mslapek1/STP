
hold on;
plot(rzeczywiste_x1, 'DisplayName','rzeczywiste x1');
plot(rzeczywiste_x2, 'DisplayName','rzeczywiste x2');
plot(rzeczywiste_x3, 'DisplayName','rzeczywiste x3');
plot(estymowane_x1, 'DisplayName','estymowane x1');
plot(estymowane_x2, 'DisplayName','estymowane x2');
plot(estymowane_x3, 'DisplayName','estymowane x3');
hold off;

lgd = legend;
lgd.NumColumns = 2;
xlabel('czas(s)')
ylabel('')
title('')