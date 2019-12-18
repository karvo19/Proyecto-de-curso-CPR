% Minimos cuadrados
clear all
clc
format short

Tsim=30;
Ts=1e-3;
l0 = 1.00;
l1 = 0.40;
l2 = 0.70;
l3 = 0.50;

g=9.81;

R1=50;
R2=30;
R3=15;

Kt1=0.5;
Kt2=0.4;
Kt3=0.35;

 
% t_red =[
%  
%                            - m2*L2^2 - m3*l2^2 + Ixx2 - Iyy2
%                                      - m3*L3^2 + Ixx3 - Iyy3
%  m2*L2^2 + m3*L3^2 + Jm1*R1^2 + m3*l2^2 + Iyy1 + Iyy2 + Iyy3
%                          m2*L2^2 + Jm2*R2^2 + m3*l2^2 + Izz2
%                                               m3*L3^2 + Izz3
%                                                          Jm3
%                                                          Bm1
%                                                          Bm2
%                                                          Bm3
%                                                L2*m2 + l2*m3
%                                                        L3*m3];



% Valores de excitación y ejecutar simulacion
% Excitacion


A_a=[5  4.5   2];
A_b=0*[2 1.15 0.0];
w_a=[0.5 0.5 0.5];   % En Hz
w_b=[2.5 2.5 1.5];   
Icc=[0 1 0.5];
tau=7;



sim('R3GDL');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

% Estimar velocidades y aceleraciones (derivada numérica)

[num den]=butter(2,2*pi*40/(pi/Ts));
qmsf =filtfilt(num,den,qms);

qd_est=[];
qd_est(1,:)=[0 0 0];
for i=2:(length(qmsf)-1)
    qd_est(i,:)=(qmsf(i+1,:)-qmsf(i-1,:))/(2*Ts);
end
qd_est(length(qmsf),:)= qd_est(length(qmsf)-1,:);

[num den]=butter(4,2*pi*20/(pi/Ts));
qd_est_f=filtfilt(num,den,qd_est);


qdd_est=[];
qdd_est(1,:)=[0 0 0];
for i=2:(length(qd_est_f)-1)
    qdd_est(i,:)=(qd_est_f(i+1,:)-qd_est_f(i-1,:))/(2*Ts);
end
qdd_est(length(qd_est_f),:)= qdd_est(length(qd_est_f)-1,:);


[num den]=butter(8,2*pi*10/(pi/Ts));
qdd_est_f=filtfilt(num,den,qdd_est);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

















% Recopilar datos
q1=[];
q2=[];
q3=[];
qd1=[];
qd2=[];
qd3=[];
qdd1=[];
qdd2=[];
qdd3=[];
Im1=[];
Im2=[];
Im3=[];
I=[];
gamma=[];


ini=500;
fin=25000;
for i=ini:10:fin
    
%     
%     q1=qs(i,1);
%     q2=qs(i,2);
%     q3=qs(i,3);
%     
%     qd1=qds(i,1);
%     qd2=qds(i,2);
%     qd3=qds(i,3);
    
%     qdd1=qdds(i,1);
%     qdd2=qdds(i,2);
%     qdd3=qdds(i,3);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    q1=qms(i,1);
    q2=qms(i,2);
    q3=qms(i,3);
  
    qd1=qd_est_f(i,1);
    qd2=qd_est_f(i,2);
    qd3=qd_est_f(i,3);
    
    qdd1=qdd_est_f(i,1);
    qdd2=qdd_est_f(i,2);
    qdd3=qdd_est_f(i,3);
    
     
    I=[
        I;
        Ims(i,1);
        Ims(i,2);
        Ims(i,3)];
  
    
	gamma=[gamma;

    (1/(Kt1*R1))*[ qdd1/2 - (qdd1*cos(2*q2))/2 + qd1*qd2*sin(2*q2), qdd1/2 - (qdd1*cos(2*q2 + 2*q3))/2 + qd1*qd2*sin(2*q2 + 2*q3) + qd1*qd3*sin(2*q2 + 2*q3), qdd1,    0,           0,         0, R1^2*qd1,        0,        0,         0,           -l2*(qd1*qd3*sin(q3) - qdd1*cos(2*q2 + q3) - qdd1*cos(q3) + 2*qd1*qd2*sin(2*q2 + q3) + qd1*qd3*sin(2*q2 + q3))];
    (1/(Kt2*R2))*[                            -(qd1^2*sin(2*q2))/2,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0, qdd2, qdd2 + qdd3,         0,        0, R2^2*qd2,        0, g*cos(q2), l2*sin(2*q2 + q3)*qd1^2 - l2*sin(q3)*qd3^2 - 2*l2*qd2*sin(q3)*qd3 + g*cos(q2 + q3) + 2*l2*qdd2*cos(q3) + l2*qdd3*cos(q3)];
    (1/(Kt3*R3))*[                                               0,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0,    0, qdd2 + qdd3, R3^2*qdd3,        0,        0, R3^2*qd3,         0,                 g*cos(q2 + q3) + l2*qdd2*cos(q3) + (l2*qd1^2*sin(q3))/2 + l2*qd2^2*sin(q3) + (l2*qd1^2*sin(2*q2 + q3))/2]];
    
end


[Theta,Sigma]=lscov(gamma,I);

dtr=100*abs(Sigma./Theta);
ideales=[
    -1.7594
   -0.3966
    8.3284
   16.0353
    0.3977
    0.0072
    0.0120
    0.0085
    0.0150
    2.9131
    0.9710];
[ideales Theta dtr]

graficas_ruid


% %%
% phi_red =[
%  
% [ qdd1/2 - (qdd1*cos(2*q2))/2 + qd1*qd2*sin(2*q2), qdd1/2 - (qdd1*cos(2*q2 + 2*q3))/2 + qd1*qd2*sin(2*q2 + 2*q3) + qd1*qd3*sin(2*q2 + 2*q3), qdd1,    0,           0,         0, R1^2*qd1,        0,        0,         0,           -l2*(qd1*qd3*sin(q3) - qdd1*cos(2*q2 + q3) - qdd1*cos(q3) + 2*qd1*qd2*sin(2*q2 + q3) + qd1*qd3*sin(2*q2 + q3))];
% [                            -(qd1^2*sin(2*q2))/2,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0, qdd2, qdd2 + qdd3,         0,        0, R2^2*qd2,        0, g*cos(q2), l2*sin(2*q2 + q3)*qd1^2 - l2*sin(q3)*qd3^2 - 2*l2*qd2*sin(q3)*qd3 + g*cos(q2 + q3) + 2*l2*qdd2*cos(q3) + l2*qdd3*cos(q3)];
% [                                               0,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0,    0, qdd2 + qdd3, R3^2*qdd3,        0,        0, R3^2*qd3,         0,                 g*cos(q2 + q3) + l2*qdd2*cos(q3) + (l2*qd1^2*sin(q3))/2 + l2*qd2^2*sin(q3) + (l2*qd1^2*sin(2*q2 + q3))/2]];
 






















