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
        % PID analitico sin cancelacion     <- 2
        % PID frecuencial sin cancelacion   <- 3
        % Precompensacion de G              <- 4
        % Precompensacion de V y G          <- 5
        % Feed forward                      <- 6       
        % Control por par calculado         <- 7
        
        global control;
        global control_4;
        control = 6;

        % Control a usar con el precompensador de G (control_4 € [1,3])
        control_4 = 3;
        
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