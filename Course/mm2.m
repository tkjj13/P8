
clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% wideband data

Tx = 1:2; % one of 1:2
Rx = 1; % one of 1:2

Pos = 1:1:600;

InMeasName = 'Stud2017-2_IR';

InDataPath = './MeasData/'; % with the slash

DeltaTau = 2.5e-9; % delay increment
Fs = 60; % IR sampling frequency


% IR( delay, Tx, Rx, Position )

eval( sprintf( 'load %s/%s', InDataPath, InMeasName ) );


PDP = mean( abs( IR( :, Tx, Rx, Pos ) ) .^2, 4 );
PDP2 = mean( abs( IR( :, Tx, 2, Pos ) ) .^2, 4 );

x = 0:DeltaTau:DeltaTau*(length(PDP)-1);
figure(1)

plot(x, 10*log10( PDP ) ); hold on;
plot(x,10*log10(exp(-51.71*10^6*(x-2.5*10^(-8)))))
%plot(x, 10*log10( PDP2 ) ); hold off;
xlabel( 'Delay time' )
ylabel( 'Power [dB]' )
title( 'Power-delay profile' )
grid on


figure
%x = 0:1e-11:DeltaTau*(length(PDP)-1);
f = -1/(2*DeltaTau):1/(DeltaTau*(length(PDP)-1)):1/(2*DeltaTau);
data = fftshift(abs(fft(10*log10(exp(-51.71*10^6*x)))));
plot(f,data/max(data))
grid
title('Frequency correlation function')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% narrowband data

%Tx = 1:2; % from range 1:2
%Rx = 1:2; % from range 1:2

Pos = 1:1:600;

InMeasName = 'Stud2017-2_H';

InDataPath = './MeasData/'; % with the slash

Fs = 60; % IR sampling frequency


% H( Tx, Rx, Position )

eval( sprintf( 'load %s/%s', InDataPath, InMeasName ) );

% part 1

A = fftshift(fft(H,[],3));
S = abs(A);%.^2;

S2 = S./repmat(sum(S,3),1,1,600);

data = squeeze(S2(1,1,:));
figure
x = linspace(-Fs/2,Fs/2,length(data))';
plot(x,data)

DopplerSpread = sqrt(sum(x.^2.*data)-sum((x.*data).^2))


% part 2 
figure
x = 1/Fs:1/Fs:1/Fs*length(H(1,1,:));
for Tx = 1:2
    for Rx = 1:2
      subplot(2,2,(Tx-1)*2+Rx)
        plot(x, 10*log10( abs( squeeze( H( Tx, Rx, : ))')));
        xlabel( 'Time index' )
        ylabel( 'Power [dB]' )
    end
end

% part 2 a
figure
x = 1/Fs:1/Fs:1/Fs*length(H(1,1,:));
for Tx = 1:1
    for Rx = 1:1
      subplot(3,1,1)
        plot(x, 10*log10( abs( squeeze( H( Tx, Rx, : ))')));
        ylabel( 'Power [dB]' )
        grid;
      subplot(3,1,2)
        HAngle = unwrap(angle(squeeze( H( Tx, Rx, : ))'));
        plot(x,HAngle);
        ylabel( 'Phase [rad]' )
        grid;
      subplot(3,1,3)
        derivative = (HAngle(2:end)-HAngle(1:end-1))/(1/Fs);
        plot(x(1:end-1),derivative);
        ylabel( 'Random FM (Phase change) [rad/s]' )
        xlabel( 'Time index' )
        grid
    end
end

% part 2 b
%%
close all;



histogram( abs( squeeze( H( Tx, Rx, : ))'),'Normalization','PDF');
hold on
plot([0:0.1:6],raylpdf([0:0.1:6],1.3));
title('PDF');
xlabel('linear SNR [1]');
ylabel('Probability');
legend('Meas','Theory');

figure
CDFval = sort(10*log10( abs( squeeze( H( Tx, Rx, : ))')));
p = 1/length(CDFval):1/length(CDFval):1;
semilogy(CDFval,p);
hold on
semilogy(10*log10([0.02:0.01:10]),raylcdf([0.02:0.01:10],1.3));
grid
title('CDF');
xlabel('SNR [dB]');
ylabel('Probability');
legend('Meas','Theory');





