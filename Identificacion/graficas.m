% Gráficas para la estimación de parámetros

close all

% Excitación
% figure(100)
figure
for i=1:3
subplot(3,1,i);plot(ts,Ims(:,i)); grid on;  title(["I_"+ i]);
end

figure
% figure(200)
for i=1:3
subplot(3,1,i);plot(ts,qms(:,i)); grid on;  title(["qms_"+ i]);
end


figure
% figure(200)
for i=1:3
subplot(3,1,i);plot(ts,qdms(:,i),ts,qdmsf(:,i)); grid on;  title(["qdms_"+ i]);
end



figure
% figure(200)
for i=1:3
subplot(3,1,i);plot(ts,qdds(:,i),ts,qdd_est(:,i),ts,qddf(:,i)); grid on;  title(["qdd_"+ i]);
end

