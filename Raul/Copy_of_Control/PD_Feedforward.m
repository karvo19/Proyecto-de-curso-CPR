function Im = PD_Feedforward(in)

%%%%%%% Parámetros estimados %%%%%%%%%%%%%
t_red=[
   -1.7594
   -0.3966
    8.3284
   16.0353
    0.3977
    0.0072
    0.0120
    0.0085
    0.0150
    2.9131
    0.9710];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Datos del robot %%%%%%%%%%
R1=1;
R2=1;
R3=1;
R=diag([R1 R2 R3]);

l0 = 1.00;
l1 = 0.40;
l2 = 0.70;
l3 = 0.50;

g=9.81;

Kt1=0.5;
Kt2=0.4;
Kt3=0.35;
Kt=[Kt1 Kt2 Kt3]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Ki=[0 0 0];
% Kd=[140.5539 140.5539 140.5539];
% Kp=[7.6736e+03 7.6736e+03 7.6736e+03]
 wc=150;
tau=1/wc*tan(70*pi/180);
 
Kp=[7.4989e+04 1.4125e+05 1.5488e+04];
Ki=[0 0 0];
Kd=Kp*tau;


tiempo    = in(16);


qr=[in(1) in(2) in(3)]';
qdr=[in(4) in(5) in(6)]';
qddr=[in(7) in(8) in(9)]';

if (tiempo<1e-5)
    q=[0 0 0]';
    qd=[0 0 0]';    


else
q=[in(10) in(11) in(12)]';
qd=[in(13) in(14) in(15)]';

end
err_q=qr-q;
err_qd=qdr-qd;

q1=q(1);q2=q(2);q3=q(3);
qd1=qd(1);qd2=qd(2);qd3=qd(3);





% Modelo en forma matricial (M, V, G)
% M11=[t_red(3)+t_red(11)*l2*(cos(2*q2+q3)+cos(q3))+1/2*(t_red(1)+t_red(2)-t_red(1)*cos(2*q2)-t_red(2)*cos(2*q2+2*q3))];
% M12=0;
% M13=0;
% M21=M12;
% M22=[t_red(4)+t_red(5)+2*l2*t_red(11)*cos(q3)];
% M23=[t_red(5)+l2*t_red(11)*cos(q3)];
% M31=M13;
% M32=M23;
% M33=[t_red(5)+R3^2*t_red(6)];
% 
% M=[M11 M12 M13
%     M21 M22 M23
%     M31 M32 M33];
% 
% V1=[qd1*( t_red(7)*R1^2 +qd2*(sin(2*q2)*t_red(1) +sin(2*q2+2*q3)*t_red(2) - 2*l2*t_red(11)*sin(2*q2+q3)) + qd3*(sin(2*q2+2*q3)*t_red(2) -l2*t_red(11)*sin(2*q2+q3) -l2*t_red(11)*sin(q3) )     ) ];
% V2=( (-1/2*qd1^2*(sin(2*q2)*t_red(1) + sin(2*q2+2*q3)*t_red(2) - 2*l2*t_red(11)*sin(2*q2+q3) ))  + (qd2*t_red(8)*R2^2) - l2*t_red(11)*sin(q3)*qd3^2 - 2*l2*t_red(11)*qd2*sin(q3)*qd3 );
% V3=(    (qd3*R3^2*t_red(9)) + (qd2^2*sin(q3)*l2*t_red(11))  + qd1^2*(-t_red(2)*sin(2*q2 + 2*q3) +l2*t_red(11)*(sin(2*q2 + q3) + sin(q3))   )/2  );
% 
% V=[V1 V2 V3]';

G1=0;
G2=g*(t_red(10)*cos(q2) +t_red(11)*cos(q2+q3));
G3=g*t_red(11)*cos(q2+q3);

G=[G1 G2 G3]';


u=Kp'.*err_q +  Kd'.*err_qd + G ;

Im=u./Kt;
