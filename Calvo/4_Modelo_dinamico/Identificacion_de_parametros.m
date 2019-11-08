%% Obtencion de las matrices M V y G
clear all;
close all;
clc;

% Variables simbolicas necesarias
syms T1 T2 T3 q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g real
syms m1 m2 m3 l1 l2 l3 Ixx1 Ixx2 Ixx3 Iyy1 Iyy2 Iyy3 Izz1 Izz2 Izz3 real
syms Jm1 Jm2 Jm3 Bm1 Bm2 Bm3 real

gamma_reducida = [ qdd1, 2500*qd1, (49*qdd1)/200 + (49*qdd1*cos(2*q2))/200 - (49*qd1*qd2*sin(2*q2))/100, (7*qd1*qd2*sin(2*q2))/5 - (7*qdd1*cos(2*q2))/10 - (7*qdd1)/10, qd1*qd2*sin(2*q2) - qdd1*(cos(2*q2)/2 - 1/2),       0, (37*qdd1)/100 + (49*qdd1*cos(2*q2))/200 + (qdd1*cos(2*q2 + 2*q3))/8 + (7*qdd1*cos(q3))/20 + (7*qdd1*cos(2*q2 + q3))/20 - (7*qd1*qd3*sin(q3))/20 - (7*qd1*qd2*sin(2*q2 + q3))/10 - (7*qd1*qd3*sin(2*q2 + q3))/20 - (49*qd1*qd2*sin(2*q2))/100 - (qd1*qd2*sin(2*q2 + 2*q3))/4 - (qd1*qd3*sin(2*q2 + 2*q3))/4, (7*qd1*qd3*sin(q3))/10 - (qdd1*cos(2*q2 + 2*q3))/2 - (7*qdd1*cos(q3))/10 - (7*qdd1*cos(2*q2 + q3))/10 - qdd1/2 + (7*qd1*qd2*sin(2*q2 + q3))/5 + (7*qd1*qd3*sin(2*q2 + q3))/10 + qd1*qd2*sin(2*q2 + 2*q3) + qd1*qd3*sin(2*q2 + 2*q3), (qd1*(100*qd2*sin(2*q2 + 2*q3) + 100*qd3*sin(2*q2 + 2*q3)))/100 - qdd1*(cos(2*q2 + 2*q3)/2 - 1/2),        0,       0;
                      0,        0,          (49*sin(2*q2)*qd1^2)/200 + (49*qdd2)/100 + (7*g*cos(q2))/10,             - (7*qdd2)/5 - (7*qd1^2*sin(2*q2))/10 - g*cos(q2),                         -(qd1^2*sin(2*q2))/2, 900*qd2,                                                            (37*qdd2)/50 + qdd3/4 - (7*qd3^2*sin(q3))/20 + (7*qd1^2*sin(2*q2 + q3))/20 + (g*cos(q2 + q3))/2 + (49*qd1^2*sin(2*q2))/200 + (7*g*cos(q2))/10 + (qd1^2*sin(2*q2 + 2*q3))/8 + (7*qdd2*cos(q3))/10 + (7*qdd3*cos(q3))/20 - (7*qd2*qd3*sin(q3))/10,                                                   (7*sin(q3)*qd3^2)/10 + (7*qd2*sin(q3)*qd3)/5 - qdd2 - qdd3 - (7*qd1^2*sin(2*q2 + q3))/10 - g*cos(q2 + q3) - (qd1^2*sin(2*q2 + 2*q3))/2 - (7*qdd2*cos(q3))/5 - (7*qdd3*cos(q3))/10,                                                                       -(qd1^2*sin(2*q2 + 2*q3))/2,        0,       0;
                      0,        0,                                                                    0,                                                             0,                                            0,       0,                                                                                                                                        qdd2/4 + qdd3/4 + (7*qd1^2*sin(q3))/40 + (7*qd2^2*sin(q3))/20 + (7*qd1^2*sin(2*q2 + q3))/40 + (g*cos(q2 + q3))/2 + (qd1^2*sin(2*q2 + 2*q3))/8 + (7*qdd2*cos(q3))/20,                                                                       - qdd2 - qdd3 - (7*qd1^2*sin(q3))/20 - (7*qd2^2*sin(q3))/10 - (7*qd1^2*sin(2*q2 + q3))/20 - g*cos(q2 + q3) - (qd1^2*sin(2*q2 + 2*q3))/2 - (7*qdd2*cos(q3))/10,                                                                       -(qd1^2*sin(2*q2 + 2*q3))/2, 225*qdd3, 225*qd3];
 

thita_reducida = [    Iyy1 + Iyy2 + Iyy3 - Izz2 - Izz3 + 2500*Jm1 - 900*Jm2
                                                                        Bm1
4*m3*l3^2 - (100*Izz2)/49 + 4*Izz3 - (90000*Jm2)/49 + m2 - (100*l2^2*m2)/49
                        l2*m2 - (9000*Jm2)/7 - (10*Izz2)/7 - (10*l2^2*m2)/7
                                               Ixx2 - Iyy2 + Izz2 + 900*Jm2
                                                                        Bm2
                                                  - 4*m3*l3^2 - 4*Izz3 + m3
                                               - 2*m3*l3^2 + m3*l3 - 2*Izz3
                                                         Ixx3 - Iyy3 + Izz3
                                                                        Jm3 
                                                                        Bm3];
%% Estimacion de parámetros
% Accionamiento directo (Parametros con medidas perfectas)
clear all;
syms qdd1 qdd2 qdd3 g real

gamma_reducida = [];
thita_reducida = [
         -1.75940038424998
        -0.396642654749998
          2.16551925299997
          1.77669585024997
         0.397667654749993
       0.00722506600000024
        0.0119999999999998
       0.00849999999999985
        0.0149999999999998
          2.91314677499997
         0.971048924999985
];

l0 = 1.00;
l1 = 0.40;
l2 = 0.70;
l3 = 0.50;

g = 9.81;

R1 = 1;
R2 = 1;
R3 = 1;

Kt_Im_R = simplify(gamma_reducida*thita_reducida);

qdd = [qdd1, qdd2, qdd3]';
qd = [qd1, qd2, qd3]';

M = sym(zeros(3,3));
V = sym(zeros(3,1));
G = sym(zeros(3,1));

for i = 1:3
    for j = 1:3
        M(i,j) = diff(Kt_Im_R(i), qdd(j));
    end
    G(i) = diff(Kt_Im_R(i), g)*g;
    V(i) = Kt_Im_R(i) - M(i,:)*qdd - G(i);
end

% R, Jm y Bm ya estan inluidas en M V y G
Ma = simplify(M);
Va = simplify(V);
Ga = simplify(G);