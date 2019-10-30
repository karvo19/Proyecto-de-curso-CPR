ti=0.5;
Tsim=20;
Ts=0.001;
R1=50; R2=30; R3=15;
Kt1=0.5; Kt2=0.4; Kt3=0.35;
RT_1=inv(diag([Kt1*R1, Kt2*R2, Kt3*R3]));
g=9.8;
Mat=[];
Im=[];

art=3;%articulaciones
int_ini=round(ti/Ts);%intervalos
int_fin=round(Tsim/Ts);
%diap7
for int=int_ini:10:int_fin %para cada valor que tomamos muestreado, y para cada articulacion
    q1=qm(art,1);q2=qm(art,2);q3=qm(art,3); %(formacion de la Gamma r.nxm e Yr.nx1)
    qd1=qdm(art,1);qd2=qdm(art,2);qd3=qdm(art,3);
    qdd1=qddm(art,1);qdd2=qddm(art,2);qdd3=qddm(art,3);
    Im1=Imm(art,1);Im2=Imm(art,2);Im3=Imm(art,3);
    
    Imi=[Im1; Im2; Im3];
    Mati=[ qdd1,  qdd1/2 - (qdd1*cos(2*q2))/2 + qd1*qd2*sin(2*q2),    0,qdd1/2 - (qdd1*cos(2*q2 + 2*q3))/2 + qd1*qd2*sin(2*q2 + 2*q3) + qd1*qd3*sin(2*q2 + 2*q3),           0,         0, R1^2*qd1,        0,        0,         0,  l2*qdd1*cos(q3) + l2*qdd1*cos(2*q2 + q3) - l2*qd1*qd3*sin(q3) - 2*l2*qd1*qd2*sin(2*q2 + q3) - l2*qd1*qd3*sin(2*q2 + q3);
              0,                             -(qd1^2*sin(2*q2))/2, qdd2,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2, qdd2 + qdd3,         0,        0, R2^2*qd2,        0, g*cos(q2), l2*sin(2*q2 + q3)*qd1^2 - l2*sin(q3)*qd3^2 - 2*l2*qd2*sin(q3)*qd3 + g*cos(q2 + q3) + 2*l2*qdd2*cos(q3) + l2*qdd3*cos(q3);
              0,                                                0,    0,                                                              -(qd1^2*sin(2*q2 + 2*q3))/2, qdd2 + qdd3, R3^2*qdd3,        0,        0, R3^2*qd3,         0,               2*g*cos(q2 + q3) + l2*qdd2*cos(q3) + (l2*qd1^2*sin(q3))/2 + l2*qd2^2*sin(q3) + (l2*qd1^2*sin(2*q2 + q3))/2];
    Mati=RT_1*Mati;
    
    Mat=[Mat;Mati];
    Im=[Im;Imi];
    art=art+1;
end

%diap8
[Theta_est]=lscov(Mat,Im); %std zeros para rango de A insuficiente
%diap9
[fil,col]=size(Mat);
sigma_ro=norm(Im-Mat*Theta_est)^2/(fil-col);
C_Theta_est=sigma_ro*inv(Mat'*Mat);

sigma_Theta_est=[];
for ind=1:length(Theta_est) %indice para recorrer thet
    sigma_Theta_est(ind)=sqrt(C_Theta_est(ind,ind));
end

sigma_Theta_est_r=sigma_Theta_est./abs(Theta_est)'*100;




