% Simulacion y graficas
clear
clc
close all

Tsim=20;
Tm=30e-3;
y_pared = 40e-2;
% ref=0;  % distancia

% Condiciones iniciales ( X Y PHI )
CI = [0 0 0.3];


sim('Robot_diferencial');


linea_pared=y_pared*ones(size(xyp(:,1)));

% figure(1);plot(100*xyp(:,1),100*linea_pared,'r');hold on; axis([0 100*abs(max(xyp(:,1))) 100*-0.34 100*0.44]); grid on; 
figure(1);plot(100*xyp(:,1),100*xyp(:,2)); axis([0 100*abs(max(xyp(:,1))) 100*-0.34 100*0.44]); grid on;title('Plano XY'); legend('pared','referencia','robot');

