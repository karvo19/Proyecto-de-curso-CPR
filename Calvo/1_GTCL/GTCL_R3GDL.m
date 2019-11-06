function trayectoria = GTCL_R3GDL(in)

XYZinicio = [in(1) in(2) in(3)]';
XYZfin = [in(4) in(5) in(6)]';

n = in(7);

inicio = in(8);

duracion = in(9);

t = in(10);

T = duracion/(n+1);

persistent flag;
persistent q;
persistent a;
persistent b;
persistent c;
persistent d;
persistent t_tramos;

% tiempo:       inicio         inicio+T     inicio+2T   inicio+...T   inicio+(n-1)T   inicio+nT  inicio+(n+1)T
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
    
    % Condicion para que la recta esté en el espacio de tarea
    if (L2 - L3)^2 <= (XYZinicio(1)^2 + XYZinicio(2)^2 + (XYZinicio(3) - L0 - L1)^2) && (XYZinicio(1)^2 + XYZinicio(2)^2 + (XYZinicio(3) - L0 - L1)^2) <= (L2 + L3)^2
        if (L2 - L3)^2 <= (XYZfin(1)^2 + XYZfin(2)^2 + (XYZfin(3) - L0 - L1)^2) && (XYZfin(1)^2 + XYZfin(2)^2 + (XYZfin(3) - L0 - L1)^2) <= (L2 + L3)^2
            % si los dos extremos de la recta están en el espacio de trabajo
            % comprobamos si tambien lo está la recta que los une
            C = [0; 0; L0 + L1];        % Centro de las esferas
            u = (XYZfin - XYZinicio)'/norm(XYZfin - XYZinicio); % Vector unitario en direccion de la trayectoria
            PiC = C - XYZinicio;    % Vector de XYZinicio a C
            Proy = ((u*PiC)/(u*u'))*u; % Proyeccion del vector PiC en direccion de u

            distancia = norm(PiC - Proy'); % Menor distancia de C a la trayectoria

            if distancia >= (L2 - L3)
                % La recta está dentro del espacio de tarea.
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
        % Error: recta no válida
        disp('La trayectoria fijada no es valida. El punto inicial no es alcanzable')
        set_param(gcs, 'SimulationCommand', 'stop')
    end
    
    if flag == 1
        % Calculamos los puntos muestreados de la trayectoria en coordenadas articulares
        q = zeros(3, n + 2);
        t_tramos = zeros(1, n + 2);
        pendiente = (XYZfin - XYZinicio)/duracion;
        for punto = 0:(n+1)
            aux = (pendiente*T*punto + XYZinicio);
            q(:, punto+1) = CinematicaInversa(aux);
            % Calculamos los tiempos a los que comienza cada tramo
            t_tramos(punto+1) = inicio + T * punto;
        end

        % Método heurístico para obtener las velocidades de cada tramo
        qd = zeros(3, n + 2);
        qd(:, 1) = [0 0 0]';
        qd(:, n + 2) = [0 0 0]';
        for i = 2:(n + 1)
            if (sign(q(:,i) - q(:,i-1)) ~= sign(q(:,i+1) - q(:,i)))
                qd(:,i) = [0 0 0]';
            else
                qd(:,i) = [((q(:,i+1) - q(:,i))/T + (q(:,i) - q(:,i-1))/T)/2];
            end
        end

        % Interpolamos cada par de puntos con un polinomio de orden 3
        a = zeros(3, n + 1);
        b = zeros(3, n + 1);
        c = zeros(3, n + 1);
        d = zeros(3, n + 1);
        for i = 1:(n+1)
            a(:, i) = q(:,i);
            b(:, i) = qd(:,i);
            c(:, i) = 3/T^2 * (q(:,i+1) - q(:,i)) - 1/T * (qd(:,i+1) + 2*qd(:,i));
            d(:, i) = - 2/T^3 * (q(:,i+1) - q(:,i)) + 1/T^2 * (qd(:,i+1) + qd(:,i));
        end
        
        flag = 0;
    end
    q
end

% Calculos a realizar una vez por llamada a la función:
% Comprobamos en que tramo ha sido llamada la funcion
if t <= inicio
    % t < tiempo de inicio (reposo inicial) --> ref = q_inicio
    trayectoria = [q(:, 1); [0 0 0]'; [0 0 0]'];
elseif t >= inicio + duracion
    % t > tiempo de inicio + duracion (reposo final) --> ref = q_fin
    trayectoria = [q(:, n + 2); [0 0 0]'; [0 0 0]'];
else
    % Hay que detectar en que tramo nos encontramos
    for i = 1:(n+1)
        if t_tramos(i) <= t && t < t_tramos(i+1)
            tramo = i;
            break
        end
    end
    % Evaluamos la ecuacion para el tramo y tiempo actual
        % q = a + b*(t - ti) + c*(t - ti)^2 + d*(t - ti)^3
        % qd = b + c*(2*t - 2*ti) + 3*d*(t - ti)^2
        % qdd = 2*c + 3*d*(2*t - 2*ti)
    q_t = a(:, tramo) + b(:, tramo)*(t - t_tramos(tramo)) + c(:, tramo)*(t - t_tramos(tramo))^2 + d(:, tramo)*(t - t_tramos(tramo))^3;
    qd_t = b(:, tramo) + c(:, tramo)*(2*t - 2*t_tramos(tramo)) + 3*d(:, tramo)*(t - t_tramos(tramo))^2;
    qdd_t = 2*c(:, tramo) + 3*d(:, tramo)*(2*t - 2*t_tramos(tramo));

    trayectoria = [q_t; qd_t; qdd_t];
end
return