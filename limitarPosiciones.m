
% Esta funcion reciba como entrada los vectores de posición y el time_vector
% Devuelve los vectores de posición acotados

function [posicion_x_acotado, posicion_y_acotado, posicion_z_acotado] = limitarPosiciones(posicion_x, posicion_y, posicion_z, time_vector)
  
    % Calcula la longitud mínima entre el time_vector y la posición
    min_len = min(length(time_vector), length(posicion_x));
    
    % Limita cada posición (x, y, z) según el mínimo calculado
    posicion_x_acotado = posicion_x(1:min_len);
    posicion_y_acotado = posicion_y(1:min_len);
    posicion_z_acotado = posicion_z(1:min_len);
end
