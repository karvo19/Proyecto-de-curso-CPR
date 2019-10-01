function accesible(XYZinicio, XYZfin)

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
            disp('La trayectoria fijada es VALIDA')
        else
            disp('La trayectoria fijada NO es valida. Atraviesa zonas no alcanzables')
        end
    else
        % Error: recta no valida
        disp('La trayectoria fijada NO es valida. El punto final no es alcanzable')
    end
else
    % Error: recta no válida
    disp('La trayectoria fijada NO es valida. El punto inicial no es alcanzable')
end
    
return