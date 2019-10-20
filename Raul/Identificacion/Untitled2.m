%%
clear
clc

A=[
    1   0   -1
    0   0   0
    0   1   1];

[B C]=rref(A)

[m n]=size(B);

B_red=[];
for i=1:n
    if i~=find(all(B==0))
        B_red=[B_red B(:,i)]
    end
end



%% 
clear
clc

syms L1 L2 L3 l0 l1 l2 l3 T1 T2 T3 q1 qd1 qdd1 q2 qd2 qdd2 q3 qd3 qdd3 g real 
syms m1 Ixx1 Iyy1 Izz1 sy1 real
syms m2 Ixx2 Iyy2 Izz2 sx2 real
syms m3 Ixx3 Iyy3 Izz3 sx3 real
syms Jm1 Jm2 Jm3 Bm1 Bm2 Bm3 R1 R2 R3 Kt1 Kt2 Kt3 real
syms l1 real



phi=[
    qdd1 g*cos(q1) l1^2*qdd1 + l1*g*cos(q1)
    0   0   0]
theta=[
    Izz1+m1*L1^2
    m1*L1
    m2]


% 
% phi(:,1:2)
% 
%  A=simplify(rref(phi))
% 
% phi(:,1:2)*A(:,3)
% 










