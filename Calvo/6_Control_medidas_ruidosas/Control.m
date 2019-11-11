function [Tau] = Control(in)

% Variables de entrada en la funcion: [q(2)  qp(2)  Imotor(2)]
qr1        = in(1);
qr2        = in(2);
qr3        = in(3);
qdr1       = in(4);
qdr2       = in(5);
qdr3       = in(6);
qddr1      = in(7);
qddr2      = in(8);
qddr3      = in(9);
q1         = in(10);
q2         = in(11);
q3         = in(12);
qd1        = in(13);
qd2        = in(14);
qd3        = in(15);
tiempo     = in(16);

% Tm declarado en simulaciones.m
global Tm;

global control;

global kp1 kp2 kp3;
global ki1 ki2 ki3;
global kd1 kd2 kd3;

persistent Int_Err;

if tiempo < 1e-5
    Int_Err = [0;0;0];
end

Err_q = [qr1-q1;qr2-q2;qr3-q3];
Err_qd = [qdr1-qd1;qdr2-qd2;qdr3-qd3];

Int_Err = Int_Err + Tm*Err_q;

kp = [kp1;kp2;kp3];
ki = [ki1;ki2;ki3];
kd = [kd1;kd2;kd3];

u = kp.*Err_q + kd.*Err_qd + ki.*Int_Err;

% Constantes de control declaradas en controles.m

% Matriz de Inercias
 M = [
[ (6797*cos(2*q2 + q3))/5000 + (8797*cos(2*q2))/5000 + (1983*cos(2*q2 + 2*q3))/5000 + (6797*cos(q3))/5000 + 2159/1000,                             0,                               0]
[                                                                                                                   0,  (6797*cos(q3))/2000 + 217/40, (6797*cos(q3))/4000 + 3977/4000]
[                                                                                                                   0, (971*cos(q3))/500 + 3977/3500,                       4049/3500]];

% Matriz de aceleraciones centrípetas y de Coriolis
 V = [
    -(qd1*(17594*qd2*sin(2*q2) + 3966*qd2*sin(2*q2 + 2*q3) + 3966*qd3*sin(2*q2 + 2*q3) + 6797*qd3*sin(q3) + 13594*qd2*sin(2*q2 + q3) + 6797*qd3*sin(2*q2 + q3) - 120))/5000
 (17*qd2)/800 - (6797*qd3^2*sin(q3))/4000 + (6797*qd1^2*sin(2*q2 + q3))/4000 + (8797*qd1^2*sin(2*q2))/4000 + (1983*qd1^2*sin(2*q2 + 2*q3))/4000 - (6797*qd2*qd3*sin(q3))/2000
                                       (3*qd3)/70 + (971*qd1^2*sin(q3))/1000 + (971*qd2^2*sin(q3))/500 + (971*qd1^2*sin(2*q2 + q3))/1000 + (1983*qd1^2*sin(2*q2 + 2*q3))/3500];
 
% Par gravitatorio
g = 9.81;
 G = [
                                                 0
  g*((971*cos(q2 + q3))/400 + (29131*cos(q2))/4000)
                          (971*g*cos(q2 + q3))/350];
                      
% PD sin cancelacion                <- 1
% PID analitico sin cancelacion     <- 2
% PID frecuencial sin cancelacion   <- 3
    if control == 1 || control == 2 || control == 3
        Tau = u;
        
% Precompensacion de G              <- 4
    elseif control == 4
        Tau = u + G;        
        
% Precompensacion de V y G          <- 5
    elseif control == 5
        Tau = u + V + G;
        
% Feed forward                      <- 6
    elseif control == 6
        Tau = M*[qddr1;qddr2;qddr3] + V + G + u;
        
% Control por par calculado         <- 7
    elseif control == 7
        Tau = M*([qddr1;qddr2;qddr3] + u) + V + G;
         
    else
        disp('Ese numero se corresponde con ningun control')
    end