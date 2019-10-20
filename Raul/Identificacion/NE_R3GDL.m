% Ejemplo de la utilización del algoritmo de Newton Euler para la dinámica
% de un robot de 3 DGL
% M.G. Ortega (2017)
clear
% clc

syms L1 L2 L3 l0 l1 l2 l3 T1 T2 T3 q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g real 
syms m1 Ixx1 Iyy1 Izz1 sy1 real
syms m2 Ixx2 Iyy2 Izz2 sx2 real
syms m3 Ixx3 Iyy3 Izz3 sx3 real
syms Jm1 Jm2 Jm3 Bm1 Bm2 Bm3 R1 R2 R3 Kt1 Kt2 Kt3 real

PI = sym('pi');

% DATOS CINEMÁTICOS DEL BRAZO DEL ROBOT
% Dimensiones (m)
%   L0=;  % Base
%   L1=;  % Esalbón 1 
%   L2=;  % Esalbón 2
%   L3=;  % Esalbón 3
  
% Parámetros de Denavit-Hartenberg (utilizado en primera regla de Newton-Euler)
% Eslabón base (no utilizado)
  theta0=0; d0=l0; a0=0; alpha0=0;
% Eslabón 1:
  theta1=q1; d1=l1 ; a1=0 ; alpha1=PI/2 ;
% Eslabón 2:
  theta2= q2; d2=0 ; a2= l2; alpha2= 0;
% Eslabón 3:
  theta3= q3; d3= 0; a3=l3 ; alpha3=0 ;
% Entre eslabón 3 y marco donde se ejerce la fuerza (a definir según
% experimento)
  theta4= 0; d4=0 ; a4=0 ; alpha4= 0;

% DATOS DINÁMICOS DEL BRAZO DEL ROBOT
% Eslabón 1
%   m1= ; % kg
  s11 = [0 ,  -sy1,0 ]'; % m
  I11=[ Ixx1,0  , 0 ; 0 ,  Iyy1, 0; 0,0 ,Izz1 ]; % kg.m2

% Eslabón 2
%   m2= ; % kg
  s22 = [ -sx2, 0 , 0]'; % m
  I22=[ Ixx2,0  , 0 ; 0 ,  Iyy2, 0; 0,0 ,Izz2 ]; % kg.m2
% Eslabón 3
%   m3= ; % kg
  s33 = [-sx3 , 0 , 0]'; % m
  I33=[ Ixx3,0  , 0 ; 0 ,  Iyy3, 0; 0,0 ,Izz3 ]; % kg.m2

