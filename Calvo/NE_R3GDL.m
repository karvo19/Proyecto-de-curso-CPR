%% Newton-Euler
clear all;

% Variables simbolicas necesarias
syms T1 T2 T3 q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g real
syms m1 m2 m3 l1 l2 l3 Ixx1 Ixx2 Ixx3 Iyy1 Iyy2 Iyy3 Izz1 Izz2 Izz3 real
syms Jm1 Jm2 Jm3 Bm1 Bm2 Bm3 real
PI = sym('pi');

% DATOS CINEMÁTICOS DEL BRAZO DEL ROBOT
% Dimensiones (m)
  L0=0;  % Base
  L1=0.8;  % Esalbón 1 
  L2=0.4;  % Esalbón 2
  L3=0.6;  % Esalbón 3
  L4=0.4;  % Eslabón 4
  
% Parámetros de Denavit-Hartenberg (utilizado en primera regla de Newton-Euler)
% Eslabón base (no utilizado)
  theta0=0; d0=L0; a0=0; alpha0=0;
% Eslabón 1:
  theta1=q1; d1=L1; a1=0; alpha1=PI/2;
% Eslabón 2:
  theta2=q2; d2=0; a2=L2; alpha2=0;
% Eslabón 3:
  theta3=q3; d3=0; a3=L3; alpha3=0;
% Entre eslabón 3 y marco donde se ejerce la fuerza (a definir según
% experimento)
  theta4=0; d4=0; a4=0; alpha4=0;

% DATOS DINÁMICOS DEL BRAZO DEL ROBOT
% Eslabón 1
  m1; % kg
  s11 = [0,-l1,0]'; % m
  I11=[Ixx1,0,0;0,Iyy1,0;0,0,Izz1]; % kg.m2

% Eslabón 2
  m2; % kg
  s22 = [-l2,0, 0]'; % m
  I22=[Ixx2,0,0;0,Iyy2,0;0,0,Izz2]; % kg.m2

% Eslabón 3
  m3; % kg
  s33 = [-l3,0,0]'; % m
  I33=[Ixx3,0,0;0,Iyy3,0;0,0,Izz3]; % kg.m2


% DATOS DE LOS MOTORES
% Inercias
  Jm1; Jm2; Jm3; % kg.m2
% Coeficientes de fricción viscosa
  Bm1; Bm2; Bm3; % N.m / (rad/s)
% Factores de reducción
  R1 = 50; R2 = 30; R3 = 15;
% Constantes de par de los motores
  Kt1 = 0.5; Kt2 = 0.4; Kt3 = 0.35;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGORÍTMO DE NEWTON-EULER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wij : velocidad angular absoluta de eje j expresada en i
% wdij : aceleración angular absoluta de eje j expresada en i
% vij : velocidad lineal absoluta del origen del marco j expresada en i
% vdij : aceleración lineal absoluta del origen del marco j expresada en i
% aii : aceleración del centro de gravedad del eslabón i, expresado en i?

% fij : fuerza ejercida sobre la articulación j-1 (unión barra j-1 con j),
% expresada en i-1
%
% nij : par ejercido sobre la articulación j-1 (unión barra j-1 con j),
% expresada en i-1

% pii : vector (libre) que une el origen de coordenadas de i-1 con el de i,
% expresadas en i : [ai, di*sin(alphai), di*cos(alphai)] (a,d,aplha: parámetros de DH)
%
% sii : coordenadas del centro de masas del eslabón i, expresada en el sistema
% i

