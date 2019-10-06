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
  M =[(128*q3*cos(q2)^2)/25-(7847*sin(2*q2))/5000-(32*q3*sin(2*q2))/25+(8067*cos(q2)^2)/5000+(16*q3^2*cos(q2)^2)/5+474911/5000,0,0;
      0,((16*q3)/5+64/25)*(q3+4/5)+4137/50,-32/25;
      0,-32/25,939/20];
 
  
% Matriz de aceleraciones centrípetas y de Coriolis
  V = [-(qd1*(31388*qd2*cos(2*q2)-25600*qd3-25600*qd3*cos(2*q2)+16134*qd2*sin(2*q2)+12800*qd3*sin(2*q2)-32000*q3*qd3+25600*q3*qd2*cos(2*q2)-32000*q3*qd3*cos(2*q2)+51200*q3*qd2*sin(2*q2)+32000*q3^2*qd2*sin(2*q2)-225))/10000;
      (9*qd2)/625+(128*qd2*qd3)/25+(7847*qd1^2*cos(2*q2))/5000+(8067*qd1^2*sin(2*q2))/10000+(8*q3^2*qd1^2*sin(2*q2))/5+(32*q3*qd2*qd3)/5+(32*q3*qd1^2*cos(2*q2))/25+(64*q3*qd1^2*sin(2*q2))/25;
      (9*qd3)/400-(64*qd1^2*cos(q2)^2)/25+(16*qd1^2*sin(2*q2))/25-(16*q3*qd2^2)/5-(64*qd2^2)/25-(16*q3*qd1^2*cos(q2)^2)/5]; 
 
% Par gravitatorio                
  G = 9.8*[0;
      (94*cos(q2))/25 - (52*sin(q2))/25 + (16*q3*cos(q2))/5;
      (16*sin(q2))/5];

% Ecuación del robot
%    Tau = M*qpp + V + G
  Tau=[Tau1;Tau2;Tau3];

% Por lo que:  
% Aceleraciones
  qdd = inv(M)*(Tau-V-G);
  