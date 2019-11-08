global control;

global kp1 kp2 kp3;
global ki1 ki2 ki3;
global kd1 kd2 kd3;

% syms q1 q2 q3 qd1 qd2 qd3;
% 
% % Matriz de Inercias
%   M = [(128*q3*cos(q2)^2)/25-(7847*sin(2*q2))/5000-(32*q3*sin(2*q2))/25+(8067*cos(q2)^2)/5000+(16*q3^2*cos(q2)^2)/5+474911/5000,0,0;
%       0,((16*q3)/5+64/25)*(q3+4/5)+4137/50,-32/25;
%       0,-32/25,939/20];
%   
%   M = vpa(M,5)
%  
% % Matriz de aceleraciones centrípetas y de Coriolis
%   V = [-(qd1*(31388*qd2*cos(2*q2)-25600*qd3-25600*qd3*cos(2*q2)+16134*qd2*sin(2*q2)+12800*qd3*sin(2*q2)-32000*q3*qd3+25600*q3*qd2*cos(2*q2)-32000*q3*qd3*cos(2*q2)+51200*q3*qd2*sin(2*q2)+32000*q3^2*qd2*sin(2*q2)-225))/10000;
%       (9*qd2)/625+(128*qd2*qd3)/25+(7847*qd1^2*cos(2*q2))/5000+(8067*qd1^2*sin(2*q2))/10000+(8*q3^2*qd1^2*sin(2*q2))/5+(32*q3*qd2*qd3)/5+(32*q3*qd1^2*cos(2*q2))/25+(64*q3*qd1^2*sin(2*q2))/25;
%       (9*qd3)/400-(64*qd1^2*cos(q2)^2)/25+(16*qd1^2*sin(2*q2))/25-(16*q3*qd2^2)/5-(64*qd2^2)/25-(16*q3*qd1^2*cos(q2)^2)/5];
%   
%   V = vpa(V,5)

% Simplificando y aplicando las consideraciones tomadas, las matrices M y V resultan en:

% M =
%  
% [ 94.982,     0,     0]
% [ 0,      82.74,     0]
% [ 0,          0, 46.95]

% V =
% 
%  0.0225*qd1
%  0.0144*qd2
%  0.0225*qd3

% Ecuación del robot
%    Tau = M*qpp + V + G

% PD con cancelacion                <- 1        
    if control == 1
        M11 = 94.982;
        M22 = 82.74;
        M33 = 46.95;

        V1 = 0.0225;
        V2 = 0.0144;
        V3 = 0.0225;
        
        % G11 = tf(1/V1,[M11/V1 V1/V1 0]);
        % G22 = tf(1/V2,[M22/V2 V2/V2 0]);
        % G33 = tf(1/V3,[M33/V3 V3/V3 0]);
        k1 = 1/V1;
        k2 = 1/V2;
        k3 = 1/V3;
        
        tau1 = M11/V1;
        tau2 = M22/V2;
        tau3 = M33/V3;
        
        Tm = 0.001;
        Wn = pi/Tm;        
        Wc = Wn/20;        
        tsbc = pi/Wc;
        
        % C(s) = Kc/K_i*(Tau_i*s+1)
        kc = 3/tsbc;     
        
        ki1 = 0;
        ki2 = 0;
        ki3 = 0;
        kp1 = kc/k1;
        kp2 = kc/k2;
        kp3 = kc/k3;
        kd1 = kp1*tau1;
        kd2 = kp2*tau2;
        kd3 = kp3*tau3;
    
