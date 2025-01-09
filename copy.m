clc,clear,close all
% 加载信号
load('bt_signal_2416_sr8e6.mat'); % 确保文件在当前工作路径
signal = bt_signal; % 假设文件加载的变量名是此名称

% 参数设置
Fs = 8e6; % 采样率 25 MHz
nfft = length(signal); %     FFT 点数
window = hamming(nfft); % 窗口函数

% 计算功率谱密度 (PSD) 使用 Welch 方法
[pxx, f] = periodogram(signal, window, nfft, Fs, 'centered');

% 转换频率为 MHz
f_MHz = f / 1e6;

% 绘制双边功率谱密度图
figure;
plot(f_MHz, 10*log10(pxx)); 
xlabel('Frequency (MHz)');
ylabel('Power Spectral Density (dB/Hz)');
title('Double-Sided Power Spectral Density (PSD)');
grid on;

% 带宽估计
% 设定门限值，例如最大值的 10 dB 降低点
threshold = max(pxx) * 10^(-10/10);
bw_indices = find(pxx > threshold);
bandwidth = (max(f(bw_indices)) - min(f(bw_indices))) / 1e6; % 单位 MHz

% 打印带宽估计结果
fprintf('Estimated Bandwidth: %.2f MHz\n', bandwidth);
