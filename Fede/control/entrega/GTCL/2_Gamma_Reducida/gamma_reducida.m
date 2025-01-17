%% Obtencion y reduccion de la matriz gamma para posteiormente estimar parametros
% Newton-Euler
clear all;
close all;
clc;

% Variables simbolicas necesarias
syms T1 T2 T3 q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g real
syms m1 m2 m3 L1 L2 L3 l0 l1 l2 l3 lc1 lc2 lc3 real
syms Ixx1 Ixx2 Ixx3 Iyy1 Iyy2 Iyy3 Izz1 Izz2 Izz3 real
syms Jm1 Jm2 Jm3 Bm1 Bm2 Bm3 real
syms Kt1 Kt2 Kt3 R1 R2 R3 real
PI = sym('pi');

% DATOS CINEM�TICOS DEL BRAZO DEL ROBOT
% Dimensiones (m)
%   l0 = 1.00;  % Base
%   l1 = 0.40;  % Esalb�n 1 
%   l2 = 0.70;  % Esalb�n 2
%   l3 = 0.50;  % Esalb�n 3
  
% Par�metros de Denavit-Hartenberg (utilizado en primera regla de Newton-Euler)
% Eslab�n base (no utilizado)
  theta0=0; d0=l0; a0=0; alpha0=0;
% Eslab�n 1:
  theta1=q1; d1=l1; a1=0; alpha1=PI/2;
% Eslab�n 2:
  theta2=q2; d2=0; a2=l2; alpha2=0;
% Eslab�n 3:
  theta3=q3; d3=0; a3=l3; alpha3=0;
% Entre eslab�n 3 y marco donde se ejerce la fuerza (a definir seg�n
% experimento)
  theta4=0; d4=0; a4=0; alpha4=0;

% DATOS DIN�MICOS DEL BRAZO DEL ROBOT
% Eslab�n 1
  m1; % kg
  s11 = [0,-lc1,0]'; % m
  I11=[Ixx1,0,0;0,Iyy1,0;0,0,Izz1]; % kg.m2

% Eslab�n 2
  m2; % kg
  s22 = [-lc2,0, 0]'; % m
  I22=[Ixx2,0,0;0,Iyy2,0;0,0,Izz2]; % kg.m2

% Eslab�n 3
  m3; % kg
  s33 = [-lc3,0,0]'; % m
  I33=[Ixx3,0,0;0,Iyy3,0;0,0,Izz3]; % kg.m2


% DATOS DE LOS MOTORES
% Inercias
  Jm1; Jm2; Jm3; % kg.m2
% Coeficientes de fricci�n viscosa
  Bm1; Bm2; Bm3; % N.m / (rad/s)
% % Factores de reducci�n
%   R1 = 50; R2 = 30; R3 = 15;
% % Constantes de par de los motores
%   Kt1 = 0.5; Kt2 = 0.4; Kt3 = 0.35;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGOR�TMO DE NEWTON-EULER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wij : velocidad angular absoluta de eje j expresada en i
% wdij : aceleraci�n angular absoluta de eje j expresada en i
% vij : velocidad lineal absoluta del origen del marco j expresada en i
% vdij : aceleraci�n lineal absoluta del origen del marco j expresada en i
% aii : aceleraci�n del centro de gravedad del eslab�n i, expresado en i?

% fij : fuerza ejercida sobre la articulaci�n j-1 (uni�n barra j-1 con j),
% expresada en i-1
%
% nij : par ejercido sobre la articulaci�n j-1 (uni�n barra j-1 con j),
% expresada en i-1

% pii : vector (libre) que une el origen de coordenadas de i-1 con el de i,
% expresadas en i : [ai, di*sin(alphai), di*cos(alphai)] (a,d,aplha: par�metros de DH)
%
% sii : coordenadas del centro de masas del eslab�n i, expresada en el sistema
% i

