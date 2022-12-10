c=3*10^8;
fc=2.4*(10^9);
lambda=c/fc;
d_res=0.5;
d_max=10;
v_res=0.4;
v_max=5;
A_1=10; % Amplitude of Tx
A_2=5; % Amplitude of Rx

% Tc와 Tf를 먼저 설정하기

Tc=lambda/(4*v_max); % Tc : chirp duration
Tf=lambda/(2*v_res); % Tf : frame duration
N=Tf/Tc;
B=c/(2*d_res);       % B : chirp Bandwidth (300MHz)
slope=B/Tc;
adc_max=slope*2*d_max/c; % adc_max : ADC requirement

%% Generating Tx signal
fs=10*10^9;
dt=1/fs;
t=(0:dt:Tc-dt);

Tx=zeros(N,length(t));
for c_index = 1:N
    Tx(c_index, :)=A_1*cos(2*pi*(fc*(c_index*Tc+t)+slope*(t.^2)/2));
end

% Tx plot
fs_sample=1e+2;
dt_sample=1/fs_sample;
t_sample=(0:dt_sample:1e+3);

Tx_sample=zeros(1,length(t_sample));
Tx_sample=cos(2*pi*(1+(t_sample)+(t_sample).^2));

clf
plot(t, Tx(1,:));
xlabel('time');
title('Transmit Signal');

%% Generating Rx signal
R=5;
v=3;

Rx=zeros(N,length(t));
for c_index = 1:N
    tau=2*(R+v*(c_index*Tc+t))/c;
    Rx(c_index,:)=A_2*cos(2*pi*(fc*(c_index*Tc+t-tau)+slope*((t-tau).^2)/2));
end

% rx plot

%% Mixed Signal & low pass filtered
Mixed_signal=zeros(N,length(t));
for c_index = 1:N
    Mixed_signal(c_index, :) = Tx(c_index, :).* Rx(c_index, :);
end

lp_signal=zeros(N,length(t));
for c_index = 1:N
    lp_signal(c_index,:)=lowpass(Mixed_signal(c_index,:),3*10^9,fs);
end

% lp_signal plot

%% ADC converter
% should be larger than adc_max

ADC_signal=zeros(N,length(t)/(3.125e+6)); % t_down samples per chirp
for c_index = 1:N
    ADC_signal(c_index,:)=lp_signal(c_index,1:3.125e+6:1+(3.125e+6)*19);
    %ADC_signal(c_index, :)=downsample(lp_signal(c_index, :),1e+4);
end

%% 2D FFT & mesh plot
dataused_rv=fft2(ADC_signal);
y=mag2db(abs(dataused_rv));
mesh(y);
%Raxis=
%Vaxis=
