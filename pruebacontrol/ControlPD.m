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



persistent Int_re;



Tm = 0.001;


M11 = 7.0338;
M22 = 8.8235;
M33 = 1.1568571428571428571428571428571;

V1 = 0.024;
V2 = 0.02125;
V3 = 0.042857142857142857142857142857143;
    
control=4;
control_4=1;



        
        Tm = 0.001;
        Wn = pi/Tm;        
        Wc = Wn/20;        
        tsbc = pi/Wc;
        
        % Mirando el bode del sistema obtenemos el margen de fase actual
        Mfact1 = 0;
        Mfact2 = 0;
        Mfact3 = 0;
        
        % Segun especificaciones indicamos el margen de fase que deseamos
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
        
        % figure;bode(G11*C11,logspace(0,3,1000));grid;title('Bode Gba11');
        % figure;bode(G22*C22,logspace(0,3,1000));grid;title('Bode Gba22');
        % figure;bode(G33*C33,logspace(0,3,1000));grid;title('Bode Gba33');
        
        % Medimos el margen de ganancia a Wc para calcular las ganancias
        Mg1 = -95.5;
        Mg2 = -97.4;
        Mg3 = -79.8;
        
        ki1 = 0;
        ki2 = 0;
        ki3 = 0;
        kp1 = 10^(-Mg1/20);
        kp2 = 10^(-Mg2/20);
        kp3 = 10^(-Mg3/20);
        kd1 = kp1*tau1;
        kd2 = kp2*tau2;
        kd3 = kp3*tau3;
        

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



        Tau = u;
     
    end