function [Tau] = Control(in) %%solo un parametro salida y entrada. in puede ser un vector(en este caso lo es )

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
persistent Int_err;
g=9.8;
Tm=0.001;
if (tiempo<0.35)
    Int_err=[0;0;0];
end

% Control
err_q=[qr1-q1;qr2-q2;qr3-q3];
err_qd=[qdr1-qd1;qdr2-qd2;qdr3-qd3];
Int_err=Int_err+Tm.*err_q;
   
   
Kp=[7.4989e+04 1.4125e+05 1.5488e+04];
Ki=[0 0 0];
Kd=[1.3735e+03 2.5872e+03 0.2837e+03]

   
   
u=Kp.*err_q+Kd.*err_qd+Ki.*Int_err;
   
  
% Ecuación del robot
  Tau=[qddr1;qddr2;qddr3]+u;

