function trayectoria = GTCL_R3GDL(in)

XYZinicio = [in(1) in(2) in(3)]';
XYZfin = [in(4) in(5) in(6)]';

n = in(7);

inicio = in(8);

duracion = in(9);

t = in(10);

T = duracion/(n+1);

persistent ti;
persistent flag;
persistent XYZi;
persistent XYZf;
persistent a;
persistent b;
persistent c;
persistent d;
persistent q_t;
persistent qd_i; %no se si necesariamente debe ser persistent
persistent q_1_t; %esta si, es donde se guarda el valor de la posicion del punto anterior para heur

if t == 0 
    ti = inicio;
    XYZi = XYZinicio;
    q_t = CinematicaInversa(XYZi);
    qd_i=[0 0 0]';
    q_1_t=CinematicaInversa(XYZi);
    flag = 2;
    
    % Variables articulares
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
            u = (XYZfin-XYZinicio)'/norm(XYZfin-XYZinicio); % Vector unitario en direccion de la trayectoria
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
end

if (t >= ti) && (t < (ti+T))

    if flag == 1
        
        XYZf = XYZi + (XYZfin-XYZinicio)/duracion*T;
        q_i = CinematicaInversa(XYZi);
        q_f = CinematicaInversa(XYZf);
        
%         if (sign(q_i-q_1_t)~=sign(q_f-q_i))
%             qd_f=[0 0 0]';
%         elseif (q_i==q_1_t)
%             qd_f=transpose([(q_f-q_i)/T+(q_i-q_1_t)/T]/2);
%         elseif (q_f==q_i)
%             qd_f=transpose([(q_f-q_i)/T+(q_i-q_1_t)/T]/2);
%         else
%             qd_f=transpose([(q_f-q_i)/T+(q_i-q_1_t)/T]/2);
%         end
        qd_f=[0 0 0]';
        qd_i=[0 0 0]';  
        
        a = q_i;
        b = qd_i;
        c=(3/T^2)*(q_f-q_i)-(1/T)*(qd_f+2*qd_i);
        d=(-2/T^3)*(q_f-q_i)+(1/T^2)*(qd_f+qd_i);
        
        XYZi = XYZf;
        flag = 0;
    end        
    
    if flag == 0
        q_t=a+b*(t-ti)+c*(t-ti)^2+d*(t-ti)^3;
    end
    
elseif t >= (ti+T)
    q_1_t=q_t;
    ti = t;
    flag = 1;
end

trayectoria = q_t;

return

