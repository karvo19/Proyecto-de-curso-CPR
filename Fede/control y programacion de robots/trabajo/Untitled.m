%% CALCULO BRAZO + MUÑECA
startup_rvc
syms q1 q2 q3 L0 L1 L2 L3 real;
pi1=sym('pi');
AU0=MDH(0, L0, 0, 0)
A01=MDH(q1, L1, 0, pi1/2)
A12=MDH(q2, 0, L2, 0)
A23=MDH(q3, 0, L3, 0)
%% CALCULO BRAZO
AU0=MDH(0, L0, 0, 0)
A01=MDH(q1, L1, 0, pi1/2)
A12=MDH(q2, 0, L2, 0)
A2f=MDH(q3, 0, L3, 0)
AUf=(AU0*A01*A12*A2f);
simplify (AUf)
%% CINEMATICA DIRECTA
syms x y z real;
eq1=x==cos(q1)*(L3*cos(q2+q3)+L2*cos(q2))
eq2=y==sin(q1)*(L3*cos(q2+q3)+L2*cos(q2))
eq3=z==L0+L1+L3*sin(q2+q3)+L2*sin(q2)
%% CINEMATICA INVERSA
syms nx ny nz ox oy oz ax ay az px py pz real;
AU0inv=inv(AU0);
A01inv=inv(A01);
%A12inv=inv(A12);
T=[nx ox ax px;ny oy ay py;nz oz az pz;0 0 0 1];
%simplify(A12inv*A01inv*AU0inv*T)
simplify(A01inv*AU0inv*T)
A12*A2f


eq4=L3*cos(q3)==pz*sin(q2) - L0*sin(q2) - L1*sin(q2) - L2 + px*cos(q1)*cos(q2) + py*cos(q2)*sin(q1)
eq5=L3*sin(q3)==pz*cos(q2) - L1*cos(q2) - L0*cos(q2) - px*cos(q1)*sin(q2) - py*sin(q1)*sin(q2)
eq6=0==px*sin(q1) - py*cos(q1)

eq7=L3==(L0*cos(q2) + L1*cos(q2) - pz*cos(q2) + px*cos(q1)*sin(q2) + py*sin(q1)*sin(q2))^2 + (L2 + L0*sin(q2) + L1*sin(q2) - pz*sin(q2) - px*cos(q1)*cos(q2) - py*cos(q2)*sin(q1))^2
solve(eq4,q2)