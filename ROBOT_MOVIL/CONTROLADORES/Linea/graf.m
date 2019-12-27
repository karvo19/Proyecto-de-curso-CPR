% Simulacion y graficas
clear
clc
close all

Tsim=15;
Tm=30e-3;

% Condiciones iniciales ( X Y PHI )
CI = [0 0 0];     % X_ini Y_ini Phi_ini    

% Recta de referencia
% ax + by + c = 0       
a=0.5;
b=-1;
c=0.5;

sim('Robot_diferencial_linea');


% Graficas
x_l = 0:0.01:13;
y_l = (-a*x_l - c)/b;



figure(1);
plot(xyp(:,1),xyp(:,2)); grid on;title('Plano XY');hold on;
plot([0 0],[min(xyp(:,2))-1 max(xyp(:,2))+1],'k'); hold on;
plot([min(xyp(:,1))-1 max(xyp(:,1))],[0 0],'k'); hold on;
plot(x_l,y_l,'--k');
DibujaTriangulo;

figure(2);
subplot(2,1,1);plot(t,w_ref(:,1),t,w_ref_sat(:,1)); grid on;title('Velocidades de referencia (ruedas)'); legend('w_i','w_i^{sat}');
subplot(2,1,2);plot(t,w_ref(:,2),t,w_ref_sat(:,2)); grid on; legend('w_d','w_d^{sat}');
% figure(3);
% subplot(2,1,1);plot(t,xyp(:,3)); axis equal ;grid on;title('Phi');
% subplot(2,1,2);plot(t,d); axis equal ;grid on;title('d');

