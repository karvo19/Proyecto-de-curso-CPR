% Simulacion y graficas
clear
clc
close all

Tsim=10;
Tm=30e-3;

 CI = [0 0 0];     % X_ini Y_ini Phi_ini    ;


% punto
xref=3;
yref=4;


sim('Robot_diferencial_control');


% figure(1); %%parabola con generador
% plot(xyp(:,1),xyp(:,2)); axis tight equal;grid on;title('Plano XY');legend('robot');hold on;
% plot([0 0],[min(xyp(:,2))-1 max(xyp(:,2))+1],'k'); hold on;
% plot([min(xyp(:,1))-1 max(xyp(:,1))+1],[0 0],'k'); hold on;
% figure(2); 
% subplot(2,1,1);plot(t,w_ref(:,1)); axis equal ;grid on;title('Velocidades de referencia (ruedas)'); legend('w_i');
% subplot(2,1,2);plot(t,w_ref(:,2)); axis equal ;grid on; legend('w_d');
% 
% 
% figure(3); %%lazo abierto
% plot(xyp(:,1),xyp(:,2)); axis tight equal;grid on;title('Plano XY');legend('robot');hold on;
% plot([0 0],[min(xyp(:,2))-1 max(xyp(:,2))+1],'k'); hold on;
% plot([min(xyp(:,1))-1 max(xyp(:,1))+1],[0 0],'k'); hold on;
% figure(4);
% subplot(2,1,1);plot(t,wrefizq); axis equal ;grid on;title('Velocidades de referencia (ruedas)'); legend('w_i');
% subplot(2,1,2);plot(t,wrefder); axis equal ;grid on; legend('w_d');

figure(5);
subplot(2,1,1);plot(t,xyp(:,1),t,xref); axis equal ;grid on;title('control a punto'); legend('x', 'xref');
subplot(2,1,2);plot(t,xyp(:,2),t,yref); axis equal ;grid on; legend('y', 'yref');


