% Simulacion y graficas
clear
clc
close all

Tsim=10;
Tm=30e-3;

% Condiciones iniciales ( X Y PHI )
A=2;                    %Par�metro de la ecuaci�n de la par�bola; Hay que cambiarlo en el generador tambi�n.
CI = [0 0 atan(A)];     % X_ini Y_ini Phi_ini    ;  Phi = atan(y_d/x_d) = atan(-2x + A);


sim('Robot_diferencial_apt3');


figure(1);
plot(xyp(:,1),xyp(:,2)); axis tight equal;grid on;title('Plano XY');hold on;
plot([0 0],[min(xyp(:,2))-1 max(xyp(:,2))+1],'k'); hold on;
plot([min(xyp(:,1))-1 max(xyp(:,1))+1],[0 0],'k'); hold on;
legend('Trayectoria seguida', 'eje x', 'eje y');
figure(2);
subplot(2,1,1);plot(t,w_ref(:,1)); grid on;title('Velocidades de referencia (ruedas)'); legend('w_i');
subplot(2,1,2);plot(t,w_ref(:,2)); grid on; legend('w_d');

