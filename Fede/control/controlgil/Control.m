function senalcontrol = Control(in)
q1rk    = in(1);           % Referencais de posiciones articulares
q2rk    = in(2);           
q3rk    = in(3);           
qp1rk   = in(4);           % `Referencais de velocidades articulares
qp2rk   = in(5);           
qp3rk   = in(6);           
qpp1rk  = in(7);           % Referencias de aAceleraciones articulares
qpp2rk  = in(8);
qpp3rk  = in(9);
q1k     = in(10);           % Posiciones articulares
q2k     = in(11);
q3k     = in(12);
qp1k    = in(13);           % Velocidades articulares
qp2k    = in(14);
qp3k    = in(15);
t       = in(16);           % Tiempo




senalcontrol= [0;0;0];


  