%% Diseño de un controlador PD descentralizado (CANCELACION DE DINAMICA)
K_i=[44.44 69.44 44.44];
tau_i=[1.22e4 7.44e3 2.53e3];

% wc=150 rad/s --> tsbc=20 ms
tsbc=20e-3;
Kc=3/tsbc; %% Unidades -> depende del tipo de articulación

Ki=[0 0 0];
Kp=Kc./K_i
Kd=Kp.*tau_i


%% DISEÑO DE UN PD SIN CANCELACION

G11=tf([K_i(1)],conv([tau_i(1) 1],[1 0]));
G22=tf([K_i(2)],conv([tau_i(2) 1],[1 0]));
G33=tf([K_i(3)],conv([tau_i(3) 1],[1 0]));

wc=150;
Gain=113.5;
C1=tf(1,1);
Kp=1;
Kp=10^(Gain/20);

tau=1/wc*tan(70*pi/180);

C1=tf(Kp*[tau 1],1);


Gba=C1*G33;
bode(Gba,logspace(0,3,1000)); grid

Kp=[2.1135e+06 8.4140e+05 4.7315e+05];
Ki=[0 0 0];
Kd=Kp*tau

%% diseño de un PID por cancelación 
% Un cero para cancelar dinámica. 
% El otro cero y la ganancia para diseñar el bucle cerrado sobreamortiguado
clear
clc
K_i=[44.44 69.44 44.44];
tau_i=[1.22e4 7.44e3 2.53e3];

% wc=150 rad/s --> tsbc=20 ms
tsbc=20e-3;

tau_bc=tsbc/6;
tau2=2*tau_bc;

Kc_i=1./(tau_bc^2*K_i);

tau1=tau_i;

Ti=tau1+tau2
Td=(tau1.*tau2)./(tau1+tau2)
Kp=Kc_i.*(tau1+tau2)

Kd=Kp.*Td;
Ki=Kp./Ti;

%% diseño de un PID sin cancelación 
clear
clc
K_i=[44.44 69.44 44.44];
tau_i=[1.22e4 7.44e3 2.53e3];

G11=tf([K_i(1)],conv([tau_i(1) 1],[1 0]));
G22=tf([K_i(2)],conv([tau_i(2) 1],[1 0]));
G33=tf([K_i(3)],conv([tau_i(3) 1],[1 0]));


%% 2
C1=tf(1,1);
Gba=C1*G11;
bode(Gba,logspace(0,3,1000)); grid
%% 
wc=150;
Mf_act=0;
Mf_des=70;
phi=Mf_des-Mf_act;
tau=tand((90+phi)/2)/wc;
Kc=1;
C1=tf(Kc*conv([tau 1],[tau 1]),[1 0]);
Gba=C1*G33;
bode(Gba,logspace(0,3,1000)); grid
%%
Gain=135.5;
Kc=10^(Gain/20);
C1=tf(Kc*conv([tau 1],[tau 1]),[1 0]);
Gba=C1*G33;
bode(Gba,logspace(0,3,1000)); grid

margin(Gba);grid;

Ti=2*tau
Td=tau/2
Kp=2*Kc*tau

Ti=[7.5617e-02 7.5617e-02 7.5617e-02];
Td=[1.8904e-02 1.8904e-02 1.8904e-02];
Kp=[2.1312e+06 8.4844e+05 4.5042e+05];

Kd=Kp.*Td;
Ki=Kp./Ti;





%% GRAFICAS 
close all

%------------------------------ POSICIONES -------------------------------
figure(1);
subplot(3,1,1);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos);
plot(t_M,q_M(:,1),'r','LineWidth',1.75); hold on;
plot(t_M,qr(:,1),'--k','LineWidth',1.75); hold on;

title('Posiciones articulares'); 
xlabel('Tiempo (s)'); ylabel('q_1 (m)');
legend('Salida','Referencia','Location', 'Best');
grid on;

subplot(3,1,2);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)

plot(t_M,q_M(:,2),'r','LineWidth',1.75); hold on;
plot(t_M,qr(:,2),'--k','LineWidth',1.75); hold on;
xlabel('Tiempo (s)'); ylabel('q_2 (rad)');
legend('Salida','Referencia','Location', 'Best');
grid on;

subplot(3,1,3);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)
plot(t_M,q_M(:,3),'r','LineWidth',1.75); hold on;
plot(t_M,qr(:,3),'--k','LineWidth',1.75); hold on;

xlabel('Tiempo (s)'); ylabel('q_3 (rad)');
legend('Salida','Referencia','Location', 'Best');
grid on;
      
set(gcf, 'Units', 'Centimeters', 'Position', [0, 0, 18, 25], 'PaperUnits', 'Centimeters', 'PaperSize', [18, 25]);
print(gcf, '-dmeta', '-r150', '1.emf');

%------------------------------ VELOCIDADES -------------------------------
figure(2);
subplot(3,1,1);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos);
plot(t_M,qd_M(:,1),'r','LineWidth',1.75); hold on;
plot(t_M,qdr(:,1),'--k','LineWidth',1.75); hold on;

title('Velocidades articulares'); 
xlabel('Tiempo (s)'); ylabel('qd_1 (m/s)');
legend('Salida','Referencia','Location', 'Best');
grid on;

subplot(3,1,2);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)

plot(t_M,qd_M(:,2),'r','LineWidth',1.75); hold on;
plot(t_M,qdr(:,2),'--k','LineWidth',1.75); hold on;
xlabel('Tiempo (s)'); ylabel('qd_2 (rad/s)');
legend('Salida','Referencia','Location', 'Best');
grid on;

