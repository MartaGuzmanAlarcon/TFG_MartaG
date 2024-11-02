% Leer los datos del archivo actual usando readmatrix
calibracion1 = readmatrix('Verde_calibracion_1.txt'); 
calibracion2 = readmatrix('Verde_calibracion_2.txt');
calibracion3 = readmatrix('Verde_calibracion_3.txt');

% Definir las columnas correspondientes a las posiciones en los archivos
columna_x = 3;
columna_y = 4;
columna_z = 5;

% Calcular máximos y mínimos para calibracion1
max_x_file1 = max(calibracion1(:, columna_x));
min_x_file1 = min(calibracion1(:, columna_x));
max_y_file1 = max(calibracion1(:, columna_y));
min_y_file1 = min(calibracion1(:, columna_y));
max_z_file1 = max(calibracion1(:, columna_z));
min_z_file1 = min(calibracion1(:, columna_z));

% Calcular máximos y mínimos para calibracion2
max_x_file2 = max(calibracion2(:, columna_x));
min_x_file2 = min(calibracion2(:, columna_x));
max_y_file2 = max(calibracion2(:, columna_y));
min_y_file2 = min(calibracion2(:, columna_y));
max_z_file2 = max(calibracion2(:, columna_z));
min_z_file2= min(calibracion2(:, columna_z));

% Calcular máximos y mínimos para calibracion3
max_x_file3 = max(calibracion3(:, columna_x));
min_x_file3 = min(calibracion3(:, columna_x));
max_y_file3 = max(calibracion3(:, columna_y));
min_y_file3 = min(calibracion3(:, columna_y));
max_z_file3 = max(calibracion3(:, columna_z));
min_z_file3 = min(calibracion3(:, columna_z));

% Calcular máximos y mínimos globales para cada posición
max_x_global = max([max_x_file1, max_x_file2, max_x_file3]);
min_x_global = min([min_x_file1, min_x_file2, min_x_file3]);
max_y_global = max([max_y_file1, max_y_file2, max_y_file3]);
min_y_global = min([min_y_file1, min_y_file2, min_y_file3]);
max_z_global = max([max_z_file1, max_z_file2, max_z_file3]);
min_z_global = min([min_z_file1, min_z_file2, min_z_file3]);

% Rojo:

%max_x_global = 40104
%min_x_global = 27832
%max_y_global = 38076 
%min_y_global = 25272
%max_z_global = 40468
%min_z_global = 27584

% Verde:

%max_x_global = 46152
%min_x_global = 25876
%max_y_global = 38012
%min_y_global = 27540
%max_z_global = 39096
%min_z_global = 24020