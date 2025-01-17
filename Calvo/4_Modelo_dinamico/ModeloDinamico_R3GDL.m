%%%%%%%%%%%%%%% Modelo Dinámico %%%%%%%%%%%%%%%
function [qdd] = ModeloDinamico_R3GDL(in)

% Variables de entrada en la funcion:
q1        = in(1);
q2        = in(2);
q3        = in(3);
qd1       = in(4);
qd2       = in(5);
qd3       = in(6);
Im1      = in(7);
Im2      = in(8);
Im3      = in(9);


% Parámetros base estimados:
t_red=[
%  Modelo perfecto con reductoras
%    -1.7594
%    -0.3966
%     8.3284
%    16.0353
%     0.3977
%     0.0072
%     0.0120
%     0.0085
%     0.0150
%     2.9131
%     0.9710

% Modelo ruidoso con reductoras
    -1.7507
    -0.3874
     8.2151
     15.973
     0.3841
     0.0080
     0.0114
     0.0069
     0.0150
     2.9975
     0.9856

%  Modelo perfecto con accionamiento directo
%          -1.75940038424998
%         -0.396642654749998
%           2.16551925299997
%           1.77669585024997
%          0.397667654749993
%        0.00722506600000024
%         0.0119999999999998
%        0.00849999999999985
%         0.0149999999999998
%           2.91314677499997
%          0.971048924999985
];


% Datos geométricos / gravedad / reductoras / constantes de par
l0 = 1.00;
l1 = 0.40;
l2 = 0.70;
l3 = 0.50;

g = 9.81;

R1 = 1;
R2 = 1;
R3 = 1;

% R1 = 50;
% R2 = 30;
% R3 = 15;

R = diag([R1 R2 R3]);

Kt1 = 0.5;
Kt2 = 0.4;
Kt3 = 0.35;
Kt = diag([Kt1 Kt2 Kt3]);


% Modelo en forma matricial (M, V, G) (solucion de Raul)
M11 = [t_red(3)+t_red(11)*l2*(cos(2*q2+q3)+cos(q3))+1/2*(t_red(1)+t_red(2)-t_red(1)*cos(2*q2)-t_red(2)*cos(2*q2+2*q3))];
M12 = 0;
M13 = 0;
M21 = M12;
M22 = [t_red(4)+t_red(5)+2*l2*t_red(11)*cos(q3)];
M23 = [t_red(5)+l2*t_red(11)*cos(q3)];
M31 = M13;
M32 = M23;
M33 = [t_red(5)+R3^2*t_red(6)];

M = [M11 M12 M13
     M21 M22 M23
     M31 M32 M33];

V1 = [qd1*( t_red(7)*R1^2 +qd2*(sin(2*q2)*t_red(1) +sin(2*q2+2*q3)*t_red(2) - 2*l2*t_red(11)*sin(2*q2+q3)) + qd3*(sin(2*q2+2*q3)*t_red(2) -l2*t_red(11)*sin(2*q2+q3) -l2*t_red(11)*sin(q3) )     ) ];
V2 = ( (-1/2*qd1^2*(sin(2*q2)*t_red(1) + sin(2*q2+2*q3)*t_red(2) - 2*l2*t_red(11)*sin(2*q2+q3) ))  + (qd2*t_red(8)*R2^2) - l2*t_red(11)*sin(q3)*qd3^2 - 2*l2*t_red(11)*qd2*sin(q3)*qd3 );
V3 = (    (qd3*R3^2*t_red(9)) + (qd2^2*sin(q3)*l2*t_red(11))  + qd1^2*(-t_red(2)*sin(2*q2 + 2*q3) +l2*t_red(11)*(sin(2*q2 + q3) + sin(q3))   )/2  );

V = [V1 V2 V3]';

G1 = 0;
G2 = g*(t_red(10)*cos(q2) +t_red(11)*cos(q2+q3));
G3 = g*t_red(11)*cos(q2+q3);

G=[G1 G2 G3]';
  
Im=[Im1 Im2 Im3]';

qdd = inv(M)*(Kt*R*Im-V-G);