subplot(3,1,3);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)
plot(t_M,qd_M(:,3),'r','LineWidth',1.75); hold on;
plot(t_M,qdr(:,3),'--k','LineWidth',1.75); hold on;

xlabel('Tiempo (s)'); ylabel('qd_3 (rad/s)');
legend('Salida','Referencia','Location', 'Best');
grid on;
      
set(gcf, 'Units', 'Centimeters', 'Position', [0, 0, 18, 25], 'PaperUnits', 'Centimeters', 'PaperSize', [18, 25]);
print(gcf, '-dmeta', '-r150', '2.emf');


%---------------------------ERROR EN POSICIONES ARTICULARES -------------------------------
figure(3);
subplot(3,1,1);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos);
plot(t_M,qr(:,1)-q_M(:,1),'r','LineWidth',1.75); hold on;
title('Errores en posiciones articulares'); 
xlabel('Tiempo (s)'); ylabel('q_1 (m)');
% legend('Referencia','Salida','Location', 'Best');
grid on;

subplot(3,1,2);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)

plot(t_M,qr(:,2)-q_M(:,2),'r','LineWidth',1.75); hold on;
xlabel('Tiempo (s)'); ylabel('q_2 (rad)');
% legend('Referencia','Salida','Location', 'Best');
grid on;

subplot(3,1,3);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)
plot(t_M,qr(:,3)-q_M(:,3),'r','LineWidth',1.75); hold on;

xlabel('Tiempo (s)'); ylabel('q_3 (rad)');
% legend('Referencia','Salida','Location', 'Best');
grid on;
      
set(gcf, 'Units', 'Centimeters', 'Position', [0, 0, 18, 25], 'PaperUnits', 'Centimeters', 'PaperSize', [18, 25]);
print(gcf, '-dmeta', '-r150', '3.emf');


%---------------------------ERROR EN VELOCIDADES ARTICULARES -------------------------------
figure(4);
subplot(3,1,1);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos);
plot(t_M,qdr(:,1)-qd_M(:,1),'r','LineWidth',1.75); hold on;
title('Errores en velocidades articulares'); 
xlabel('Tiempo (s)'); ylabel('qd_1 (m/s)');
% legend('Referencia','Salida','Location', 'Best');
grid on;

subplot(3,1,2);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)

plot(t_M,qdr(:,2)-qd_M(:,2),'r','LineWidth',1.75); hold on;
xlabel('Tiempo (s)'); ylabel('qd_2 (rad/s)');
% legend('Referencia','Salida','Location', 'Best');
grid on;

subplot(3,1,3);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)
plot(t_M,qdr(:,3)-qd_M(:,3),'r','LineWidth',1.75); hold on;

xlabel('Tiempo (s)'); ylabel('qd_3 (rad/s)');
% legend('Referencia','Salida','Location', 'Best');
grid on;
      
set(gcf, 'Units', 'Centimeters', 'Position', [0, 0, 18, 25], 'PaperUnits', 'Centimeters', 'PaperSize', [18, 25]);
print(gcf, '-dmeta', '-r150', '4.emf');

%--------------------------- ERROR EN EL ESPACIO DE LA TAREA -------------------------------
err=sqrt((xr-x).^2+(yr-y).^2+(zr-z).^2);

% Error cometido en cada instante
figure(5);

plot(t_M,1000*err,'r','LineWidth',1.75); hold on;
title('Error en el espacio de la tarea'); 
xlabel('Tiempo (s)'); ylabel('Error absoluto (mm)');
grid on;
ax = gca; outerpos = ax.OuterPosition; ti = ax.TightInset;  left = outerpos(1) + ti(1); bottom = outerpos(2) + ti(2); ax_width = outerpos(3) - ti(1) - ti(3); ax_height = outerpos(4) - ti(2) - ti(4); ax.Position = [left bottom ax_width ax_height];
set(gcf, 'Units', 'Centimeters', 'Position', [0, 0, 15, 15], 'PaperUnits', 'Centimeters', 'PaperSize', [18, 25]);
print(gcf, '-dmeta', '-r150', '5.emf');


% ----------------------------------- FUERZAS Y PARES----------------------------------------
figure(6);
subplot(3,1,1);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos);
plot(t_M,Tau_M(:,1),'r','LineWidth',1.75); hold on;
title('Fuerzas y Pares'); 
xlabel('Tiempo (s)'); ylabel('F_1 (N)');

% legend('Referencia','Salida','Location', 'Best');
grid on;

subplot(3,1,2);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)

plot(t_M,Tau_M(:,2),'r','LineWidth',1.75); hold on;
xlabel('Tiempo (s)'); ylabel('tau_2 (Nm)');
% legend('Referencia','Salida','Location', 'Best');
grid on;

subplot(3,1,3);
pos = get(gca, 'Position');
    pos(1) = 0.095;
    pos(3) = 0.9;
    set(gca, 'Position', pos)
plot(t_M,Tau_M(:,3),'r','LineWidth',1.75); hold on;

xlabel('Tiempo (s)'); ylabel('tau_3 (Nm)');
% legend('Referencia','Salida','Location', 'Best');
grid on;
      
set(gcf, 'Units', 'Centimeters', 'Position', [0, 0, 18, 25], 'PaperUnits', 'Centimeters', 'PaperSize', [18, 25]);
print(gcf, '-dmeta', '-r150', '6.emf');



















