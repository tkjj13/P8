
clear all
close all
clc

eval( sprintf( 'load PDP/') );      % get data from PDP.mat
DeltaTau = 2.5e-9;                  % delay increment


Corrlation_treshold = 0.5;          % the coherence bandwidth is found at this coherence

%PDP = PDP(1:end-1,:);              % remove last element to make odd number of samples

k = 1;      % PDP 1 or 2
t0 = find(max(PDP(:,k))==PDP(:,k));     % find time of max input
x = 0:DeltaTau:DeltaTau*(length(PDP(t0:end,k))-1);  % define time axis


figure
plot(x, 10*log10( PDP(t0:end,k) ) ); hold on;   % plot meas PDP
plot(x,10*log10(exp(-51.71*10^6*(x+0.5e-7))))   % plot model PDP
xlabel( 'Delay time [s]' )
ylabel( 'Power [dB]' )
title( 'Power-delay profile' )
grid on
legend('Meas','Model')

figure
f = -1/(2*DeltaTau):1/(max(x)):1/(2*DeltaTau);  % make frequency axis
data = fftshift(abs(fft(( PDP(t0:end,k) ))));       % take fft of meas PDP
data = data/max(data);                              % normalize
data2 = fftshift(abs(fft((exp(-51.71*10^6*x)))));   % take fft of model PDP
data2 = data2/max(data2);                           % normalize
plot(f,10*log10(data/max(data))); hold on;          % plot fft of meas PDP
plot(f, 10*log10(data2/max(data2)));                % plot fft of model PDP
grid
title('Frequency correlation function')
xlabel( 'Frequency [Hz]' )
ylabel( 'Corrolation [dB]' )
grid on
legend('Meas','Model')


BW = max(2*f(find(data > Corrlation_treshold)));
disp('Coherence bandwidth from measurement in Hz')
disp(BW)

%% Theoretic coherence bandwidth
% source: http://clusterfie.epn.edu.ec/ibernal/html/cursos/oct06marzo07/cominalam/18.pdf
% page 15 equation 18.12

mTau = 0;
mTau2 = 0;
Scale = sum(PDP(t0:end,k));
% calculate first and second moment of the excess delay
for n = 1:length(PDP(t0:end,k))-1
   temp = PDP(t0+n,k)*(n)*DeltaTau/Scale;       % calculate the integrant to the first moment
   temp2 = PDP(t0+n,k)*((n)*DeltaTau).^2/Scale; % calculate the integrant to the second moment
   mTau = mTau+temp;                            % integration of first moment
   mTau2 = mTau2+temp2;                         % integration of second moment
end

RMS = sqrt(mTau2-mTau.^2);                      % calculate the RMS excess delay
theoBW = 1/(2*pi*RMS);                          % calculat the 0.5 coherence BW 

disp('Coherence bandwidth calculated from RMS excess delay')
disp(theoBW)

disp(sprintf('%i / %i = %f',BW,theoBW,BW/theoBW))
return
%%
clc;
close all;
clear all;



w = linspace(-250E6,250E6,1E2);
a = 100E6;

R = abs(-1./(1i*2*pi*w-a));

plot(w/1E6,R/max(R));
grid;
xlabel('\Delta f [MHz]');
ylabel('Coherence level');
title('FCF');
legend('a = -100E6');