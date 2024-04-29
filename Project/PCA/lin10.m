function x = lin10(xdb)
%function x = lin10(xdb)

%xdb = 10*log10(abs(x)+eps);
x=10.^(xdb./10);