% Iii : matriz de inercia del eslab�n i expresado en un sistema paralelo al
% i y con el origen en el centro de masas del eslab�n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% N-E 1: Asignaci�n a cada eslab�n de sistema de referencia de acuerdo con las normas de D-H.
  % Eslab�n 1:
    p11 = [a1, d1*sin(alpha1), d1*cos(alpha1)]';   
  % Eslab�n 2:
    p22 = [a2, d2*sin(alpha2), d2*cos(alpha2)]'; 
  % Eslab�n 3:
    p33 = [a3, d3*sin(alpha3), d3*cos(alpha3)]'; 
  % Entre eslab�n 2 y marco donde se ejerce la fuerza (supongo que el mismo
  % que el Z0
    p44 = [a4, d4*sin(alpha4), d4*cos(alpha4)]'; 

% N-E 2: Condiciones iniciales de la base
  w00=[0 0 0]';
  wd00 = [0 0 0]';
  v00 = [0 0 0]';
  vd00 = [0 0 g]'; % Aceleraci�n de la gravedad en el eje Z0 negativo

% Condiciones iniciales para el extremo del robot
  f44= [0 0 0]';
  n44= [0 0 0]';

% Definici�n de vector local Z
  Z=[0 0 1]';


% N-E 3: Obtenci�n de las matrices de rotaci�n (i)R(i-1) y de sus inversas
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


%%%%%%% ITERACI�N HACIA EL EXTERIOR (CINEM�TICA)

% N-E 4: Obtenci�n de las velocidades angulares absolutas
 % Articulaci�n 1
   w11= R10*(w00+Z*qd1);  % Si es de rotaci�n
   % w11 = R10*w00;      % Si es de translaci�n
 % Articulaci�n 2
   w22= R21*(w11+Z*qd2);  % Si es de rotaci�n
   % w22 = R21*w11;      % Si es de translaci�n
 % Articulaci�n 3
   w33= R32*(w22+Z*qd3);  % Si es de rotaci�n
   % w33 = R32*w22;      % Si es de translaci�n

% N-E 5: Obtenci�n de las aceleraciones angulares absolutas
 % Articulaci�n 1
   wd11 = R10*(wd00+Z*qdd1+cross(w00,Z*qd1));  % si es de rotaci�n
   % wd11 = R10*wd00;                                % si es de translaci�n
 % Articulaci�n 2
   wd22 = R21*(wd11+Z*qdd2+cross(w11,Z*qd2));  % si es de rotaci�n
   % wd22 = R21*wd11;                                % si es de translaci�n
 % Articulaci�n 3
   wd33 = R32*(wd22+Z*qdd3+cross(w22,Z*qd3));  % si es de rotaci�n
   % wd33 = R32*wd22;                                % si es de translaci�n

% N-E 6: Obtenci�n de las aceleraciones lineales de los or�genes de los
% sistemas
 % Articulaci�n 1
   vd11 = cross(wd11,p11)+cross(w11,cross(w11,p11))+R10*vd00;  % si es de rotaci�n
   % vd11 = R10*(Z*qdd1+vd00)+cross(wd11,p11)+2*cross(w11,R10*Z*qd1) + cross(w11,cross(w11,p11));    % si es de translaci�n
 % Articulaci�n 2
   vd22 = cross(wd22,p22)+cross(w22,cross(w22,p22))+R21*vd11;  % si es de rotaci�n
   % vd22 = R21*(Z*qdd2+vd11)+cross(wd22,p22)+2*cross(w22,R21*Z*qd2) + cross(w22,cross(w22,p22));    % si es de translaci�n
 % Articulaci�n 3
   vd33 = cross(wd33,p33)+cross(w33,cross(w33,p33))+R32*vd22;  % si es de rotaci�n
   % vd33 = R32*(Z*qdd3+vd22)+cross(wd33,p33)+2*cross(w33,R32*Z*qd3) + cross(w33,cross(w33,p33));    % si es de translaci�n

% N-E 7: Obtenci�n de las aceleraciones lineales de los centros de gravedad
   a11 = cross(wd11,s11)+cross(w11,cross(w11,s11))+vd11;
   a22 = cross(wd22,s22)+cross(w22,cross(w22,s22))+vd22;
   a33 = cross(wd33,s33)+cross(w33,cross(w33,s33))+vd33;

%%%%%%% ITERACI�N HACIA EL INTERIOR (DIN�MICA)

% N-E 8: Obtenci�n de las fuerzas ejercidas sobre los eslabones
  f33=R34*f44+m3*a33;
  f22=R23*f33+m2*a22;
  f11=R12*f22+m1*a11;

% N-E 9: Obtenci�n de los pares ejercidas sobre los eslabones
  n33 = R34*(n44+cross(R43*p33,f44))+cross(p33+s33,m3*a33)+I33*wd33+cross(w33,I33*w33);
  n22 = R23*(n33+cross(R32*p22,f33))+cross(p22+s22,m2*a22)+I22*wd22+cross(w22,I22*w22);
  n11 = R12*(n22+cross(R21*p11,f22))+cross(p11+s11,m1*a11)+I11*wd11+cross(w11,I11*w11);

% N-E 10: Obtener la fuerza o par aplicado sobre la articulaci�n
  N3z = n33'*R32*Z;  % Si es de rotaci�n
  N3  = n33'*R32;    % Para ver todos los pares, no solo el del eje Z
  F3z = f33'*R32*Z;  % Si es de translacion;
  F3  = f33'*R32;    % Para ver todas las fuerzas, no solo la del eje Z
  N2z = n22'*R21*Z;  % Si es de rotaci�n
  N2  = n22'*R21;    % Para ver todos los pares, no solo el del eje Z
  F2z = f22'*R21*Z;  % Si es de translacion;
  F2  = f22'*R21;    % Para ver todas las fuerzas, no solo la del eje Z
  N1z = n11'*R10*Z;  % Si es de rotaci�n
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
M11 = diff(T1,qdd1);
M12 = diff(T1,qdd2);
M13 = diff(T1,qdd3);
G1 = diff(T1,g)*g;
V1 = T1 - M11*qdd1 - M12*qdd2 - M13*qdd3 - G1;

M21 = diff(T2,qdd1);
M22 = diff(T2,qdd2);
M23 = diff(T2,qdd3);
G2 = diff(T2,g)*g;
V2 = T2 - M21*qdd1 - M22*qdd2 - M23*qdd3 - G2;

M31 = diff(T3,qdd1);
M32 = diff(T3,qdd2);
M33 = diff(T3,qdd3);
G3 = diff(T3,g)*g;
V3 = T3 - M31*qdd1 - M32*qdd2 - M33*qdd3 - G3;

M11 = simplify(M11); M12 = simplify(M12); M13 = simplify(M13);
M21 = simplify(M21); M22 = simplify(M22); M23 = simplify(M23);
M31 = simplify(M31); M32 = simplify(M32); M33 = simplify(M33);

V1 = simplify(V1); V2 = simplify(V2); V3 = simplify(V3);

G1 = simplify(G1); G2 = simplify(G2); G3 = simplify(G3);

% Matrices MVG
M = [M11, M12, M13; M21, M22, M23; M31, M32, M33];
V = [V1; V2; V3];
G = [G1; G2; G3];

R = [R1, 0, 0; 0, R2, 0; 0, 0, R3];
Jm = [Jm1, 0, 0; 0, Jm2, 0; 0, 0, Jm3];
Bm = [Bm1, 0, 0; 0, Bm2, 0; 0, 0, Bm3];

Ma = M + Jm*R*R;
Va = V + Bm*R*R*[qd1; qd2; qd3];
Ga = G;

% Matrices ampliadas
Ma = simplify(Ma);
Va = simplify(Va);
Ga = simplify(Ga);

%% Reordenacion de las ecuaciones en forma de Kt_Im_R = gamma * thita
% Modelo: K * Im * R = Ma * qdd + Va + G
% Kt_Im_R = [K1 K2 K3] * [R1 ; R2; R3] * Im
Kt_Im_R = Ma * [qdd1; qdd2; qdd3] + Va + G;

% Hacemos el cambio de variable Li = li - lci
Kt_Im_R = subs(Kt_Im_R, lc1, l1 - L1);
Kt_Im_R = subs(Kt_Im_R, lc2, l2 - L2);
Kt_Im_R = subs(Kt_Im_R, lc3, l3 - L3);

Kt_Im_R = simplify(Kt_Im_R);

thita = [m1 m1*L1 m1*L1^2 Ixx1 Iyy1 Izz1 Jm1 Bm1 ...
         m2 m2*L2 m2*L2^2 Ixx2 Iyy2 Izz2 Jm2 Bm2 ...
         m3 m3*L3 m3*L3^2 Ixx3 Iyy3 Izz3 Jm3 Bm3]';
gamma = sym(zeros(3, length(thita)));

gamma(:,3) = diff((diff(Kt_Im_R, L1, 2)/2),m1);
gamma(:,2) = diff((diff((Kt_Im_R - gamma(:,3)*m1*L1^2),L1)),m1);
gamma(:,1) = diff((Kt_Im_R - gamma(:,2)*m1*L1 - gamma(:,3)*m1*L1^2),m1);

gamma(:,11) = diff((diff(Kt_Im_R, L2, 2)/2),m2);
gamma(:,10) = diff((diff((Kt_Im_R - gamma(:,11)*m2*L2^2),L2)),m2);
gamma(:,9) = diff((Kt_Im_R - gamma(:,10)*m2*L2 - gamma(:,11)*m2*L2^2),m2);

gamma(:,19) = diff((diff(Kt_Im_R, L3, 2)/2),m3);
gamma(:,18) = diff((diff((Kt_Im_R - gamma(:,19)*m3*L3^2),L3)),m3);
gamma(:,17) = diff((Kt_Im_R - gamma(:,18)*m3*L3 - gamma(:,19)*m3*L3^2),m3);

for j = [4:8 12:16 20:24]
    gamma(:,j) = diff(Kt_Im_R, thita(j));
end

gamma = simplify(gamma);

%%
Kt_Im_R = Ma * [qdd1; qdd2; qdd3] + Va + G;

% Hacemos el cambio de variable Li = li - lci
Kt_Im_R = subs(Kt_Im_R, lc1, l1 - L1);
Kt_Im_R = subs(Kt_Im_R, lc2, l2 - L2);
Kt_Im_R = subs(Kt_Im_R, lc3, l3 - L3);

Kt_Im_R = simplify(Kt_Im_R);

thita=[Ixx1, Iyy1, Izz1, Ixx2, Iyy2, Izz2, Ixx3, Iyy3, Izz3,...
       Jm1, Jm2, Jm3, Bm1, Bm2, Bm3, ...
       m1*L1^2, m2*L2^2, m3*L3^2, m1*L1, m2*L2, m3*L3, ...
       m1, m2, m3]; 
   
gamma = sym(zeros(3, length(thita)));

gamma(:,16) = diff((diff(Kt_Im_R, L1, 2)/2),m1);
gamma(:,19) = diff((diff((Kt_Im_R - gamma(:,16)*m1*L1^2),L1)),m1);
gamma(:,22) = diff((Kt_Im_R - gamma(:,19)*m1*L1 - gamma(:,16)*m1*L1^2),m1);

gamma(:,17) = diff((diff(Kt_Im_R, L2, 2)/2),m2);
gamma(:,20) = diff((diff((Kt_Im_R - gamma(:,17)*m2*L2^2),L2)),m2);
gamma(:,23) = diff((Kt_Im_R - gamma(:,20)*m2*L2 - gamma(:,17)*m2*L2^2),m2);

gamma(:,18) = diff((diff(Kt_Im_R, L3, 2)/2),m3);
gamma(:,21) = diff((diff((Kt_Im_R - gamma(:,18)*m3*L3^2),L3)),m3);
gamma(:,24) = diff((Kt_Im_R - gamma(:,21)*m3*L3 - gamma(:,18)*m3*L3^2),m3);

for j = 1:15
    gamma(:,j) = diff(Kt_Im_R, thita(j));
end

gamma = simplify(gamma);

% %% Identificacion de las columnas independientes de gamma con m�todos numericos
% gamma_numerica = zeros(length(thita),length(thita));
% g = 9.8;
% l0 = 1.00;  l1 = 0.40;  l2 = 0.70;  l3 = 0.50;
% R1 = 50; R2 = 30; R3 = 15;
% Kt1 = 0.5; Kt2 = 0.4; Kt3 = 0.35;
% for j = 1:10
%     for i = 1:3:(length(thita))
%         q1 = rand; qd1 = rand; qdd1 = rand;
%         q2 = rand; qd2 = rand; qdd2 = rand;
%         q3 = rand; qd3 = rand; qdd3 = rand;
% 
%         gamma_numerica(i:i+2,:) = eval(gamma);
%     end
%     [Coeficientes, Columnas_Independientes] = rref(gamma_numerica);
%     Columnas_Independientes
% end
% % Columnas_Independientes -> 5 8 10 11 12 16 18 19 20 23 24

%% Reduccion de gamma
% Columnas_Independientes = [5 8 10 11 12 16 18 19 20 23 24];
Columnas_Independientes = [2 4 6 7 9 12 13 14 15 20 21];

gamma_reducida = [];
for i = 1:length(Columnas_Independientes)
    gamma_reducida = [gamma_reducida, gamma(:,Columnas_Independientes(i))];
end

%% Obtencion de gamma simplificada para calculo simbolico
gamma_sim = [];
thita_sim = [];
%for i = 1:(length(gamma)-2)
for i = [1:11 16:20 22:24]
    if sum(gamma(:,i)) ~= 0
        gamma_sim = [gamma_sim, gamma(:,i)];
        thita_sim = [thita_sim; thita(i)];
    end
end

%% Ampliacion de gamma simplificada para hacerla cuadrada
syms q1_1 qd1_1 qdd1_1 q2_1 qd2_1 qdd2_1 q3_1 qd3_1 qdd3_1 real
syms q1_2 qd1_2 qdd1_2 q2_2 qd2_2 qdd2_2 q3_2 qd3_2 qdd3_2 real
syms q1_3 qd1_3 qdd1_3 q2_3 qd2_3 qdd2_3 q3_3 qd3_3 qdd3_3 real
syms q1_4 qd1_4 qdd1_4 q2_4 qd2_4 qdd2_4 q3_4 qd3_4 qdd3_4 real
syms q1_5 qd1_5 qdd1_5 q2_5 qd2_5 qdd2_5 q3_5 qd3_5 qdd3_5 real
syms q1_6 qd1_6 qdd1_6 q2_6 qd2_6 qdd2_6 q3_6 qd3_6 qdd3_6 real

gamma_sim_ampliada = [];

q1 = q1_1; qd1 = qd1_1; qdd1 = qdd1_1; 
q2 = q2_1; qd2 = qd2_1; qdd2 = qdd2_1; 
q3 = q3_1; qd3 = qd3_1; qdd3 = qdd3_1; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada];

