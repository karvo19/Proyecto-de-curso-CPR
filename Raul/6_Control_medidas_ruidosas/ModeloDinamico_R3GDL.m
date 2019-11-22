%%%%%%%%%%%%%%% Modelo Dinámico %%%%%%%%%%%%%%%
function [qdd] = ModeloDinamico_R3GDL(in)

% Variables de entrada en la funcion:
q1        = in(1);
q2        = in(2);
q3        = in(3);
qd1       = in(4);
qd2       = in(5);
qd3       = in(6);
Im1      = in(7);
Im2      = in(8);
Im3      = in(9);


Im=[Im1 Im2 Im3]';

% Modelo en forma matricial (M, V, G)
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
                      
qdd = inv(Ma)*(Im-Va-Ga);