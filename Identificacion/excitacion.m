% Excitacion
Im_cc=[0  0.01  0.01]*10;

% Senos que se amortiguan lentamente (tendran frec baja)
A_a=[0.1    0.1  0.1]*10;
W_a=[1  2  3];%*2*pi
tau=7;

% Senos que desaparecen rapido (tendran frecuencia alta)
A_b=[0.5    0.5   0.5]*10;
W_b=[4 5  6];%*2*pi
tau2=4;
    
Ts=0.001;
Tsim=30;