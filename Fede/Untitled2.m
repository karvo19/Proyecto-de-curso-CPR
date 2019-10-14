%%estimacion parametros%%

k1=0.5;k2=0.4;k3=0.35;
Thet=[I11x, I11y, I11z, I22x, I22y, I22z, I33x, I33y, I33z, Jm1, Jm2, Jm3, Bm1, Bm2, Bm3, m1*s11y^2, m2*s22x^2, m3*s33x^2, m1*s11y, m2*s22x, m3*s33x, m1, m2, m3]; 
%T1
%inercias
Mat101=diff(T1,I11x);
Mat102=diff(T1,I11y);
Mat103=diff(T1,I11z);
Mat104=diff(T1,I22x);
Mat105=diff(T1,I22y);
Mat106=diff(T1,I22z);
Mat107=diff(T1,I33x);
Mat108=diff(T1,I33y);
Mat109=diff(T1,I33z);

%JyB
Mat110=diff(T1,Jm1);
Mat111=diff(T1,Jm2);
Mat112=diff(T1,Jm3);

Mat113=diff(T1,Bm1);
Mat114=diff(T1,Bm2);
Mat115=diff(T1,Bm3);

%masas %diff(T1,m1) y seleccionar terminos con s11y^2...
Mat116=diff(diff(T1,s11y,2),m1);
Mat117=diff(diff(T1,s22x,2),m2);
Mat118=diff(diff(T1,s33x,2),m3);

Maux=simplify(T1-Mat116*m1*s11y^2);
Mat119=diff(diff(Maux,s11y),m1);
Maux=simplify(Maux-Mat117*m2*s22x^2);
Mat120=diff(diff(Maux,s22x),m2);
Maux=simplify(Maux-Mat118*m3*s33x^2);
Mat121=diff(diff(Maux,s33x),m3);

Maux=simplify(Maux-Mat119*m1*s11y);
Mat122=diff(Maux,m1);
Maux=simplify(Maux-Mat120*m2*s22x);
Mat123=diff(Maux,m2);
Maux=simplify(Maux-Mat121*m3*s33x);
Mat124=diff(Maux,m3);

%T2
%inercias
Mat201=diff(T2,I11x);
Mat202=diff(T2,I11y);
Mat203=diff(T2,I11z);
Mat204=diff(T2,I22x);
Mat205=diff(T2,I22y);
Mat206=diff(T2,I22z);
Mat207=diff(T2,I33x);
Mat208=diff(T2,I33y);
Mat209=diff(T2,I33z);

%JyB
Mat210=diff(T2,Jm1);
Mat211=diff(T2,Jm2);
Mat212=diff(T2,Jm3);

Mat213=diff(T2,Bm1);
Mat214=diff(T2,Bm2);
Mat215=diff(T2,Bm3);

%masas
Mat216=diff(diff(T2,s11y,2),m1);
Mat217=diff(diff(T2,s22x,2),m2);
Mat218=diff(diff(T2,s33x,2),m3);

Maux=simplify(T2-Mat216*m1*s11y^2);
Mat219=diff(diff(Maux,s11y),m1);
Maux=simplify(Maux-Mat217*m2*s22x^2);
Mat220=diff(diff(Maux,s22x),m2);
Maux=simplify(Maux-Mat218*m3*s33x^2);
Mat221=diff(diff(Maux,s33x),m3);

Maux=simplify(Maux-Mat219*m1*s11y);
Mat222=diff(Maux,m1);
Maux=simplify(Maux-Mat220*m2*s22x);
Mat223=diff(Maux,m2);
Maux=simplify(Maux-Mat221*m3*s33x);
Mat224=diff(Maux,m3);

%T3
%inercias
Mat301=diff(T3,I11x);
Mat302=diff(T3,I11y);
Mat303=diff(T3,I11z);
Mat304=diff(T3,I22x);
Mat305=diff(T3,I22y);
Mat306=diff(T3,I22z);
Mat307=diff(T3,I33x);
Mat308=diff(T3,I33y);
Mat309=diff(T3,I33z);

%JyB
Mat310=diff(T3,Jm1);
Mat311=diff(T3,Jm2);
Mat312=diff(T3,Jm3);

Mat313=diff(T3,Bm1);
Mat314=diff(T3,Bm2);
Mat315=diff(T3,Bm3);

