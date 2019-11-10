%% Obtencion de las matrices M V y G
% Estimacion de parámetros
% Accionamiento directo (Parametros con medidas perfectas)
clear all;
syms q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g real

l0 = 1.00;
l1 = 0.40;
l2 = 0.70;
l3 = 0.50;

R1 = 1;
R2 = 1;
R3 = 1;

Kt1=0.5;
Kt2=0.4;
Kt3=0.35;

gamma_reducida = [
    (1/(Kt1*R1))*[ qdd1/2 - (qdd1*cos(2*q2))/2 + qd1*qd2*sin(2*q2), qdd1/2 - (qdd1*cos(2*q2 + 2*q3))/2 + qd1*qd2*sin(2*q2 + 2*q3) + qd1*qd3*sin(2*q2 + 2*q3), qdd1,    0,           0,         0, R1^2*qd1,        0,        0,         0,           -l2*(qd1*qd3*sin(q3) - qdd1*cos(2*q2 + q3) - qdd1*cos(q3) + 2*qd1*qd2*sin(2*q2 + q3) + qd1*qd3*sin(2*q2 + q3))];
    (1/(Kt2*R2))*[                            -(qd1^2*sin(2*q2))/2,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0, qdd2, qdd2 + qdd3,         0,        0, R2^2*qd2,        0, g*cos(q2), l2*sin(2*q2 + q3)*qd1^2 - l2*sin(q3)*qd3^2 - 2*l2*qd2*sin(q3)*qd3 + g*cos(q2 + q3) + 2*l2*qdd2*cos(q3) + l2*qdd3*cos(q3)];
    (1/(Kt3*R3))*[                                               0,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0,    0, qdd2 + qdd3, R3^2*qdd3,        0,        0, R3^2*qd3,         0,                 g*cos(q2 + q3) + l2*qdd2*cos(q3) + (l2*qd1^2*sin(q3))/2 + l2*qd2^2*sin(q3) + (l2*qd1^2*sin(2*q2 + q3))/2]];
    
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

Im = simplify(gamma_reducida*thita_reducida);

qdd = [qdd1, qdd2, qdd3]';
qd = [qd1, qd2, qd3]';

M = sym(zeros(3,3));
V = sym(zeros(3,1));
G = sym(zeros(3,1));

for i = 1:3
    for j = 1:3
        M(i,j) = diff(Im(i), qdd(j));
    end
    G(i) = diff(Im(i), g)*g;
    V(i) = Im(i) - M(i,:)*qdd - G(i);
end

% R, Jm y Bm ya estan inluidas en M V y G
Ma = simplify(M);
Va = simplify(V);
Ga = simplify(G);

%% Obtencion de las matrices M V y G
% Estimacion de parámetros
% Accionamiento directo (Parametros con medidas ruidosas)
clear all;
syms q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g real

l0 = 1.00;
l1 = 0.40;
l2 = 0.70;
l3 = 0.50;

R1 = 1;
R2 = 1;
R3 = 1;

Kt1=0.5;
Kt2=0.4;
Kt3=0.35;

gamma_reducida = [
    (1/(Kt1*R1))*[ qdd1/2 - (qdd1*cos(2*q2))/2 + qd1*qd2*sin(2*q2), qdd1/2 - (qdd1*cos(2*q2 + 2*q3))/2 + qd1*qd2*sin(2*q2 + 2*q3) + qd1*qd3*sin(2*q2 + 2*q3), qdd1,    0,           0,         0, R1^2*qd1,        0,        0,         0,           -l2*(qd1*qd3*sin(q3) - qdd1*cos(2*q2 + q3) - qdd1*cos(q3) + 2*qd1*qd2*sin(2*q2 + q3) + qd1*qd3*sin(2*q2 + q3))];
    (1/(Kt2*R2))*[                            -(qd1^2*sin(2*q2))/2,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0, qdd2, qdd2 + qdd3,         0,        0, R2^2*qd2,        0, g*cos(q2), l2*sin(2*q2 + q3)*qd1^2 - l2*sin(q3)*qd3^2 - 2*l2*qd2*sin(q3)*qd3 + g*cos(q2 + q3) + 2*l2*qdd2*cos(q3) + l2*qdd3*cos(q3)];
    (1/(Kt3*R3))*[                                               0,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2,    0,    0, qdd2 + qdd3, R3^2*qdd3,        0,        0, R3^2*qd3,         0,                 g*cos(q2 + q3) + l2*qdd2*cos(q3) + (l2*qd1^2*sin(q3))/2 + l2*qd2^2*sin(q3) + (l2*qd1^2*sin(2*q2 + q3))/2]];
    
thita_reducida = [
                     0
                     0
                     0
                     0
                     0
                     0
                     0
                     0
                     0
                     0
                     0
];

Im = simplify(gamma_reducida*thita_reducida);

qdd = [qdd1, qdd2, qdd3]';
qd = [qd1, qd2, qd3]';

M = sym(zeros(3,3));
V = sym(zeros(3,1));
G = sym(zeros(3,1));

for i = 1:3
    for j = 1:3
        M(i,j) = diff(Im(i), qdd(j));
    end
    G(i) = diff(Im(i), g)*g;
    V(i) = Im(i) - M(i,:)*qdd - G(i);
end

% R, Jm y Bm ya estan inluidas en M V y G
Ma = simplify(M);
Va = simplify(V);
Ga = simplify(G);