q1 = q1_2; qd1 = qd1_2; qdd1 = qdd1_2; 
q2 = q2_2; qd2 = qd2_2; qdd2 = qdd2_2; 
q3 = q3_2; qd3 = qd3_2; qdd3 = qdd3_2; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada];

q1 = q1_3; qd1 = qd1_3; qdd1 = qdd1_3; 
q2 = q2_3; qd2 = qd2_3; qdd2 = qdd2_3; 
q3 = q3_3; qd3 = qd3_3; qdd3 = qdd3_3; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada];

q1 = q1_4; qd1 = qd1_4; qdd1 = qdd1_4; 
q2 = q2_4; qd2 = qd2_4; qdd2 = qdd2_4; 
q3 = q3_4; qd3 = qd3_4; qdd3 = qdd3_4; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada];

q1 = q1_5; qd1 = qd1_5; qdd1 = qdd1_5; 
q2 = q2_5; qd2 = qd2_5; qdd2 = qdd2_5; 
q3 = q3_5; qd3 = qd3_5; qdd3 = qdd3_5; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada];

q1 = q1_6; qd1 = qd1_6; qdd1 = qdd1_6; 
q2 = q2_6; qd2 = qd2_6; qdd2 = qdd2_6; 
q3 = q3_6; qd3 = qd3_6; qdd3 = qdd3_6; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada(1:1,:)];

