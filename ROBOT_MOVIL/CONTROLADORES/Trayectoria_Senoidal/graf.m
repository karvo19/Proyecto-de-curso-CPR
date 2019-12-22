% Simulacion y graficas
clear
clc
close all

Tsim=15;
Tm=30e-3;

% Condiciones iniciales ( X Y PHI )
CI = [0 0 0];     % X_ini Y_ini Phi_ini    


sim('Robot_diferencial');



figure(1);
plot(xyp(:,1),xyp(:,2)); axis equal;grid on;title('Plano XY');hold on;
% plot([0 0],[min(xyp(:,2))-1 max(xyp(:,2))+1],'k'); hold on;
% plot([min(xyp(:,1))-1 max(xyp(:,1))],[0 0],'k'); hold on;
plot(trayectoria(:,1),trayectoria(:,2),'--k');
figure(2);
subplot(2,1,1);plot(t,w_ref(:,1)); axis equal ;grid on;title('Velocidades de referencia (ruedas)'); legend('w_i');
subplot(2,1,2);plot(t,w_ref(:,2)); axis equal ;grid on; legend('w_d');
figure(3);
subplot(3,1,1);plot(t,xyp(:,3)); axis equal ;grid on;title('Phi');
subplot(3,1,2);plot(t,[trayectoria(:,1) xyp(:,1)]); axis equal ;grid on;title('x');
subplot(3,1,3);plot(t,[trayectoria(:,2) xyp(:,2)]); axis equal ;grid on;title('y');

