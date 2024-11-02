

frecuencia_original= 1000;
TEST = 1;

if (TEST)
    time_vector = 1:(5*60)*frecuencia_original;  % 5 minutos de registro
    % Recuerda= fs (Hz)= muetsras/s --> 5min x 60s = 300s-> ¿muestras?=
    % fs*s = 1000*300=300000 minimo

    file1 = 'NewIII_Rest_2024-10-18.txt';
    file2 = 'NewIII_Working_2024-10-18.txt';
    file3 = 'NewIII_Walking_2024-10-18.txt';
    file4 = 'NewIII_Stairs_2024-10-18.txt';
    
    file5 = 'NewII_Rest_2024-10-16.txt';
    file6 = 'NewII_Working_2024-10-16.txt';
    file7 = 'NewII_Walking_2024-10-16.txt';
    file8 = 'NewII_Stairs_2024-10-16.txt';

files_pruebas= {file1, file2, file3, file4, file5, file6, file7, file8};

% files_TopS = {'NewII_Rest_2024-10-16.txt', 'NewII_Working_2024-10-16.txt', 'NewII_Walking_2024-10-16.txt', 'NewII_Stairs_2024-10-16.txt'};

else

    time_vector = 1:(((7*60 + 59)*60)*frecuencia_original-360000);%8h
    files_pruebas= {'TopS_R1_2024-04-04.txt', 'TopS_R2_2024-04-12.txt', 'TopS_R3_2024-04-16.txt', 'TopS_R4_2024-04-23.txt'};
end

% 
fileSets = {files_pruebas};
mSQI_archivos_generados = {}; % Array para almacenar los nombres de archivos generados

for setIndex = 1:length(fileSets)
    currentFiles = fileSets{setIndex};
    
    for fileIndex = 1:length(currentFiles)
        file_name = currentFiles{fileIndex};  % Nombre del archivo actual
        
        % Importar datos (ECG comercial y top deportivo)
        data_ecg_electrodos_top = ImportPluxData(file_name, 3);  % Columna 3: ECG con electrodos del top
        data_ecg_electrodos_comercial = ImportPluxData(file_name, 7);  % Columna 7: ECG electrodos comerciales

        % Limitar la longitud de los datos según time_vector
       data_ecg_electrodos_top = data_ecg_electrodos_top(1:min(length(time_vector), length(data_ecg_electrodos_top)));
       data_ecg_electrodos_comercial = data_ecg_electrodos_comercial(1:min(length(time_vector), length(data_ecg_electrodos_comercial)));

        % Calcular mSQI para ambos conjuntos de electrodos
        [comercial_kSQI_01_vector, comercial_sSQI_01_vector, comercial_pSQI_01_vector, comercial_rel_powerLine01_vector, comercial_cSQI_01_vector, comercial_basSQI_01_vector, comercial_dSQI_01_vector, geometricMean_vector_comercial, averageGeometricMean_commercial] = mSQI(data_ecg_electrodos_comercial, 1000);
        [top_kSQI_01_vector, top_sSQI_01_vector, top_pSQI_01_vector, top_rel_powerLine01_vector, top_cSQI_01_vector, top_basSQI_01_vector, top_dSQI_01_vector, geometricMean_vector_top, averageGeometricMean_top] = mSQI(data_ecg_electrodos_top, 1000);

        % Guardar el vector geometricMean_vector en un archivo CSV para el top
        nombre_archivo_top = ['mSQI_Top_', file_name, '.csv'];
        guardarEnCSV(nombre_archivo_top, num2cell (geometricMean_vector_top'), {'geometricMean_vector'});

        % Guardar el vector geometricMean_vector en un archivo CSV para el comercial
        nombre_archivo_comercial = ['mSQI_Comercial_', file_name, '.csv'];
        guardarEnCSV(nombre_archivo_comercial, num2cell(geometricMean_vector_comercial'), {'geometricMean_vector'});

        % Almacenar los nombres de los archivos generados
        mSQI_archivos_generados{end+1} = nombre_archivo_top;
        mSQI_archivos_generados{end+1} = nombre_archivo_comercial;

        fprintf("Processed and saved mSQI vectors \n");
    end
end

% Guardar la lista de archivos generados en un CSV
file_list = cell2table(mSQI_archivos_generados', 'VariableNames', {'NombreArchivo'});
csv_filename = 'mSQI_NombresArchivos.csv';
writetable(file_list, csv_filename);

