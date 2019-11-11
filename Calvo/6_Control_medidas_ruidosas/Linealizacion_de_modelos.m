clear all;
syms q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g real

Ma = [
[ (6797*cos(2*q2 + q3))/5000 + (8797*cos(2*q2))/5000 + (1983*cos(2*q2 + 2*q3))/5000 + (6797*cos(q3))/5000 + 2159/1000,                             0,                               0]
[                                                                                                                   0,  (6797*cos(q3))/2000 + 217/40, (6797*cos(q3))/4000 + 3977/4000]
[                                                                                                                   0, (971*cos(q3))/500 + 3977/3500,                       4049/3500]];
 
Va = [
    -(qd1*(17594*qd2*sin(2*q2) + 3966*qd2*sin(2*q2 + 2*q3) + 3966*qd3*sin(2*q2 + 2*q3) + 6797*qd3*sin(q3) + 13594*qd2*sin(2*q2 + q3) + 6797*qd3*sin(2*q2 + q3) - 120))/5000
 (17*qd2)/800 - (6797*qd3^2*sin(q3))/4000 + (6797*qd1^2*sin(2*q2 + q3))/4000 + (8797*qd1^2*sin(2*q2))/4000 + (1983*qd1^2*sin(2*q2 + 2*q3))/4000 - (6797*qd2*qd3*sin(q3))/2000
                                       (3*qd3)/70 + (971*qd1^2*sin(q3))/1000 + (971*qd2^2*sin(q3))/500 + (971*qd1^2*sin(2*q2 + q3))/1000 + (1983*qd1^2*sin(2*q2 + 2*q3))/3500];
 
g = 9.81;
Ga = [
                                                 0
  g*((971*cos(q2 + q3))/400 + (29131*cos(q2))/4000)
                          (971*g*cos(q2 + q3))/350];
                                              
                                              
% Modelo estimado para el diseño de controladores:
% De M nos quedamos con los terminos de la diagonal. Cogemos el maximo.
% M11 = simplify(Ma(1,1))
% M22 = simplify(Ma(2,2))
% M33 = simplify(Ma(3,3))

% M11 = vpa(6797/5000 + 8797/5000 + 1983/5000 + 6797/5000 + 2159/1000)
% M22 = vpa(6797/2000 + 217/40)
% M33 = vpa(4049/3500)

M11 = 7.0338;
M22 = 8.8235;
M33 = 1.1568571428571428571428571428571;

% De V eliminamos los terminos cuadráticos de qd y los senos y cosenos
% V1 = vpa(qd1*120/5000)
% V2 = vpa(17*qd2/800)
% V3 = vpa(3*qd3/70)

V1 = 0.024*qd1;
V2 = 0.02125*qd2;
V3 = 0.042857142857142857142857142857143*qd3;