% % % q_modelo vs qr
% % figure;
% %     subplot(3,1,1);
% %         plot(t,[q_modelo(:,1) qr(:,1)],'LineWidth',1);grid;
% %         ylabel('q_1 (rad)');
% %         title('q_{modelo} frente a qr');
% %         legend('q_1','qr_1');
% %     subplot(3,1,2);
% %         plot(t,[q_modelo(:,2) qr(:,2)],'LineWidth',1);grid;
% %         ylabel('q_2 (rad)');
% %         legend('q_2','qr_2');
% %     subplot(3,1,3);
% %         plot(t,[q_modelo(:,3) qr(:,3)],'LineWidth',1);grid;
% %         ylabel('q_3 (m)');
% %         xlabel('t (s)');
% %         legend('q_3','qr_3');
% %         
% % % qd_modelo vs qdr
% % figure;
% %     subplot(3,1,1);
% %         plot(t,[qd_modelo(:,1) qdr(:,1)],'LineWidth',1);grid;
% %         ylabel('qd_1 (rad/s)');
% %         title('qd_{modelo} frente a qdr');
% %         legend('qd_1','qdr_1');
% %     subplot(3,1,2);
% %         plot(t,[qd_modelo(:,2) qdr(:,2)],'LineWidth',1);grid;
% %         ylabel('qd_2 (rad/s)');
% %         legend('qd_2','qdr_2');
% %     subplot(3,1,3);
% %         plot(t,[qd_modelo(:,3) qdr(:,3)],'LineWidth',1);grid;
% %         ylabel('qd_3 (m/s)');
% %         xlabel('t (s)');
% %         legend('qd_3','qdr_3');
% %         
% % % qdd_modelo vs qddr
% % figure;
% %     subplot(3,1,1);
% %         plot(t,[qdd_modelo(:,1) qddr(:,1)],'LineWidth',1);grid;
% %         ylabel('qdd_1 (rad/s^2)');
% %         title('qdd_{modelo} frente a qddr');
% %         legend('qdd_1','qddr_1');
% %     subplot(3,1,2);
% %         plot(t,[qdd_modelo(:,2) qddr(:,2)],'LineWidth',1);grid;
% %         ylabel('qdd_2 (rad/s^2)');
% %         legend('qdd_2','qddr_2');
% %     subplot(3,1,3);
% %         plot(t,[qdd_modelo(:,3) qddr(:,3)],'LineWidth',1);grid;
% %         ylabel('qdd_3 (m/s^2)');
% %         xlabel('t (s)');
% %         legend('qdd_3','qddr_3');
% %         
% % % Errores en posicion (q_modelo)
% % figure;
% %     subplot(3,1,1);
% %         plot(t,qr(:,1)-q_modelo(:,1),'LineWidth',1);grid;
% %         ylabel('error q_1 (rad)');
% %         title('Errores en posición (q_{modelo})');
% %         legend('error q_1');
% %     subplot(3,1,2);
% %         plot(t,qr(:,2)-q_modelo(:,2),'LineWidth',1);grid;
% %         ylabel('error q_2 (rad)');
% %         legend('error q_2');
% %     subplot(3,1,3);
% %         plot(t,qr(:,3)-q_modelo(:,3),'LineWidth',1);grid;
% %         ylabel('error q_3 (m)');
% %         xlabel('t (s)');
% %         legend('error q_3');
% % 
% % % Errores en velocidad (qd_modelo)
% % figure;
% %     subplot(3,1,1);
% %         plot(t,qdr(:,1)-qd_modelo(:,1),'LineWidth',1);grid;
% %         ylabel('error qd_1 (rad/s)');
% %         title('Errores en velocidad (qd_{modelo})');
% %         legend('error qd_1');
% %     subplot(3,1,2);
% %         plot(t,qdr(:,2)-qd_modelo(:,2),'LineWidth',1);grid;
% %         ylabel('error qd_2 (rad/s)');
% %         legend('error qd_2');
% %     subplot(3,1,3);
% %         plot(t,qdr(:,3)-qd_modelo(:,3),'LineWidth',1);grid;
% %         ylabel('error qd_3 (m/s)');
% %         xlabel('t (s)');
% %         legend('error qd_3');
% % 
% % % Errores en aceleracion (qdd_modelo)
% % figure;
% %     subplot(3,1,1);
% %         plot(t,qddr(:,1)-qdd_modelo(:,1),'LineWidth',1);grid;
% %         ylabel('error qdd_1 (rad/s^2)');
% %         title('Errores en aceleración (qdd_{modelo})');
% %         legend('error qdd_1');
% %     subplot(3,1,2);
% %         plot(t,qddr(:,2)-qdd_modelo(:,2),'LineWidth',1);grid;
% %         ylabel('error qdd_2 (rad/s^2)');
% %         legend('error qdd_2');
% %     subplot(3,1,3);
% %         plot(t,qddr(:,3)-qdd_modelo(:,3),'LineWidth',1);grid;
% %         ylabel('error qdd_3 (m/s^2)');
% %         xlabel('t (s)');
% %         legend('error qdd_3');
% % 
% % % Señales de control (Ims_modelo)
% % figure;
% %     subplot(3,1,1);
% %         plot(t,Im_modelo(:,1),'LineWidth',1);grid;
% %         ylabel('Im_1 (Nm)');
% %         title('Señales de control para el modelo');
% %         legend('Im_1');
% %     subplot(3,1,2);
% %         plot(t,Im_modelo(:,2),'LineWidth',1);grid;
% %         ylabel('Im_2 (Nm)');
% %         legend('Im_2');
% %     subplot(3,1,3);
% %         plot(t,Im_modelo(:,3),'LineWidth',1);grid;
% %         ylabel('Im_3 (N)');
% %         xlabel('t (s)');
% %         legend('Im_3');
% % 
% % % Trayectoria XYZ en 3D para el modelo
% % figure;
% %     plot3([x_modelo xr],[y_modelo yr],[z_modelo zr],'LineWidth',1);grid;
% %         title('Trayectoria del modelo vs Referencia');
% %         xlabel('x (m)');
% %         ylabel('y (m)');
% %         zlabel('z (m)');
% %         legend('XYZ','XYZ_R');
% % 
% % % Error XYZ en modulo
% % figure;
% %     plot(t,sqrt((xr-x_modelo).^2+(yr-y_modelo).^2+(zr-z_modelo).^2),'LineWidth',1);grid;
% %         title('Error XYZ en módulo del modelo');        
% %         xlabel('t (s)');
% %         ylabel('Error en XYZ (m)');
% %         legend('Error en XYZ');
        
