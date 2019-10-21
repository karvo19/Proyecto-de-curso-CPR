%% Estimacion de los parámetros que definen la dinamica del robot
clear all;
close all;
clc;

% Tiempos de simulacion
Tsim = 30;
Ts = 0.001;

% Variables para las excitaciones
Im_cc = [0 1 0.5];

A_a = [0.1 0.1 0.1];
W_a = [15 15 15];

A_b = [0.5 0.5 0.5];
W_b = [3 6 6];

tau = 7;

% Factores de reducción
R1 = 50; R2 = 30; R3 = 15;
  
% Constantes de par de los motores
Kt1 = 0.5; Kt2 = 0.4; Kt3 = 0.35;

% Simulacion
sim('sk_R3GDL.mdl');

% Graficas de la simulacion
graficas;

% Recoleccion de datos
g = 9.8;
l0 = 1.00;  l1 = 0.40;  l2 = 0.70;  l3 = 0.50;
R1 = 50; R2 = 30; R3 = 15;
Kt1 = 0.5; Kt2 = 0.4; Kt3 = 0.35;
Kt = [1/Kt1 0 0; 0 1/Kt2 0; 0 0 1/Kt3];
R = [1/R1 0 0; 0 1/R2 0; 0 0 1/R3];

gamma_evaluada = [];
Im_evaluada = [];

for i = 500:10:25000 % length(q)
    q1 = q(i,1);        q2 = q(i,2);        q3 = q(i,3);
    qd1 = qd(i,1);      qd2 = qd(i,2);      qd3 = qd(i,3);
    qdd1 = qdd(i,1);    qdd2 = qdd(i,2);    qdd3 = qdd(i,3);
    
    gamma_reducida = [... 
         qdd1, R1^2*qd1,         0, qdd1/2 + (qdd1*cos(2*q2))/2 - qd1*qd2*sin(2*q2), qdd1/2 - (qdd1*cos(2*q2))/2 + qd1*qd2*sin(2*q2),        0,           -l2*(qd1*qd3*sin(q3) - qdd1*cos(2*q2 + q3) - qdd1*cos(q3) + 2*qd1*qd2*sin(2*q2 + q3) + qd1*qd3*sin(2*q2 + q3)), qdd1/2 + (qdd1*cos(2*q2 + 2*q3))/2 - qd1*qd2*sin(2*q2 + 2*q3) - qd1*qd3*sin(2*q2 + 2*q3), qdd1/2 - (qdd1*cos(2*q2 + 2*q3))/2 + qd1*qd2*sin(2*q2 + 2*q3) + qd1*qd3*sin(2*q2 + 2*q3),         0,        0
            0,        0, g*cos(q2),                      (sin(2*q2)*qd1^2)/2 + qdd2,                            -(qd1^2*sin(2*q2))/2, R2^2*qd2, l2*sin(2*q2 + q3)*qd1^2 - l2*sin(q3)*qd3^2 - 2*l2*qd2*sin(q3)*qd3 + g*cos(q2 + q3) + 2*l2*qdd2*cos(q3) + l2*qdd3*cos(q3),                                                 (sin(2*q2 + 2*q3)*qd1^2)/2 + qdd2 + qdd3,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,         0,        0
            0,        0,         0,                                               0,                                               0,        0,                 g*cos(q2 + q3) + l2*qdd2*cos(q3) + (l2*qd1^2*sin(q3))/2 + l2*qd2^2*sin(q3) + (l2*qd1^2*sin(2*q2 + q3))/2,                                                 (sin(2*q2 + 2*q3)*qd1^2)/2 + qdd2 + qdd3,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2, R3^2*qdd3, R3^2*qd3];
    gamma_evaluada = [gamma_evaluada; Kt*R*gamma_reducida];
    Im_evaluada = [Im_evaluada; Im(i,:)'];
end

[thita, sigma] = lscov(gamma_evaluada, Im_evaluada)
dtr = 100*sigma./abs(thita)