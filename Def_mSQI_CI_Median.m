TEST = 1;

if (TEST)
    time_vector = 1:(5*60)*frecuencia_original; % 5 minutos de registro

    % Archivos de actividad con 4 registros
   %files_TopS = {'Seated_2024-09-21.txt', 'Working_2024-09-21.txt', 'Stairs_2024-09-21.txt', 'Walking_2024-09-21.txt'};
   %files_TopS = {'RestII_ 2024-09-24.txt', 'WorkingII_2024-09-24.txt', 'StairsII_2024-09-24.txt', 'WalkingII_2024-09-24.txt'};
    %files_TopS = {'NewI_Rest_2024-10-16.txt', 'NewI_Working_2024-10-16.txt', 'NewI_Walking_2024-10-16.txt', 'NewI_Stairs_2024-10-16.txt'};
   files_TopS = {'NewII_Rest_2024-10-16.txt', 'NewII_Working_2024-10-16.txt', 'NewII_Walking_2024-10-16.txt', 'NewII_Stairs_2024-10-16.txt'};
else
    time_vector = 1:(((7*60 + 59)*60)*1000-360000);

    files_TopS = {'TopS_R1_2024-04-04.txt', 'TopS_R2_2024-04-12.txt', 'TopS_R3_2024-04-16.txt', 'TopS_R4_2024-04-23.txt'};
end

% Para prueba de los 5 minutos solo usando TopS
fileSets = {files_TopS};
indexes_commercial = cell(1, length(fileSets));  % Para los electrodos comerciales
indexes_top = cell(1, length(fileSets));  % Para los electrodos del top deportivo

for setIndex = 1:length(fileSets)
    currentFiles = fileSets{setIndex};
    indexes_commercial{setIndex} = cell(1, length(currentFiles));
    indexes_top{setIndex} = cell(1, length(currentFiles));

    for fileIndex = 1:length(currentFiles)

        % Importar datos (ECG comercial y top deportivo)
        data_ecg_electrodos_top = ImportPluxData(currentFiles{fileIndex}, 3 ); % Columna 3: ECG con electrodos del top cosidos (Canal1)
        data_ecg_electrodos_comercial = ImportPluxData(currentFiles{fileIndex}, 7 ); % Columna 7: ECG electrodos comerciales (Canal5)

        % Limitar la longitud de los datos según time_vector
        data_ecg_electrodos_top = data_ecg_electrodos_top(1:min(length(time_vector), length(data_ecg_electrodos_top)));
        data_ecg_electrodos_comercial = data_ecg_electrodos_comercial(1:min(length(time_vector), length(data_ecg_electrodos_comercial)));

        % Calcular mSQI y otras características para ambos: electrodos comerciales y top deportivo

        % Para los electrodos comerciales
        [comercial_kSQI_01_vector, comercial_sSQI_01_vector, comercial_pSQI_01_vector, comercial_rel_powerLine01_vector, comercial_cSQI_01_vector, comercial_basSQI_01_vector, comercial_dSQI_01_vector, comercial_geometricMean_vector, averageGeometricMean_commercial] = mSQI(data_ecg_electrodos_comercial, 1000);
        
        % Para los electrodos del top deportivo
        [top_kSQI_01_vector, top_sSQI_01_vector, top_pSQI_01_vector, top_rel_powerLine01_vector, top_cSQI_01_vector, top_basSQI_01_vector, top_dSQI_01_vector, top_geometricMean_vector, averageGeometricMean_top] = mSQI(data_ecg_electrodos_top, 1000);

        % Guardar los resultados por separado
        indexes_commercial{setIndex}{fileIndex} = comercial_geometricMean_vector;
        indexes_top{setIndex}{fileIndex} = top_geometricMean_vector;

        fprintf("Average mean of windows (Commercial, Top) for %s: %f, %f\n", currentFiles{fileIndex}, averageGeometricMean_commercial, averageGeometricMean_top);
    end
end

% Nivel de significancia para calcular los intervalos de confianza
alph = 0.01;
iter = 1000;

% Asignar los índices de los ECGs comerciales y los del top deportivo
indexes_topS = indexes_top{1};
indexes_commercialS = indexes_commercial{1};

