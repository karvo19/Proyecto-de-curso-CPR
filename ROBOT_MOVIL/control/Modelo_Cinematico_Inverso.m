function [out] = Modelo_Cinematico_Inverso(in)
v = in(1);
phi_d = in(2);

% Datos geométricos
b = 0.8 ; % Distancia entre las ruedas
R = 0.4 ; % Radio de las ruedas

w = [1/R -b/(2*R); 1/R b/(2*R)]*[v phi_d]';


out = [w_i w_d];
end