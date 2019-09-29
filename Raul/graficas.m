% q vs qr
figure;
    subplot(3,1,1);
        plot(t,[q(:,1) qr(:,1)],'LineWidth',1);grid;
        ylabel('q_1 (rad)');
        title('q frente a qr');
        legend('q_1','qr_1');
    subplot(3,1,2);
        plot(t,[q(:,2) qr(:,2)],'LineWidth',1);grid;
        ylabel('q_2 (rad)');
        legend('q_2','qr_2');
    subplot(3,1,3);
        plot(t,[q(:,3) qr(:,3)],'LineWidth',1);grid;
        ylabel('q_3 (m)');
        xlabel('t (s)');
        legend('q_3','qr_3');
        
% qd vs qdr
figure;
    subplot(3,1,1);
        plot(t,[qd(:,1) qdr(:,1)],'LineWidth',1);grid;
        ylabel('qd_1 (rad/s)');
        title('qd frente a qdr');
        legend('qd_1','qdr_1');
    subplot(3,1,2);
        plot(t,[qd(:,2) qdr(:,2)],'LineWidth',1);grid;
        ylabel('qd_2 (rad/s)');
        legend('qd_2','qdr_2');
    subplot(3,1,3);
        plot(t,[qd(:,3) qdr(:,3)],'LineWidth',1);grid;
        ylabel('qd_3 (m/s)');
        xlabel('t (s)');
        legend('qd_3','qdr_3');
        
% qdd vs qddr
figure;
    subplot(3,1,1);
        plot(t,[qdd(:,1) qddr(:,1)],'LineWidth',1);grid;
        ylabel('qdd_1 (rad/s^2)');
        title('qdd frente a qddr');
        legend('qdd_1','qddr_1');
    subplot(3,1,2);
        plot(t,[qdd(:,2) qddr(:,2)],'LineWidth',1);grid;
        ylabel('qdd_2 (rad/s^2)');
        legend('qdd_2','qddr_2');
    subplot(3,1,3);
        plot(t,[qdd(:,3) qddr(:,3)],'LineWidth',1);grid;
        ylabel('qdd_3 (m/s^2)');
        xlabel('t (s)');
        legend('qdd_3','qddr_3');
        
% Errores en posicion (q)
figure;
    subplot(3,1,1);
        plot(t,qr(:,1)-q(:,1),'LineWidth',1);grid;
        ylabel('error q_1 (rad)');
        title('Errores en posición (q)');
        legend('error q_1');
    subplot(3,1,2);
        plot(t,qr(:,2)-q(:,2),'LineWidth',1);grid;
        ylabel('error q_2 (rad)');
        legend('error q_2');
    subplot(3,1,3);
        plot(t,qr(:,3)-q(:,3),'LineWidth',1);grid;
        ylabel('error q_3 (m)');
        xlabel('t (s)');
        legend('error q_3');

% Errores en velocidad (qd)
figure;
    subplot(3,1,1);
        plot(t,qdr(:,1)-qd(:,1),'LineWidth',1);grid;
        ylabel('error qd_1 (rad/s)');
        title('Errores en velocidad (qd)');
        legend('error qd_1');
    subplot(3,1,2);
        plot(t,qdr(:,2)-qd(:,2),'LineWidth',1);grid;
        ylabel('error qd_2 (rad/s)');
        legend('error qd_2');
    subplot(3,1,3);
        plot(t,qdr(:,3)-qd(:,3),'LineWidth',1);grid;
        ylabel('error qd_3 (m/s)');
        xlabel('t (s)');
        legend('error qd_3');

% Errores en aceleracion (qdd)
figure;
    subplot(3,1,1);
        plot(t,qddr(:,1)-qdd(:,1),'LineWidth',1);grid;
        ylabel('error qdd_1 (rad/s^2)');
        title('Errores en aceleración (qdd)');
        legend('error qdd_1');
    subplot(3,1,2);
        plot(t,qddr(:,2)-qdd(:,2),'LineWidth',1);grid;
        ylabel('error qdd_2 (rad/s^2)');
        legend('error qdd_2');
    subplot(3,1,3);
        plot(t,qddr(:,3)-qdd(:,3),'LineWidth',1);grid;
        ylabel('error qdd_3 (m/s^2)');
        xlabel('t (s)');
        legend('error qdd_3');

% Señales de control (Taus)
figure;
    subplot(3,1,1);
        plot(t,Tau(:,1),'LineWidth',1);grid;
        ylabel('Tau_1 (Nm)');
        title('Señales de control');
        legend('Tau_1');
    subplot(3,1,2);
        plot(t,Tau(:,2),'LineWidth',1);grid;
        ylabel('Tau_2 (Nm)');
        legend('Tau_2');
    subplot(3,1,3);
        plot(t,Tau(:,3),'LineWidth',1);grid;
        ylabel('Tau_3 (N)');
        xlabel('t (s)');
        legend('Tau_3');

% Trayectoria XYZ en 3D
figure;
    plot3([x xr],[y yr],[z zr],'LineWidth',1);grid;
        title('Trayectoria real vs Referencia');
        xlabel('x (m)');
        ylabel('y (m)');
        zlabel('z (m)');
        legend('XYZ','XYZ_R');

% Error XYZ en modulo
figure;
    plot(t,sqrt((xr-x).^2+(yr-y).^2+(zr-z).^2),'LineWidth',1);grid;
        title('Error XYZ en módulo');        
        xlabel('t (s)');
        ylabel('Error en XYZ (m)');
        
        legend('Error en XYZ');
        
        
        %%
        close all
        clear
        
        XYZini=CinematicaDirecta([0 0 0]);
        XYZfin=CinematicaDirecta([0.5 0.5 0.5]);
        N_puntos=5;
        Tini=0.5;
        Duracion=0.5;
        Tsim=1.5;
        
        
        
        sim('slGTC_3gdl')
        
       
        figure;
    plot3(xr,yr,zr,'LineWidth',1);grid;