%masas
Mat316=diff(diff(T3,s11y,2),m1);
Mat317=diff(diff(T3,s22x,2),m2);
Mat318=diff(diff(T3,s33x,2),m3);

Maux=simplify(T3-Mat316*m1*s11y^2);
Mat319=diff(diff(Maux,s11y),m1);
Maux=simplify(Maux-Mat317*m2*s22x^2);
Mat320=diff(diff(Maux,s22x),m2);
Maux=simplify(Maux-Mat318*m3*s33x^2);
Mat321=diff(diff(Maux,s33x),m3);

Maux=simplify(Maux-Mat319*m1*s11y);
Mat322=diff(Maux,m1);
Maux=simplify(Maux-Mat320*m2*s22x);
Mat323=diff(Maux,m2);
Maux=simplify(Maux-Mat321*m3*s33x);
Mat324=diff(Maux,m3);

Mat=[Mat101,Mat102,Mat103,Mat104,Mat105,Mat106,Mat107,Mat108,Mat109,Mat110,Mat111,Mat112,Mat113,Mat114,Mat115,Mat116,Mat117,Mat118,Mat119,Mat120,Mat121,Mat122,Mat123,Mat124;...
     Mat201,Mat202,Mat203,Mat204,Mat205,Mat206,Mat207,Mat208,Mat209,Mat210,Mat211,Mat212,Mat213,Mat214,Mat215,Mat216,Mat217,Mat218,Mat219,Mat220,Mat221,Mat222,Mat223,Mat224;...
     Mat301,Mat302,Mat303,Mat304,Mat305,Mat306,Mat307,Mat308,Mat309,Mat310,Mat311,Mat312,Mat313,Mat314,Mat315,Mat316,Mat317,Mat318,Mat319,Mat320,Mat321,Mat322,Mat323,Mat324];
    
 Mat=simplify(Mat);
 %% ----
Mat1=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat1=subs(Mat1);

Mat2=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat2=subs(Mat2);

Mat3=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat3=subs(Mat3);

Mat4=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat4=subs(Mat4);

Mat5=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat5=subs(Mat5);

Mat6=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat6=subs(Mat6);

Mat7=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat7=subs(Mat7);

Mat8=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat8=subs(Mat8); 

Mat9=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat9=subs(Mat9); 

Mat10=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat10=subs(Mat10); 

Mat11=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat11=subs(Mat11); 

Mat12=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat12=subs(Mat12); 

Mat13=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat13=subs(Mat13); 

Mat14=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat14=subs(Mat14); 

Mat15=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat15=subs(Mat15); 

Mat16=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat16=subs(Mat16); 

Mat17=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat17=subs(Mat17); 

Mat18=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat18=subs(Mat18); 

Mat19=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat19=subs(Mat19); 

Mat20=Mat;
s11y=rand;
s22x=rand;
s33x=rand;
q1=rand;
q2=rand;
q3=rand;
qd1=rand;
qd2=rand;
qd3=rand;
qdd1=rand;
qdd2=rand;
qdd3=rand;
g=9.8;
Mat20=subs(Mat20); 
 
Mcuad=vpa([Mat1;Mat2;Mat3;Mat4;Mat5;Mat6;Mat7;Mat8;Mat9;Mat10;Mat11;Mat12;Mat13;Mat14;Mat15;Mat16;Mat17;Mat18;Mat19;Mat20;]);
Mcuad=double(Mcuad);
[AA, colind]=rref(Mcuad);

ThetRed=[I11y + 2500*Jm1, I22x - I22y - (m2*s22x^2)/2, I22z + Jm2, I33x - I33y - (m3*s33x^2)/2, I33z + (m3*s33x^2)/2, Jm3, Bm1, Bm2, Bm3, m2*s22x, m3*s33x, m2, m3]; 

MatRed=[Mat102,Mat104,Mat106,Mat107,Mat109,Mat112,Mat113,Mat114,Mat115,Mat120,Mat121,Mat123,Mat124;...
     Mat202,Mat204,Mat206,Mat207,Mat209,Mat212,Mat213,Mat214,Mat215,Mat220,Mat221,Mat223,Mat224;...
     Mat302,Mat304,Mat306,Mat307,Mat309,Mat312,Mat313,Mat314,Mat315,Mat320,Mat321,Mat323,Mat324];
 
 