% DATOS DE LOS MOTORES
% Inercias
%   Jm1= ; Jm2=; Jm3=; % kg.m2
% % Coeficientes de fricción viscosa
%   Bm1= ; Bm2= ; Bm3= ; % N.m / (rad/s)
% % Factores de reducción
%   R1= ; R2= ; R3= ;

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
  
  %
  T1=simplify(T1);
  T2=simplify(T2);
  T3=simplify(T3);
  
  % Reescribir en forma matricial
  M11=diff(T1,qdd1);
  Taux=simplify(T1-M11*qdd1);
  M12=diff(Taux,qdd2);
  Taux=simplify(Taux-M12*qdd2);
  M13=diff(Taux,qdd3);
  Taux=simplify(Taux-M13*qdd3); 
  
  G1=diff(Taux,g)*g;
  Taux=simplify(Taux-G1);
  V1=Taux;
  
  
  M21=diff(T2,qdd1);
  Taux=simplify(T2-M21*qdd1);
  M22=diff(Taux,qdd2);
  Taux=simplify(Taux-M22*qdd2);
  M23=diff(Taux,qdd3);
  Taux=simplify(Taux-M23*qdd3); 
  
  G2=diff(Taux,g)*g;
  Taux=simplify(Taux-G2);
  V2=Taux;

  
  M31=diff(T3,qdd1);
  Taux=simplify(T3-M31*qdd1);
  M32=diff(Taux,qdd2);
  Taux=simplify(Taux-M32*qdd2);
  M33=diff(Taux,qdd3);
  Taux=simplify(Taux-M33*qdd3); 
  
  G3=diff(Taux,g)*g;
  Taux=simplify(Taux-G3);
  V3=Taux;
  
  
  M=[M11 M12 M13;M21 M22 M23;M31 M32 M33];
  
  %Matrices ampliadas
  
  R=diag([R1 R2 R3]);
  Jm=diag([Jm1 Jm2 Jm3]);
  Bm=diag([Bm1 Bm2 Bm3]);
    
  
  Ma=simplify(M+R*R*Jm);
  Va=simplify([V1 V2 V3]'+R*R*Bm*[qd1 qd2 qd3]');
  Ga=simplify([G1 G2 G3]');

% Reescribir ecuaciones lineales con los parámetros

Ta=Ma*[qdd1 qdd2 qdd3]'+Va+Ga;
Ta=subs(Ta,sy1,l1-L1);
Ta=subs(Ta,sx2,l2-L2);
Ta=subs(Ta,sx3,l3-L3);

Ta1=simplify(Ta(1));
Ta2=simplify(Ta(2));
Ta3=simplify(Ta(3));
%%

phi11=diff(Ta1,Ixx1);
Taux=Ta1-phi11*Ixx1;

phi12=diff(Taux,Ixx2);
Taux=Taux-phi12*Ixx2;

phi13=diff(Taux,Ixx3);
Taux=Taux-phi13*Ixx3;

phi14=diff(Taux,Iyy1);
Taux=Taux-phi14*Iyy1;

phi15=diff(Taux,Iyy2);
Taux=Taux-phi15*Iyy2;

phi16=diff(Taux,Iyy3);
Taux=Taux-phi16*Iyy3;

phi17=diff(Taux,Izz1);
Taux=Taux-phi17*Izz1;

phi18=diff(Taux,Izz2);
Taux=Taux-phi18*Izz2;

phi19=diff(Taux,Izz3);
Taux=Taux-phi19*Izz3;

phi110=diff(Taux,Jm1);
Taux=Taux-phi110*Jm1;

phi111=diff(Taux,Jm2);
Taux=Taux-phi111*Jm2;

phi112=diff(Taux,Jm3);
Taux=Taux-phi112*Jm3;

phi113=diff(Taux,Bm1);
Taux=Taux-phi113*Bm1;

phi114=diff(Taux,Bm2);
Taux=Taux-phi114*Bm2;

phi115=diff(Taux,Bm3);
Taux=Taux-phi115*Bm3;

phi116=diff(diff(Taux,L1,2),m1)/2;
Taux=Taux-phi116*L1^2*m1;

phi117=diff(diff(Taux,L2,2),m2)/2;
Taux=Taux-phi117*L2^2*m2;

phi118=diff(diff(Taux,L3,2),m3)/2;
Taux=Taux-phi118*L3^2*m3;

phi119=diff(diff(Taux,L1),m1);
Taux=Taux-phi119*m1*L1;

phi120=diff(diff(Taux,L2),m2);
Taux=Taux-phi120*m2*L2;

phi121=diff(diff(Taux,L3),m3);
Taux=Taux-phi121*m3*L3;

phi122=diff(Taux,m1);
Taux=Taux-phi122*m1;

phi123=diff(Taux,m2);
Taux=Taux-phi123*m2;

phi124=diff(Taux,m3);
Taux=Taux-phi124*m3;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phi21=diff(Ta2,Ixx1);
Taux=Ta2-phi21*Ixx1;

phi22=diff(Taux,Ixx2);
Taux=Taux-phi22*Ixx2;

phi23=diff(Taux,Ixx3);
Taux=Taux-phi23*Ixx3;

phi24=diff(Taux,Iyy1);
Taux=Taux-phi24*Iyy1;

phi25=diff(Taux,Iyy2);
Taux=Taux-phi25*Iyy2;

phi26=diff(Taux,Iyy3);
Taux=Taux-phi26*Iyy3;

phi27=diff(Taux,Izz1);
Taux=Taux-phi27*Izz1;

phi28=diff(Taux,Izz2);
Taux=Taux-phi28*Izz2;

phi29=diff(Taux,Izz3);
Taux=Taux-phi29*Izz3;

phi210=diff(Taux,Jm1);
Taux=Taux-phi210*Jm1;

phi211=diff(Taux,Jm2);
Taux=Taux-phi211*Jm2;

phi212=diff(Taux,Jm3);
Taux=Taux-phi212*Jm3;

phi213=diff(Taux,Bm1);
Taux=Taux-phi213*Bm1;

phi214=diff(Taux,Bm2);
Taux=Taux-phi214*Bm2;

phi215=diff(Taux,Bm3);
Taux=Taux-phi215*Bm3;

phi216=diff(diff(Taux,L1,2),m1)/2;
Taux=Taux-phi216*L1^2*m1;

phi217=diff(diff(Taux,L2,2),m2)/2;
Taux=Taux-phi217*L2^2*m2;

phi218=diff(diff(Taux,L3,2),m3)/2;
Taux=Taux-phi218*L3^2*m3;

phi219=diff(diff(Taux,L1),m1);
Taux=Taux-phi219*m1*L1;

phi220=diff(diff(Taux,L2),m2);
Taux=Taux-phi220*m2*L2;

phi221=diff(diff(Taux,L3),m3);
Taux=Taux-phi221*m3*L3;

phi222=diff(Taux,m1);
Taux=Taux-phi222*m1;

phi223=diff(Taux,m2);
Taux=Taux-phi223*m2;

phi224=diff(Taux,m3);
Taux=Taux-phi224*m3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


phi31=diff(Ta3,Ixx1);
Taux=Ta3-phi31*Ixx1;

phi32=diff(Taux,Ixx2);
Taux=Taux-phi32*Ixx2;

phi33=diff(Taux,Ixx3);
Taux=Taux-phi33*Ixx3;

phi34=diff(Taux,Iyy1);
Taux=Taux-phi34*Iyy1;

phi35=diff(Taux,Iyy2);
Taux=Taux-phi35*Iyy2;

phi36=diff(Taux,Iyy3);
Taux=Taux-phi36*Iyy3;

phi37=diff(Taux,Izz1);
Taux=Taux-phi37*Izz1;

phi38=diff(Taux,Izz2);
Taux=Taux-phi38*Izz2;

phi39=diff(Taux,Izz3);
Taux=Taux-phi39*Izz3;

phi310=diff(Taux,Jm1);
Taux=Taux-phi310*Jm1;

phi311=diff(Taux,Jm2);
Taux=Taux-phi311*Jm2;

phi312=diff(Taux,Jm3);
Taux=Taux-phi312*Jm3;

phi313=diff(Taux,Bm1);
Taux=Taux-phi313*Bm1;

phi314=diff(Taux,Bm2);
Taux=Taux-phi314*Bm2;

phi315=diff(Taux,Bm3);
Taux=Taux-phi315*Bm3;

phi316=diff(diff(Taux,L1,2),m1)/2;
Taux=Taux-phi316*L1^2*m1;

phi317=diff(diff(Taux,L2,2),m2)/2;
Taux=Taux-phi317*L2^2*m2;

phi318=diff(diff(Taux,L3,2),m3)/2;
Taux=Taux-phi318*L3^2*m3;

phi319=diff(diff(Taux,L1),m1);
Taux=Taux-phi319*m1*L1;

phi320=diff(diff(Taux,L2),m2);
Taux=Taux-phi320*m2*L2;

phi321=diff(diff(Taux,L3),m3);
Taux=Taux-phi321*m3*L3;

phi322=diff(Taux,m1);
Taux=Taux-phi322*m1;

phi323=diff(Taux,m2);
Taux=Taux-phi323*m2;

phi324=diff(Taux,m3);
Taux=Taux-phi324*m3;



%%%%%%%%%%%%%%%%

PHI=simplify([
    phi11 phi12 phi13 phi14 phi15 phi16 phi17 phi18 phi19 phi110 phi111 phi112 phi113 phi114 phi115 phi116 phi117 phi118 phi119 phi120 phi121 phi122 phi123 phi124
    phi21 phi22 phi23 phi24 phi25 phi26 phi27 phi28 phi29 phi210 phi211 phi212 phi213 phi214 phi215 phi216 phi217 phi218 phi219 phi220 phi221 phi222 phi223 phi224
    phi31 phi32 phi33 phi34 phi35 phi36 phi37 phi38 phi39 phi310 phi311 phi312 phi313 phi314 phi315 phi316 phi317 phi318 phi319 phi320 phi321 phi322 phi323 phi324]);
    
theta=[Ixx1 Ixx2 Ixx3 Iyy1 Iyy2 Iyy3 Izz1 Izz2 Izz3 Jm1 Jm2 Jm3 Bm1 Bm2 Bm3 m1*L1^2 m2*L2^2 m3*L3^2 m1*L1 m2*L2 m3*L3 m1 m2 m3]';

simplify(PHI*theta-[Ta1 Ta2 Ta3]')

% para comparar
phi1=[PHI(:,22) PHI(:,19) PHI(:,16) PHI(:,1) PHI(:,4) PHI(:,7) PHI(:,10) PHI(:,13) PHI(:,23) PHI(:,20) PHI(:,17) PHI(:,2) PHI(:,5) PHI(:,8) PHI(:,11) PHI(:,14) PHI(:,24) PHI(:,21) PHI(:,18) PHI(:,3) PHI(:,6) PHI(:,9) PHI(:,12) PHI(:,15)];

        
%% Simbólico - Base reducida

t=[Ixx1 Ixx2 Ixx3 Iyy1 Iyy2 Iyy3 Izz1 Izz2 Izz3 Jm1 Jm2 Jm3 Bm1 Bm2 Bm3 m1*L1^2 m2*L2^2 m3*L3^2 m1*L1 m2*L2 m3*L3 m1 m2 m3]';
t_red=[
    t(2)-t(5)-t(17)-l2^2*t(24)
    t(3)-t(6)-t(18)
    t(4)+t(5)+t(6)+R1^2*t(10)+t(17)+t(18)+l2^2*t(24)
    t(8)+R2^2*t(11)+t(17)+l2^2*t(24)
    t(9)+t(18)
    t(12)
    t(13)
    t(14)
    t(15)
    t(20)+l2*t(24)
    t(21)]

phi_red=[PHI(:,2) PHI(:,3) PHI(:,4) PHI(:,8) PHI(:,9) PHI(:,12) PHI(:,13) PHI(:,14) PHI(:,15) PHI(:,20) PHI(:,21)]

Tau=simplify(phi_red*t_red);
T1=Tau(1);
T2=Tau(2);
T3=Tau(3);

  % Reescribir en forma matricial
  M11=diff(T1,qdd1);
  Taux=simplify(T1-M11*qdd1);
  M12=diff(Taux,qdd2);
  Taux=simplify(Taux-M12*qdd2);
  M13=diff(Taux,qdd3);
  Taux=simplify(Taux-M13*qdd3); 
  
  G1=diff(Taux,g)*g;
  Taux=simplify(Taux-G1);
  V1=Taux;
  
  
  M21=diff(T2,qdd1);
  Taux=simplify(T2-M21*qdd1);
  M22=diff(Taux,qdd2);
  Taux=simplify(Taux-M22*qdd2);
  M23=diff(Taux,qdd3);
  Taux=simplify(Taux-M23*qdd3); 
  
  G2=diff(Taux,g)*g;
  Taux=simplify(Taux-G2);
  V2=Taux;

  
  M31=diff(T3,qdd1);
  Taux=simplify(T3-M31*qdd1);
  M32=diff(Taux,qdd2);
  Taux=simplify(Taux-M32*qdd2);
  M33=diff(Taux,qdd3);
  Taux=simplify(Taux-M33*qdd3); 
  
  G3=diff(Taux,g)*g;
  Taux=simplify(Taux-G3);
  V3=Taux;
  
  
  M=[M11 M12 M13;M21 M22 M23;M31 M32 M33];






























