clc, clear, close all

%% 加载信号
load('dtmb522_signal_sr25e6.mat');
load('nr_signal_sr30.72e6.mat');
load('bt_signal_2416_sr8e6.mat');
signal1 = dtmb522_signal;
signal2 = nr_signal;
signal3 = bt_signal;

%% 参数设置
% 采样率
fs1 = 25e6;
fs2 = 30.72e6;
fs3 = 8e6;

% Welch法参数
segment_length1 = 2048; % 每段的长度，可调整
segment_length2 = 2048;
segment_length3 = 1024;
overlap1 = floor(segment_length1 / 2); % 50% 重叠
overlap2 = floor(segment_length2 / 2);
overlap3 = floor(segment_length3 / 2);
window1 = blackman(segment_length1);
window2 = blackman(segment_length2);
window3 = blackman(segment_length3);

%% Welch法功率谱估计
[psd1, f1] = pwelch(signal1, window1, overlap1, segment_length1, fs1, 'centered');
[psd2, f2] = pwelch(signal2, window2, overlap2, segment_length2, fs2, 'centered');
[psd3, f3] = pwelch(signal3, window3, overlap3, segment_length3, fs3, 'centered');

%% 绘制功率谱密度
figure;
plot(f1 / 1e6, 10 * log10(psd1)); % 转换为MHz和dB
xlim([-0.5 * fs1 / 1e6, 0.5 * fs1 / 1e6]);
xlabel('频率 (MHz)');
ylabel('功率/频率 (dB/Hz)');
title('DTMB数字电视地面广播信号功率谱密度 (Welch)');
grid on;

figure;
plot(f2 / 1e6, 10 * log10(psd2)); % 转换为MHz和dB
xlim([-0.5 * fs2 / 1e6, 0.5 * fs2 / 1e6]);
xlabel('频率 (MHz)');
ylabel('功率/频率 (dB/Hz)');
title('5G广播PBCH信道信号功率谱密度 (Welch)');
grid on;

figure;
plot(f3 / 1e6, 10 * log10(psd3)); % 转换为MHz和dB
xlim([-0.5 * fs3 / 1e6, 0.5 * fs3 / 1e6]);
xlabel('频率 (MHz)');
ylabel('功率/频率 (dB/Hz)');
title('蓝牙信号功率谱密度 (Welch)');
grid on;

%% 带宽估计
threshold = -9;

% DTMB信号带宽估计
psd_dB1 = 10 * log10(psd1);
peak_power1 = max(psd_dB1);
bandwidth_indices1 = find(psd_dB1 > (peak_power1 + threshold));
bandwidth_frequencies1 = f1(bandwidth_indices1);
estimated_bandwidth1 = max(bandwidth_frequencies1) - min(bandwidth_frequencies1);
fprintf('DTMB数字电视地面广播信号估计带宽: %.2f MHz\n', estimated_bandwidth1 / 1e6);

% 5G信号带宽估计
psd_dB2 = 10 * log10(psd2);
peak_power2 = max(psd_dB2);
bandwidth_indices2 = find(psd_dB2 > (peak_power2 + threshold));
bandwidth_frequencies2 = f2(bandwidth_indices2);
estimated_bandwidth2 = max(bandwidth_frequencies2) - min(bandwidth_frequencies2);
fprintf('5G广播PBCH信道的信号估计带宽: %.2f MHz\n', estimated_bandwidth2 / 1e6);

% 蓝牙信号带宽估计
psd_dB3 = 10 * log10(psd3);
peak_power3 = max(psd_dB3);
bandwidth_indices3 = find(psd_dB3 > (peak_power3 + threshold));
bandwidth_frequencies3 = f3(bandwidth_indices3);
estimated_bandwidth3 = max(bandwidth_frequencies3) - min(bandwidth_frequencies3);
fprintf('蓝牙信号估计带宽: %.2f MHz\n', estimated_bandwidth3 / 1e6);