function [out] = Control_linea(in)
x = in(1);
y = in(2);
phi = in(3);

% Recta de referencia
% ax + by + c = 0       
a=0.5;
b=-1;
c=0.5;

% Par�metros del controlador
Kd=0.7;     % Proporcional a la distancia
Kh=1.5;       % Proporcional a la orientaci�n

% Distancia a la recta
d=(a*x +b*y +c)/sqrt(a^2 + b^2);

% Orientaci�n de referencia
phi_ref = atan2(a,-b);

% Se�ales de control
v = 1;
phi_d = Kd*d + Kh * angdiff( phi_ref , phi );

out = Modelo_Cinematico_Inverso([v phi_d]);
out=[out d];
end