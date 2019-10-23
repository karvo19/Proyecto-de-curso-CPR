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