close all
figure;
    subplot(3,1,1);
        plot(t,XYZ(:,1),'LineWidth',1);grid;
        ylabel('X (m)');
        title('Posición XYZ');
        
    subplot(3,1,2);
        plot(t,XYZ(:,2),'LineWidth',1);grid;
        ylabel('Y (m)');
        
    subplot(3,1,3);
        plot(t,XYZ(:,3),'LineWidth',1);grid;
        ylabel('Z (m)');
        xlabel('t (s)');
        
figure;
    subplot(3,1,1);
        plot(t,Vxyz(:,1),'LineWidth',1);grid;
        ylabel('V_x (m/s)');
        title('Velocidades lineales Vxyz');
        
    subplot(3,1,2);
        plot(t,Vxyz(:,2),'LineWidth',1);grid;
        ylabel('V_y (m/s)');
        
    subplot(3,1,3);
        plot(t,Vxyz(:,3),'LineWidth',1);grid;
        ylabel('V_z (m/s)');
        xlabel('t (s)');
        
        
figure;
    subplot(3,1,1);
        plot(t,RPY(:,1),'LineWidth',1);grid;
        ylabel('Roll (rad)');
        title('Ángulos RPY');
        
    subplot(3,1,2);
        plot(t,RPY(:,2),'LineWidth',1);grid;
        ylabel('Pitch (rad)');
        
    subplot(3,1,3);
        plot(t,RPY(:,3),'LineWidth',1);grid;
        ylabel('Yaw (rad)');
        xlabel('t (s)');
       
        
figure;
    subplot(3,1,1);
        plot(t,Wxyz(:,1),'LineWidth',1);grid;
        ylabel('W_x (rad/s)');
        title('Velocidades angulares del sólido ríg.');
        
    subplot(3,1,2);
        plot(t,Wxyz(:,2),'LineWidth',1);grid;
        ylabel('W_y (rad/s)');
        
    subplot(3,1,3);
        plot(t,Wxyz(:,3),'LineWidth',1);grid;
        ylabel('W_z (rad/s)');
        xlabel('t (s)');
       

       