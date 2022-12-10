c=3*10^8;
fc=2*(10^9);
lambda=c/fc;
%d_res=0.5;
%d_max=10;
%v_res=0.4;
%v_max=5;
A_1=10; % Amplitude of Tx
A_2=5; % Amplitude of Rx

% Tc와 Tf를 먼저 설정하기

Tc=lambda/(4*5); % Tc : chirp duration
Tf=lambda/(2*0.4); % Tf : frame duration
N=25;
B=c/(2*0.5);       % B : chirp Bandwidth (300MHz)
slope=B/Tc;
adc_max=slope*2*10/c; % adc_max : ADC requirement

fs=10*10^9;
dt=1/fs;
t=(0:dt:Tc-dt);

%% Generating Rx signal
R=5;
v=3;
% rx plot

%% Mixed Signal & low pass filtered

lp_signal=zeros(N,length(t));
ADC_signal=zeros(N,length(t)/(3.75e+6)); 

for c_index = 1:N
    tau=2*(R+v*(c_index*Tc+t))/c;
    lp_signal(c_index,:)=lowpass(cos(2*pi*(fc*(c_index*Tc+t)+slope*(t.^2)/2)).* cos(2*pi*(fc*(c_index*Tc+t-tau)+slope*((t-tau).^2)/2)),3*10^9,fs);
    ADC_signal(c_index,:)=lp_signal(c_index, 1:3.75e+6:1+(3.75e+6)*19);
end

% lp_signal plot

%% plot test
figure(); plot(mag2db(abs(fftshift(fft(cos(2*pi*(fc*(1*Tc+t)+slope*(t.^2)/2)))))));
figure(); plot(mag2db(abs(fftshift(fft(cos(2*pi*(fc*(1*Tc+t-tau)+slope*((t-tau).^2)/2)))))));

figure();
plot(mag2db(abs(fft(cos(2*pi*(fc*(1*Tc+t)+slope*(t.^2)/2)).* cos(2*pi*(fc*(1*Tc+t-tau)+slope*((t-tau).^2)/2))))));
figure(); plot(mag2db(abs(fft(lp_signal(1,:)))));

figure(); dataused_rv=fft2(ADC_signal);
y=mag2db(abs(dataused_rv));
mesh(y);