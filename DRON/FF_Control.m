function w_ref= FF_Control(in)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Inversión del modelo propulsivo. Convierte las referencias de las 4 
%   variables de actuación sobre el sólido rígido (empuje y pares en RPI) 
%   a referencias de velocidades angulares a controlar por el ESC.
%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Entradas 
T_ref = in(1);
tau_roll_ref = in(2);
tau_pitch_ref = in(3);
tau_yaw_ref = in(4);

% Parámetros del modelo
L = 0.332;      % Distancia entre el centro de masa y los rotores
b = 9.5e-6;       % Coeficiente de empuje de los rotores
Kt = 1.7e-7;        % Coeficiente de arrastre de los rotores

% Inversión del modelo propulsivo
F_ref = [1/4    0   -1/(2*L)    b/(4*Kt);
         1/4    1/(2*L) 0      -b/(4*Kt);
         1/4    0   1/(2*L)     b/(4*Kt);
         1/4    -1/(2*L)    0   -b/(4*Kt)] * [T_ref tau_roll_ref tau_pitch_ref tau_yaw_ref]';

     
w_ref = sign(F_ref).*sqrt(abs(F_ref/b)); 


w_ref = abs(w_ref);     % El simulador espera valores positivos de velocidad
end

