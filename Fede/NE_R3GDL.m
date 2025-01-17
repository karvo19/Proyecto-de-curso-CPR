% Ejemplo de la utilizaci�n del algoritmo de Newton Euler para la din�mica
% de un robot de 3 DGL
% M.G. Ortega (2017)
clear
syms T1 T2 T3 q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g m1 m2 m3 s11x s11y s11z s22x s22y s22z s33x s33y s33z I11x I11y I11z I22x I22y I22z I33x I33y I33z Jm1 Jm2 Jm3 Bm1 Bm2 Bm3 L1 L2 L3 l0 l1 l2 l3 R1 R2 R3 Kt1 Kt2 Kt3 real  
PI = sym('pi');
s11=[0, -s11y, 0]';
s22=[-s22x, 0, 0]';
s33=[-s33x, 0, 0]';
I11=[I11x, 0, 0; 0, I11y, 0; 0, 0, I11z];
I22=[I22x, 0, 0; 0, I22y, 0; 0, 0, I22z];
I33=[I33x, 0, 0; 0, I33y, 0; 0, 0, I33z];


% DATOS CINEM�TICOS DEL BRAZO DEL ROBOT
% Dimensiones (m)
%   L0=1.0;  % Base
%   L1=0.4;  % eslabon 1
%   L2=0.7;  % Esalb�n 2
%   L3=0.5;  % Esalb�n 3

  
% Par�metros de Denavit-Hartenberg (utilizado en primera regla de Newton-Euler)
% Eslab�n base (no utilizado)
  theta0=0; d0=l0; a0=0; alpha0=0;
% Eslab�n 1:
  theta1=q1; d1=l1 ; a1=0; alpha1=PI/2 ;
% Eslab�n 2:
  theta2= q2; d2=0 ; a2= l2; alpha2=0;
% Eslab�n 3:
  theta3= q3; d3= 0; a3=l3 ; alpha3=0;
% Entre eslab�n 3 y marco donde se ejerce la fuerza (a definir seg�n
% experimento)
theta4= 0; d4=0 ; a4=0 ; alpha4=0 ; %%==0 significa que el marco donde aplicamos la fuerza es el mismo que el anterior

% % DATOS DIN�MICOS DEL BRAZO DEL ROBOT
% % Eslab�n 1
%   m1= 4.2; % kg
%   s11 = [-L3/2 , 0 ,-L2/2 ]'; % m (distancia del centro de masas de eslabon 1 con respecto al sistema 1)
%   I11=[0.25 , 0 , 0 ;0 , 0.2 ,0 ; 0, 0, 0.15]; % kg.m2
% 
% % Eslab�n 2
%   m2=4.0 ; % kg
%   s22 = [ -L4/2 ,0  ,-L6/2 ]'; % m 
%   I22=[ 0.35, 0 , 0 ; 0, 0.25 ,0 ;0 ,0 ,0.2 ]; % kg.m2
% 
% % Eslab�n 3
%   m3= 3.8; % kg
%   s33 = [-L5/2 , 0 , 0]'; % m
%   I33=[ 0.06,  0, 0 ;0 ,0.05  ,0 ;0 ,0 , 0.07]; % kg.m2


% % DATOS DE LOS MOTORES
% % Inercias
%   Jm1= 0.15; Jm2= 0.2; Jm3= 0.07; % kg.m2
% % Coeficientes de fricci�n viscosa
%   Bm1= 3.6e-5 ; Bm2= 3.6e-5; Bm3= 3.6e-5; % N.m / (rad/s)
% Factores de reducci�n
% R1= 50; R2=30; R3= 15;

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
   %w11 = R10*w00;      % Si es de translaci�n
 % Articulaci�n 2
   w22= R21*(w11+Z*qd2);  % Si es de rotaci�n
   % w22 = R21*w11;      % Si es de translaci�n
 % Articulaci�n 3
   w33= R32*(w22+Z*qd3);  % Si es de rotaci�n
   % w33 = R32*w22;      % Si es de translaci�n

