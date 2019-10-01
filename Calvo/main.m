%% Modelo Cinematico Directo
% DATOS CINEM�TICOS DEL BRAZO DEL ROBOT
% Dimensiones (m)
%   L0 = 1.00;    % Base
%   L1 = 0.40;  % Esalb�n 1 
%   L2 = 0.70;  % Esalb�n 2
%   L3 = 0.50;  % Esalb�n 3
  
syms L0 L1 L2 L3 q1 q2 q3 real;

PI = sym('pi'); %para que el numero pi sea exacto

AU0 = MDH(0, L0, 0, 0);
A01 = MDH(q1, L1, 0, PI/2);
A12 = MDH(q2, 0, L2, 0);
A23 = MDH(q3, 0, L3, 0);

T = simplify(AU0*A01*A12*A23)

%% Simulacion del GTCL
clear

Tsim = 2;
XYZini = CinematicaDirecta([0 0 0]);
XYZfin = CinematicaDirecta([pi 3*pi/4 -pi/5]);
n = 5;
t_ini = 0.5;
duracion = 1;

accesible(XYZini, XYZfin);

sim('GTCL.mdl');

graficas_pruebas;
graficas_gtcl;

%% 
clear
XYZini = CinematicaDirecta([0 0 0])
XYZfin = CinematicaDirecta([1 1 1])

GTCL_R3GDL([XYZini', XYZfin', 5, 0.5, 1, 0])