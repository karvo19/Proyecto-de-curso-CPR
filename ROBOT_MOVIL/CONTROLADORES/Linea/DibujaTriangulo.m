% Vamos a representar la posicion inicial del robot
% Para ello tendremos que calculartres puntos en funcion de CI
% CI = [X_ini Y_ini Phi_ini]    

h = 0.5;    % altura del triagulo
b = 0.3;    % base del triangulo

px = [CI(1)-b/2*cos(CI(3)+pi/2) CI(1)+b/2*cos(CI(3)+pi/2) CI(1)+h*cos(CI(3)) CI(1)-b/2*cos(CI(3)+pi/2)];
py = [CI(2)-b/2*sin(CI(3)+pi/2) CI(2)+b/2*sin(CI(3)+pi/2) CI(2)+h*sin(CI(3)) CI(2)-b/2*sin(CI(3)+pi/2)];

plot(px,py,'r');axis equal;%plot(CI(1),CI(2),'b*');axis equal;