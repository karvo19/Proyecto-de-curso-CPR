%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                            %
%       ESTO ES UNA COPIA DE AÑO PASADO SIN MODIFICAR        %
%                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [qdd] = ModeloDinamico_R3GDL(in)

% Variables de entrada en la funcion: [q(2)  qp(2)  Imotor(2)]
q1        = in(1);
q2        = in(2);
q3        = in(3);
qd1       = in(4);
qd2       = in(5);
qd3       = in(6);
Tau1      = in(7);
Tau2      = in(8);
Tau3      = in(9);



% Matriz de Inercias
  Ma =[0 0 0
       0 0 0
       0 0 0];
 
  
% Matriz de aceleraciones centrípetas y de Coriolis
  Va = [0
        0
        0]; 
 
% Par gravitatorio                
  Ga = 9.8*[0
            0
            0];

% Ecuación del robot
%    Tau = M*qpp + V + G
  Tau=[Tau1;Tau2;Tau3];

% Por lo que:  
% Aceleraciones
  qdd = inv(Ma)*(Tau-Va-Ga);
  