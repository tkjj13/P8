clc
close all;
clear all;


adB = -110;
amin = 10^((adB-1)/10);
alin = 10^(adB/10);
amax = 10^((adB+1)/10);

conf_tres = 0.90;
conf = 0;
integer = 1000;
while conf < conf_tres
    integer =  integer*1.0001;
    sigma = 1/integer;
    cdf_min = normcdf(amin,alin,sigma);
    cdf_max = normcdf(amax,alin,sigma);
    conf = cdf_max - cdf_min;
end

%%
kexp = alin^2/2*sigma^2;

for k = 1e38*kexp:1e38*kexp:1e40*kexp;
    
    pd = makedist('Rician','s',k,'sigma',sqrt(alin^2/(2*k)));
    cdf_min = cdf(pd,amin);
    cdf_max = cdf(pd,amax);
    
    conf = cdf_max-cdf_min
    
end

%%
x = 0.00000001:0.0001:1;

conf = cdf(pd,x);

loglog(x,conf)




