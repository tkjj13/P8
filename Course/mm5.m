clc;
close all;
clear all;

Pos = 1:1:600;

InMeasName = 'Stud2017-2_H';

InDataPath = './MeasData/'; % with the slash

Fs = 60; % IR sampling frequency


% H( Tx, Rx, Position )

eval( sprintf( 'load %s/%s', InDataPath, InMeasName ) );


Meas = squeeze(abs(H(:,1,:)));
combining = max(Meas,[],1);

figure
datas = sort(10*log10(Meas),2);
combinings = sort(10*log10(combining));
p = 1/length(combinings):1/length(combinings):1;

semilogy(datas(1,:),p);
hold on
semilogy(datas(2,:),p);
semilogy(combinings,p);
grid
title('CDF');
xlabel('SNR [dB]');
ylabel('Probability');
legend('Meas1','Meas2','Combining');









%%


d = 0:0.00001:1;
plot(d,besselj(0,2*pi*d));
set(gca,'Ytick',[-0.5:0.1:1])
grid
xlabel('Distance [\lambda]');
ylabel('Correlation');



%%

MatA = [1/(1^4),1/(3^4);1/(4^4),1/(2^4)];
[V,D] = eig(MatA,'matrix');
eigval = D
eigvec = V
Dmax = max(abs(D))
10*log10((Dmax(1)/(Dmax(2)))) %% SIR dB between user 1 and user 2
%%

close all
clear all
clc

o = [2.75, -1, -4, -6.5, -10.5]; % Modulation and Coding Scheme offset
r = [1/4 1/2 3/4 1/2 3/4]; % Coding rate
M = [4 4 4 16 16];
n = [1 2 3 4 5]; % Number of channels (1-5)
k = 10; % Constant gain multiplier
Rc = 3.84E6; % chip rate (From slides)
SF = 16; % spreading factor (From slides)

SINR = -10:0.1:20;
for j = 1:5 % Modulation and coding scheme
    for i = 1:5 % Number of channels
        MaxThroug(i,j,:) = Rc/SF*r(j)*log2(M(j))*i;
        BLEP(i,j,:) = 1-1/pi*(pi/2+atan(k*(SINR+o(j)-10*log10(n(i)))));
    end
end

figure
for i = 1:5
    subplot(2,5,i)
    plot(SINR, squeeze(BLEP(i,1,:)));
    hold on
    plot(SINR, squeeze(BLEP(i,2,:)));
    plot(SINR, squeeze(BLEP(i,3,:)));
    plot(SINR, squeeze(BLEP(i,4,:)));
    plot(SINR, squeeze(BLEP(i,5,:)));
    
    title(strcat('Nchan = ',int2str(i)));
    xlabel('SINR [dB]');
    ylabel('BLEP');
    legend('QPSK 1/4','QPSK 1/2','QPSK 3/4','QAM 1/2','QAM 3/4','Location','NorthWest');
end

figure
for i = 1:5
    %subplot(2,5,5+i)    
    plot(SINR, squeeze(((1-BLEP(i,1,:)) * MaxThroug(i,1,:))));
    hold on
    plot(SINR, squeeze(((1-BLEP(i,2,:)) * MaxThroug(i,2,:))));
    plot(SINR, squeeze(((1-BLEP(i,3,:)) * MaxThroug(i,3,:))));
    plot(SINR, squeeze(((1-BLEP(i,4,:)) * MaxThroug(i,4,:))));
    plot(SINR, squeeze(((1-BLEP(i,5,:)) * MaxThroug(i,5,:))));
    
    title(strcat('Nchan = ',int2str(i)));
    xlabel('SINR [dB]');
    ylabel('Bit rate [bits/s]');
    legend('QPSK 1/4','QPSK 1/2','QPSK 3/4','QAM 1/2','QAM 3/4','Location','NorthWest');
end