% PD sin cancelacion                <- 2       
    elseif control == 2
        % M11 = 94.982;
        % M22 = 82.74;
        % M33 = 46.95;
        % 
        % V1 = 0.0225;
        % V2 = 0.0144;
        % V3 = 0.0225;
        % 
        % G11 = tf(1/V1,[M11/V1 V1/V1 0]);
        % G22 = tf(1/V2,[M22/V2 V2/V2 0]);
        % G33 = tf(1/V3,[M33/V3 V3/V3 0]);        
        % 
        % figure;bode(G11,logspace(0,3,1000));grid;title('Bode G11');
        % figure;bode(G22,logspace(0,3,1000));grid;title('Bode G22');
        % figure;bode(G33,logspace(0,3,1000));grid;title('Bode G33');
        
        Tm = 0.001;
        Wn = pi/Tm;        
        Wc = Wn/20;        
        tsbc = pi/Wc;
        
        Mfact1 = 0;
        Mfact2 = 0;
        Mfact3 = 0;
        
        Mfdes1 = 70;
        Mfdes2 = 70;
        Mfdes3 = 70;
        
        fi1 = Mfdes1 - Mfact1;
        fi2 = Mfdes2 - Mfact2;
        fi3 = Mfdes3 - Mfact3;
        
        tau1 = 1/Wc*tan(fi1*pi/180);
        tau2 = 1/Wc*tan(fi2*pi/180);
        tau3 = 1/Wc*tan(fi3*pi/180);
        
        % C11 = tf([tau1 1],1);
        % C22 = tf([tau2 1],1);
        % C33 = tf([tau3 1],1);
        % 
        % figure;bode(G11*C11,logspace(0,3,1000));grid;title('Bode Gba11');
        % figure;bode(G22*C22,logspace(0,3,1000));grid;title('Bode Gba22');
        % figure;bode(G33*C33,logspace(0,3,1000));grid;title('Bode Gba33');
        
        Mg1 = -118;
        Mg2 = -117;
        Mg3 = -112;
        
        ki1 = 0;
        ki2 = 0;
        ki3 = 0;
        kp1 = 10^(-Mg1/20);
        kp2 = 10^(-Mg2/20);
        kp3 = 10^(-Mg3/20);
        kd1 = kp1*tau1;
        kd2 = kp2*tau2;
        kd3 = kp3*tau3;
        
% PID analitico sin cancelacion     <- 3
    elseif control == 3
        M11 = 94.982;
        M22 = 82.74;
        M33 = 46.95;

        V1 = 0.0225;
        V2 = 0.0144;
        V3 = 0.0225;
        
        Tm = 0.001;
        Wn = pi/Tm;        
        Wc = Wn/20;        
        tsbc = pi/Wc;
        
        % Diseño de un PID analiticamente
        % G = k/(tau*s + 1)*S;
        % C = kc*(tauc*s + 1)^2/s;
        % Gba = C*G;
        % Gbc = C*G/(1 + C*G);
        %
        % Gbc = k*kc*(tauc*s + 1)^2/(taubc*s + 1)^3;
        % taubc_eq = 3*taubc;
        % tsbc = 0.02 = 3*taubc_eq;
        
        taubc = 0.02/(3*3);
        
        k1 = 1/V1;
        k2 = 1/V2;
        k3 = 1/V3;
        
        tau1 = M11/V1;
        tau2 = M22/V2;
        tau3 = M33/V3;
        
        kc1 = tau1/(k1*taubc^3);
        kc2 = tau2/(k2*taubc^3);
        kc3 = tau3/(k3*taubc^3);
        
        tauc1 = sqrt(3*taubc^2-1/(k1*kc1));
        tauc2 = sqrt(3*taubc^2-1/(k2*kc2));
        tauc3 = sqrt(3*taubc^2-1/(k3*kc3));
        
        % tauc = 3*taubc/2
        
        Ti1 = 2*tauc1;
        Ti2 = 2*tauc2;
        Ti3 = 2*tauc3;
        
        Td1 = tauc1^2/Ti1;
        Td2 = tauc2^2/Ti2;
        Td3 = tauc3^2/Ti3;
        
        kp1 = kc1*Ti1;
        kp2 = kc2*Ti2;
        kp3 = kc3*Ti3;
        
        ki1 = kp1/Ti1;
        ki2 = kp2/Ti2;
        ki3 = kp3/Ti3;
        kp1 = kp1;
        kp2 = kp2;
        kp3 = kp3;
        kd1 = kp1*Td1;
        kd2 = kp2*Td2;
        kd3 = kp3*Td3;
        
