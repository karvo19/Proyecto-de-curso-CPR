function [qd_f] = Filtro(in)
persistent qd_1 qd_2 qdf_1 qdf_2;

qd1=in(1);
qd2=in(2);
qd3=in(3);

qd=[qd1;qd2;qd3];

t=in(4);

if t<1e-5
    qd_1=[0;0;0];
    qd_2=[0;0;0];
    qdf_1=[0;0;0];
    qdf_2=[0;0;0];
    
end

num = [0.007820208033497   0.015640416066994   0.007820208033497];
den = [ 1.000000000000000  -1.734725768809275   0.766006600943264];

qd_f = num(1)*qd + num(2)*qd_1 + num(3)*qd_2 - den(2)*qdf_1-den(3)*qdf_2;

qd_2=qd_1;
qd_1=qd;
qdf_2=qdf_1;
qdf_1=qd_f;

end