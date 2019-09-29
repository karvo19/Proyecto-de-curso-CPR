function trayectoria=GTCL_R3GDL(in)

XYZinicio=[in(1) in(2) in(3)]';
XYZfin=[in(4) in(5) in(6)]';

n = in(7);

inicio = in(8);

duracion = in(9);

t = in(10);

T=duracion/(n+1);

persistent ti;
persistent flag;
persistent XYZi;
persistent XYZf;
persistent a;
persistent b;
persistent c;
persistent d;
persistent q_t;

if t==0 
    ti=inicio;
    XYZi=XYZinicio;
    q_t=cin_in(XYZi);
    flag=1;
end

if (t>=ti) && (t<(ti+T))

    if flag==1
        
        XYZf=XYZi + (XYZfin-XYZinicio)/duracion*T;
        q_i=cin_in(XYZi);
        q_f=cin_in(XYZf);
        
        qd_i=[0 0 0]';
        qd_f=[0 0 0]';
        
        a=q_i;
        b=qd_i;
        c=3/T^2*(q_f-q_i)-1/T*(qd_f+2*qd_i);
        d=-2/T^3*(q_f-q_i)+1/T^2*(qd_f+qd_i);
        
        XYZi=XYZf;
        flag=0;
    end
        
    
    q_t=a+b*(t-ti)+c*(t-ti)^2+d*(t-ti)^3;
    
elseif t==(ti+T)
    ti=t;
    flag=1;
end

trayectoria=q_t;

return