% q_real vs qr
figure('Renderer', 'painters', 'Position', [100 100 1000 500]);
    subplot(3,2,1);
        plot(ts,[qms(:,1) qr(:,1)],'LineWidth',1);grid;
        ylabel('q_1 (rad)');
        title('q_{real} frente a qr');
        legend('q_1','qr_1');
    subplot(3,2,3);
        plot(ts,[qms(:,2) qr(:,2)],'LineWidth',1);grid;
        ylabel('q_2 (rad)');
        legend('q_2','qr_2');
    subplot(3,2,5);
        plot(ts,[qms(:,3) qr(:,3)],'LineWidth',1);grid;
        ylabel('q_3 (m)');
        xlabel('t (s)');
        legend('q_3','qr_3');
        
        % Errores en posicion (q_real)
%figure('Renderer', 'painters', 'Position', [500 100 400 500]);
    subplot(3,2,2);
        plot(ts,qr(:,1)-qms(:,1),'LineWidth',1);grid;
        ylabel('error q_1 (rad)');
        title('Errores en posición (q_{real})');
    subplot(3,2,4);
        plot(ts,qr(:,2)-qms(:,2),'LineWidth',1);grid;
        ylabel('error q_2 (rad)');
    subplot(3,2,6);
        plot(ts,qr(:,3)-qms(:,3),'LineWidth',1);grid;
        ylabel('error q_3 (m)');
        xlabel('t (s)');
        

        
% qd_real vs qdr
figure('Renderer', 'painters', 'Position', [100 100 1000 500]);
    subplot(3,2,1);
        plot(ts,[qpms(:,1) qpr(:,1)],'LineWidth',1);grid;
        ylabel('qd_1 (rad/s)');
        title('qd_{real} frente a qdr');
        legend('qd_1','qdr_1');
    subplot(3,2,3);
        plot(ts,[qpms(:,2) qpr(:,2)],'LineWidth',1);grid;
        ylabel('qd_2 (rad/s)');
        legend('qd_2','qdr_2');
    subplot(3,2,5);
        plot(ts,[qpms(:,3) qpr(:,3)],'LineWidth',1);grid;
        ylabel('qd_3 (m/s)');
        xlabel('t (s)');
        legend('qd_3','qdr_3');
        


