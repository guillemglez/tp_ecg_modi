load('ecgdata.mat')

%% QUESTION A
ecg4s = ecg3(1:360*4) .* (20 / 2^12) - 10;
plot(linspace(0,4,length(ecg4s)), ecg4s ./ 1000);
xlabel('Temps (s)')
ylabel('ECG (V)')

%% QUESTION B
ecgb1 = ecg4s(1 : 360 / 100 : end);
plot(linspace(0,4,length(ecgb1)), ecgb1 ./ 1000);
xlabel('Temps (s)')
ylabel('ECG (V)')
title('CAN de 12 bits, fs=100Hz')

ecg38b = round(ecg3 ./ (4096 / 256));
ecg4s8b = ecg38b(1:1440) .* (20 / 2^8) - 10;
ecgb2 = ecg4s8b(1 : 360 / 50 : end);
plot(linspace(0,4,length(ecgb2)), ecgb2 ./ 1000);
xlabel('Temps (s)')
ylabel('ECG (V)')
title('CAN de 8 bits, fs=50Hz')

%% QUESTION C
ecg54s = ecg5(1:360*4) .* (20 / 2^12) - 10;

ecgc1 = ecg54s(1 : 360 / 100 : end);
plot(linspace(0,4,length(ecgc1)), ecgc1 ./ 1000);
xlabel('Temps (s)')
ylabel('ECG (V)')
title('ECG5 : CAN de 12 bits, fs=100Hz')

ecg58b = round(ecg5 ./ (4096 / 256));
ecg54s8b = ecg58b(1:1440) .* (20 / 2^8) - 10;
ecgc2 = ecg54s8b(1 : 360 / 50 : end);
plot(linspace(0,4,length(ecgc2)), ecgc2 ./ 1000);
xlabel('Temps (s)')
ylabel('ECG (V)')
title('ECG5 : CAN de 8 bits, fs=50Hz')

%% QUESTION D
ecg = ecg4s;
fs = 360;

moy = mean(ecg);
mark = zeros(length(ecg),1);
for i=1:length(ecg)
    if abs(ecg(i)) > 50*moy
        if ~max(mark) % When it's first maximum found
            mark(i) = 1;
        end
        if ( (i - max(find(mark))) / fs ) > ( 60 / 220 ) % When it's not been too long since last was found
            mark(i) = 1;
        end
    end
end

plot(ecg4s)
xlabel('Échantillons')
ylabel('ECG avec gain (V)')
title('Méthode de détection des QRS')
hold on
plot(find(mark), ecg4s(find(mark)), 'ro')

bpm = 60 ./ ( diff(find(mark)' ) / fs );
stairs(bpm)
xlabel('Section QRS')
ylabel('Fréquence cardiaque (BPM)')
title('Fréquence cardiaque')

