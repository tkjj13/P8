
clear


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

figure(1)

plot( 10*log10( PDP ) )
xlabel( 'Delay index' )
ylabel( 'Power [dB]' )
title( 'Power-delay profile' )



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% narrowband data

Tx = 1:2; % from range 1:2
Rx = 2; % from range 1:2

Pos = 1:1:600;

InMeasName = 'Stud2017-2_H';

InDataPath = './MeasData/'; % with the slash

Fs = 60; % IR sampling frequency


% H( Tx, Rx, Position )

eval( sprintf( 'load %s/%s', InDataPath, InMeasName ) );

figure(2)

plot( 20*log10( abs( squeeze( H( Tx, Rx, : ))')))

xlabel( 'Time index' )
ylabel( 'Power [dB]' )
title( 'Narrowband power in different branches' )

A = fftshift(fft(H,[],3));
S = abs(A).^2;

S2 = S./sum(S,3);
data(:) = S2(1,2,:);
figure
plot(data)
