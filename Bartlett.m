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

% Bartlett法分段数
num_segments1 = 32;
num_segments2 = 32;
num_segments3 = 32;

%% 平均周期图法（Bartlett法）
[psd1, f1] = bartlett_psd(signal1, fs1, num_segments1);
[psd2, f2] = bartlett_psd(signal2, fs2, num_segments2);
[psd3, f3] = bartlett_psd(signal3, fs3, num_segments3);

%% 绘制功率谱密度
figure;
plot(f1 / 1e6, 10 * log10(psd1)); % 转换为MHz和dB
xlim([-0.5 * fs1 / 1e6, 0.5 * fs1 / 1e6]);
xlabel('频率 (MHz)');
ylabel('功率/频率 (dB/Hz)');
title('DTMB数字电视地面广播信号功率谱密度 (Bartlett)');
grid on;

figure;
plot(f2 / 1e6, 10 * log10(psd2)); % 转换为MHz和dB
xlim([-0.5 * fs2 / 1e6, 0.5 * fs2 / 1e6]);
xlabel('频率 (MHz)');
ylabel('功率/频率 (dB/Hz)');
title('5G广播PBCH信道信号功率谱密度 (Bartlett)');
grid on;

figure;
plot(f3 / 1e6, 10 * log10(psd3)); % 转换为MHz和dB
xlim([-0.5 * fs3 / 1e6, 0.5 * fs3 / 1e6]);
xlabel('频率 (MHz)');
ylabel('功率/频率 (dB/Hz)');
title('蓝牙信号功率谱密度 (Bartlett)');
grid on;

%% 带宽估计
% 门限设置
threshold1 = -18;
threshold2 = -9;
threshold3 = -21;

psd_dB1 = 10*log10(psd1);
peak_power1 = max(psd_dB1);
bandwidth_indices1 = find(psd_dB1 > (peak_power1 + threshold1));
bandwidth_frequencies1 = f1(bandwidth_indices1);

psd_dB2 = 10*log10(psd2);
peak_power2 = max(psd_dB2);
bandwidth_indices2 = find(psd_dB2 > (peak_power2 + threshold2));
bandwidth_frequencies2 = f2(bandwidth_indices2);

psd_dB3 = 10*log10(psd3);
peak_power3 = max(psd_dB3);
bandwidth_indices3 = find(psd_dB3 > (peak_power3 + threshold3));
bandwidth_frequencies3 = f3(bandwidth_indices3);

% 计算带宽
estimated_bandwidth1 = max(bandwidth_frequencies1) - min(bandwidth_frequencies1);
fprintf('DTMB数字电视地面广播信号估计带宽: %.2f MHz\n', estimated_bandwidth1 / 1e6);

estimated_bandwidth2 = max(bandwidth_frequencies2) - min(bandwidth_frequencies2);
fprintf('5G广播PBCH信道的信号SSB块信号估计带宽: %.2f MHz\n', estimated_bandwidth2 / 1e6);

estimated_bandwidth3 = max(bandwidth_frequencies3) - min(bandwidth_frequencies3);
fprintf('蓝牙信号估计带宽: %.2f MHz\n', estimated_bandwidth3 / 1e6);

%% Bartlett法辅助函数
function [psd, f] = bartlett_psd(signal, fs, num_segments)
    % Bartlett功率谱估计
    segment_length = floor(length(signal) / num_segments);
    overlap = 0;
    window = blackman(segment_length);
    [psd, f] = pwelch(signal, window, overlap, segment_length, fs, 'centered');
end
