function trayectoria = GTCL_R3GDL(in)

XYZinicio = [in(1) in(2) in(3)]';
XYZfin = [in(4) in(5) in(6)]';

n = in(7);

inicio = in(8);

duracion = in(9);

t = in(10);

T = duracion/(n+1);

persistent flag;
persistent a;
persistent b;
persistent c;
persistent d;
persistent t_tramos;

% t_tramos:     inicio         inicio+T     inicio+2T   inicio+...T   inicio+(n-1)T   inicio+nT  inicio+(n+1)T
% trayectoria: (inicio)----------(p1)---------(p2)---------(...)----------(pn-1)----------(pn)--------(fin)
% numero de tramo:         1             2            3             n-1              n           n+1

% set up de las variables y calculos/comprobaciones a realizar unicamente la primera vez
if t == 0
    tramo = 0;
    flag = 2;
    
    % Dimensiones de los eslabones
    L0 = 1.00;
    L1 = 0.40;
    L2 = 0.70;
    L3 = 0.50;
    
    % Condicion para que la recta est� en el espacio de tarea
    if (L2 - L3)^2 <= (XYZinicio(1)^2 + XYZinicio(2)^2 + (XYZinicio(3) - L0 - L1)^2) && (XYZinicio(1)^2 + XYZinicio(2)^2 + (XYZinicio(3) - L0 - L1)^2) <= (L2 + L3)^2
        if (L2 - L3)^2 <= (XYZfin(1)^2 + XYZfin(2)^2 + (XYZfin(3) - L0 - L1)^2) && (XYZfin(1)^2 + XYZfin(2)^2 + (XYZfin(3) - L0 - L1)^2) <= (L2 + L3)^2
            % si los dos extremos de la recta est�n en el espacio de trabajo
            % comprobamos si tambien lo est� la recta que los une
            C = [0, 0, L0 + L1];        % Centro de las esferas
            u = (XYZfin - XYZinicio)'/norm(XYZfin - XYZinicio); % Vector unitario en direccion de la trayectoria
            PiC = C - XYZinicio;    % Vector de XYZinicio a C
            Proy = ((u*PiC')/(u*u'))*u; % Proyeccion del vector PiC en direccion de u

            distancia = norm(PiC - Proy); % Menor distancia de C a la trayectoria

            if distancia >= (L2 - L3)
                % La recta est� dentro del espacio de tarea.
                flag = 1;
            else
                disp('La trayectoria fijada no es valida. Atraviesa zonas no alcanzables')
                set_param(gcs, 'SimulationCommand', 'stop')
            end
        else
            % Error: recta no valida
            disp('La trayectoria fijada no es valida. El punto final no es alcanzable')
            set_param(gcs, 'SimulationCommand', 'stop')
        end
    else
        % Error: recta no v�lida
        disp('La trayectoria fijada no es valida. El punto inicial no es alcanzable')
        set_param(gcs, 'SimulationCommand', 'stop')
    end
    
    if flag == 1
        % Calculamos los puntos muestreados de la trayectoria en coordenadas articulares
        q_t = zeros(3, n + 2);
        t_tramos = zeros(1, n + 2);
        pendiente = (XYZfin - XYZinicio)/duracion;
        for punto = 0:(n+1)
            q_t(:,punto+1) = CinematicaInversa((pendiente*T*punto + XYZinicio));
            % Calculamos los tiempos a los que comienza cada tramo
            t_tramos(punto+1) = inicio + T * punto;
        end

        % M�todo heur�stico para obtener las velocidades de cada tramo
        qd_t = zeros(3, n + 2);
        qd_t(:, 1) = [0 0 0]';
        qd_t(:, n + 2) = [0 0 0]';
        for i = 2:(n + 1)
            if (sign(q_t(:,i) - q_t(:,i-1)) ~= sign(q_t(:,i+1) - q_t(:,i)))
                qd_t(:,i) = [0 0 0]';
            else
                qd_t(:,i) = [((q_t(:,i+1) - q_t(:,i))/T + (q_t(:,i) - q_t(:,i))/T)/2];
            end
        end

        % Interpolamos cada par de puntos con un polinomio de orden 3
        a = zeros(3, n + 1);
        b = zeros(3, n + 1);
        c = zeros(3, n + 1);
        d = zeros(3, n + 1);
        for i = 1:(n+1)
            a(:, i) = q_t(:,i);
            b(:, i) = qd_t(:,i);
            c(:, i) = 3/T^2 * (q_t(:,i+1) - q_t(:,i)) - 1/T * (qd_t(:,i+1) + 2*qd_t(:,i));
            d(:, i) = - 2/T^3 * (q_t(:,i+1) - q_t(:,i)) + 1/T^2 * (qd_t(:,i+1) + qd_t(:,i));
        end
        
        flag = 0;
    end
end

% Calculos a realizar una vez por llamada a la funci�n:
    % Comprobamos en que tramo ha sido llamada la funcion
    % t < tiempo de inicio (reposo inicial) --> ref = q_inicio
    % t > tiempo de inicio + duracion (reposo final) --> ref = q_fin
    % cc: ref --> q_t = a+b*(t-ti)+c*(t-ti)^2+d*(t-ti)^3;
    
    
    % Evaluamos la ecuacion para el tramo y tiempo actual
    trayectoria = a(:, tramo) + b(:, tramo)*(t - t_tramos(tramo)) + c(:, tramo)*(t - t_tramos(tramo))^2 + d(:, tramo)*(t - t_tramos(tramo))^3;

return