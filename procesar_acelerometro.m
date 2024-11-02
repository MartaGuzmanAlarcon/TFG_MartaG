
% Funtion used in CalculoPotencias

function resultados = procesar_acelerometro(posicion_x, posicion_y, posicion_z, muestras_por_ventana, min_vals, max_vals)
    % Calibración de las posiciones
    %min_vals: [minx,miny,minz]
    aceleracion_x =  2*(posicion_x - min_vals(1)) / (max_vals(1) - min_vals(1)) - 1;
    aceleracion_y =  2*(posicion_y - min_vals(2)) / (max_vals(2) - min_vals(2)) - 1;
    aceleracion_z =  2*(posicion_z - min_vals(3)) / (max_vals(3) - min_vals(3)) - 1;

    % Aplicar filtro paso bajo
    g_x = 0; g_y = 0; g_z = 0;
    for i = 1:length(aceleracion_x)
        g_x = 0.9 * g_x + 0.1 * aceleracion_x(i);
        aceleracion_x(i) = aceleracion_x(i) - g_x;

        g_y = 0.9 * g_y + 0.1 * aceleracion_y(i);
        aceleracion_y(i) = aceleracion_y(i) - g_y;

        g_z = 0.9 * g_z + 0.1 * aceleracion_z(i);
        aceleracion_z(i) = aceleracion_z(i) - g_z;
    end

    % Inicializar resultados
    resultados = zeros(floor(length(aceleracion_x) / muestras_por_ventana), 4);

    % Calcular la potencia para cada ventana de 10 segundos
    indice_resultados = 1;
    for i = 1:muestras_por_ventana:length(aceleracion_x)
        ventana_x = aceleracion_x(i : min(i + muestras_por_ventana - 1, length(aceleracion_x)));
        ventana_y = aceleracion_y(i : min(i + muestras_por_ventana - 1, length(aceleracion_y)));
        ventana_z = aceleracion_z(i : min(i + muestras_por_ventana - 1, length(aceleracion_z)));

        potencia_x = mean(ventana_x .^ 2);
        potencia_y = mean(ventana_y .^ 2);
        potencia_z = mean(ventana_z .^ 2);

        potencia_total_xyz = potencia_x + potencia_y + potencia_z;
        resultados(indice_resultados, :) = [potencia_x, potencia_y, potencia_z, potencia_total_xyz];
        indice_resultados = indice_resultados + 1;
    end
end
