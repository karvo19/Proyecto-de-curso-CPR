%%%%%%%%%%%%%%%%%% Cinem�tica Inversa %%%%%%%%%%%%%%%%%%%%%
%
% C�lculo simb�lico para obtener el Jacobiano inverso
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
syms R phi b w_i w_d x_d y_d phi phi_d x A real;

% Obtenci�n a partir del Jacobiano Directo completo
J_q=[R/2*cos(phi) R/2*cos(phi);
     R/2*sin(phi) R/2*sin(phi);
     -R/b         R/b         ];

 q_d=[x_d y_d phi_d]';                  %Variables generalizadas
 
 J_q_pseudoinv = simplify((J_q'*J_q)^-1*J_q')
 
 p_d = simplify(J_q_pseudoinv * q_d);   % p_d=[w_i w_d]' (Variables de actuaci�n)

 % La matriz J_q_pseudoinv obtenida es 2x3. Al no tener rango completo 
 % no es posible controlar todas las variables generalizadas (solo se tienen 
 % 2 actuaciones y hay tres variables a controlar).
 
    
 % Como con ese m�todo no lo consegu�a, prob� con el modelo de v y phi_d
 % (explicado en el folio)
inv([R/2 R/2;-R/b R/b])
phi=atan(-2*x + A);
phi_d = simplify(diff(phi,x)*x_d)














