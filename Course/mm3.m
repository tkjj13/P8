clc;
close;
clear all;


t = linspace(0,1,1000);

a = 1;

y = exp(-a*t);

plot(t,mag2db(y));
grid

10^(86.86/10)
%20 = 173.7
%10 = 86.86
%5 = 43.43
%2 = 17.37


%%
x = [1 2 5 10 20];
z = [8.685 17.37 43.43 86.86 173.7];

plot(x,z)