% PID frecuencial sin cancelacion   <- 4
    elseif control == 4
        % M11 = 94.982;
        % M22 = 82.74;
        % M33 = 46.95;
        % 
        % V1 = 0.0225;
        % V2 = 0.0144;
        % V3 = 0.0225;
        % 
        % G11 = tf(1/V1,[M11/V1 V1/V1 0]);
        % G22 = tf(1/V2,[M22/V2 V2/V2 0]);
        % G33 = tf(1/V3,[M33/V3 V3/V3 0]);        
        % 
        % figure;bode(G11,logspace(0,3,1000));grid;title('Bode G11');
        % figure;bode(G22,logspace(0,3,1000));grid;title('Bode G22');
        % figure;bode(G33,logspace(0,3,1000));grid;title('Bode G33');
        
        Tm = 0.001;
        Wn = pi/Tm;        
        Wc = Wn/20;        
        tsbc = pi/Wc;
        
        Mfact1 = 0;
        Mfact2 = 0;
        Mfact3 = 0;
        
        Mfdes1 = 80;
        Mfdes2 = 80;
        Mfdes3 = 80;
        
        fi1 = Mfdes1 - Mfact1;
        fi2 = Mfdes2 - Mfact2;
        fi3 = Mfdes3 - Mfact3;
        
        tauc1 = 1/Wc*tan((90+fi1)/2*pi/180);
        tauc2 = 1/Wc*tan((90+fi2)/2*pi/180);
        tauc3 = 1/Wc*tan((90+fi3)/2*pi/180);
        
        % C11 = tf(conv([tauc1 1],[tauc1 1]),[tauc1 0]);
        % C22 = tf(conv([tauc2 1],[tauc2 1]),[tauc2 0]);
        % C33 = tf(conv([tauc3 1],[tauc3 1]),[tauc3 0]);
        %  
        % figure;bode(G11*C11,logspace(0,3,1000));grid;title('Bode Gba11');
        % figure;bode(G22*C22,logspace(0,3,1000));grid;title('Bode Gba22');
        % figure;bode(G33*C33,logspace(0,3,1000));grid;title('Bode Gba33');
        
        Mg1 = -106;
        Mg2 = -105;
        Mg3 = -100;
        
        kc1 = 10^(-Mg1/20);
        kc2 = 10^(-Mg2/20);
        kc3 = 10^(-Mg3/20);
        
        Ti1 = 2*tauc1;
        Ti2 = 2*tauc2;
        Ti3 = 2*tauc3;
        
        Td1 = tauc1^2/Ti1;
        Td2 = tauc2^2/Ti2;
        Td3 = tauc3^2/Ti3;
        
        kp1 = kc1*Ti1/tauc1;
        kp2 = kc2*Ti2/tauc2;
        kp3 = kc3*Ti3/tauc2;
        
        ki1 = kp1/Ti1;
        ki2 = kp2/Ti2;
        ki3 = kp3/Ti3;
        kp1 = kp1;
        kp2 = kp2;
        kp3 = kp3;
        kd1 = kp1*Td1;
        kd2 = kp2*Td2;
        kd3 = kp3*Td3;
        
% Precompensacion de G              <- 5
    elseif control == 5
        
        % Junto con el precompensador de G hay que esar algun control
        
        % PD sin cancelacion <- 2
        ki1 = 0;
        ki2 = 0;
        ki3 = 0;
        kp1 = 7.9433e+05;
        kp2 = 7.0795e+05;
        kp3 = 3.9811e+05;
        kd1 = 1.3894e+04;
        kd2 = 1.2383e+04;
        kd3 = 6.9633e+03;
        
        % PID analitico sin cancelacion <- 3
        % ki1 = 8.6552e+09;
        % ki2 = 7.5397e+09;
        % ki3 = 4.2783e+09;
        % kp1 = 6.6628e+07;
        % kp2 = 5.8040e+07;
        % kp3 = 3.2935e+07;
        % kd1 = 1.2823e+05;
        % kd2 = 1.1170e+05;
        % kd3 = 6.3382e+04;
        
