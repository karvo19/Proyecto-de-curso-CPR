%Controladores

Mii=Copy_of_ModeloDinamico_R3GDL(zeros(1,9));
M11=Mii(1);
M22=Mii(2);
M33=Mii(3);

Bm1=Mii(4);
Bm2=Mii(5);
Bm3=Mii(6);

G11=tf(1,[M11 Bm1 0]);
G22=tf(1,[M22 Bm2 0]);
G33=tf(1,[M33 Bm3 0]);

wc=150;
Gain=83.8;
C1=tf(1,1);
Kp=1;
Kp=10^(Gain/20);

tau=1/wc*tan(70*pi/180);

C1=tf(Kp*[tau 1],1);


Gba=C1*G33;
bode(Gba,logspace(0,3,1000)); grid
Kp=[7.4989e+04 1.4125e+05 1.5488e+04];
Ki=[0 0 0];
Kd=Kp*tau