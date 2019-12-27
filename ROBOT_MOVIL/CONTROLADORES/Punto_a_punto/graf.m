% Simulacion y graficas
clear
clc
close all

Tsim=15;
Tm=30e-3;

% Condiciones iniciales ( X Y PHI )
CI = [0 0 0];     % X_ini Y_ini Phi_ini    

sim('Robot_diferencial_punto');

% axis tight equal;
figure(1);
plot(xyp(:,1),xyp(:,2)); grid on;title('Plano XY');hold on;
plot([0 0],[min(xyp(:,2))-1 max(xyp(:,2))+1],'k'); hold on;
plot([min(xyp(:,1))-1 max(xyp(:,1))+1],[0 0],'k'); hold on;
DibujaTriangulo;
plot(3,3,'gd')
legend('Trayectoria', 'eje x', 'eje y', 'Pose inicial', 'Punto objetivo');


figure(2);
subplot(2,1,1);plot(t,w_ref(:,1),t,w_ref_sat(:,1)); grid on;title('Velocidades de referencia (ruedas)'); legend('w_i','w_i^{sat}');
subplot(2,1,2);plot(t,w_ref(:,2),t,w_ref_sat(:,2)); grid on; legend('w_d','w_d^{sat}');

