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