% Cálculo de CI para las comparaciones del top deportivo (electrodos no comerciales)
data_topS_R1R2R3 = [indexes_topS{1}, indexes_topS{2}, indexes_topS{3}];
data_topS_R1R2R4 = [indexes_topS{1}, indexes_topS{2}, indexes_topS{4}];
data_topS_R1R3R4 = [indexes_topS{1}, indexes_topS{3}, indexes_topS{4}];
data_topS_R2R3R4 = [indexes_topS{2}, indexes_topS{3}, indexes_topS{4}];

% Comparaciones (electrodos no comerciales)
CIMedian_topS_R1vsR2R3R4 = estimateCIMedian(indexes_topS{1}, data_topS_R2R3R4, alph, iter);
CIMean_topS_R1vsR2R3R4 = estimateCIMean(indexes_topS{1}, data_topS_R2R3R4, alph, iter);

CIMedian_topS_R2vsR1R3R4 = estimateCIMedian(indexes_topS{2}, data_topS_R1R3R4, alph, iter);
CIMean_topS_R2vsR1R3R4 = estimateCIMean(indexes_topS{2}, data_topS_R1R3R4, alph, iter);

CIMedian_topS_R3vsR1R2R4 = estimateCIMedian(indexes_topS{3}, data_topS_R1R2R4, alph, iter);
CIMean_topS_R3vsR1R2R4 = estimateCIMean(indexes_topS{3}, data_topS_R1R2R4, alph, iter);

CIMedian_topS_R4vsR1R2R3 = estimateCIMedian(indexes_topS{4}, data_topS_R1R2R3, alph, iter);
CIMean_topS_R4vsR1R2R3 = estimateCIMean(indexes_topS{4}, data_topS_R1R2R3, alph, iter);

% Histograms for each register of TopS
for i = 1:4
    figure;
    histogram(indexes_topS{i}, 20);
    xlabel('mSQI Values');
    ylabel('count');
    title(['Histogram (NO commercial electrodes) for indexes\_commercialS{' num2str(i) '}']);


end

% Hacemos lo mismo pero para los elecrodos comerciales

% Cálculo de CI para las comparaciones del top deportivo (electrodos comerciales)
data_topS_comercial_R1R2R3 = [indexes_commercialS{1}, indexes_commercialS{2}, indexes_commercialS{3}];
data_topS_comercial_R1R2R4 = [indexes_commercialS{1}, indexes_commercialS{2}, indexes_commercialS{4}];
data_topS_comercial_R1R3R4 = [indexes_commercialS{1}, indexes_commercialS{3}, indexes_commercialS{4}];
data_topS_comercial_R2R3R4 = [indexes_commercialS{2}, indexes_commercialS{3}, indexes_commercialS{4}];

% Comparaciones (electrodos no comerciales)
CIMedian_topS_comercial_R1vsR2R3R4 = estimateCIMedian(indexes_commercialS{1}, data_topS_comercial_R2R3R4, alph, iter);
CIMean_topS_comercial_R1vsR2R3R4 = estimateCIMean(indexes_commercialS{1}, data_topS_comercial_R2R3R4, alph, iter);

CIMedian_topS_comercial_R2vsR1R3R4 = estimateCIMedian(indexes_commercialS{2}, data_topS_comercial_R1R3R4, alph, iter);
CIMean_topS_comercial_R2vsR1R3R4 = estimateCIMean(indexes_commercialS{2}, data_topS_comercial_R1R3R4, alph, iter);

CIMedian_topS_comercial_R3vsR1R2R4 = estimateCIMedian(indexes_commercialS{3}, data_topS_comercial_R1R2R4, alph, iter);
CIMean_topS_comercial_R3vsR1R2R4 = estimateCIMean(indexes_commercialS{3}, data_topS_comercial_R1R2R4, alph, iter);

CIMedian_topS_comercial_R4vsR1R2R3 = estimateCIMedian(indexes_commercialS{4}, data_topS_comercial_R1R2R3, alph, iter);
CIMean_topS_comercial_R4vsR1R2R3 = estimateCIMean(indexes_commercialS{4}, data_topS_comercial_R1R2R3, alph, iter);

% Histograms for each register of TopS
for i = 1:4
    figure;
    histogram(indexes_topS{i}, 20);
    xlabel('mSQI Values');
    ylabel('count');
    title(['Histogram (commercial electrodes) for indexes\_commercialS{' num2str(i) '}']);

end