%% Ampliacion de gamma simplificada para hacerla cuadrada
syms q1_1 qd1_1 qdd1_1 q2_1 qd2_1 qdd2_1 q3_1 qd3_1 qdd3_1 real
syms q1_2 qd1_2 qdd1_2 q2_2 qd2_2 qdd2_2 q3_2 qd3_2 qdd3_2 real
syms q1_3 qd1_3 qdd1_3 q2_3 qd2_3 qdd2_3 q3_3 qd3_3 qdd3_3 real
syms q1_4 qd1_4 qdd1_4 q2_4 qd2_4 qdd2_4 q3_4 qd3_4 qdd3_4 real
syms q1_5 qd1_5 qdd1_5 q2_5 qd2_5 qdd2_5 q3_5 qd3_5 qdd3_5 real

gamma_sim_ampliada = [];

q1 = q1_1; qd1 = qd1_1; qdd1 = qdd1_1; 
q2 = q2_1; qd2 = qd2_1; qdd2 = qdd2_1; 
q3 = q3_1; qd3 = qd3_1; qdd3 = qdd3_1; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada];

q1 = q1_2; qd1 = qd1_2; qdd1 = qdd1_2; 
q2 = q2_2; qd2 = qd2_2; qdd2 = qdd2_2; 
q3 = q3_2; qd3 = qd3_2; qdd3 = qdd3_2; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada];

