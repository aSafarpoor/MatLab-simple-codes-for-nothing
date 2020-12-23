
format compact
cd('R:\_speech recognition\hw\data')

[y,Fs] = audioread("S01_P01.wav");

chunkDuration = 0.030 ;% 30 ms
numSamplesPerChunk = chunkDuration*Fs;
list=[];list2=[];
chunkCnt = 1;
counter=0;
for startLoc = 1:fix(numSamplesPerChunk*1/4):info.TotalSamples- numSamplesPerChunk
    endLoc = min(startLoc + numSamplesPerChunk - 1, info.TotalSamples);
    chunkfile = audioread(name, [startLoc endLoc]);
   
end


y=chunkfile ;

energy = sum((abs(y)).^2);
len_y = size(y);
len_y = len_y(1);
dft = fft(y);
mag_dft = abs(dft);

%n=size(mag_dft);
%[mel_list,b]=melfilter(14,Fs ,@triang); %creates 24 filter, mel filter bank
%spectrl=log10(mag_dft* mel_list'.^2);

n=size(mag_dft);
f=ifft(mag_dft);			        % rfft() returns only 1+floor(n/2) coefficients
%f= mag_dft'
x=melbankm(14,1323,Fs);	        % n is the fft length, p is the number of filters wanted
spectrl=log(abs(f)*x.^2);         % multiply x by the power spectrum


idft = zeros(1,14);
for  i_index=1:14
    for j_index=1:len_y
        idft(i_index)=idft(i_index) + spectrl(j_index,i_index) * exp(i * j_index * i_index);
    end
end
idft= abs(idft / (2 *pi));

delta=[];
expanded_idft  = [idft(1) idft idft(end)];
for i_index= 2:15
    i_index;
    delta(i_index-1)= expanded_idft(i_index + 1) - expanded_idft(i_index - 1);
end

delteDelta=[];
expanded_delta  = [delta(1) delta delta(end)];
for i_index= 2:15
    delteDelta(i_index-1)= expanded_delta(i_index + 1) - expanded_delta(i_index - 1);
end

coeff= idft;


