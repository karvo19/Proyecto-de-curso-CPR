% Simulacion del GTCL
clear

Tsim = 2;
XYZini = CinematicaDirecta([0 0 0]);
XYZfin = CinematicaDirecta([pi 3*pi/4 -pi/5]);
n = 5;
t_ini = 0.5;
duracion = 1;

tic
for i = 1:100
    sim('GTCL.mdl');
end
toc