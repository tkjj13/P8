
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

PDP = PDP(1:end-1,:);

k = 1;
t0 = find(max(PDP(:,k))==PDP(:,k));
x = 0:DeltaTau:DeltaTau*(length(PDP(t0:end,k))-1);
figure(1)


plot(x, 10*log10( PDP(t0:end,k) ) ); hold on;
%plot(x,10*log10(exp(-91.71*10^6*(x-2.5*10^(-8)))))
plot(x,10*log10(exp(-51.71*10^6*(x+0.5e-7))))
%plot(x, 10*log10( PDP2 ) ); hold off;
xlabel( 'Delay time' )
ylabel( 'Power [dB]' )
title( 'Power-delay profile' )
grid on


%plot(x,10*log10(1/17e-9*exp(-x/17e-9).*x));

figure
%inc = 1e-11;
%x = 0:inc:inc*(1e6-1);
%f = -1/(2*inc):1/(max(x)):1/(2*inc);
f = -1/(2*DeltaTau):1/(max(x)):1/(2*DeltaTau);
data3 = fftshift(abs(fft((exp(-51.71*10^6*x))))); 
%data2 = fftshift(abs(fft((1/17e-9*exp(-x/17e-9).*x)))); 
data = fftshift(abs(fft(( PDP(t0:end,k) ))));
plot(f,10*log10(data/max(data))); hold on;
%plot(f, 10*log10(data2/max(data2)));
plot(f, 10*log10(data3/max(data3)));
grid
title('Frequency correlation function')

%%

mTau = 0;
mTau2 = 0;
Scale = sum(PDP(t0:end,k));
for n = 1:length(PDP(t0:end,k))-1
   temp = PDP(t0+n,k)*(n)*DeltaTau/Scale;
   temp2 = PDP(t0+n,k)*((n)*DeltaTau).^2/Scale;
   mTau = mTau+temp;
   mTau2 = mTau2+temp2;
end

RMS = sqrt(mTau2-mTau.^2)
1/(2*pi*RMS)
%%
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





