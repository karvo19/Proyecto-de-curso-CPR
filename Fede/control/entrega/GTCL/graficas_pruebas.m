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