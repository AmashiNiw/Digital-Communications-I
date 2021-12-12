close all;
clear all;

N  = 10^3; % number of symbols
ik = rand(1,N)>0.5; % bit sequence
bpsk = 2*(ik)-1 ; % random BPSK signal
h = [0.2 0.9 0.3].'; 

yt = conv(bpsk,h,'same');   % multipath channel output without noise
yn = bpsk ; % awgn channel (before noise got added)

figure;
stem([0:1:N-1],ik,'b');     
title('Binary Sequence');
xlabel('time')
ylabel('Value') 
grid on

figure;
stem([0:1:N-1],bpsk,'b');     
title('BPSK Sequence');
xlabel('time')
ylabel('amplitude') 
grid on

figure;
stem([0:1:N-1],yt,'b');     
title('Transmit Sequence');
xlabel('time')
ylabel('amplitude') 
grid on

%%%%%%%%%%%%%%%%%%%%%%% Bit Error Rate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BER3 = plotOutput(3,N,yt,ik);
BER5 = plotOutput(5,N,yt,ik);
BER7 = plotOutput(7,N,yt,ik);
BER9 = plotOutput(9,N,yt,ik);
BER1 = plotOutput(1,N,yn,ik);

figure;
semilogy(0:10,BER3,'bs-'),'Linewidth',2;
hold on
semilogy(0:10,BER5,'gd-'),'Linewidth',2;
semilogy(0:10,BER7,'ks-'),'Linewidth',2;
semilogy(0:10,BER9,'mx-'),'Linewidth',2;
semilogy(0:10,BER1,'ro-'),'Linewidth',2;
grid on
legend('3 Taps', '5 Taps','7 Taps','9 Taps','AWGN');
xlabel('Power Efficiency $\frac{E_{b}}{N_{0}}$ dB','interpreter','latex');
ylabel('Bit Error Rate');
title('Bit Error Probability Curve for BPSK in ISI with ZF Equalizers');

%%%%%%%%%%%%%%% Uncomment to save figures to folder %%%%%%%%%%%%%%%%%%%%%%%
% FolderName = 'DC1';   % Your destination folder
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% for iFig = 1:length(FigList)
%   FigHandle = FigList(iFig);
%   FigName   = num2str(get(FigHandle, 'Number'));
%   set(0, 'CurrentFigure', FigHandle);
%   %savefig(fullfile(FolderName, [FigName '.fig']));
%   saveas(iFig,FigName,'bmp')
% end

function BER = plotOutput(taps,N,yt,ik)
    BER = zeros(1,11);

    for gamma = 0:10
        
        Eb = 1;
        N0 = Eb/(10^(gamma/10));
        AWGN = sqrt(N0)*randn(1,N); 

        rt = yt + AWGN; %Recieved signal
        
        if taps == 1
            Po = rt;
        
        else
            Pr3 = [0.9 0.2 0; 0.3 0.9 0.2; 0 0.3 0.9];
            P3 = [0 1 0];

            Pr5 = [0.9 0.2 0 0 0; 0.3 0.9 0.2 0 0; 0 0.3 0.9 0.2 0; 0 0 0.3 0.9 0.2; 0 0 0 0.3 0.9];
            P5 = [0 0 1 0 0];

            Pr7 = [0.9 0.2 0 0 0 0 0; 0.3 0.9 0.2 0 0 0 0; 0 0.3 0.9 0.2 0 0 0; 0 0 0.3 0.9 0.2 0 0; 0 0 0 0.3 0.9 0.2 0; 0 0 0 0 0.3 0.9 0.2; 0 0 0 0 0 0.3 0.9];
            P7 = [0 0 0 1 0 0 0];

            Pr9 = [0.9 0.2 0 0 0 0 0 0 0; 0.3 0.9 0.2 0 0 0 0 0 0; 0 0.3 0.9 0.2 0 0 0 0 0; 0 0 0.3 0.9 0.2 0 0 0 0; 0 0 0 0.3 0.9 0.2 0 0 0; 0 0 0 0 0.3 0.9 0.2 0 0; 0 0 0 0 0 0.3 0.9 0.2 0;0 0 0 0 0 0 0.3 0.9 0.2; 0 0 0 0 0 0 0 0.3 0.9];
            P9 = [0 0 0 0 1 0 0 0 0];

            if taps == 3
                Pr = Pr3 ; P = P3;
            elseif taps == 5
                Pr = Pr5 ; P = P5;
            elseif taps == 7
                Pr = Pr7 ; P = P7;
            elseif taps == 9
                Pr = Pr9 ; P = P9;
            end

            C = [inv(Pr)*P.'].';

            Po = conv(rt,C,'same');
            
            
        end
        
        decoded = (Po >= 0); % demodulated and converted sequence
        
        BER(1,gamma+1) = sum(decoded ~= ik )/N;

        figure;
        stem([0:1:N-1],rt,'b');     
        title(['Recieved Signal for \gamma = ',num2str(gamma),' and Taps = ', num2str(taps)]);
        xlabel('time')
        ylabel('amplitude') 
        grid on

        figure;
        stem([0:1:N-1],Po,'b');     
        title(['Filtered Signal by Zero Forcing Equalizer for \gamma = ',num2str(gamma),' and taps = ', num2str(taps)]);
        xlabel('time')
        ylabel('amplitude') 
        grid on

        figure;
        stem([0:1:N-1],decoded,'b');     
        title(['Decoded Sequence for \gamma = ',num2str(gamma),' and taps = ', num2str(taps)]);
        xlabel('time')
        ylabel('Value') 
        grid on
        end
        
    end
    
end

