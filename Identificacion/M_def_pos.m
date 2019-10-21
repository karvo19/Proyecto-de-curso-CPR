 % Comprobar que M es definida positiva

 % Parámetros base estimados:
t_red=[
   -1.7594
   -0.3966
    8.3284
   16.0353
    0.3977
    0.0072
    0.0120
    0.0085
    0.0150
    2.9131
    0.9710
];
%                    probar load/save theta 

% Datos geométricos / gravedad / reductoras / constantes de par
l0 = 1.00;
l1 = 0.40;
l2 = 0.70;
l3 = 0.50;

g=9.81;

R1=50;
R2=30;
R3=15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=0;
flag=0;
while (i < 10000 & flag==0)
q1        = rand;
q2        = rand;
q3        = rand;

% Modelo en forma matricial (M, V, G)
M11=[t_red(3)+t_red(11)*l2*(cos(2*q2+q3)+cos(q3))+1/2*(t_red(1)+t_red(2)-t_red(1)*cos(2*q2)-t_red(2)*cos(2*q2+2*q3))];
M12=0;
M13=0;
M21=M12;
M22=[t_red(4)+t_red(5)+2*l2*t_red(11)*cos(q3)];
M23=[t_red(5)+l2*t_red(11)*cos(q3)];
M31=M13;
M32=M23;
M33=[t_red(5)+R3^2*t_red(6)];

M=[M11 M12 M13
    M21 M22 M23
    M31 M32 M33];

if det(M)>=0
    flag=0;
else flag=1;
end
i=i+1;
end

if flag==1
    display('La matriz M no es definida positiva');
    
end

