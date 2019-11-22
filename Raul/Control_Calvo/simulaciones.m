% Variables para el simulador
    % Tiempo de simulacion
        Tsim = 2;

    % Trayectoria
        XYZini = CinematicaDirecta([0 0 0]);
        XYZfin = CinematicaDirecta([1 1 1]);
        
        n = 5;
        t_ini = 0.5;
        duracion = 1;
        
    % Control utilizado
        % PD sin cancelacion                <- 1
        
    % Controles del año pasado en controles.m no actualizados de momento
        % PID analitico sin cancelacion     <- 3
        % PID frecuencial sin cancelacion   <- 4
        % Precompensacion de G              <- 5
        % Precompensacion de V y G          <- 6
        % Feed forward                      <- 7
        % Control por par calculado         <- 8
        
        global control;
        control = 1;
        
    % Llamada al script que carga las K del control
        controles
        
        global Tm;
        Tm = 0.001;
        
    % ejecutamos la simulacion
        sim('slGTC_3gdl.mdl');
        
    % dibujamos graficas
        graficas
        
    % Para las simulaciones en discreto seleccionar el bloque donde esta la
    % funcion Control.m y ejecutar el siguiente comando:
        % set_param(gcb,'SampleTime','0.001')