% MDH  		Obtenci�n de la Matriz de transformaci�n homog�nea 
%           a partir de par�metros de Denavit Hartenberg estandar.
% 	        DH = MDH(THETA, D, A, ALFA) devuelve la matriz de transformacion 
%	        homog�nea 4 x 4 a partir de los parametros de Denavit-Hartenberg
%	        THETA,D, ALFA y A.
%          

function dh=MDH(theta, d, a, alfa)
dh=[cos(theta)            -cos(alfa)*sin(theta)   sin(alfa)*sin(theta)      a*cos(theta);
    sin(theta)             cos(alfa)*cos(theta)  -sin(alfa)*cos(theta)      a*sin(theta);
           0                   sin(alfa)            cos(alfa)                   d;
           0                     0                     0                        1];

