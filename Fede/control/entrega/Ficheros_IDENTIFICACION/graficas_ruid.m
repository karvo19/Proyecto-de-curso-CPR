% Graficas:
close all
figure(1);

for i = 1:3
    subplot(3,1,i);
    plot(t,Im(:,i));grid;
    ylabel('Intensidad (A)');
    legend(insertAfter('Im_', '_', int2str(i)));
end
xlabel('tiempo (s)');
subplot(3,1,1);title('Intensidades de los motores');


figure(2);

for i = 1:3
  
    subplot(3,1,i);plot(ts,qms(:,i));grid on;
    ylabel('Posicion (rad)');
    legend(insertAfter('q_', '_', int2str(i)))
        
end
xlabel('tiempo (s)');
subplot(3,1,1);title('Posiciones Articulares');


figure(3);
for i = 1:3
    subplot(3,1,i);
    plot(ts,qd_est(:,i),ts,qd_est_f(:,i));grid;
    ylabel('Velocidad (rad/s)');
    legend(insertAfter('qd_ est', '_', int2str(i)),insertAfter('qd_ est f', '_', int2str(i)));
end

    
xlabel('tiempo (s)');
subplot(3,1,1);title('Velocidades (derivadas y filtradas)');




figure(4);

for i = 1:3
    subplot(3,1,i);
    plot(ts,qdd_est(:,i),ts,qdd_est_f(:,i));grid;
    ylabel('Aceleracion (rad/s^2)');
    legend(insertAfter('qdd_ est', '_', int2str(i)),insertAfter('qdd_ est f', '_', int2str(i)));
end
xlabel('tiempo (s)');
subplot(3,1,1);title('Aceleraciones Articulares (derivadas y filtradas)');


