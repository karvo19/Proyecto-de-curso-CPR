function xyz = CinematicaDirecta(in)

% Posicion articular
q1       = in(1);           
q2       = in(2);           
q3       = in(3);

% Variables articulares
L0 = 1.00;
L1 = 0.40;
L2 = 0.70;
L3 = 0.50;

% syms L0 L1 L2 L3 q1 q2 q3 real;
% 
% PI = sym('pi'); %para que el numero pi sea exacto
% 
% AU0 = MDH(0, L0, 0, 0);
% A01 = MDH(q1, L1, 0, PI/2);
% A12 = MDH(q2, 0, L2, 0);
% A23 = MDH(q3, 0, L3, 0);
% 
% T = simplify(AU0*A01*A12*A23)

  x = cos(q1)*(L3*cos(q2 + q3) + L2*cos(q2));
  y = sin(q1)*(L3*cos(q2 + q3) + L2*cos(q2));
  z = L0 + L1 + L3*sin(q2 + q3) + L2*sin(q2);
  
xyz=[x;y;z];
return



  