% Errores en velocidad (qd_real)
%figure('Renderer', 'painters', 'Position', [500 100 400 500]);
    subplot(3,2,2);
        plot(ts,qpr(:,1)-qpms(:,1),'LineWidth',1);grid;
        ylabel('error qd_1 (rad/s)');
        title('Errores en velocidad (qd_{real})');
        
    subplot(3,2,4);
        plot(ts,qpr(:,2)-qpms(:,2),'LineWidth',1);grid;
        ylabel('error qd_2 (rad/s)');
        
    subplot(3,2,6);
        plot(ts,qpr(:,3)-qpms(:,3),'LineWidth',1);grid;
        ylabel('error qd_3 (m/s)');
        xlabel('t (s)');
        

% %         % qdd_real vs qddr
% % figure('Renderer', 'painters', 'Position', [100 100 1000 500]);
% %     subplot(3,2,1);
% %         plot(t,[qdd_real(:,1) qddr(:,1)],'LineWidth',1);grid;
% %         ylabel('qdd_1 (rad/s^2)');
% %         title('qdd_{real} frente a qddr');
% %         legend('qdd_1','qddr_1');
% %     subplot(3,2,3);
% %         plot(t,[qdd_real(:,2) qddr(:,2)],'LineWidth',1);grid;
% %         ylabel('qdd_2 (rad/s^2)');
% %         legend('qdd_2','qddr_2');
% %     subplot(3,2,5);
% %         plot(t,[qdd_real(:,3) qddr(:,3)],'LineWidth',1);grid;
% %         ylabel('qdd_3 (m/s^2)');
% %         xlabel('t (s)');
% %         legend('qdd_3','qddr_3');
% %         
% % % Errores en aceleracion (qdd_real)
% % %figure('Renderer', 'painters', 'Position', [500 100 400 500]);
% %     subplot(3,2,2);
% %         plot(t,qddr(:,1)-qdd_real(:,1),'LineWidth',1);grid;
% %         ylabel('error qdd_1 (rad/s^2)');
% %         title('Errores en aceleración (qdd_{real})');
% %         
% %     subplot(3,2,4);
% %         plot(t,qddr(:,2)-qdd_real(:,2),'LineWidth',1);grid;
% %         ylabel('error qdd_2 (rad/s^2)');
% %         
% %     subplot(3,2,6);
% %         plot(t,qddr(:,3)-qdd_real(:,3),'LineWidth',1);grid;
% %         ylabel('error qdd_3 (m/s^2)');
% %         xlabel('t (s)');
        

% Señales de control (Ims_real)
figure('Renderer', 'painters', 'Position', [100 100 500 500]);
    subplot(3,1,1);
        plot(ts,Ims(:,1),'LineWidth',1);grid;
        ylabel('Im_1 (Nm)');
        title('Señales de control para el real');
       
    subplot(3,1,2);
        plot(ts,Ims(:,2),'LineWidth',1);grid;
        ylabel('Im_2 (Nm)');
       
    subplot(3,1,3);
        plot(ts,Ims(:,3),'LineWidth',1);grid;
        ylabel('Im_3 (N)');
        xlabel('t (s)');
        

% % % Trayectoria XYZ en 3D para el real
% % figure('Renderer', 'painters', 'Position', [500 100 400 500]);
% %     plot3([x_real xr],[y_real yr],[z_real zr],'LineWidth',1);grid;
% %         title('Trayectoria del real vs Referencia');
% %         xlabel('x (m)');
% %         ylabel('y (m)');
% %         zlabel('z (m)');
% %         legend('XYZ','XYZ_R');

% Error XYZ en modulo
figure('Renderer', 'painters', 'Position', [100 100 500 500]);

    plot(ts,sqrt((xr-x).^2+(yr-y).^2+(zr-z).^2),'LineWidth',1);grid;
        title('Error XYZ en módulo del real');        
        xlabel('t (s)');
        ylabel('Error en XYZ (m)');
        legend('Error en XYZ');