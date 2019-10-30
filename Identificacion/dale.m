MinimosCuadrados
clc
% Parámetros base estimados:
Comparacion_Parametros = [...
   -1.7594
   -0.3966
    8.3284
   16.0353
    0.3977
    0.0072
    0.0120
    0.0085
    0.0150
    2.9131
    0.9710
];
Comparacion_Parametros = [ Comparacion_Parametros, salida]
%H = [H, salida]
columnas = size(Hs);
if columnas(2) < 4
    Hs = [Hs, 100*Sigma./Theta]
else
    Hs = [Hs(:,2:4), 100*Sigma./Theta]
end
norm(100*Sigma./Theta)
% Theta

% graficas;