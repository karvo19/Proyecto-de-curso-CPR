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

Tsim = 2;
XYZini = CinematicaDirecta([0 0 0]);
XYZfin = CinematicaDirecta([pi 3*pi/4 -pi/5]);
n = 5;
t_ini = 0.5;
duracion = 1;

Gba=C1*G33;
bode(Gba,logspace(0,3,1000)); grid
Kp=[7.4989e+04 1.4125e+05 1.5488e+04];
Ki=[0 0 0];
Kd=Kp*tau


%% PID sin cancelacion

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

C1=tf(1,1);
Gba=C1*G11;
bode(Gba,logspace(0,3,1000)); grid
%% 
wc=150;
Mf_act=0;
Mf_des=70;
phi=Mf_des-Mf_act;
tau=tand((90+phi)/2)/wc;
Kc=1;
C1=tf(Kc*conv([tau 1],[tau 1]),[1 0]);
Gba=C1*G33;
bode(Gba,logspace(0,3,1000)); grid
%%
Gain=106;
Kc=10^(Gain/20);
C1=tf(Kc*conv([tau 1],[tau 1]),[1 0]);
Gba=C1*G33;
bode(Gba,logspace(0,3,1000)); grid

margin(Gba);grid;


%%
Ti=2*tau
Td=tau/2
Kp=2*Kc*tau

%%

Ti=[0.0756 0.0756 0.0756];
Td=[0.0189 0.0189 0.0189];

Kp=[7.5617e+04 1.3447e+05 1.5088e+04];
 

Kd=Kp.*Td;
Ki=Kp./Ti;

%%
q0=Kp.*(1 +Tm./Ti + Td/Tm)
 q1=Kp.*(-1-2*Td/Tm)
 q2=Kp.*Td/Tm
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %% PD
 wc=150;
tau=1/wc*tan(70*pi/180);
 
 Kp=[7.4989e+04 1.4125e+05 1.5488e+04];
Ki=[0 0 0];
Kd=Kp*tau















