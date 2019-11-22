function [Im] = Control(in)

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
persistent qdf1_1;
persistent qdf2_1;
persistent qdf3_1;

control = 6;

if control == 6
          ki1 = 817407.556227432;
          ki2 = 1029055.14432728;
          ki3 = 135655.887835558;

          kp1 = 59024.1845333278;
          kp2 = 74307.0458194346;
          kp3 = 9795.57638736892;

          kd1 = 1065.51937686486;
          kd2 = 1341.40942029426;
          kd3 = 176.832200746595;
end

if tiempo < 1e-5
    Int_Err = [0;0;0];
    qdf1_1 = 0;
    qdf2_1 = 0;
    qdf3_1 = 0;
end

% Filtramos la velocidad
tau_af = 50*2*pi;
    
qdf1 = (Tm*qd1 + tau_af*qdf1_1)/(tau_af + Tm);
qdf1_1 = qdf1;
qd1 = qdf1;

qdf2 = (Tm*qd2 + tau_af*qdf2_1)/(tau_af + Tm);
qdf2_1 = qdf2;
qd2 = qdf2;

qdf3 = (Tm*qd3 + tau_af*qdf3_1)/(tau_af + Tm);
qdf3_1 = qdf3;
qd3 = qdf3;

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
        Im = u;
        
% Precompensacion de G              <- 4
    elseif control == 4
        Im = u + G;        
        
% Precompensacion de V y G          <- 5
    elseif control == 5
        Im = u + V + G;
        
% Feed forward                      <- 6
    elseif control == 6
        Im = M*[qddr1;qddr2;qddr3] + V + G + u;
        
% Control por par calculado         <- 7
    elseif control == 7
        Im = M*([qddr1;qddr2;qddr3] + u) + V + G;
         
    else
        disp('Ese numero se corresponde con ningun control')
    end
    
    % Filtro en discreto aproximado por Euler II
    % Diseñado para ponerse tras el control
    %                1
    %   G(s) = ------------
    %          Tau_af s + 1
    %
    % ufk = (Tm*uk + tau_af*ufk1)/(tau_af + Tm)
    
    % Entiendo que si se pone delante del control sería:
    % ufk = (Tm*ek + tau_af*ufk1)/(tau_af + Tm)
    
    % tau_af = tsbc/30
    
    