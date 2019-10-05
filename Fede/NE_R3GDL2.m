% Ejemplo de la utilizaci�n del algoritmo de Newton Euler para la din�mica
% de un robot de 3 DGL
% M.G. Ortega (2017)

syms T1 T2 T3 q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g real  
PI = sym('pi');

% DATOS CINEM�TICOS DEL BRAZO DEL ROBOT
% Dimensiones (m)
  L1=0.4;  % Base
  L2=0.7;  % Esalb�n 1 
  L3=0.3;  % Esalb�n 1
  L4=0.5;  % Esalb�n 2
  L5=0.4;  % Esalb�n 3
  L6=0.2;  % Esalb�n 2
  
% Par�metros de Denavit-Hartenberg (utilizado en primera regla de Newton-Euler)
% Eslab�n base (no utilizado)
  theta0=0; d0=L1; a0=0; alpha0=0;
% Eslab�n 1:
  theta1=0; d1=q1+L2 ; a1= L3; alpha1=0 ;
% Eslab�n 2:
  theta2= q2; d2=0 ; a2= L4; alpha2=-PI/2;
% Eslab�n 3:
  theta3= -q3; d3= -L6; a3=L5 ; alpha3=0;
% Entre eslab�n 3 y marco donde se ejerce la fuerza (a definir seg�n
% experimento)
theta4= 0; d4=0 ; a4=0 ; alpha4=0 ; %%==0 significa que el marco donde aplicamos la fuerza es el mismo que el anterior

% DATOS DIN�MICOS DEL BRAZO DEL ROBOT
% Eslab�n 1
  m1= 4.2; % kg
  s11 = [-L3/2 , 0 ,-L2/2 ]'; % m (distancia del centro de masas de eslabon 1 con respecto al sistema 1)
  I11=[0.25 , 0 , 0 ;0 , 0.2 ,0 ; 0, 0, 0.15]; % kg.m2

% Eslab�n 2
  m2=4.0 ; % kg
  s22 = [ -L4/2 ,0  ,-L6/2 ]'; % m 
  I22=[ 0.35, 0 , 0 ; 0, 0.25 ,0 ;0 ,0 ,0.2 ]; % kg.m2

% Eslab�n 3
  m3= 3.8; % kg
  s33 = [-L5/2 , 0 , 0]'; % m
  I33=[ 0.06,  0, 0 ;0 ,0.05  ,0 ;0 ,0 , 0.07]; % kg.m2


% DATOS DE LOS MOTORES
% Inercias
  Jm1= 0.15; Jm2= 0.2; Jm3= 0.07; % kg.m2
% Coeficientes de fricci�n viscosa
  Bm1= 3.6e-5 ; Bm2= 3.6e-5; Bm3= 3.6e-5; % N.m / (rad/s)
% Factores de reducci�n
  R1= 25; R2=20 ; R3= 25;

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
   % w11= R10*(w00+Z*qd1);  % Si es de rotaci�n
   w11 = R10*w00;      % Si es de translaci�n
 % Articulaci�n 2
   w22= R21*(w11+Z*qd2);  % Si es de rotaci�n
   % w22 = R21*w11;      % Si es de translaci�n
 % Articulaci�n 3
   w33= R32*(w22+Z*qd3);  % Si es de rotaci�n
   % w33 = R32*w22;      % Si es de translaci�n

% N-E 5: Obtenci�n de las aceleraciones angulares absolutas
 % Articulaci�n 1
   % wd11 = R10*(wd00+Z*qdd1+cross(w00,Z*qd1));  % si es de rotaci�n
   wd11 = R10*wd00;                                % si es de translaci�n
 % Articulaci�n 2
   wd22 = R21*(wd11+Z*qdd2+cross(w11,Z*qd2));  % si es de rotaci�n
   % wd22 = R21*wd11;                                % si es de translaci�n
 % Articulaci�n 3
   wd33 = R32*(wd22+Z*qdd3+cross(w22,Z*qd3));  % si es de rotaci�n
   % wd33 = R32*wd22;                                % si es de translaci�n

% N-E 6: Obtenci�n de las aceleraciones lineales de los or�genes de los
% sistemas
 % Articulaci�n 1
   % vd11 = cross(wd11,p11)+cross(w11,cross(w11,p11))+R10*vd00;  % si es de rotaci�n
   vd11 = R10*(Z*qdd1+vd00)+cross(wd11,p11)+2*cross(w11,R10*Z*qd1) + cross(w11,cross(w11,p11));    % si es de translaci�n
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
  T1=simplify(F1z);
  % T1=N1z;
  % T2=F2z;
  T2=simplify(N2z);
  % T3=F3z;
  T3=simplify(N3z);

  
  %%%HASTA AQUI EL CODIGO QUE DAN EN EXAMEN
  
% traslacion apuntes
M11 = diff(T1,qdd1);
Taux= simplify(T1-M11*qdd1);
M12 = diff(Taux,qdd2);
Taux= simplify(Taux-M12*qdd2);
M13 = diff(Taux,qdd3);  
Taux= simplify(Taux-M13*qdd3);
G1=diff(Taux,g)*g;
Taux=simplify(Taux-G1);
V1=Taux;

M21 = diff(T2,qdd1);
Taux= simplify(T2-M21*qdd1);
M22 = diff(Taux,qdd2);
Taux= simplify(Taux-M22*qdd2);
M23 = diff(Taux,qdd3);
Taux= simplify(Taux-M23*qdd3);
G2=diff(Taux,g)*g;
Taux=simplify(Taux-G2);
V2=Taux;

M31 = diff(T3,qdd1);
Taux= simplify(T3-M13*qdd1);
M32 = diff(Taux,qdd2);
Taux= simplify(Taux-M32*qdd2);
M33 = diff(Taux,qdd3);
Taux= simplify(Taux-M33*qdd3);
G3=diff(Taux,g)*g;
Taux=simplify(Taux-G1);
V3=Taux;

%simplificar elementos
M11=simplify(M11);
M12=simplify(M12);
M13=simplify(M13);
M21=simplify(M21);
M22=simplify(M22);
M23=simplify(M23);
M31=simplify(M31);
M32=simplify(M32);
M33=simplify(M33);

G1=simplify(G1);
G2=simplify(G2);
G3=simplify(G3);

V1=simplify(V1);
V2=simplify(V2);
V3=simplify(V3);


M=[M11 M12 M13;M21 M22 M23; M31 M32 M33];
V=[V1;V2;V3];
G=[G1;G2;G3];


% vpa(M,5) %%evalua matriz (5 decimales)


%%reductora
R=diag([R1 R2 R3]);
Jm=diag([Jm1 Jm2 Jm3]);
Bm=diag([Bm1 Bm2 Bm3]);

%%matrices ampliadas
Ma=M+R*R*Jm
Va=V+R*R*Bm*[qd1;qd2;qd3]
Ga=G


%%continuar en RTB_robot_3GDL.m


