clc;
close all;
clear all;


% %% Read all data 
% 
% data =  zeros(41,7,9,3780);
% k = 1;
% disp('Load FILE1')
% for n = 1:1250
%     name = sprintf('Meas/FILE%i_%.4i.csv',k,n);
%     data(:,:,k,n) = dlmread(name,',',[7 0 47 6]);
% end
% 
% k = 2;
% disp('Load FILE2')
% for n = 1:2520
%     name = sprintf('Meas/FILE%i_%.4i.csv',k,n);
%     data(:,:,1,1250+n) = dlmread(name,',',[7 0 47 6]);
% end
% 
% for k = 3:6;
%     fprintf('Load FILE%i\n',k)
%     for n = 1:3780
%         name = sprintf('Meas%i/FILE%i_%.4i.csv',k,k,n);
%         data(:,:,k-1,n) = dlmread(name,',',[7 0 47 6]);
%     end
% end
% 
% for k = 7:10;
%     fprintf('Load FILE%i\n',k)
%     for n = 1:3780
%         name = sprintf('Meas%i/FILE%iN_%.4i.csv',k,k,n);
%         data(:,:,k-1,n) = dlmread(name,',',[7 0 47 6]);
%     end
% end
% disp('Done loading')
% data(:,:,1,3770:3780) = data(:,:,4,3770:3780);
% save data;
%% restructure data
load data;
f = data(:,1,1,1);
mag = [data(:,2,:,:) data(:,4,:,:) data(:,6,:,:)];
magLin = 10.^(mag/10);

%fade = magLin./repmat(mean(magLin,1),41,1,1,1);    % remove PL based on frequency
%fade2 = 10*log10(sort(reshape(fade,41*3*9*3780,1)));

fade = squeeze(cat(4,magLin(:,:,1,:),magLin(:,:,2,:),magLin(:,:,3,:),magLin(:,:,4,:),magLin(:,:,5,:),magLin(:,:,6,:),magLin(:,:,7,:),magLin(:,:,8,:),magLin(:,:,9,:)));
fade = reshape(fade,41,3*34020);

%% Corrlation
close all
sz = size(fade);
% SCF
ACF = zeros(1,50);
for n = 1:sz(1)
    [acf,lags,bounds] = autocorr(fade(n,1:10000),49);
    ACF = ACF+acf;
end

ACF = ACF./41;
stem([0:length(ACF)-1],ACF); hold on;

ACF = zeros(41,1);
for n = 1:sz(2)
    [acf,lags,bounds] = autocorr(fade(:,n),40);
    ACF = ACF+acf;
end

ACF = ACF./sz(2);
stem([0:length(ACF)-1],ACF)
legend('SCF','FCF');
xlabel('Lags');
ylabel('Correlation');
title('SCF and FCF');
grid;



%% Remove PL

PL = repmat(mean(fade,2),1,102060);
fade2 = fade./PL;
fade3 = reshape(fade2,41*3*9*3780,1);

pd = fitdist(fade3,'Rician');
K = pd.s^2/(2*pd.sigma^2);
fade3 = 10*log10(sort(fade3));
figure
p = (1:length(fade3))./length(fade3);
semilogy(fade3,p);
title('CDF of data')
xlabel('Fading gain [dB]');
ylabel('Probability');
grid;

% figure
% autocorr(fade3,10);
% for n = 2:3
%     clear fade4;
%     m = 1;
%     while 1+n*(m-1) < length(fade3)
%        fade4(m) = fade3(1+n*(m-1));
%        m = m+1;
%     end
% 	figure
%     autocorr(fade4,10);
% end