% N-E 5: Obtenci�n de las aceleraciones angulares absolutas
 % Articulaci�n 1
    wd11 = R10*(wd00+Z*qdd1+cross(w00,Z*qd1));  % si es de rotaci�n
   %wd11 = R10*wd00;                                % si es de translaci�n
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
  %T1=simplify(F1z);
  T1=simplify(N1z);
  % T2=F2z;
  T2=simplify(N2z);
  % T3=F3z;
  T3=simplify(N3z);

  
  T1f=T1;T2f=T2;T3f=T3;
  
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
Ma=M+R*R*Jm;
Va=V+R*R*Bm*[qd1;qd2;qd3];
Ga=G;

T_comp = simplify( Ma * [qdd1 qdd2 qdd3]' + Va + Ga);
T1=(T_comp(1));
T2=(T_comp(2));
T3=(T_comp(3));


%%continuar en RTB_robot_3GDL.m

%% ---
T_comp=subs(T_comp,s11y,l1-L1);
T_comp=subs(T_comp,s22x,l2-L2);
T_comp=subs(T_comp,s33x,l3-L3);
T1=(T_comp(1));
T2=(T_comp(2));
T3=(T_comp(3));

%%estimacion parametros%%

%k1=0.5;k2=0.4;k3=0.35;
Thet=[I11x, I11y, I11z, I22x, I22y, I22z, I33x, I33y, I33z, Jm1, Jm2, Jm3, Bm1, Bm2, Bm3, m1*L1^2, m2*L2^2, m3*L3^2, m1*L1, m2*L2, m3*L3, m1, m2, m3]; 
%T1
%inercias
Mat101=diff(T1,I11x);
Mat102=diff(T1,I11y);
Mat103=diff(T1,I11z);
Mat104=diff(T1,I22x);
Mat105=diff(T1,I22y);
Mat106=diff(T1,I22z);
Mat107=diff(T1,I33x);
Mat108=diff(T1,I33y);
Mat109=diff(T1,I33z);

%JyB
Mat110=diff(T1,Jm1);
Mat111=diff(T1,Jm2);
Mat112=diff(T1,Jm3);

Mat113=diff(T1,Bm1);
Mat114=diff(T1,Bm2);
Mat115=diff(T1,Bm3);

%masas %diff(T1,m1) y seleccionar terminos con s11y^2...
Mat116=diff(diff(T1,L1,2)/2,m1);
Mat117=diff(diff(T1,L2,2)/2,m2);
Mat118=diff(diff(T1,L3,2)/2,m3);

Maux=simplify(T1-Mat116*m1*L1^2);
Mat119=diff(diff(Maux,L1),m1);
Maux=simplify(Maux-Mat117*m2*L2^2);
Mat120=diff(diff(Maux,L2),m2);
Maux=simplify(Maux-Mat118*m3*L3^2);
Mat121=diff(diff(Maux,L3),m3);

Maux=simplify(Maux-Mat119*m1*L1);
Mat122=diff(Maux,m1);
Maux=simplify(Maux-Mat120*m2*L2);
Mat123=diff(Maux,m2);
Maux=simplify(Maux-Mat121*m3*L3);
Mat124=diff(Maux,m3);

%T2
%inercias
Mat201=diff(T2,I11x);
Mat202=diff(T2,I11y);
Mat203=diff(T2,I11z);
Mat204=diff(T2,I22x);
Mat205=diff(T2,I22y);
Mat206=diff(T2,I22z);
Mat207=diff(T2,I33x);
Mat208=diff(T2,I33y);
Mat209=diff(T2,I33z);

%JyB
Mat210=diff(T2,Jm1);
Mat211=diff(T2,Jm2);
Mat212=diff(T2,Jm3);

Mat213=diff(T2,Bm1);
Mat214=diff(T2,Bm2);
Mat215=diff(T2,Bm3);

%masas
Mat216=diff(diff(T2,L1,2)/2,m1);
Mat217=diff(diff(T2,L2,2)/2,m2);
Mat218=diff(diff(T2,L3,2)/2,m3);

Maux=simplify(T2-Mat216*m1*L1^2);
Mat219=diff(diff(Maux,L1),m1);
Maux=simplify(Maux-Mat217*m2*L2^2);
Mat220=diff(diff(Maux,L2),m2);
Maux=simplify(Maux-Mat218*m3*L3^2);
Mat221=diff(diff(Maux,L3),m3);

Maux=simplify(Maux-Mat219*m1*L1);
Mat222=diff(Maux,m1);
Maux=simplify(Maux-Mat220*m2*L2);
Mat223=diff(Maux,m2);
Maux=simplify(Maux-Mat221*m3*L3);
Mat224=diff(Maux,m3);

%T3
%inercias
Mat301=diff(T3,I11x);
Mat302=diff(T3,I11y);
Mat303=diff(T3,I11z);
Mat304=diff(T3,I22x);
Mat305=diff(T3,I22y);
Mat306=diff(T3,I22z);
Mat307=diff(T3,I33x);
Mat308=diff(T3,I33y);
Mat309=diff(T3,I33z);

%JyB
Mat310=diff(T3,Jm1);
Mat311=diff(T3,Jm2);
Mat312=diff(T3,Jm3);

Mat313=diff(T3,Bm1);
Mat314=diff(T3,Bm2);
Mat315=diff(T3,Bm3);

%masas
Mat316=diff(diff(T3,L1,2)/2,m1);
Mat317=diff(diff(T3,L2,2)/2,m2);
Mat318=diff(diff(T3,L3,2)/2,m3);

Maux=simplify(T3-Mat316*m1*L1^2);
Mat319=diff(diff(Maux,L1),m1);
Maux=simplify(Maux-Mat317*m2*L2^2);
Mat320=diff(diff(Maux,L2),m2);
Maux=simplify(Maux-Mat318*m3*L3^2);
Mat321=diff(diff(Maux,L3),m3);

Maux=simplify(Maux-Mat319*m1*L1);
Mat322=diff(Maux,m1);
Maux=simplify(Maux-Mat320*m2*L2);
Mat323=diff(Maux,m2);
Maux=simplify(Maux-Mat321*m3*L3);
Mat324=diff(Maux,m3);

Mat=[Mat101,Mat102,Mat103,Mat104,Mat105,Mat106,Mat107,Mat108,Mat109,Mat110,Mat111,Mat112,Mat113,Mat114,Mat115,Mat116,Mat117,Mat118,Mat119,Mat120,Mat121,Mat122,Mat123,Mat124;...
     Mat201,Mat202,Mat203,Mat204,Mat205,Mat206,Mat207,Mat208,Mat209,Mat210,Mat211,Mat212,Mat213,Mat214,Mat215,Mat216,Mat217,Mat218,Mat219,Mat220,Mat221,Mat222,Mat223,Mat224;...
     Mat301,Mat302,Mat303,Mat304,Mat305,Mat306,Mat307,Mat308,Mat309,Mat310,Mat311,Mat312,Mat313,Mat314,Mat315,Mat316,Mat317,Mat318,Mat319,Mat320,Mat321,Mat322,Mat323,Mat324];
    
 Mat=simplify(Mat);
 %% ----
 
 
  l0=1.0;  % Base
  l1=0.4;  % eslabon 1
  l2=0.7;  % Esalb�n 2
  l3=0.5;  % Esalb�n 3
 
  R1= 50; R2=30; R3= 15;
 

% % Para colind
% 
% 
% 
% Mat1=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat1=eval(Mat1); 
% 
% Mat2=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat2=eval(Mat2); 
% 
% Mat3=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat3=eval(Mat3); 
% 
% Mat4=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat4=eval(Mat4); 
% 
% Mat5=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat5=eval(Mat5); 
% 
% Mat6=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat6=eval(Mat6); 
% 
% Mat7=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat7=eval(Mat7); 
% 
% Mat8=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat8=eval(Mat8); 
% 
% Mat9=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat9=eval(Mat9); 
% 
% Mat10=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat10=eval(Mat10); 
% 
% Mat11=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat11=eval(Mat11); 
% 
% Mat12=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat12=eval(Mat12); 
% 
% Mat13=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat13=eval(Mat13); 
% 
% Mat14=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat14=eval(Mat14); 
% 
% Mat15=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat15=eval(Mat15); 
% 
% Mat16=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat16=eval(Mat16); 
% 
% Mat17=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat17=eval(Mat17); 
% 
% Mat18=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat18=eval(Mat18); 
% 
% Mat19=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat19=eval(Mat19); 
% 
% Mat20=Mat;
% s11y=rand;
% s22x=rand;
% s33x=rand;
% q1=rand;
% q2=rand;
% q3=rand;
% qd1=rand;
% qd2=rand;
% qd3=rand;
% qdd1=rand;
% qdd2=rand;
% qdd3=rand;
% g=9.8;
% Mat20=eval(Mat20); 
%  
% Mcuad=vpa([Mat1;Mat2;Mat3;Mat4;Mat5;Mat6;Mat7;Mat8;Mat9;Mat10;Mat11;Mat12;Mat13;Mat14;Mat15;Mat16;Mat17;Mat18;Mat19;Mat20]);
% Mcuad=double(Mcuad);
% [AA,colind]=rref(Mcuad);
% 
% % ThetRed=[I11y + 2500*Jm1, I22x - I22y - (m2*s22x^2)/2, I22z + Jm2, I33x - I33y - (m3*s33x^2)/2, I33z + (m3*s33x^2)/2, Jm3, Bm1, Bm2, Bm3, m2*s22x, m3*s33x, m2, m3]; 
% % 
% % MatRed=[Mat102,Mat104,Mat106,Mat107,Mat109,Mat112,Mat113,Mat114,Mat115,Mat120,Mat121,Mat123,Mat124;...
% %         Mat202,Mat204,Mat206,Mat207,Mat209,Mat212,Mat213,Mat214,Mat215,Mat220,Mat221,Mat223,Mat224;...
% %         Mat302,Mat304,Mat306,Mat307,Mat309,Mat312,Mat313,Mat314,Mat315,Mat320,Mat321,Mat323,Mat324];
% %  






 %para AA
syms q1_1 q1_2 q1_3 q1_4 q1_5 q1_6 q1_7 q1_8;
syms qd1_1 qd1_2 qd1_3 qd1_4 qd1_5 qd1_6 qd1_7 qd1_8;
syms qdd1_1 qdd1_2 qdd1_3 qdd1_4 qdd1_5 qdd1_6 qdd1_7 qdd1_8;
syms q2_1 q2_2 q2_3 q2_4 q2_5 q2_6 q2_7 q2_8;
syms qd2_1 qd2_2 qd2_3 qd2_4 qd2_5 qd2_6 qd2_7 qd2_8;
syms qdd2_1 qdd2_2 qdd2_3 qdd2_4 qdd2_5 qdd2_6 qdd2_7 qdd2_8;
syms q3_1 q3_2 q3_3 q3_4 q3_5 q3_6 q3_7 q3_8;
syms qd3_1 qd3_2 qd3_3 qd3_4 qd3_5 qd3_6 qd3_7 qd3_8;
syms qdd3_1 qdd3_2 qdd3_3 qdd3_4 qdd3_5 qdd3_6 qdd3_7 qdd3_8;

Mat=[Mat102,Mat104,Mat105,Mat106,Mat107,Mat108,Mat109,Mat110,Mat111,Mat113,Mat114,Mat117,Mat118,Mat120,Mat121,Mat123,Mat124;...
     Mat202,Mat204,Mat205,Mat206,Mat207,Mat208,Mat209,Mat210,Mat211,Mat213,Mat214,Mat217,Mat218,Mat220,Mat221,Mat223,Mat224;...
     Mat302,Mat304,Mat305,Mat306,Mat307,Mat308,Mat309,Mat310,Mat311,Mat313,Mat314,Mat317,Mat318,Mat320,Mat321,Mat323,Mat324];
Thet=[I11y, I22x, I22y, I22z, I33x, I33y, I33z, Jm1, Jm2, Bm1, Bm2, m2*L2^2, m3*L3^2, m2*L2, m3*L3, m2, m3]; 


Mat1=Mat;
q1=q1_1;q2=q2_1;q3=q3_1;qd1=qd1_1;qd2=qd2_1;qd3=qd3_1;qdd1=qdd1_1;qdd2=qdd2_1;qdd3=qdd3_1;
g=9.8;
Mat1=eval(Mat1);

Mat2=Mat;
q1=q1_2;q2=q2_2;q3=q3_2;qd1=qd1_2;qd2=qd2_2;qd3=qd3_2;qdd1=qdd1_2;qdd2=qdd2_2;qdd3=qdd3_2;
g=9.8;
Mat2=eval(Mat2);

Mat3=Mat;
q1=q1_3;q2=q2_3;q3=q3_3;qd1=qd1_3;qd2=qd2_3;qd3=qd3_3;qdd1=qdd1_3;qdd2=qdd2_3;qdd3=qdd3_3;
g=9.8;
Mat3=eval(Mat3);

Mat4=Mat;
q1=q1_4;q2=q2_4;q3=q3_4;qd1=qd1_4;qd2=qd2_4;qd3=qd3_4;qdd1=qdd1_4;qdd2=qdd2_4;qdd3=qdd3_4;
g=9.8;
Mat4=eval(Mat4);

Mat5=Mat;
q1=q1_5;q2=q2_5;q3=q3_5;qd1=qd1_5;qd2=qd2_5;qd3=qd3_5;qdd1=qdd1_5;qdd2=qdd2_5;qdd3=qdd3_5;
g=9.8;
Mat5=eval(Mat5);

Mat6=Mat;
q1=q1_6;q2=q2_6;q3=q3_6;qd1=qd1_6;qd2=qd2_6;qd3=qd3_6;qdd1=qdd1_6;qdd2=qdd2_6;qdd3=qdd3_6;
g=9.8;
Mat6=eval(Mat6);

Mat7=Mat;
q1=q1_7;q2=q2_7;q3=q3_7;qd1=qd1_7;qd2=qd2_7;qd3=qd3_7;qdd1=qdd1_7;qdd2=qdd2_7;qdd3=qdd3_7;
g=9.8;
Mat7=eval(Mat7);

Mat8=Mat;
q1=q1_8;q2=q2_8;q3=q3_8;qd1=qd1_8;qd2=qd2_8;qd3=qd3_8;qdd1=qdd1_8;qdd2=qdd2_8;qdd3=qdd3_8;
g=9.8;
Mat8=eval(Mat8); 

Mcuad=vpa([Mat1;Mat2;Mat3;Mat4;Mat5;Mat6([1 2], :)]);
[AA]=rref(Mcuad);
Thetminsim=AA*Thet'

Thet_red= [1.0*m2*L2^2 + 1.0*m3*L3^2 + I11y + 1.0*I22y + 1.0*I33y + 2500.0*Jm1 + 0.49*m3,...
    - 1.0*m2*L2^2 + I22x - 1.0*I22y - 0.49*m3,...
    1.0*m2*L2^2 + I22z + 900.0*Jm2 + 0.49*m3,...
    - 1.0*m3*L3^2 + I33x - 1.0*I33y,...
    1.0*m3*L3^2 + I33z,...
    Jm3,...
    Bm1,...
    Bm2,...
    Bm3,...
    0.7*m3 + L2*m2,...
    L3*m3];


Mat_red=[Mat102,Mat104,Mat106,Mat107,Mat109,Mat112,Mat113,Mat114,Mat115,Mat120,Mat121;...
     Mat202,Mat204,Mat206,Mat207,Mat209,Mat212,Mat213,Mat214,Mat215,Mat220,Mat221;...
     Mat302,Mat304,Mat306,Mat307,Mat309,Mat312,Mat313,Mat314,Mat315,Mat320,Mat321];

