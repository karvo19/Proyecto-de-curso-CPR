%% Modelo Cinematico Directo
% DATOS CINEMÁTICOS DEL BRAZO DEL ROBOT
% Dimensiones (m)
%   L0 = 1.00;    % Base
%   L1 = 0.40;  % Esalbón 1 
%   L2 = 0.70;  % Esalbón 2
%   L3 = 0.50;  % Esalbón 3
  
syms L0 L1 L2 L3 q1 q2 q3 real;

PI = sym('pi'); %para que el numero pi sea exacto

AU0 = MDH(0, L0, 0, 0);
A01 = MDH(q1, L1, 0, PI/2);
A12 = MDH(q2, 0, L2, 0);
A23 = MDH(q3, 0, L3, 0);

T = simplify(AU0*A01*A12*A23)

%% Cinemática Inversa
% el solver no quiere pero vienen resuelto en el libro barrientos