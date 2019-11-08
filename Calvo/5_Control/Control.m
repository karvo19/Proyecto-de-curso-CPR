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
  M =[(128*q3*cos(q2)^2)/25-(7847*sin(2*q2))/5000-(32*q3*sin(2*q2))/25+(8067*cos(q2)^2)/5000+(16*q3^2*cos(q2)^2)/5+474911/5000,0,0;
      0,((16*q3)/5+64/25)*(q3+4/5)+4137/50,-32/25;
      0,-32/25,939/20];
 
  
% Matriz de aceleraciones centrípetas y de Coriolis
  V = [-(qd1*(31388*qd2*cos(2*q2)-25600*qd3-25600*qd3*cos(2*q2)+16134*qd2*sin(2*q2)+12800*qd3*sin(2*q2)-32000*q3*qd3+25600*q3*qd2*cos(2*q2)-32000*q3*qd3*cos(2*q2)+51200*q3*qd2*sin(2*q2)+32000*q3^2*qd2*sin(2*q2)-225))/10000;
      (9*qd2)/625+(128*qd2*qd3)/25+(7847*qd1^2*cos(2*q2))/5000+(8067*qd1^2*sin(2*q2))/10000+(8*q3^2*qd1^2*sin(2*q2))/5+(32*q3*qd2*qd3)/5+(32*q3*qd1^2*cos(2*q2))/25+(64*q3*qd1^2*sin(2*q2))/25;
      (9*qd3)/400-(64*qd1^2*cos(q2)^2)/25+(16*qd1^2*sin(2*q2))/25-(16*q3*qd2^2)/5-(64*qd2^2)/25-(16*q3*qd1^2*cos(q2)^2)/5]; 
 
% Par gravitatorio                
  G = 9.8*[0;
      (94*cos(q2))/25-(52*sin(q2))/25+(16*q3*cos(q2))/5;
      (16*sin(q2))/5];
  
% PD con cancelacion                <- 1  
% PD sin cancelacion                <- 2
% PID analitico sin cancelacion     <- 3
% PID frecuencial sin cancelacion   <- 4
    if control == 1 ||  control == 2 || control == 3 || control == 4
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