
% Función para guardar los datos en un archivo CSV

function guardarEnCSV(nombreArchivo, datos, nombresColumnas)
    tabla = cell2table(datos, 'VariableNames', nombresColumnas);
    writetable(tabla, nombreArchivo);
end

