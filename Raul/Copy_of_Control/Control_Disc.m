function Im = Control_disc(in)



Kt1=0.5;
Kt2=0.4;
Kt3=0.35;
Kt=[Kt1 Kt2 Kt3]';
 
% Ki=[0 0 0];
% Kd=[140.5539 140.5539 140.5539];
% Kp=[7.6736e+03 7.6736e+03 7.6736e+03]
 wc=150;
tau=1/wc*tan(70*pi/180);
 
 Kp=[7.4989e+04 1.4125e+05 1.5488e+04];
Ki=[0 0 0];
Kd=Kp*tau;


qr=[in(1) in(2) in(3)]';
qdr=[in(4) in(5) in(6)]';
qddr=[in(7) in(8) in(9)]';

q=[in(10) in(11) in(12)]';
qd=[in(13) in(14) in(15)]';

err_q=qr-q;
err_qd=qdr-qd;

u=Kp'.*err_q +  Kd'.*err_qd;



q1=q(1);q2=q(2);q3=q(3);
qd1=qd(1);qd2=qd(2);qd3=qd(3);



% M =[275.9, 0, 0;
%     0,  0.9787*cos(q3 - 0.588) + 106.2, 0.4893*cos(q3 - 0.588) + 0.3619;
%     0, 0.4893*cos(q3 - 0.588) + 0.3619, 56.91];
% 
% V =[0.0225*qd1;
%     0.0144*qd2 - 0.4893*qd3*sin(q3 - 0.588)*(2.0*qd2 + qd3);
%     0.4893*sin(q3 - 0.588)*qd2^2 + 0.0225*qd3];
% 
% G = 9.8*[35.63 0 0]';

Im=u./Kt;
% tau=M*(u+qddr)+V+G;