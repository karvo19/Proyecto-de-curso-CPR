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

if t == 0 
    ti = inicio;
    XYZi = XYZinicio;
    q_t = cin_in(XYZi);
    flag = 2;
    
    % Variables articulares
    L0 = 1.00;
    L1 = 0.40;
    L2 = 0.70;
    L3 = 0.50;
    
    % Condicion para que la recta esté en el espacio de tarea
    if (L2 - L3)^2 <= (xi^2 + yi^2 + (zi - L0 - L1)^2) && (xi^2 + yi^2 + (zi - L0 - L1)^2) <= (L2 + L3)^2
        if (L2 - L3)^2 <= (xf^2 + yf^2 + (zf - L0 - L1)^2) && (xf^2 + yf^2 + (zf - L0 - L1)^2) <= (L2 + L3)^2
            % si los dos extremos de la recta están en el espacio de trabajo
            % comprobamos si tambien lo está la recta que los une
            C = [0, 0, L0 + L1];
            Pini = [xi, yi, zi];
            u = [xf - xi, yf - yi, zf - zi]/((xf - xi)^2 + (yf - yi)^2 + (zf - zi)^2);

            PiniC = C - Pini;
            Proy = ((u*PiniC')/(u*u'))*u;

            d = norm(PiniC - Proy);

            if d >= (L2 - L3)
                % La recta está dentro del espacio de tarea. Calculamos:
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
end

if (t >= ti) && (t < (ti+T))

    if flag == 1
        
        XYZf = XYZi + (XYZfin-XYZinicio)/duracion*T;
        q_i = cin_in(XYZi);
        q_f = cin_in(XYZf);
        
        qd_i = [0 0 0]';
        qd_f = [0 0 0]';
        
        a = q_i;
        b = qd_i;
        c = 3/T^2*(q_f-q_i)-1/T*(qd_f+2*qd_i);
        d = -2/T^3*(q_f-q_i)+1/T^2*(qd_f+qd_i);
        
        XYZi = XYZf;
        flag = 0;
    end        
    
    if flag == 0
        q_t = a+b*(t-ti)+c*(t-ti)^2+d*(t-ti)^3;
    end
    
elseif t >= (ti+T)
    ti = t;
    flag = 1;
end

trayectoria = q_t;

return

