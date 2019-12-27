% Simulacion y graficas
clear
clc
close all

Tsim=45;
Tm=30e-3;

% Condiciones iniciales ( X Y PHI )
CI = [1 0 pi/2];     % X_ini Y_ini Phi_ini   

sim('Robot_diferencial_trayectoria');



figure(1);
plot(xyp(:,1),xyp(:,2)); axis equal;grid on;title('Plano XY');hold on;
% plot([0 0],[min(xyp(:,2))-1 max(xyp(:,2))+1],'k'); hold on;
% plot([min(xyp(:,1))-1 max(xyp(:,1))],[0 0],'k'); hold on;
plot(trayectoria(:,1),trayectoria(:,2),'--k');
DibujaTriangulo;
legend('Trayectoria seguida', 'Trayectoria de referencia', 'Pose inicial');

figure(2);
subplot(2,1,1);plot(t,[w_ref(:,1) w_reales(:,1)]) ;grid on;title('Velocidades de referencia (ruedas)'); legend('w_i','w_i^{real}');
subplot(2,1,2);plot(t,[w_ref(:,2) w_reales(:,2)]); grid on; legend('w_d','w_d^{real}');
figure(3);
subplot(3,1,1);plot(t,xyp(:,3)) ;grid on;title('Phi');legend('phi_{real}');
subplot(3,1,2);plot(t,[trayectoria(:,1) xyp(:,1)]); grid on;title('x');legend('x_{ref}','x_{real}'); 
subplot(3,1,3);plot(t,[trayectoria(:,2) xyp(:,2)]); grid on;title('y');legend('y_{ref}','y_{real}'); 


