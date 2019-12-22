function [out] = Control_punto(in)
x = in(1);
y = in(2);
phi = in(3);

x_ref=3;
y_ref=3;

Kv=0.5;
Kp=4;

v = Kv * sqrt((x_ref - x)^2+(y_ref - y)^2);

phi_ref = atan( (y_ref - y)/(x_ref - x) );
phi_d = Kp * angdiff( phi , phi_ref );

out = Modelo_Cinematico_Inverso([v phi_d]);

end