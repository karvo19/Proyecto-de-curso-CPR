function [out] = Control(in)
errx = in(1);
erry = in(2);
p = in(3);

Kv = 1;
Kh = 1;

prel = atan(erry/errx);

v = Kv*sqrt(errx^2+erry^2);
pd = Kh*(prel-p);


out = [v pd];
end