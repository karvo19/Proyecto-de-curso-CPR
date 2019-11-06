function q = CinematicaInversa(pos)
% Variables articulares
L0 = 1.00;
L1 = 0.40;
L2 = 0.70;
L3 = 0.50;

x = pos(1);
y = pos(2);
z = pos(3);


q1 = atan(y/x);

% q3=acos((x^2+y^2+(z-L0-L1)^2-L2^2-L3^2)/(2*L2*L3));

C3 = (x^2+y^2+(z-L0-L1)^2-L2^2-L3^2)/(2*L2*L3);

q3 = atan(sqrt(1-C3^2)/C3);

q2 = atan((z-L0-L1)/sqrt(x^2+y^2))-atan((L3*sin(q3))/(L2+L3*cos(q3)));

q = [q1 q2 q3]';
return

