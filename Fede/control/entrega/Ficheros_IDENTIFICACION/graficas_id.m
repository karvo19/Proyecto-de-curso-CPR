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
    subplot(3,1,i);
    plot(t,q(:,i));grid;
    ylabel('Posicion (rad)');
    legend(insertAfter('q_', '_', int2str(i)))
        
end
xlabel('tiempo (s)');
subplot(3,1,1);title('Posiciones Articulares');


return


figure(3);
for i = 1:3
    subplot(3,1,i);
    plot(t,qd(:,i));grid;
    ylabel('Velocidad (rad/s)');
    legend(insertAfter('qd_', '_', int2str(i)))
end
    
xlabel('tiempo (s)');
subplot(3,1,1);title('Velocidades Articulares');

figure(4);

for i = 1:3
    subplot(3,1,i);
    plot(t,qdd(:,i));grid;
    ylabel('Aceleracion (rad/s^2)');
    legend(insertAfter('qdd_', '_', int2str(i)));
end
xlabel('tiempo (s)');
subplot(3,1,1);title('Aceleraciones Articulares');











%% 
clc
close all

Ts = 1e-3;

A_a=[5  4.5   2];
A_b=0*[2 1.15 0.0];
w_a=[0.5 0.5 0.5];   % En Hz
w_b=[2.5 2.5 1.5];   
Icc=[0 1 0.5];

tau=7;

sim('R3GDL');
[num den]=butter(2,2*pi*40/(pi/Ts));
qmsf =filter(num,den,qms);


qd_est=[];
qd_est(1,:)=[0 0 0];
for i=2:(length(qmsf)-1)
    qd_est(i,:)=(qmsf(i+1,:)-qmsf(i-1,:))/(2*Ts);
end
qd_est(length(qmsf),:)= qd_est(length(qmsf)-1,:);

[num den]=butter(4,2*pi*20/(pi/Ts));
qd_est_f=filter(num,den,qd_est);




qdd_est=[];
qdd_est(1,:)=[0 0 0];
for i=2:(length(qd_est_f)-1)
    qdd_est(i,:)=(qd_est_f(i+1,:)-qd_est_f(i-1,:))/(2*Ts);
end
qdd_est(length(qd_est_f),:)= qdd_est(length(qd_est_f)-1,:);


[num den]=butter(8,2*pi*10/(pi/Ts));
qdd_est_f=filtfilt(num,den,qdd_est);




% figure(2);
% 
% for i = 1:3
%     subplot(3,1,i);
%     plot(t,q(:,i));grid;
%     ylabel('Posicion (rad)');
%     legend(insertAfter('q_', '_', int2str(i)))
%         
% end
% xlabel('tiempo (s)');
% subplot(3,1,1);title('Posiciones Articulares');



figure(30);
for i = 1:3
    subplot(3,1,i);
    plot(t,qd(:,i),ts,qd_est_f(:,i));grid;
    ylabel('Velocidad (rad/s)');
    legend(insertAfter('qd_', '_', int2str(i)))
end

    
xlabel('tiempo (s)');
subplot(3,1,1);title('Velocidades Articulares');




figure(40);

for i = 1:3
    subplot(3,1,i);
    plot(t,qdd(:,i),ts,qdd_est_f(:,i));grid;
    ylabel('Aceleracion (rad/s^2)');
    legend(insertAfter('qdd_', '_', int2str(i)));
end
xlabel('tiempo (s)');
subplot(3,1,1);title('Aceleraciones Articulares');



