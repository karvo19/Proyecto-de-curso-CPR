function senalcontrol = Control(in)

control = 5;

% Control = 1 -> PD  Precomp. G
% Control = 2 -> PID Precomp. G
% Control = 3 -> PID FeedForward
% Control = 4 -> PID Par Calculado con referencias
% Control = 5 -> PD  Par Calculado con referencias

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

Tm = 0.001;

persistent Int_Err;

if control == 1
          ki1 = 0;
          ki2 = 0;
          ki3 = 0;

          kp1 = 58884.365535559;
          kp2 = 74131.0241300918;
          kp3 = 9772.3722095581;

          kd1 = 1029.94552449692;
          kd2 = 1296.62459355284;
          kd3 = 170.928410782899;
          
elseif control == 2
          ki1 = 817407.556227432;
          ki2 = 1029055.14432728;
          ki3 = 135655.887835558;

          kp1 = 59024.1845333278;
          kp2 = 74307.0458194346;
          kp3 = 9795.57638736892;

          kd1 = 1065.51937686486;
          kd2 = 1341.40942029426;
          kd3 = 176.832200746595;
          
elseif control == 3
          ki1 = 817407.556227432;
          ki2 = 1029055.14432728;
          ki3 = 135655.887835558;

          kp1 = 59024.1845333278;
          kp2 = 74307.0458194346;
          kp3 = 9795.57638736892;

          kd1 = 1065.51937686486;
          kd2 = 1341.40942029426;
          kd3 = 176.832200746595;
          
elseif control == 4
          ki1 = 116798.87187347;
          ki2 = 116798.87187347;
          ki3 = 116798.87187347;

          kp1 = 8433.93006857164;
          kp2 = 8433.93006857164;
          kp3 = 8433.93006857164;

          kd1 = 152.251420027871;
          kd2 = 152.251420027871;
          kd3 = 152.251420027871;
          
elseif control == 5
          ki1 = 0;
          ki2 = 0;
          ki3 = 0;

          kp1 = 8413.95141645195;
          kp2 = 8413.95141645195;
          kp3 = 8413.95141645195;

          kd1 = 147.168293754919;
          kd2 = 147.168293754919;
          kd3 = 147.168293754919;
end

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
                      
% Matriz de Inercias con referencias
 Mr = [
[ (6797*cos(2*qr2 + qr3))/5000 + (8797*cos(2*qr2))/5000 + (1983*cos(2*qr2 + 2*qr3))/5000 + (6797*cos(qr3))/5000 + 2159/1000,                             0,                               0]
[                                                                                                                   0,  (6797*cos(qr3))/2000 + 217/40, (6797*cos(qr3))/4000 + 3977/4000]
[                                                                                                                   0, (971*cos(qr3))/500 + 3977/3500,                       4049/3500]];

% Matriz de aceleraciones centrípetas y de Coriolis
 Vr = [
    -(qdr1*(17594*qdr2*sin(2*qr2) + 3966*qdr2*sin(2*qr2 + 2*qr3) + 3966*qdr3*sin(2*qr2 + 2*qr3) + 6797*qdr3*sin(qr3) + 13594*qdr2*sin(2*qr2 + qr3) + 6797*qdr3*sin(2*qr2 + qr3) - 120))/5000
 (17*qdr2)/800 - (6797*qdr3^2*sin(qr3))/4000 + (6797*qdr1^2*sin(2*qr2 + qr3))/4000 + (8797*qdr1^2*sin(2*qr2))/4000 + (1983*qdr1^2*sin(2*qr2 + 2*qr3))/4000 - (6797*qdr2*qdr3*sin(qr3))/2000
                                       (3*qdr3)/70 + (971*qdr1^2*sin(qr3))/1000 + (971*qdr2^2*sin(qr3))/500 + (971*qdr1^2*sin(2*qr2 + qr3))/1000 + (1983*qdr1^2*sin(2*qr2 + 2*qr3))/3500];
 
% Par gravitatorio
g = 9.81;
 Gr = [
                                                 0
  g*((971*cos(qr2 + qr3))/400 + (29131*cos(qr2))/4000)
                          (971*g*cos(qr2 + qr3))/350];
                      
% Precompensacion de G
% PD frecuencial                <- 1
% PID frecuencial               <- 2
    if control == 1 || control == 2
        Im = u + G;        
        
% Feed forward                      <- 3
    elseif control == 3
        Im = M*[qddr1;qddr2;qddr3] + V + G + u;
        
% Control por par calculado con referencias
% PID frecuencial               <- 4
% PD frecuencial                <- 5
    elseif control == 4 || control == 5
        Im = Mr*([qddr1;qddr2;qddr3] + u) + Vr + Gr;
         
    else
        disp('Ese numero se corresponde con ningun control')
    end
    
    % Antiwindup 2
    if max(Im) > 300 || min(Im) < -300
        Int_Err = Int_Err - Tm*Err_q;
    end

senalcontrol= Im;


  