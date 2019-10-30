<<<<<<< HEAD
 % Excitacion
% A_a=[1  3   0.5];
% A_b=[1.5  1   0.3]*1;
% w_a=[1  1  0.6]*0.5;
% w_b=[1  1  0.4]*2.5;
% Icc=[0  2  1.5];
% A_a=[0.15  4   0.35];
% A_b=[0.2  5   0.57];
% w_a=[3  3  3];
% w_b=[4  4  4];
% Icc=[0  0.1  0.1];
% A_a=[0.15  3   0.5];
% A_b=[0.2  1   0.3];
% w_a=[1 2 3];
% w_b=[0.5 0.5 0.5];
% Icc=[0  0.1  0.1];
A_a=[1.1  1.5   1.2];
A_b=[0.4 0.15 0.15];
w_a=[0.5 1.2 1];
w_b=[4 5 3];
Icc=[0  0.02  0.02];


tau=5;



%%%%

R1=50;
R2=30;
R3=15;
=======
% Excitacion
Im_cc=[0  0.4  0.15];

% Senos que se amortiguan lentamente (tendran frec baja)
A_a=[0.7    1.3  0.5];
W_a=[0.5  0.5  0.5]*2*pi;
tau=7;

% Senos que desaparecen rapido (tendran frecuencia alta)
A_b=[1    0.5   0.4];
W_b=[1.7 2.5  2.5]*2*pi;
tau2=4;

% % Excitacion
% Im_cc=[0  0.4  0.15];
% 
% % Senos que se amortiguan lentamente (tendran frec baja)
% A_a=[0.7    1.3  0.5];
% W_a=[0.5  0.5  0.5]*2*pi;
% tau=7;
% 
% % Senos que desaparecen rapido (tendran frecuencia alta)
% A_b=[1    0.5   0.4];
% W_b=[1.7 2.5  2.5]*2*pi;
% tau2=4;

>>>>>>> 3623cc8a2dde2ec97e74a804993e7b262874012a

Ts=1e-3;
Tsim=30;

% t_red =[
%  
%                            - m2*L2^2 - m3*l2^2 + Ixx2 - Iyy2
%                                      - m3*L3^2 + Ixx3 - Iyy3
%  m2*L2^2 + m3*L3^2 + Jm1*R1^2 + m3*l2^2 + Iyy1 + Iyy2 + Iyy3
%                          m2*L2^2 + Jm2*R2^2 + m3*l2^2 + Izz2
%                                               m3*L3^2 + Izz3
%                                                          Jm3
%                                                          Bm1
%                                                          Bm2
%                                                          Bm3
%                                                L2*m2 + l2*m3
%                                                        L3*m3];