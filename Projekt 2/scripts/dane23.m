file = fopen('dane23.txt');

% A = fscanf(fileID,formatSpec,sizeA)
data = fscanf(file, '%f %f', [2 1000]);

u = data(1, :);
y = data(2, :);

fclose(file);