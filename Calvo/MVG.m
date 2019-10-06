%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                            %
%       ESTO ES UNA COPIA DE AÑO PASADO SIN MODIFICAR        %
%                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Limpiamos todas las variables para evitar errores
    clear

% Método a emplear para calcular M, V y G (descomentar el que proceda)
    NE_R3GDL
%     Lagrange


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

Ma=simplify(Ma)
Va=simplify(Va)
Ga=simplify(Ga)