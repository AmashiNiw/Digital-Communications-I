clear all;
close all;

N  = 10^3; % number of symbols
am = 2*(rand(1,N)>0.5)-1; % generating random binary sequence
fs = 10; % sampling frequency in Hz

% Snippets of the following code was extracted by the provided source for
% the assignment http://www.dsplog.com/2008/05/01/eye-diagram-plot-matlab-raised-cosine-filter/

% defining the sinc filter
sincNum = sin(pi*[-fs:1/fs:fs]); % numerator of the sinc function
sincDen = (pi*[-fs:1/fs:fs]); % denominator of the sinc function
sincDenZero = find(abs(sincDen) < 10^-10);
sincOp = sincNum./sincDen;
sincOp(sincDenZero) = 1; % sin(pix/(pix) =1 for x =0

% raised cosine filter
alpha = 0.5;
cosNum = cos(alpha*pi*[-fs:1/fs:fs]);
cosDen = (1-(2*alpha*[-fs:1/fs:fs]).^2);
cosDenZero = find(abs(cosDen)<10^-10);
cosOp = cosNum./cosDen;
cosOp(cosDenZero) = pi/4;

gt_alpha5 = sincOp.*cosOp;

alpha = 1;
cosNum = cos(alpha*pi*[-fs:1/fs:fs]);
cosDen = (1-(2*alpha*[-fs:1/fs:fs]).^2);
cosDenZero = find(abs(cosDen)<10^-10);
cosOp = cosNum./cosDen;
cosOp(cosDenZero) = pi/4;
gt_alpha1 = sincOp.*cosOp;

% upsampling the transmit sequence 
amUpSampled = [am;zeros(fs-1,length(am))];
amU = amUpSampled(:).';

% filtered sequence
st_alpha0 = conv(amU,sincOp);
st_alpha5 = conv(amU,gt_alpha5);
st_alpha1 = conv(amU,gt_alpha1);

% taking only the first 10000 samples
st_alpha0 = st_alpha0([1:10000]);
st_alpha5 = st_alpha5([1:10000]);
st_alpha1 = st_alpha1([1:10000]);

st_alpha0_reshape = reshape(st_alpha0,fs*2,N*fs/20).';
st_alpha5_reshape = reshape(st_alpha5,fs*2,N*fs/20).';
st_alpha1_reshape = reshape(st_alpha1,fs*2,N*fs/20).';

close all
figure;
stem([0:1/fs:N-1/fs],amU,'b');     
title('BPSK Signal');
xlabel('time')
ylabel('amplitude') 
grid on

figure;
plot([0:1/fs:1.99],real(st_alpha0_reshape).','b');   
title('Eye Diagram for the Transmit Signal');
xlabel('time')
ylabel('amplitude') 
axis([0 2 -2.5 2.5])
grid on

figure;
plot([0:1/fs:1.99],real(st_alpha5_reshape).','b');   
title('Eye Diagram with \alpha = 0.5');
xlabel('time')
ylabel('amplitude') 
axis([0 2 -1.5 1.5])
grid on

figure;
plot([0:1/fs:1.99],real(st_alpha1_reshape).','b');  
title('Eye Diagram with \alpha = 1') 
xlabel('time')
ylabel('amplitude') 
axis([0 2 -1.5 1.5 ])
grid on



