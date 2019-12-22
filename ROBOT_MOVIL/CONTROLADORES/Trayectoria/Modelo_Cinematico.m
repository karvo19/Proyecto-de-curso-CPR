function [out] = Modelo_Cinematico(in)
% Variables de actuación - Velocidad angular de las ruedas
w_i=in(1);
w_d=in(2);

% Variables generalizadas
x=in(3);
y=in(4);
phi=in(5);

% Datos geométricos
b = 0.8 ; % Distancia entre las ruedas
R = 0.4 ; % Radio de las ruedas

% Modelo cinemático directo - Forma Jacobiana 
J_q=[R/2*cos(phi) R/2*cos(phi);
     R/2*sin(phi) R/2*sin(phi);
     -R/b         R/b         ];
 
 p_d = [w_i w_d]';
 
 q_d =J_q * p_d ;
     
out = q_d;  %[x_d y_d phi_d];
end