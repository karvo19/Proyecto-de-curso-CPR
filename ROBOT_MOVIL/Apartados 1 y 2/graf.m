% Simulacion y graficas
clear
clc
close all

Tsim=10;
Tm=30e-3;

% Condiciones iniciales ( X Y PHI )
CI = [0 0 0];     % X_ini Y_ini Phi_ini    

% Referencias de actuación (Senoides) - Apartado 2
Amp=1;
w_sin = 2*pi/1;


sim('Robot_diferencial_apt_1_2');


figure(1);
plot(xyp(:,1),xyp(:,2)); grid on;title('Plano XY');legend('robot');hold on;
% plot([0 0],[min(xyp(:,2))-1 max(xyp(:,2))+1],'k'); hold on;
% plot([min(xyp(:,1))-1 max(xyp(:,1))+1],[0 0],'k'); hold on;
figure(2);
subplot(2,1,1);plot(t,w_ref(:,1)); grid on;title('Velocidades de referencia (ruedas)'); legend('w_i');
subplot(2,1,2);plot(t,w_ref(:,2)); grid on; legend('w_d');

