function [Im] = Control_PID(in) %%solo un parametro salida y entrada. in puede ser un vector(en este caso lo es )

persistent Int_err;
persistent ek_1;
g=9.8;
Tm=0.001;


% Kt=[0.5 0.4 0.35]';

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
q1        = in(10);
q2        = in(11);
q3        = in(12);
qd1       = in(13);
qd2       = in(14);
qd3       = in(15);
tiempo    = in(16);



if (tiempo<1e-5)
    Int_err=[0;0;0];
    ek_1=[0;0;0];
end


% Control
err_q=[qr1-q1;qr2-q2;qr3-q3];
err_qd=[qdr1-qd1;qdr2-qd2;qdr3-qd3]

ek=[qr1-q1;qr2-q2;qr3-q3];
% Int_err=Int_err+Tm*ek;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parámetros del PID continuo
Ti=[0.0756 0.0756 0.0756]';
Td=[0.0189 0.0189 0.0189]';

Kp=[7.5617e+04 1.3447e+05 1.5088e+04]';

Kd=Kp.*Td;
Ki=Kp./Ti;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parámetros del PD continuo
 wc=150;
tau=1/wc*tan(70*pi/180);


Kp=[7.4989e+04 1.4125e+05 1.5488e+04]';
Ki=[0 0 0]';
Kd=Kp*tau;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Discretización del controlador PID
% EULER II 
% q0=Kp.*(1 +Tm./Ti + Td/Tm);
% q1=Kp.*(-1-2*Td/Tm);
% q2=Kp.*Td/Tm;

% uk=Kp.*err_q + Kp.*Int_err./Ti + Kp.*Td.*err_qd;
uk=Kp.*err_q + Kd.*err_qd;

% uk=Kp.*ek + Ki.*Int_err + Kd.*(ek-ek_1)/Tm;

ek_1=ek;

% uk=[0;0;0];
Im=uk;