% Precompensacion de V y G          <- 6
    elseif control == 6
        
        %%%%%%%%%%%%%%%        PD         %%%%%%%%%%%%%%%%%%
        
        % M11 = 94.982;
        % M22 = 82.74;
        % M33 = 46.95;
        % 
        % G11 = tf(1/M11,[1 0 0]);
        % G22 = tf(1/M22,[1 0 0]);
        % G33 = tf(1/M33,[1 0 0]);        
        % 
        % figure;bode(G11,logspace(0,3,1000));grid;title('Bode G11');
        % figure;bode(G22,logspace(0,3,1000));grid;title('Bode G22');
        % figure;bode(G33,logspace(0,3,1000));grid;title('Bode G33');
        
        Tm = 0.001;
        Wn = pi/Tm;        
        Wc = Wn/20;        
        tsbc = pi/Wc;
        
        Mfact1 = 0;
        Mfact2 = 0;
        Mfact3 = 0;
        
        Mfdes1 = 80;
        Mfdes2 = 80;
        Mfdes3 = 80;
        
        fi1 = Mfdes1 - Mfact1;
        fi2 = Mfdes2 - Mfact2;
        fi3 = Mfdes3 - Mfact3;
        
        tau1 = 1/Wc*tan(fi1*pi/180);
        tau2 = 1/Wc*tan(fi2*pi/180);
        tau3 = 1/Wc*tan(fi3*pi/180);
        
        % C11 = tf([tau1 1],1);
        % C22 = tf([tau2 1],1);
        % C33 = tf([tau3 1],1);
        % 
        % figure;bode(G11*C11,logspace(0,3,1000));grid;title('Bode Gba11');
        % figure;bode(G22*C22,logspace(0,3,1000));grid;title('Bode Gba22');
        % figure;bode(G33*C33,logspace(0,3,1000));grid;title('Bode Gba33');
        
        Mg1 = -112;
        Mg2 = -111;
        Mg3 = -106;
        
        ki1 = 0;
        ki2 = 0;
        ki3 = 0;
        kp1 = 10^(-Mg1/20);
        kp2 = 10^(-Mg2/20);
        kp3 = 10^(-Mg3/20);
        kd1 = kp1*tau1;
        kd2 = kp2*tau2;
        kd3 = kp3*tau3;
        
        %%%%%%%%%%%%%%%        PID         %%%%%%%%%%%%%%%%%%
        
        % M11 = 94.982;
        % M22 = 82.74;
        % M33 = 46.95;
        % 
        % G11 = tf(1/M11,[1 0 0]);
        % G22 = tf(1/M22,[1 0 0]);
        % G33 = tf(1/M33,[1 0 0]);        
        % 
        % figure;bode(G11,logspace(0,3,1000));grid;title('Bode G11');
        % figure;bode(G22,logspace(0,3,1000));grid;title('Bode G22');
        % figure;bode(G33,logspace(0,3,1000));grid;title('Bode G33');
        
        Tm = 0.001;
        Wn = pi/Tm;        
        Wc = Wn/20;        
        tsbc = pi/Wc;
        
        Mfact1 = 0;
        Mfact2 = 0;
        Mfact3 = 0;
        
        Mfdes1 = 80;
        Mfdes2 = 80;
        Mfdes3 = 80;
        
        fi1 = Mfdes1 - Mfact1;
        fi2 = Mfdes2 - Mfact2;
        fi3 = Mfdes3 - Mfact3;
        
        tauc1 = 1/Wc*tan((90+fi1)/2*pi/180);
        tauc2 = 1/Wc*tan((90+fi2)/2*pi/180);
        tauc3 = 1/Wc*tan((90+fi3)/2*pi/180);
        
        % C11 = tf(conv([tauc1 1],[tauc1 1]),[tauc1 0]);
        % C22 = tf(conv([tauc2 1],[tauc2 1]),[tauc2 0]);
        % C33 = tf(conv([tauc3 1],[tauc3 1]),[tauc3 0]);
        %  
        % figure;bode(G11*C11,logspace(0,3,1000));grid;title('Bode Gba11');
        % figure;bode(G22*C22,logspace(0,3,1000));grid;title('Bode Gba22');
        % figure;bode(G33*C33,logspace(0,3,1000));grid;title('Bode Gba33');
        
        Mg1 = -106;
        Mg2 = -105;
        Mg3 = -100;
        
        kc1 = 10^(-Mg1/20);
        kc2 = 10^(-Mg2/20);
        kc3 = 10^(-Mg3/20);
        
        Ti1 = 2*tauc1;
        Ti2 = 2*tauc2;
        Ti3 = 2*tauc3;
        
        Td1 = tauc1^2/Ti1;
        Td2 = tauc2^2/Ti2;
        Td3 = tauc3^2/Ti3;
        
        kp1 = kc1*Ti1/tauc1;
        kp2 = kc2*Ti2/tauc2;
        kp3 = kc3*Ti3/tauc2;
        
        ki1 = kp1/Ti1;
        ki2 = kp2/Ti2;
        ki3 = kp3/Ti3;
        kp1 = kp1;
        kp2 = kp2;
        kp3 = kp3;
        kd1 = kp1*Td1;
        kd2 = kp2*Td2;
        kd3 = kp3*Td3;
        