% Iii : matriz de inercia del eslabón i expresado en un sistema paralelo al
% i y con el origen en el centro de masas del eslabón
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% N-E 1: Asignación a cada eslabón de sistema de referencia de acuerdo con las normas de D-H.
  % Eslabón 1:
    p11 = [a1, d1*sin(alpha1), d1*cos(alpha1)]';   
  % Eslabón 2:
    p22 = [a2, d2*sin(alpha2), d2*cos(alpha2)]'; 
  % Eslabón 3:
    p33 = [a3, d3*sin(alpha3), d3*cos(alpha3)]'; 
  % Entre eslabón 2 y marco donde se ejerce la fuerza (supongo que el mismo
  % que el Z0
    p44 = [a4, d4*sin(alpha4), d4*cos(alpha4)]'; 

% N-E 2: Condiciones iniciales de la base
  w00=[0 0 0]';
  wd00 = [0 0 0]';
  v00 = [0 0 0]';
  vd00 = [0 0 g]'; % Aceleración de la gravedad en el eje Z0 negativo

% Condiciones iniciales para el extremo del robot
  f44= [0 0 0]';
  n44= [0 0 0]';

% Definición de vector local Z
  Z=[0 0 1]';


% N-E 3: Obtención de las matrices de rotación (i)R(i-1) y de sus inversas
  R01=[cos(theta1) -cos(alpha1)*sin(theta1) sin(alpha1)*sin(theta1);
      sin(theta1)  cos(alpha1)*cos(theta1)  -sin(alpha1)*cos(theta1);
      0            sin(alpha1)                cos(alpha1)           ];
  R10= R01';

  R12=[cos(theta2) -cos(alpha2)*sin(theta2) sin(alpha2)*sin(theta2);
      sin(theta2)  cos(alpha2)*cos(theta2)  -sin(alpha2)*cos(theta2);
      0            sin(alpha2)              cos(alpha2)           ];
  R21= R12';

  R23=[cos(theta3) -cos(alpha3)*sin(theta3) sin(alpha3)*sin(theta3);
      sin(theta3)  cos(alpha3)*cos(theta3)  -sin(alpha3)*cos(theta3);
      0            sin(alpha3)              cos(alpha3)           ];
  R32= R23';

  R34=[cos(theta4) -cos(alpha4)*sin(theta4) sin(alpha4)*sin(theta4);
      sin(theta4)  cos(alpha4)*cos(theta4)  -sin(alpha4)*cos(theta4);
      0            sin(alpha4)              cos(alpha4)           ];
  R43= R34';


%%%%%%% ITERACIÓN HACIA EL EXTERIOR (CINEMÁTICA)

% N-E 4: Obtención de las velocidades angulares absolutas
 % Articulación 1
   w11= R10*(w00+Z*qd1);  % Si es de rotación
   % w11 = R10*w00;      % Si es de translación
 % Articulación 2
   w22= R21*(w11+Z*qd2);  % Si es de rotación
   % w22 = R21*w11;      % Si es de translación
 % Articulación 3
   w33= R32*(w22+Z*qd3);  % Si es de rotación
   % w33 = R32*w22;      % Si es de translación

% N-E 5: Obtención de las aceleraciones angulares absolutas
 % Articulación 1
   wd11 = R10*(wd00+Z*qdd1+cross(w00,Z*qd1));  % si es de rotación
   % wd11 = R10*wd00;                                % si es de translación
 % Articulación 2
   wd22 = R21*(wd11+Z*qdd2+cross(w11,Z*qd2));  % si es de rotación
   % wd22 = R21*wd11;                                % si es de translación
 % Articulación 3
   wd33 = R32*(wd22+Z*qdd3+cross(w22,Z*qd3));  % si es de rotación
   % wd33 = R32*wd22;                                % si es de translación

% N-E 6: Obtención de las aceleraciones lineales de los orígenes de los
% sistemas
 % Articulación 1
   vd11 = cross(wd11,p11)+cross(w11,cross(w11,p11))+R10*vd00;  % si es de rotación
   % vd11 = R10*(Z*qdd1+vd00)+cross(wd11,p11)+2*cross(w11,R10*Z*qd1) + cross(w11,cross(w11,p11));    % si es de translación
 % Articulación 2
   vd22 = cross(wd22,p22)+cross(w22,cross(w22,p22))+R21*vd11;  % si es de rotación
   % vd22 = R21*(Z*qdd2+vd11)+cross(wd22,p22)+2*cross(w22,R21*Z*qd2) + cross(w22,cross(w22,p22));    % si es de translación
 % Articulación 3
   vd33 = cross(wd33,p33)+cross(w33,cross(w33,p33))+R32*vd22;  % si es de rotación
   % vd33 = R32*(Z*qdd3+vd22)+cross(wd33,p33)+2*cross(w33,R32*Z*qd3) + cross(w33,cross(w33,p33));    % si es de translación

% N-E 7: Obtención de las aceleraciones lineales de los centros de gravedad
   a11 = cross(wd11,s11)+cross(w11,cross(w11,s11))+vd11;
   a22 = cross(wd22,s22)+cross(w22,cross(w22,s22))+vd22;
   a33 = cross(wd33,s33)+cross(w33,cross(w33,s33))+vd33;

%%%%%%% ITERACIÓN HACIA EL INTERIOR (DINÁMICA)

% N-E 8: Obtención de las fuerzas ejercidas sobre los eslabones
  f33=R34*f44+m3*a33;
  f22=R23*f33+m2*a22;
  f11=R12*f22+m1*a11;

% N-E 9: Obtención de los pares ejercidas sobre los eslabones
  n33 = R34*(n44+cross(R43*p33,f44))+cross(p33+s33,m3*a33)+I33*wd33+cross(w33,I33*w33);
  n22 = R23*(n33+cross(R32*p22,f33))+cross(p22+s22,m2*a22)+I22*wd22+cross(w22,I22*w22);
  n11 = R12*(n22+cross(R21*p11,f22))+cross(p11+s11,m1*a11)+I11*wd11+cross(w11,I11*w11);

% N-E 10: Obtener la fuerza o par aplicado sobre la articulación
  N3z = n33'*R32*Z;  % Si es de rotación
  N3  = n33'*R32;    % Para ver todos los pares, no solo el del eje Z
  F3z = f33'*R32*Z;  % Si es de translacion;
  F3  = f33'*R32;    % Para ver todas las fuerzas, no solo la del eje Z
  N2z = n22'*R21*Z;  % Si es de rotación
  N2  = n22'*R21;    % Para ver todos los pares, no solo el del eje Z
  F2z = f22'*R21*Z;  % Si es de translacion;
  F2  = f22'*R21;    % Para ver todas las fuerzas, no solo la del eje Z
  N1z = n11'*R10*Z;  % Si es de rotación
  N1  = n11'*R10;    % Para ver todos los pares, no solo el del eje Z
  F1z = f11'*R10*Z;  % Si es de translacion;
  F1  = f11'*R10;    % Para ver todas las fuerzas, no solo la del eje Z

% Robot ??? (descomentar los que procedan)
  % T1=F1z;
  T1=N1z;
  % T2=F2z;
  T2=N2z;
  % T3=F3z;
  T3=N3z;

%% Obtencion de las matrices MVG
M11=diff(T1,qdd1);
M12=diff(T1,qdd2);
M13=diff(T1,qdd3);
G1=diff(T1,g)*g;
V1=T1-M11*qdd1-M12*qdd2-M13*qdd3-G1;

M21=diff(T2,qdd1);
M22=diff(T2,qdd2);
M23=diff(T2,qdd3);
G2=diff(T2,g)*g;
V2=T2-M21*qdd1-M22*qdd2-M23*qdd3-G2;

M31=diff(T3,qdd1);
M32=diff(T3,qdd2);
M33=diff(T3,qdd3);
G3=diff(T3,g)*g;
V3=T3-M31*qdd1-M32*qdd2-M33*qdd3-G3;

M11=simplify(M11); M12=simplify(M12); M13=simplify(M13);
M21=simplify(M21); M22=simplify(M22); M23=simplify(M23);
M31=simplify(M31); M32=simplify(M32); M33=simplify(M33);

V1=simplify(V1); V2=simplify(V2); V3=simplify(V3);

G1=simplify(G1); G2=simplify(G2); G3=simplify(G3);

% Matrices MVG
M=[M11,M12,M13;M21,M22,M23;M31,M32,M33];
V=[V1;V2;V3];
G=[G1;G2;G3];

R=[R1,0,0;0,R2,0;0,0,R3];
Jm=[Jm1,0,0;0,Jm2,0;0,0,Jm3];
Bm=[Bm1,0,0;0,Bm2,0;0,0,Bm3];

Ma=M+Jm*R*R;
Va=V+Bm*R*R*[qd1;qd2;qd3];
Ga=G;

% Matrices ampliadas
Ma=simplify(Ma);
Va=simplify(Va);
Ga=simplify(Ga);


%% Reordenacion de las ecuaciones en forma de Kt_Im_R = gamma * thita
% Modelo: K * Im * R = Ma * qdd + Va + G
% Kt_Im_R = [K1 K2 K3] * [R1 ; R2; R3] * Im
Kt_Im_R = Ma * [qdd1; qdd2; qdd3] + Va + G;

thita = [m1 m1*l1 m1*l1^2 Ixx1 Iyy1 Izz1 Jm1 Bm1 m2 m2*l2 m2*l2^2 Ixx2 Iyy2 Izz2 Jm2 Bm2 m3 m3*l3 m3*l3^2 Ixx3 Iyy3 Izz3 Jm3 Bm3]';
gamma = sym(zeros(3, length(thita)));

gamma(:,3) = diff((diff(Kt_Im_R, l1, 2)/2),m1);
gamma(:,2) = diff((diff((Kt_Im_R - gamma(:,3)*m1*l1^2),l1)),m1);
gamma(:,1) = diff((Kt_Im_R - gamma(:,2)*m1*l1 - gamma(:,3)*m1*l1^2),m1);

gamma(:,11) = diff((diff(Kt_Im_R, l2, 2)/2),m2);
gamma(:,10) = diff((diff((Kt_Im_R - gamma(:,11)*m2*l2^2),l2)),m2);
gamma(:,9) = diff((Kt_Im_R - gamma(:,10)*m2*l2 - gamma(:,11)*m2*l2^2),m2);

gamma(:,19) = diff((diff(Kt_Im_R, l3, 2)/2),m3);
gamma(:,18) = diff((diff((Kt_Im_R - gamma(:,19)*m3*l3^2),l3)),m3);
gamma(:,17) = diff((Kt_Im_R - gamma(:,18)*m3*l3 - gamma(:,19)*m3*l3^2),m3);

for j = [4:8 12:16 20:24]
    gamma(:,j) = diff(Kt_Im_R, thita(j));
end

gamma = simplify(gamma);

%% Reduccion de la matriz gamma con métodos numericos
gamma_numerica = zeros(length(thita),length(thita));
g = 9.8;
for j = 1:10
    for i = 1:3:(length(thita))
        q1 = rand; qd1 = rand; qdd1 = rand;
        q2 = rand; qd2 = rand; qdd2 = rand;
        q3 = rand; qd3 = rand; qdd3 = rand;

        gamma_numerica(i:i+2,:) = eval(gamma);
    end
    [Coeficientes, Columnas_Independientes] = rref(gamma_numerica);
    Columnas_Independientes
end
% Columnas_Independientes -> 5 8 9 10 12 16 17 18 20 23 24

%% Gamma y Thita reducidas

% Columnas_Independientes -> 5 8 9 10 12 16 17 18 20 23 24

%           1     2       3    4    5    6   7   8  9    10      11   12   13   14  15  16 17    18      19   20   21   22  23  24 
% thita = [m1 m1*l1 m1*l1^2 Ixx1 Iyy1 Izz1 Jm1 Bm1 m2 m2*l2 m2*l2^2 Ixx2 Iyy2 Izz2 Jm2 Bm2 m3 m3*l3 m3*l3^2 Ixx3 Iyy3 Izz3 Jm3 Bm3]';

gamma_reducida = [qdd1, 2500*qd1, (2*qdd1)/25 + (2*qdd1*cos(2*q2))/25 - (4*qd1*qd2*sin(2*q2))/25, (4*qd1*qd2*sin(2*q2))/5 - (2*qdd1*cos(2*q2))/5 - (2*qdd1)/5, qd1*qd2*sin(2*q2) - qdd1*(cos(2*q2)/2 - 1/2),       0, (13*qdd1)/50 + (2*qdd1*cos(2*q2))/25 + (9*qdd1*cos(2*q2 + 2*q3))/50 + (6*qdd1*cos(q3))/25 + (6*qdd1*cos(2*q2 + q3))/25 - (6*qd1*qd3*sin(q3))/25 - (12*qd1*qd2*sin(2*q2 + q3))/25 - (6*qd1*qd3*sin(2*q2 + q3))/25 - (4*qd1*qd2*sin(2*q2))/25 - (9*qd1*qd2*sin(2*q2 + 2*q3))/25 - (9*qd1*qd3*sin(2*q2 + 2*q3))/25, (2*qd1*qd3*sin(q3))/5 - (3*qdd1*cos(2*q2 + 2*q3))/5 - (2*qdd1*cos(q3))/5 - (2*qdd1*cos(2*q2 + q3))/5 - (3*qdd1)/5 + (4*qd1*qd2*sin(2*q2 + q3))/5 + (2*qd1*qd3*sin(2*q2 + q3))/5 + (6*qd1*qd2*sin(2*q2 + 2*q3))/5 + (6*qd1*qd3*sin(2*q2 + 2*q3))/5, (qd1*(25*qd2*sin(2*q2 + 2*q3) + 25*qd3*sin(2*q2 + 2*q3)))/25 - qdd1*(cos(2*q2 + 2*q3)/2 - 1/2),        0,       0;
                     0,        0,         (2*sin(2*q2)*qd1^2)/25 + (4*qdd2)/25 + (2*g*cos(q2))/5,            - (4*qdd2)/5 - (2*qd1^2*sin(2*q2))/5 - g*cos(q2),                         -(qd1^2*sin(2*q2))/2, 900*qd2,                                                        (13*qdd2)/25 + (9*qdd3)/25 - (6*qd3^2*sin(q3))/25 + (6*qd1^2*sin(2*q2 + q3))/25 + (3*g*cos(q2 + q3))/5 + (2*qd1^2*sin(2*q2))/25 + (2*g*cos(q2))/5 + (9*qd1^2*sin(2*q2 + 2*q3))/50 + (12*qdd2*cos(q3))/25 + (6*qdd3*cos(q3))/25 - (12*qd2*qd3*sin(q3))/25,                                                      (2*sin(q3)*qd3^2)/5 + (4*qd2*sin(q3)*qd3)/5 - (6*qdd2)/5 - (6*qdd3)/5 - (2*qd1^2*sin(2*q2 + q3))/5 - g*cos(q2 + q3) - (3*qd1^2*sin(2*q2 + 2*q3))/5 - (4*qdd2*cos(q3))/5 - (2*qdd3*cos(q3))/5,                                                                    -(qd1^2*sin(2*q2 + 2*q3))/2,        0,       0;
                     0,        0,                                                              0,                                                           0,                                            0,       0,                                                                                                                              (9*qdd2)/25 + (9*qdd3)/25 + (3*qd1^2*sin(q3))/25 + (6*qd2^2*sin(q3))/25 + (3*qd1^2*sin(2*q2 + q3))/25 + (3*g*cos(q2 + q3))/5 + (9*qd1^2*sin(2*q2 + 2*q3))/50 + (6*qdd2*cos(q3))/25,                                                                               - (6*qdd2)/5 - (6*qdd3)/5 - (qd1^2*sin(q3))/5 - (2*qd2^2*sin(q3))/5 - (qd1^2*sin(2*q2 + q3))/5 - g*cos(q2 + q3) - (3*qd1^2*sin(2*q2 + 2*q3))/5 - (2*qdd2*cos(q3))/5,                                                                    -(qd1^2*sin(2*q2 + 2*q3))/2, 225*qdd3, 225*qd3];
thita_reducida = [    Iyy1 + 2500*Jm1 + Iyy2 + Iyy3 - Izz2 - Izz3 - 900*Jm2
                       Bm1
                        m2 - 25/4*m2*l2^2 - 25/4*Izz2 - 900*25/4*Jm2 - 25/9*Izz3 - 25/9*m3*l3^2 + 50/9*Izz3 + 50/9*m3*l3^2
                     m2*l2 -  5/2*m2*l2^2 -  5/2*Izz2 -  900*5/2*Jm2 - 10/9*Izz3 - 10/9*m3*l3^2 + 10/9*Izz3 + 10/9*m3*l3^2
                      Ixx2 -         Iyy2 +      Izz2 +      900*Jm2 - 4/9*Izz3 - 4/9*m3*l3^2   +  4/9*Izz3 +  4/9*m3*l3^2
                       Bm2
                        m3 - 25/9*m3*l3^2 - 25/9*Izz3
                     m3*l3 -  5/3*m3*l3^2 -  5/3*Izz3
                      Ixx3 -         Iyy3 +      Izz3
                       Jm3
                       Bm3];
clc
simplify(gamma_reducida*thita_reducida - Kt_Im_R)