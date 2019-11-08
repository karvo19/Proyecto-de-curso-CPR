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
[ (30612509037519171*cos(2*q2 + q3))/22517998136852480 + (7923634914903717*cos(2*q2))/4503599627370496 + (7145278848525341*cos(2*q2 + 2*q3))/18014398509481984 + (30612509037519171*cos(q3))/22517998136852480 + 39181235098854191/18014398509481984,                                                                                  0,                                                                                   0];
[                                                                                                                                                                                                                                                  0, (30612509037519171*cos(q3))/9007199254740992 + 97924626708858385/18014398509481984, (30612509037519171*cos(q3))/18014398509481984 + 17909359017493675/18014398509481984];
[                                                                                                                                                                                                                                                  0,  (4373215576788453*cos(q3))/2251799813685248 + 17909359017493675/15762598695796736,                                             1167023812028605325/1008806316530991104]];

% Matriz de aceleraciones centrípetas y de Coriolis
 V = [
                    -(qd1*(3961817457451858500*qd2*sin(2*q2) + 893159856065667625*qd2*sin(2*q2 + 2*q3) + 893159856065667625*qd3*sin(2*q2 + 2*q3) + 1530625451875958550*qd3*sin(q3) + 3061250903751917100*qd2*sin(2*q2 + q3) + 1530625451875958550*qd3*sin(2*q2 + q3) - 27021597764222976))/1125899906842624000;
 (17*qd2)/800 - (30612509037519171*qd3^2*sin(q3))/18014398509481984 + (30612509037519171*qd1^2*sin(2*q2 + q3))/18014398509481984 + (39618174574518585*qd1^2*sin(2*q2))/18014398509481984 + (35726394242626705*qd1^2*sin(2*q2 + 2*q3))/72057594037927936 - (30612509037519171*qd2*qd3*sin(q3))/9007199254740992;
                                                                  (3*qd3)/70 + (4373215576788453*qd1^2*sin(q3))/4503599627370496 + (4373215576788453*qd2^2*sin(q3))/2251799813685248 + (4373215576788453*qd1^2*sin(2*q2 + q3))/4503599627370496 + (35726394242626705*qd1^2*sin(2*q2 + 2*q3))/63050394783186944];
% Par gravitatorio
g = 9.81;
 G = [
                                                                                                    0;
 g*((21866077883942265*cos(q2 + q3))/9007199254740992 + (16399558412956785*cos(q2))/2251799813685248);
                                                  (21866077883942265*g*cos(q2 + q3))/7881299347898368];
  
% PD con cancelacion                <- 1  
% PD sin cancelacion                <- 2
% PID analitico sin cancelacion     <- 3
% PID frecuencial sin cancelacion   <- 4
    if control == 1 || control == 3 || control == 4
        Tau = u;
        
% Precompensacion de G              <- 5
    elseif control == 5
        Tau = u + G;        
        
% Precompensacion de V y G          <- 6
    elseif control == 6
        Tau = u + V + G;
        
% Feed forward                      <- 7
    elseif control == 7
        Tau = M*[qddr1;qddr2;qddr3] + V + G + u;
        
% Control por par calculado         <- 8
    elseif control == 8
        Tau = M*([qddr1;qddr2;qddr3] + u) + V + G;
         
    else
        disp('Ese numero se corresponde con ningun control')
    end