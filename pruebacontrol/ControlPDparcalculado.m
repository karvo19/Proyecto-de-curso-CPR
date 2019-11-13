function [Tau] = Control(in)

Tm=1e-3;


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


persistent Int_Err;

if tiempo < 1e-5
    Int_Err = [0;0;0];
end

Err_q = [qr1-q1;qr2-q2;qr3-q3];
Err_qd = [qdr1-qd1;qdr2-qd2;qdr3-qd3];

Int_Err = Int_Err + Tm*Err_q;

        
        ki1 = 0;
        ki2 = 0;
        ki3 = 0;
        kp1 = 7.673614893618193e+03;
        kp2 = 7.673614893618193e+03;
        kp3 = 7.673614893618193e+03;
        kd1 = 1.405538909720445e+02;
        kd2 = 1.405538909720445e+02;
        kd3 = 1.405538909720445e+02;
        
        kp = [kp1;kp2;kp3];
        ki = [ki1;ki2;ki3];
        kd = [kd1;kd2;kd3];
        
        
        u = kp.*Err_q + kd.*Err_qd + ki.*Int_Err;


        M = [
            [ (6797*cos(2*qr2 + qr3))/5000 + (8797*cos(2*qr2))/5000 + (1983*cos(2*qr2 + 2*qr3))/5000 + (6797*cos(qr3))/5000 + 2159/1000,                             0,                               0]
            [                                                                                                                   0,  (6797*cos(qr3))/2000 + 217/40, (6797*cos(qr3))/4000 + 3977/4000]
            [                                                                                                                   0, (971*cos(qr3))/500 + 3977/3500,                       4049/3500]];
        
        % Matriz de aceleraciones centrípetas y de Coriolis
        V = [
            -(qdr1*(17594*qdr2*sin(2*qr2) + 3966*qdr2*sin(2*qr2 + 2*qr3) + 3966*qdr3*sin(2*qr2 + 2*qr3) + 6797*qdr3*sin(qr3) + 13594*qdr2*sin(2*qr2 + qr3) + 6797*qdr3*sin(2*qr2 + qr3) - 120))/5000
            (17*qdr2)/800 - (6797*qdr3^2*sin(qr3))/4000 + (6797*qdr1^2*sin(2*qr2 + qr3))/4000 + (8797*qdr1^2*sin(2*qr2))/4000 + (1983*qdr1^2*sin(2*qr2 + 2*qr3))/4000 - (6797*qdr2*qdr3*sin(qr3))/2000
            (3*qdr3)/70 + (971*qdr1^2*sin(qr3))/1000 + (971*qdr2^2*sin(qr3))/500 + (971*qdr1^2*sin(2*qr2 + qr3))/1000 + (1983*qdr1^2*sin(2*qr2 + 2*qr3))/3500];
        
        % Par gravitatorio
        g = 9.81;
        G = [
            0
            g*((971*cos(qr2 + qr3))/400 + (29131*cos(qr2))/4000)
            (971*g*cos(qr2 + qr3))/350];
        
         Tau = M*([qddr1;qddr2;qddr3] + u) + V + G;
    end

  