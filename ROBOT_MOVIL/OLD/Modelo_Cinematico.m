function [out] = Modelo_Cinematico(in)
vd=in(1);
vi=in(2);
x=in(3);
y=in(4);
phi=in(5);

b =  15e-2 ; % Distancia entre las ruedas

v=(vd+vi)/2;
phi_d=(vd-vi)/b;

x_d = v*cos(phi);
y_d = v*sin(phi);



out = [x_d y_d phi_d];
end