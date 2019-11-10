function [ki kp kd] = ganancias(control_id)
global control;

control = control_id;
controles
ki = [ki1 ki2 ki3]';
kp = [kp1 kp2 kp3]';
kd = [kd1 kd2 kd3]';