load('signalsTiltLearn.mat')
plot(ECG)
hold on
plot(round(tqrs), ECG(round(tqrs)), 'ro')

%% QUESTION B

bats = zeros(round(min(diff(tqrs))),length(tqrs));
for i=2:length(tqrs)-1
    bat = ECG(round(tqrs(i)-(tqrs(i)-tqrs(i-1))/2):round(tqrs(i+1)-(tqrs(i+1)-tqrs(i))/2));
    if mod(length(bat),2)
        bat = bat(1:end-1); % if odd, we take away one sample
    end
    coupe = abs((length(bat) - length(bats))) / 2;
    bats(:,i) = bat(1+coupe:end-coupe);
end
bats = bats(:,2:end-1);

moybat = mean(bats');

plot(moybat);
xlabel('Échantillons')
ylabel('ECG avec gain (V)')
title('Moyenne des battements dans le signal')

plot(moybat)
hold on
xlabel('Échantillons')
ylabel('ECG avec gain (V)')
title('Moyenne des battements dans le signal')
plot(181:323,moybat(181:323))
plot(324:500,moybat(324:500))
plot(501:length(moybat),moybat(501:end))
legend('Battement moyen','Onde P','Complexe QRS','Onde T')
hold off

moybat = [moybat zeros(1, 2048 - length(moybat) - 1)];
p = [zeros(1,180) moybat(181:323) zeros(1, 2048 - 180 - 323 + 181 - 1)];
qrs = [zeros(1,323) moybat(324:500) zeros(1, 2048 - 323 - 500 + 324 - 1)];
t = [zeros(1,500) moybat(501:end) zeros(1, 2048 - 500 - length(moybat) + 501 - 1)];

moybat = moybat - mean(moybat);
p = p - mean(p);
qrs = qrs - mean(qrs);
t = t - mean(t);

fftbat = fft(moybat)/length(moybat);
dspbat = fftbat.*conj(fftbat);
fftp = fft(p)/length(p);
dspp = fftp.*conj(fftp);
fftqrs = fft(qrs)/length(qrs);
dspqrs = fftqrs.*conj(fftqrs);
fftt = fft(t)/length(t);
dspt = fftt.*conj(fftt);

plot(linspace(1,500,1024),dspbat(1:1024),'y')
hold on
plot(linspace(1,500,1024),dspp(1:1024),'g')
plot(linspace(1,500,1024),dspqrs(1:1024),'b')
plot(linspace(1,500,1024),dspt(1:1024),'r')
legend('Battement','Onde P','Complexe QRS','Onde T')
xlabel('Fréquence (Hz)')
ylabel('Amplitude avec gain (V)')
title('Densité spectrale de puissance d''un battement moyen')
%% QUESTION D
% On détermine les fréquences de coupure de 10 et 15 Hz.

fhaut = fir1(200,10*2/1000,'high');
fbas = fir1(100,15*2/1000,'low');
fecg = filter(fhaut,1,filter(fbas,1,ECG));

%%  QUESTION E

hfvt = fvtool(fbas,1,fhaut,1)
legend(hfvt,'Filtre passe-bas','Filtre passe-haut')

i = 50;
filtbat = fecg(round(tqrs(i)-(tqrs(i)-tqrs(i-1))/2):round(tqrs(i+1)-(tqrs(i+1)-tqrs(i))/2));
plot(filtbat)
xlabel('Échantillons')
ylabel('ECG avec gain (V)')
title('Battement filtré')

%% QUESTION F

ecg = fecg;
fs = 1000;

mark = zeros(length(ecg),1);
ecgdiff = diff(ecg);
for i=1:length(ecgdiff)
    if abs(ecgdiff(i)) > 3e-3
        if ~max(mark) % When it's first maximum found
            mark(i) = 1;
        end
        if ( (i - max(find(mark))) / fs ) > ( 60 / 220 ) % When it's not been too long since last was found
            mark(i) = 1;
        end
    end
end

plot(ECG)
hold on
plot(find(mark), ECG(find(mark)), 'ro')
title('Extrait du signal avec détection')
xlabel('Échantillons')
ylabel('ECG avec gain (V)')

%% QUESTION G

bpm = 60 ./ ( diff(find(mark)' ) / fs );
stairs(bpm)
xlabel('Battements')
ylabel('Fréquence cardiaque (BPM)')
