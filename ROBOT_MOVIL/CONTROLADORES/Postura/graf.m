% Simulacion y graficas
clear
clc
close all
Tsim=15;
% Condiciones iniciales ( X Y PHI )
CI = [0 0 0];     % X_ini Y_ini Phi_ini    

sim('Robot_diferencial_postura');

figure(1);
plot(xyp(:,1),xyp(:,2)); axis equal;grid on;title('Plano XY');hold on;
% plot([0 0],[min(xyp(:,2))-1 max(xyp(:,2))+1],'k'); hold on;
% plot([min(xyp(:,1))-1 max(xyp(:,1))],[0 0],'k'); hold on;
color = 'r';
DibujaTriangulo;

% Dibujamos el triangulo de referencia
CI = [2 2 -pi/3];
color = 'g';
DibujaTriangulo;

% Dibujamos el triangulo de posicion final
L = length(xyp);
CI = xyp(L,:);
color = 'k--';
DibujaTriangulo;
legend('Trayectoria', 'Postura inicial', 'Postura de referencia', 'Postura final');

figure(2);
subplot(2,1,1);plot(t,[w_ref(:,1) w_reales(:,1)]) ;grid on;title('Velocidades de referencia (ruedas)'); legend('w_i^{ref}','w_i^{real}');
subplot(2,1,2);plot(t,[w_ref(:,2) w_reales(:,2)]); grid on; legend('w_d^{ref}','w_d^{real}');
figure(3); plot(t,xyp(:,3)); axis equal ;grid on;title('Phi^{real}');