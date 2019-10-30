% Minimos cuadrados
<<<<<<< HEAD
clear all
%clc
=======
clear a*
clear d*
clear f*
clear g*
clear i*
clear I*
clear K*
clear l*
clear n*
clear q*
clear R*
clear s*
clear S*
clear t*
clear T*
clear w*


% clc
>>>>>>> 3623cc8a2dde2ec97e74a804993e7b262874012a
format short

l0 = 1.00;
l1 = 0.40;
l2 = 0.70;
l3 = 0.50;

g=9.81;

R1=1;
R2=1;
R3=1;

% R1=50;
% R2=30;
% R3=15;

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
run excitacion


sim('R3GDL');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Filtrar velocidad
[num den]=butter(2,2*pi*40/(pi/Ts));
qdmsf=filter(num,den,qdms);

% Estimar aceleración (derivada numérica)

qdd_est=[];
qdd_est(1,:)=[0 0 0];
for i=2:(length(qdmsf)-1)
    qdd_est(i,:)=(qdmsf(i+1,:)-qdmsf(i-1,:))/(2*Ts);
end
qdd_est(length(qdmsf),:)= qdd_est(length(qdmsf)-1,:);


% Filtrar aceleracion
%[num den]=butter(2,2*pi*40/(pi/Ts));
qddf=filter(num,den,qdd_est);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


<<<<<<< HEAD
%run graficas;
=======
% run graficas;
>>>>>>> 3623cc8a2dde2ec97e74a804993e7b262874012a

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


ini=1000;
<<<<<<< HEAD
fin=25000;
=======
fin=250000;
>>>>>>> 3623cc8a2dde2ec97e74a804993e7b262874012a
for i=ini:10:fin
    
%     q1=[q1;q(i,1)];
%     q2=[q2;q(i,2)];
%     q3=[q3;q(i,3)];
%     
%     qd1=[qd1;qd(i,1)];
%     qd2=[qd2;qd(i,2)];
%     qd3=[qd3;qd(i,3)];
%     
%     qdd1=[qdd1;qdd(i,1)];
%     qdd2=[qdd2;qdd(i,2)];
%     qdd3=[qdd3;qdd(i,3)];
%     
%     Im1=[Im1;Im(i,1)];
%     Im2=[Im2;Im(i,2)];
%     Im3=[Im3;Im(i,3)];

    q1=q(i,1);
    q2=q(i,2);
    q3=q(i,3);

    qd1=qd(i,1);
    qd2=qd(i,2);
    qd3=qd(i,3);

    qdd1=qdd(i,1);
    qdd2=qdd(i,2);
    qdd3=qdd(i,3);

%     q1=qms(i,1);
%     q2=qms(i,2);
%     q3=qms(i,3);
%     
%     qd1=qdmsf(i,1);
%     qd2=qdmsf(i,2);
%     qd3=qdmsf(i,3);
%     
%     qdd1=qddf(i,1);
%     qdd2=qddf(i,2);
%     qdd3=qddf(i,3);
    
%     I=[
%         I;
%         Ims(i,1);
%         Ims(i,2);
%         Ims(i,3)];
  
I=[
        I;
        Im(i,1);
        Im(i,2);
        Im(i,3)];
    
	gamma=[gamma;

    (1/(Kt1*R1))*[ qdd1/2 - (qdd1*cos(2*q2))/2 + qd1*qd2*sin(2*q2), qdd1/2 - (qdd1*cos(2*q2 + 2*q3))/2 + qd1*qd2*sin(2*q2 + 2*q3) + qd1*qd3*sin(2*q2 + 2*q3), qdd1,    0,           0,         0, R1^2*qd1,        0,        0,         0,           -l2*(qd1*qd3*sin(q3) - qdd1*cos(2*q2 + q3) - qdd1*cos(q3) + 2*qd1*qd2*sin(2*q2 + q3) + qd1*qd3*sin(2*q2 + q3))];
    (1/(Kt2*R2))*[                            -(qd1^2*sin(2*q2))/2,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0, qdd2, qdd2 + qdd3,         0,        0, R2^2*qd2,        0, g*cos(q2), l2*sin(2*q2 + q3)*qd1^2 - l2*sin(q3)*qd3^2 - 2*l2*qd2*sin(q3)*qd3 + g*cos(q2 + q3) + 2*l2*qdd2*cos(q3) + l2*qdd3*cos(q3)];
    (1/(Kt3*R3))*[                                               0,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0,    0, qdd2 + qdd3, R3^2*qdd3,        0,        0, R3^2*qd3,         0,                 g*cos(q2 + q3) + l2*qdd2*cos(q3) + (l2*qd1^2*sin(q3))/2 + l2*qd2^2*sin(q3) + (l2*qd1^2*sin(2*q2 + q3))/2]];
    
end


[Theta,Sigma]=lscov(gamma,I);

salida = [Theta, 100*Sigma./Theta];























