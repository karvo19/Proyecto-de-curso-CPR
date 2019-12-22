function [out] = Control_trayectoria(in)

x = in(1);
y = in(2);
phi = in(3);
x_ref = in(4);
y_ref = in(5);


% Par�metros del controlador
Kh= 5;       % Proporcional a la orientaci�n

% Orientaci�n y distancia de referencia
phi_ref = atan2( (y_ref - y) , (x_ref - x) );
d_ref = 0.2;    % Distancia de persecuci�n

% Error de seguimiento
e = sqrt((x_ref - x)^2+(y_ref - y)^2) - d_ref;


% Se�ales de control
phi_d = Kh * angdiff( phi , phi_ref );

out = [e phi_d];
end