q1 = q1_3; qd1 = qd1_3; qdd1 = qdd1_3; 
q2 = q2_3; qd2 = qd2_3; qdd2 = qdd2_3; 
q3 = q3_3; qd3 = qd3_3; qdd3 = qdd3_3; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada];

q1 = q1_4; qd1 = qd1_4; qdd1 = qdd1_4; 
q2 = q2_4; qd2 = qd2_4; qdd2 = qdd2_4; 
q3 = q3_4; qd3 = qd3_4; qdd3 = qdd3_4; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada];

q1 = q1_5; qd1 = qd1_5; qdd1 = qdd1_5; 
q2 = q2_5; qd2 = qd2_5; qdd2 = qdd2_5; 
q3 = q3_5; qd3 = qd3_5; qdd3 = qdd3_5; 

gamma_sim_evaluada = eval(gamma_sim);

gamma_sim_ampliada = [gamma_sim_ampliada; gamma_sim_evaluada(1:1,:)];

%% Gamma y Thita reducidas desde simbolico
% ******** WARNING: WILL TAKE A BIG EFFORT AND TIME TO COMPUTE THIS *******
% ADVICE: COPY THIS CODE INTO COMMAND WINDOW AND RUN THEM THERE
tic
gamma_rref = rref(gamma_sim_ampliada);
toc

