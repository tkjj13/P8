clc
close all
clear all

SI = 10^(15/10);
%%Q = ceil((SI*6)^(1/3)); % omni directional antennas
Q = ceil((SI*2)^(1/3)-1/2); % 120 degree sectorizing antennas


dur = 120;
hyp = 2/3600;

Au = dur*hyp;

A = 0:0.01:100;
k = floor(100/Q);
for n = 1:length(A)
    temp = 0;
    for i = 1:k
        temp = temp + (A(n)^i)/factorial(i);
    end
    P(n) = ((A(n)^k)/factorial(k))/(temp);
end

plot(A,P)
%%
A = 8.88; % assuming omni
%A = 16.13; % asuming 120 degree sectorizing

users = A/Au


