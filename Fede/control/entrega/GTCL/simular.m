% Simulacion del GTCL
clear

Tsim = 2;
XYZini = CinematicaDirecta([0 0 0]);
XYZfin = CinematicaDirecta([1 1 1]);%([pi 3*pi/4 -pi/5]);
n = 5;
t_ini = 0.5;
duracion = 1;

numero_de_simulaciones = 1;

tic
for i = 1:numero_de_simulaciones
    sim('GTCL.mdl');
end
toc

graficas_gtcl;