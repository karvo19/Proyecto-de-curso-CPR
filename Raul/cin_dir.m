function pos=cin_dir(q)
L0=0.1;
L1=1.2;
L2=0.3;
L3=0.3;
L4=0.4;

q1=q(1);
q2=q(2);
q3=q(3);

x=cos(q1)*(L3*cos(q2 + q3) + L2*cos(q2));
y=sin(q1)*(L3*cos(q2 + q3) + L2*cos(q2));
z=L0 + L1 + L3*sin(q2 + q3) + L2*sin(q2);

pos=[x y z]';

return