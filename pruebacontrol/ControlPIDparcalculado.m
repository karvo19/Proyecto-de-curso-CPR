function [Tau] = Control(in)

% Variables de entrada en la funcion: [q(2)  qp(2)  Imotor(2)]
qr1        = in(1);
qr2        = in(2);
qr3        = in(3);
qdr1       = in(4);
qdr2       = in(5);
qdr3       = in(6);
qddr1      = in(7);
qddr2      = in(8);
qddr3      = in(9);
q1         = in(10);
q2         = in(11);
q3         = in(12);
qd1        = in(13);
qd2        = in(14);
qd3        = in(15);
tiempo     = in(16);

% Tm declarado en simulaciones.m

persistent Int_Err;


Tm = 0.001;


M11 = 7.0338;
M22 = 8.8235;
M33 = 1.1568571428571428571428571428571;

V1 = 0.024;
V2 = 0.02125;
V3 = 0.042857142857142857142857142857143;
    
% Matriz de Inercias
 M = [
[ (30612509037519171*cos(2*q2 + q3))/22517998136852480 + (7923634914903717*cos(2*q2))/4503599627370496 + (7145278848525341*cos(2*q2 + 2*q3))/18014398509481984 + (30612509037519171*cos(q3))/22517998136852480 + 39181235098854191/18014398509481984,                                                                                  0,                                                                                   0];
[                                                                                                                                                                                                                                                  0, (30612509037519171*cos(q3))/9007199254740992 + 97924626708858385/18014398509481984, (30612509037519171*cos(q3))/18014398509481984 + 17909359017493675/18014398509481984];
[                                                                                                                                                                                                                                                  0,  (4373215576788453*cos(q3))/2251799813685248 + 17909359017493675/15762598695796736,                                             1167023812028605325/1008806316530991104]];

% Matriz de aceleraciones centrípetas y de Coriolis
 V = [
                    -(qd1*(3961817457451858500*qd2*sin(2*q2) + 893159856065667625*qd2*sin(2*q2 + 2*q3) + 893159856065667625*qd3*sin(2*q2 + 2*q3) + 1530625451875958550*qd3*sin(q3) + 3061250903751917100*qd2*sin(2*q2 + q3) + 1530625451875958550*qd3*sin(2*q2 + q3) - 27021597764222976))/1125899906842624000;
 (17*qd2)/800 - (30612509037519171*qd3^2*sin(q3))/18014398509481984 + (30612509037519171*qd1^2*sin(2*q2 + q3))/18014398509481984 + (39618174574518585*qd1^2*sin(2*q2))/18014398509481984 + (35726394242626705*qd1^2*sin(2*q2 + 2*q3))/72057594037927936 - (30612509037519171*qd2*qd3*sin(q3))/9007199254740992;
                                                                  (3*qd3)/70 + (4373215576788453*qd1^2*sin(q3))/4503599627370496 + (4373215576788453*qd2^2*sin(q3))/2251799813685248 + (4373215576788453*qd1^2*sin(2*q2 + q3))/4503599627370496 + (35726394242626705*qd1^2*sin(2*q2 + 2*q3))/63050394783186944];
% Par gravitatorio
g = 9.81;
 G = [
                                                                                                    0;
 g*((21866077883942265*cos(q2 + q3))/9007199254740992 + (16399558412956785*cos(q2))/2251799813685248);
                                                  (21866077883942265*g*cos(q2 + q3))/7881299347898368];
    



        
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
        
        Mg1 = -72.5;
        Mg2 = -72.5;
        Mg3 = -72.5;
        
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
        

if tiempo < 1e-5
    Int_re=[0;0;0];
    Int_Err = [0;0;0];
    
end

Err_q = [qr1-q1;qr2-q2;qr3-q3];
Err_qd = [qdr1-qd1;qdr2-qd2;qdr3-qd3];

Int_Err = Int_Err + Tm*Err_q;
 
kp = [kp1;kp2;kp3];
ki = [ki1;ki2;ki3];
kd = [kd1;kd2;kd3];



u = kp.*Err_q + kd.*Err_qd + ki.*Int_Err;



       Tau = M*([qddr1;qddr2;qddr3] + u) + V + G;
       
       if (Tau(1)> 500 || Tau(1) < -500) Int_Err(1)=Int_Err(1)-Tm*Err_q(1);
       end
       if (Tau(2)> 500 || Tau(2) < -500) Int_Err(2)=Int_Err(2)-Tm*Err_q(2);
       end
       if (Tau(3)> 500 || Tau(3) < -500) Int_Err(3)=Int_Err(3)-Tm*Err_q(3);
       end
       
     
    end