% Graficas:
figure(1);
title('Intensidades de los motores');
for i = 1:3
    subplot(3,1,i);
    plot(t,Im(:,i),ts,Ims(:,i));grid;
    ylabel('Intensidad (A)');
    legend(insertAfter('Im_', '_', int2str(i)), ...
        insertAfter('Ims_', '_', int2str(i)));
end
xlabel('timepo (s)');

figure(2);
title('Posiciones Articulares');
for i = 1:3
    subplot(3,1,i);
    plot(t,q(:,i),ts,qs(:,i),t,qm(:,i),ts,qms(:,i));grid;
    ylabel('Posicion (rad)');
    legend(insertAfter('q_', '_', int2str(i)), ...
        insertAfter('qs_', '_', int2str(i)), ...
        insertAfter('qm_', '_', int2str(i)), ...
        insertAfter('qms_', '_', int2str(i)));
end
xlabel('timepo (s)');

figure(3);
title('Velocidades Articulares');
for i = 1:3
    subplot(3,1,i);
    plot(t,qd(:,i),ts,qds(:,i),t,qdm(:,i),ts,qdms(:,i));grid;
    ylabel('Velocidad (rad/s)');
    legend(insertAfter('qd_', '_', int2str(i)), ...
        insertAfter('qds_', '_', int2str(i)), ...
        insertAfter('qdm_', '_', int2str(i)), ...
        insertAfter('qdms_', '_', int2str(i)));
end
xlabel('timepo (s)');

figure(4);
title('Aceleraciones Articulares');
for i = 1:3
    subplot(3,1,i);
    plot(t,qdd(:,i),ts,qdds(:,i));grid;
    ylabel('Aceleracion (rad/s^2)');
    legend(insertAfter('qdd_', '_', int2str(i)), ...
        insertAfter('qdds_', '_', int2str(i)));
end
xlabel('timepo (s)');