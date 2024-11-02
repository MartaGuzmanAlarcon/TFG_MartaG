
% Frecuencia de muestreo original
frecuencia_original = 1000;  % Hz
n= 1; % ASK -> SINO PONGO 10, NO LO ESTRÍA CALCULANDO EN VENTANAS DE 10, ESO ES CORRECTO?

% Número de muestras por ventana de n segundos
muestras_por_ventana = round(frecuencia_original * n); 

% Nombres de los archivos de prueba: 
file1 = 'NewIII_Rest_2024-10-18.txt';
file2 = 'NewIII_Working_2024-10-18.txt';
file3 = 'NewIII_Walking_2024-10-18.txt';
file4 = 'NewIII_Stairs_2024-10-18.txt';

file5 = 'NewII_Rest_2024-10-16.txt';
file6 = 'NewII_Working_2024-10-16.txt';
file7 = 'NewII_Walking_2024-10-16.txt';
file8 = 'NewII_Stairs_2024-10-16.txt';

files_pruebaCortas_OpenSignal = {file1, file2, file3, file4, file5, file6, file7, file8};

% Calibraciones para cada acelerómetro
min_vals_verde = [25876, 27540, 24020];
max_vals_verde = [46152, 38012, 39096];

min_vals_rojo = [27832, 25272, 27584]; % [minx,miny,minz]
max_vals_rojo = [40104, 38076, 40468];

for file_index = 1:numel(files_pruebaCortas_OpenSignal)
    file_name = files_pruebaCortas_OpenSignal{file_index};

    % Leer los datos del archivo
    data = readmatrix(file_name);
    
    % Extraer las posiciones para ambos acelerómetros
    % en mi caso conecte el rojo al canal:2,3,4 -> x,y,z  (ver col. correspondientes en el .txt)
    % conecte el rojo al canal:6,7,8 -> x,y,z 
    posicion_x_verde = data(:, 8); posicion_y_verde = data(:, 9); posicion_z_verde = data(:, 10);
    posicion_x_rojo = data(:, 4); posicion_y_rojo = data(:, 5); posicion_z_rojo = data(:, 6);

    % Procesar cada acelerómetro
    resultados_verde = procesar_acelerometro(posicion_x_verde, posicion_y_verde, posicion_z_verde, muestras_por_ventana, min_vals_verde, max_vals_verde);
    resultados_rojo = procesar_acelerometro(posicion_x_rojo, posicion_y_rojo, posicion_z_rojo, muestras_por_ventana, min_vals_rojo, max_vals_rojo);

    % Guardar resultados en archivos CSV
    nombre_archivo_verde = ['Potencias_Verde_', file_name, '.csv'];
    nombre_archivo_rojo = ['Potencias_Rojo_', file_name, '.csv'];

    columnas = {'potencia_x', 'potencia_y', 'potencia_z', 'potencia_total_xyz'};
    writetable(array2table(resultados_verde, 'VariableNames', columnas), nombre_archivo_verde);
    writetable(array2table(resultados_rojo, 'VariableNames', columnas), nombre_archivo_rojo);

    potencias_archivos_generados{file_index, 1} = nombre_archivo_verde;
    potencias_archivos_generados{file_index, 2} = nombre_archivo_rojo;
end

% Guardar nombres de los archivos generados
file_list = cell2table(reshape(potencias_archivos_generados', [], 1), 'VariableNames', {'NombreArchivo'});
csv_filename = 'potencias_NombresArchivos.csv';
writetable(file_list, csv_filename);