% Feed forward                      <- 7
    elseif control == 7
        
        % M11 = 94.982;
        % M22 = 82.74;
        % M33 = 46.95;
        % 
        % G11 = tf(1/M11,[1 0 0]);
        % G22 = tf(1/M22,[1 0 0]);
        % G33 = tf(1/M33,[1 0 0]);        
        % 
        % figure;bode(G11,logspace(0,3,1000));grid;title('Bode G11');
        % figure;bode(G22,logspace(0,3,1000));grid;title('Bode G22');
        % figure;bode(G33,logspace(0,3,1000));grid;title('Bode G33');
        
        Tm = 0.001;
        Wn = pi/Tm;        
        Wc = Wn/20;        
        tsbc = pi/Wc;
        
        Mfact1 = 0;
        Mfact2 = 0;
        Mfact3 = 0;
        
        Mfdes1 = 80;
        Mfdes2 = 80;
        Mfdes3 = 80;
        
        fi1 = Mfdes1 - Mfact1;
        fi2 = Mfdes2 - Mfact2;
        fi3 = Mfdes3 - Mfact3;
        
        tauc1 = 1/Wc*tan((90+fi1)/2*pi/180);
        tauc2 = 1/Wc*tan((90+fi2)/2*pi/180);
        tauc3 = 1/Wc*tan((90+fi3)/2*pi/180);
        
        % C11 = tf(conv([tauc1 1],[tauc1 1]),[tauc1 0]);
        % C22 = tf(conv([tauc2 1],[tauc2 1]),[tauc2 0]);
        % C33 = tf(conv([tauc3 1],[tauc3 1]),[tauc3 0]);
        %  
        % figure;bode(G11*C11,logspace(0,3,1000));grid;title('Bode Gba11');
        % figure;bode(G22*C22,logspace(0,3,1000));grid;title('Bode Gba22');
        % figure;bode(G33*C33,logspace(0,3,1000));grid;title('Bode Gba33');
        
        Mg1 = -106;
        Mg2 = -105;
        Mg3 = -100;
        
        kc1 = 10^(-Mg1/20);
        kc2 = 10^(-Mg2/20);
        kc3 = 10^(-Mg3/20);
        
        Ti1 = 2*tauc1;
        Ti2 = 2*tauc2;
        Ti3 = 2*tauc3;
        
        Td1 = tauc1^2/Ti1;
        Td2 = tauc2^2/Ti2;
        Td3 = tauc3^2/Ti3;
        
        kp1 = kc1*Ti1/tauc1;
        kp2 = kc2*Ti2/tauc2;
        kp3 = kc3*Ti3/tauc2;
        
        ki1 = kp1/Ti1;
        ki2 = kp2/Ti2;
        ki3 = kp3/Ti3;
        kp1 = kp1;
        kp2 = kp2;
        kp3 = kp3;
        kd1 = kp1*Td1;
        kd2 = kp2*Td2;
        kd3 = kp3*Td3;
        
% Control por par calculado         <- 8
    elseif control == 8   
        
        % G(s) = 1/s^2
        
        % G11 = tf(1,[1 0 0]);
        % G22 = tf(1,[1 0 0]);
        % G33 = tf(1,[1 0 0]);
        
        Tm = 0.001;
        Wn = pi/Tm;        
        Wc = Wn/20;        
        tsbc = pi/Wc;
        
        Mfact1 = 0;
        Mfact2 = 0;
        Mfact3 = 0;
        
        Mfdes1 = 80;
        Mfdes2 = 80;
        Mfdes3 = 80;
        
        fi1 = Mfdes1 - Mfact1;
        fi2 = Mfdes2 - Mfact2;
        fi3 = Mfdes3 - Mfact3;
        
        tauc1 = 1/Wc*tan((90+fi1)/2*pi/180);
        tauc2 = 1/Wc*tan((90+fi2)/2*pi/180);
        tauc3 = 1/Wc*tan((90+fi3)/2*pi/180);
        
        % C11 = tf(conv([tauc1 1],[tauc1 1]),[tauc1 0]);
        % C22 = tf(conv([tauc2 1],[tauc2 1]),[tauc2 0]);
        % C33 = tf(conv([tauc3 1],[tauc3 1]),[tauc3 0]);
        %  
        % figure;bode(G11*C11,logspace(0,3,1000));grid;title('Bode Gba11');
        % figure;bode(G22*C22,logspace(0,3,1000));grid;title('Bode Gba22');
        % figure;bode(G33*C33,logspace(0,3,1000));grid;title('Bode Gba33');
        
        Mg1 = -66.6;
        Mg2 = -66.6;
        Mg3 = -66.6;
        
        kc1 = 10^(-Mg1/20);
        kc2 = 10^(-Mg2/20);
        kc3 = 10^(-Mg3/20);
        
        Ti1 = 2*tauc1;
        Ti2 = 2*tauc2;
        Ti3 = 2*tauc3;
        
        Td1 = tauc1^2/Ti1;
        Td2 = tauc2^2/Ti2;
        Td3 = tauc3^2/Ti3;
        
        kp1 = kc1*Ti1/tauc1;
        kp2 = kc2*Ti2/tauc2;
        kp3 = kc3*Ti3/tauc2;
        
        ki1 = kp1/Ti1;
        ki2 = kp2/Ti2;
        ki3 = kp3/Ti3;
        kp1 = kp1;
        kp2 = kp2;
        kp3 = kp3;
        kd1 = kp1*Td1;
        kd2 = kp2*Td2;
        kd3 = kp3*Td3;
        
    else
        disp('Ese numero se corresponde con ningun control')
    end
    
    