function trayectoria = GTCL_R3GDL(in)

xi = in(1);
yi = in(2);
zi = in(3);

xf = in(4);
yf = in(5);
zf = in(6);

n = in(7);

ti = in(8);

d = in(9);

t = in(10);

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
            q = calculos(in)
        else
            disp('La trayectoria fijada no es valida. Atraviesa zonas no alcanzables')
        end
    else
        % Error: recta no valida
        disp('La trayectoria fijada no es valida. El punto final no es alcanzable')
    end
else
    % Error: recta no válida
    disp('La trayectoria fijada no es valida. El punto inicial no es alcanzable')
end

return

function q = calculos(in)

xi = in(1);
yi = in(2);
zi = in(3);

xf = in(4);
yf = in(5);
zf = in(6);

n = in(7);

ti = in(8);

d = in(9);

t = in(10);

% x = ((xf - xi)/(d)*(t-ti) + xi;
% y = ((yf - yi)/(d)*(t-ti) + yi;
% z = ((zf - zi)/(d)*(t-ti) + zi;

paso = d/(n + 1);
mx = (xf - xi)/d;
my = (yf - yi)/d;
mz = (zf - zi)/d;

x = zeros(n+2);
y = zeros(n+2);
z = zeros(n+2);
q = zeros([3, n + 2]);

for p = 0:(n+1)    
    x(p+1) = mx*(paso*p) + xi;
    y(p+1) = my*(paso*p) + yi;
    z(p+1) = mz*(paso*p) + zi;
end

for p = 0:(n+1)
    q(:,p+1) = CinematicaInversa([x(p+1),y(p+1),z(p+1)]);
end
return

