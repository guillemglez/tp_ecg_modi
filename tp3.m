load("signalsTilt.mat")
fe = 1000;

t = linspace(0,length(ECG)/fe,length(ECG));
iter = 1 : 4*fe : (length(ECG)-(10*fe));
bpm = zeros(length(iter),1);

for i = iter
    ecg = ECG(i:i+10*fe);
    
    fhaut = fir1(200,10*2/fe,'high');
    fbas = fir1(100,15*2/fe,'low');
    fecg = filter(fhaut,1,filter(fbas,1,ecg));
    
    mark = zeros(length(ecg),1);
    ecgdiff = diff(ecg);
    for j=1:length(ecgdiff)
        if abs(ecgdiff(j)) > 3e-3
            if ~max(mark) % When it's first maximum found
                mark(j) = 1;
            end
            if ( (j - find(mark, 1, 'last' )) / fe ) > ( 60 / 220 ) % When it's not been too long since last was found
                mark(j) = 1;
            end
        end
    end
    
    bpmthis = 60 ./ ( diff(find(mark)' ) / fe );
    bpm( round ( i / (4*fe) ) + 1 ) = mean(bpmthis);   
end

stairs(bpm)
xlabel('Sections d''évaluation')
ylabel('Fréquence cardiaque (BPM)')
