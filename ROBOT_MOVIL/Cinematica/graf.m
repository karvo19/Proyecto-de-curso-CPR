% Simulacion y graficas
clear
clc
close all

Tsim=10;
Tm=30e-3;

% Apartado A2
Amp=2;
frec=5;

 % Condiciones iniciales ( X Y PHI )
 A=2;                    %Parámetro de la ecuación de la parábola; Hay que cambiarlo en el generador también.
 CI = [0 0 atan(A)];     % X_ini Y_ini Phi_ini    ;  Phi = atan(y_d/x_d) = atan(-2x + A);


sim('Robot_diferencial_cinematica');


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
subplot(2,1,1);plot(t,wrefizq1,t,w_ref(:,1)); axis equal ;grid on;title('Velocidades de referencia (ruedas)'); legend('w_i');
subplot(2,1,2);plot(t,wrefder1,t,w_ref(:,2)); axis equal ;grid on; legend('w_d');


