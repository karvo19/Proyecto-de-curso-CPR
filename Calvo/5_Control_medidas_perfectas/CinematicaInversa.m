function q = CinematicaInversa(pos)
% Variables articulares
L0 = 1.00;
L1 = 0.40;
L2 = 0.70;
L3 = 0.50;

x = pos(1);
y = pos(2);
z = pos(3);

% q1 siempre en el cuadrante enque este el punto 3D
q1 = atan2(y,x);
% Con la q1 así, 

% q3=acos((x^2+y^2+(z-L0-L1)^2-L2^2-L3^2)/(2*L2*L3));

C3 = (x^2+y^2+(z-L0-L1)^2-L2^2-L3^2)/(2*L2*L3);

q3 = atan2(sqrt(1-C3^2),C3);
if q3 < 0
    q3 = atan2(-1*sqrt(1-C3^2),C3);
end

q2 = atan2((z-L0-L1),sqrt(x^2+y^2))-atan2((L3*sin(q3)),(L2+L3*cos(q3)));

q = [q1 q2 q3]';
return


