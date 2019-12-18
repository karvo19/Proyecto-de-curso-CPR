% Identificación. Numérico
clear all
clc
format short

l0 = 1.00;
l1 = 0.40;
l2 = 0.70;
l3 = 0.50;


R1=50;
R2=30;
R3=15;

g=9.81;
phi_num=[];
for i=1:8
q1=rand;
qd1=rand;
qdd1=rand;
q2=rand;
qd2=rand;
qdd2=rand;
q3=rand;
qd3=rand;
qdd3=rand;

phi_num=[
     phi_num;
    [ 0, qdd1/2 - (qdd1*cos(2*q2))/2 + qd1*qd2*sin(2*q2), qdd1/2 - (qdd1*cos(2*q2 + 2*q3))/2 + qd1*qd2*sin(2*q2 + 2*q3) + qd1*qd3*sin(2*q2 + 2*q3), qdd1, qdd1/2 + (qdd1*cos(2*q2))/2 - qd1*qd2*sin(2*q2), qdd1/2 + (qdd1*cos(2*q2 + 2*q3))/2 - qd1*qd2*sin(2*q2 + 2*q3) - qd1*qd3*sin(2*q2 + 2*q3), 0,    0,           0, R1^2*qdd1,         0,         0, R1^2*qd1,        0,        0, 0, qdd1/2 + (qdd1*cos(2*q2))/2 - qd1*qd2*sin(2*q2), qdd1/2 + (qdd1*cos(2*q2 + 2*q3))/2 - qd1*qd2*sin(2*q2 + 2*q3) - qd1*qd3*sin(2*q2 + 2*q3), 0,         0,           -l2*(qd1*qd3*sin(q3) - qdd1*cos(2*q2 + q3) - qdd1*cos(q3) + 2*qd1*qd2*sin(2*q2 + q3) + qd1*qd3*sin(2*q2 + q3)), 0, 0, (l2^2*(qdd1 + qdd1*cos(2*q2) - 2*qd1*qd2*sin(2*q2)))/2];
    [ 0,                            -(qd1^2*sin(2*q2))/2,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0,                             (qd1^2*sin(2*q2))/2,                                                               (qd1^2*sin(2*q2 + 2*q3))/2, 0, qdd2, qdd2 + qdd3,         0, R2^2*qdd2,         0,        0, R2^2*qd2,        0, 0,                      (sin(2*q2)*qd1^2)/2 + qdd2,                                                 (sin(2*q2 + 2*q3)*qd1^2)/2 + qdd2 + qdd3, 0, g*cos(q2), l2*sin(2*q2 + q3)*qd1^2 - l2*sin(q3)*qd3^2 - 2*l2*qd2*sin(q3)*qd3 + g*cos(q2 + q3) + 2*l2*qdd2*cos(q3) + l2*qdd3*cos(q3), 0, 0,    (sin(2*q2)*l2^2*qd1^2)/2 + qdd2*l2^2 + g*cos(q2)*l2];
    [ 0,                                               0,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0,                                               0,                                                               (qd1^2*sin(2*q2 + 2*q3))/2, 0,    0, qdd2 + qdd3,         0,         0, R3^2*qdd3,        0,        0, R3^2*qd3, 0,                                               0,                                                 (sin(2*q2 + 2*q3)*qd1^2)/2 + qdd2 + qdd3, 0,         0,                 g*cos(q2 + q3) + l2*qdd2*cos(q3) + (l2*qd1^2*sin(q3))/2 + l2*qd2^2*sin(q3) + (l2*qd1^2*sin(2*q2 + q3))/2, 0, 0,                                                      0]];
end 


[AA Col_Indep]=rref(phi_num);

AA_red=AA(1:11,:);



% Quitar si ~0 (por legibilidad)
for i=1:11
    for j=1:24
        if norm(AA_red(i,j)) < 1e-5
            AA_red(i,j)=0;
        end     
    end
end
  
        
AA_red

    
    












