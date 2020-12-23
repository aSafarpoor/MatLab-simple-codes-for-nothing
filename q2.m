format compact
cd('R:\_speech recognition\hw\data')
first = ["S01_P01.wav","S01_P02.wav","S01_P03.wav","S01_P04.wav","S01_P05.wav","S01_P06.wav"];
second = ["S02_P02.wav","S02_P02.wav","S02_P03.wav","S02_P04.wav","S02_P05.wav","S02_P06.wav"];

clf

first_segmented = [];
secound_segmented = [];
colorList1= ["g*","r*","b*","c*","m*","k*"]
colorList2= ["go","ro","bo","co","mo","ko"]

for i=1:6
    name=first(i);
    info = audioinfo(name);
    [y,Fs] = audioread(name);
    sound(y,Fs);
    chunkDuration = 0.030 ;% 30 ms
    numSamplesPerChunk = chunkDuration*Fs;
    list=[];
    chunkCnt = 1;
    counter=0;
    for startLoc = 1:fix(numSamplesPerChunk*1/4):info.TotalSamples- numSamplesPerChunk
        endLoc = min(startLoc + numSamplesPerChunk - 1, info.TotalSamples);
        chunkfile = audioread(name, [startLoc endLoc]);
        %list= [list chunkfile];
        counter = counter+1;
        [coeffs,delta,deltaDelta,loc] = mfcc(chunkfile,Fs);
        list=[list ; [coeffs,delta,deltaDelta,loc]]; 
    end
    
    for j=1:10
        a = 1;
        b = counter;
        r = fix((b-a).*rand(30,1) + a);
        r=sort(r);
        choosed_list=list(r,:);

        [coeff,score,latent] = pca(choosed_list);    
        coeffPrime=coeff';
        dimensionReducted = score*coeffPrime;
        %dimensionReducted = score(1,1:2);
        %dimensionReducted;
        

        x = dimensionReducted(1,1);
        y = dimensionReducted(1,2);
        hold on;
        scatter(x,y,colorList1(i)); 
    end
end


    