function [out] = Generador_de_trayectorias(in)
t = in(1);

x_d = 0.25;  
A = 2;
x = x_d * t;
y_d = (-2*x + A)*x_d;


v = sqrt(x_d^2 + y_d^2);
phi_d = -(2*x_d)/((A - 2*x)^2 + 1);

w = Modelo_Cinematico_Inverso([v phi_d]);

w_i = w(1);
w_d = w(2);

out = [w_i w_d];
end