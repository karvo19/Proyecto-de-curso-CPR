function [out] = Control_postura(in)
x = in(1);
y = in(2);
phi = in(3);

% Objetivo:
x_ref = 2;
y_ref = 2;
phi_ref = -pi/3;

% Parámetros del controlador
K_rho=0.5;     % Proporcional a la distancia
K_alpha= 5;       % Proporcional a la orientación
K_beta = -3 ;          %   K_beta < 0 !!!

% Cambio de variables (a polares)
rho = sqrt((x - x_ref)^2 + (y - y_ref)^2 );
alpha = atan2((y_ref - y), (x_ref - x)) - phi;
beta = -phi - alpha;
 
% Señales de control
v = K_rho*rho;
phi_d = (K_alpha*alpha + K_beta*(beta + phi_ref) );

out = Modelo_Cinematico_Inverso([v phi_d]);
end