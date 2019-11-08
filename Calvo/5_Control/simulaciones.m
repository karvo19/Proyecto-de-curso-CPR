% Variables para el simulador
    % Tiempo de simulacion
        Tsim = 0.8;
    
    % Trayectoria
        XYZini = [1;0;1.2];
        XYZfin = [1.15;-0.15;1.35];
        % XYZfin = [-1;0;1.2];
        XYZfin = [5;-7;10]; %trayectoria exigente
        
        N_puntos = 10;
        Tini = 0.1;
        Duracion = 0.5;
        
    % Control utilizado
        % PD con cancelacion                <- 1
        % PD sin cancelacion                <- 2
        % PID analitico sin cancelacion     <- 3
        % PID frecuencial sin cancelacion   <- 4
        % Precompensacion de G              <- 5
        % Precompensacion de V y G          <- 6
        % Feed forward                      <- 7
        % Control por par calculado         <- 8
        
        global control;
        control = 8;
        
    % Llamada al script que carga las K del control
        controles
        
    % Para simular en discreto poner la siguiente variable a 1
        discreto = 1;
        
        global Tm;
        Tm = 0.001;
        
    % ejecutamos la simulacion
        if discreto == 1
            sim('slGTC_3gdl_script_discreto.mdl');
            disp('Se esta simulando en discreto')
        elseif control == 1 ||  control == 2 || control == 3 || control == 4
            sim('slGTC_3gdl.mdl');
        elseif control == 5
            sim('slGTC_3gdl_G.mdl');
        elseif control == 6
            sim('slGTC_3gdl_VG.mdl');
        elseif control == 7 || control == 8
            sim('slGTC_3gdl_script.mdl');
        else
            disp('No se puede simular')
        end         
    
    % dibujamos graficas
        graficas
        
    % Para las simulaciones en discreto seleccionar el bloque donde esta la
    % funcion Control.m y ejecutar el siguiente comando:
        % set_param(gcb,'SampleTime','0.001')