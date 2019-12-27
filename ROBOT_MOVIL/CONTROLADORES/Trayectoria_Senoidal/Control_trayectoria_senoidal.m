function [out] = Control_trayectoria_senoidal(in)

x = in(1);
y = in(2);
phi = in(3);
x_ref = in(4);
y_ref = in(5);


% Parámetros del controlador
Kh = 5;     % Proporcional a la orientacion

% Orientación y distancia de referencia
phi_ref = atan2((y_ref - y), (x_ref - x));
d_ref = 0.1;    % Distancia de persecución

% Error de seguimiento
e = sqrt((x_ref - x)^2 + (y_ref - y)^2) - d_ref;


% Señales de control
phi_d = Kh * angdiff(phi_ref, phi);

out = [e phi_d];
end