%% ***************** OBTENIDA CON SIMBOLICO ********************************
gamma_rref = [ 1, 2500, 0, 0, 0, 0,  1, -1, -900, 0,    0, 0, 0, 0,  1, -1
               0,    0, 1, 0, 0, 0,  0,  0,    0, 0,    0, 0, 0, 0,  0,  0
               0,    0, 0, 1, 0, 0,  0,  0,    0, 0,   l2, 0, 0, 0,  0,  0
               0,    0, 0, 0, 1, 0,  0,  1,  900, 0, l2^2, 0, 0, 0,  0,  0
               0,    0, 0, 0, 0, 1, -1,  1,  900, 0,    0, 0, 0, 0,  0,  0
               0,    0, 0, 0, 0, 0,  0,  0,    0, 1,    0, 0, 0, 0,  0,  0
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 1, 0, 0,  0,  0
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 0, 1, 0,  0,  1
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 0, 0, 1, -1,  1
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 0, 0, 0,  0,  0
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 0, 0, 0,  0,  0
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 0, 0, 0,  0,  0
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 0, 0, 0,  0,  0
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 0, 0, 0,  0,  0
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 0, 0, 0,  0,  0
               0,    0, 0, 0, 0, 0,  0,  0,    0, 0,    0, 0, 0, 0,  0,  0];

%           gamma_rref con todo en simbolico
%           [ 1, R1^2, 0, 0, 0, 0,  1, -1, -R2^2, 0,    0, 0, 0, 0,  1, -1]
%           [ 0,    0, 1, 0, 0, 0,  0,  0,     0, 0,    0, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 1, 0, 0,  0,  0,     0, 0,   l2, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 1, 0,  0,  1,  R2^2, 0, l2^2, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 1, -1,  1,  R2^2, 0,    0, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 1,    0, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 1, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 0, 1, 0,  0,  1]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 0, 0, 1, -1,  1]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 0, 0, 0,  0,  0]
%           [ 0,    0, 0, 0, 0, 0,  0,  0,     0, 0,    0, 0, 0, 0,  0,  0]
           
% thita_rref = gamma_rref*thita_sim

thita_reducida = [ Iyy1 + Iyy2 + Iyy3 - Izz2 - Izz3 + 2500*Jm1 - 900*Jm2
                                                                     Bm1
                                                           L2*m2 + l2*m3
                                      m2*L2^2 + m3*l2^2 + Izz2 + 900*Jm2
                                            Ixx2 - Iyy2 + Izz2 + 900*Jm2
                                                                     Bm2
                                                                   L3*m3
                                                          m3*L3^2 + Izz3
                                                      Ixx3 - Iyy3 + Izz3
                                                                     Jm3 
                                                                     Bm3];

thita_reducida = [...                               % con todo en simbolico
                   Jm1*R1^2 - Jm2*R2^2 + Iyy1 + Iyy2 + Iyy3 - Izz2 - Izz3
                                                                      Bm1
                                                            L2*m2 + l2*m3
                                      m2*L2^2 + Jm2*R2^2 + m3*l2^2 + Izz2
                                            Jm2*R2^2 + Ixx2 - Iyy2 + Izz2
                                                                      Bm2
                                                                    L3*m3
                                                           m3*L3^2 + Izz3
                                                       Ixx3 - Iyy3 + Izz3
                                                                      Jm3
                                                                      Bm3];

%% Comprobacion del resultado obtenido
Comprobacion = simplify(gamma_reducida*thita_reducida - Kt_Im_R)
