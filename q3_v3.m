clear
clf 

format compact
cd('R:\_speech recognition\hw\data')
first = ["S01_P01.wav","S01_P02.wav","S01_P03.wav","S01_P04.wav","S01_P05.wav","S01_P06.wav"];
second = ["S02_P02.wav","S02_P02.wav","S02_P03.wav","S02_P04.wav","S02_P05.wav","S02_P06.wav"];

first_segmented = [];
secound_segmented = [];
colorList1= ["g*","r*","b*","c*","m*","k*"];
colorList2= ["g+","r+","b+","c+","m+","k+"];
colorList3= ["go","ro","bo","co","mo","ko"];

dot_list=[];
dot_labels=[];

%noiseless
for i=1:6
    name=first(i);
    info = audioinfo(name);
    [y_noiseless,Fs] = audioread(name);
    y = y_noiseless;
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
    
    for j=1:100
        a = 1;
        b = counter;
        r = fix((b-a).*rand(50,1) + a);
        r=sort(r);
        choosed_list=list(r,:);
        temp = choosed_list(1,:);
       
        for ii=2:50
            temp2=choosed_list(ii,:);
            for iii=1:43
                if(temp(iii) .* temp2(iii)) < 0
                    temp(iii)=-1 * sqrt(-1* temp(iii) .* temp2(iii));
                else
                    temp(iii)=sqrt(temp(iii) .* temp2(iii));
                end
            end
        end
      
        dimensionReducted=temp;
       
        
        x = dimensionReducted(1);
        y = dimensionReducted(2);
        hold on;
        
        dot_list=[dot_list ; dimensionReducted];
        dot_labels=[dot_labels; i];
        
        scatter(x,y,colorList1(i)); 
        
    end
end

true_counter=0;
false_counter=0;

clear r;
%noisy
for i=1:6
    name=first(i);
    info = audioinfo(name);
    [y_noiseless,Fs] = audioread(name);
    y = awgn(y_noiseless,70);
    %sound(y,Fs);
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
    
    for j=1:100
        a = 1;
        b = counter;
        r = fix((b-a).*rand(50,1) + a);
        r=sort(r);
        choosed_list=list(r,:);
        temp = choosed_list(1,:);
       
        for ii=2:50
            temp2=choosed_list(ii,:);
            for iii=1:43
                if (temp(iii) .* temp2(iii)) < 0
                    temp(iii)=-1 * sqrt(-1* temp(iii) .* temp2(iii));
                else
                    temp(iii)=sqrt(temp(iii) .* temp2(iii));
                end
            end
        end
      
        dimensionReducted=temp;
       
        hold on;
        
        minimum=1000000;
        index=-1;
        for ii=1:600
            temp = sum((dot_list(ii,:) - dimensionReducted) .^2);
            if minimum> temp
                minimum=temp;
                index=ii;
            end
        end
        
        flag=false;
        if dot_labels(index) == i 
           
            flag=true;
            true_counter = true_counter +1;
        else
          
            
            false_counter = false_counter +1;
            dot_labels(index);
        end
        
        x= dimensionReducted(1);
        y= dimensionReducted(2);
        if flag
            scatter(x,y,colorList2(i)); 
        else
            scatter(x,y,colorList3(i));
        end
       
    end

end

true_counter
false_counter



    