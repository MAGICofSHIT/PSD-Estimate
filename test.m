clc,clear,close all
% 加载信号
load('nr_signal_sr30.72e6.mat'); % 确保文件在当前工作路径
signal = nr_signal; % 假设文件加载的变量名是此名称
% 参数设置
fs = 30.72e6; % 采样率 25 MHz
nfft = length(signal); % 使用信号长度的下一个2的幂进行FFT
% 窗函数应用
window = hann(length(signal)); % 使用汉明窗
windowed_signal = signal .* window;
% 计算窗函数的能量校正因子
window_power = sum(window.^2) / length(window);
% 计算周期图法的功率谱密度
[psd, f] = periodogram(windowed_signal, [], nfft, fs, 'centered');
psd = psd / window_power; % 校正窗函数的影响
% 绘制功率谱密度
figure;
plot(f/1e6, 10*log10(psd)); % 转换为MHz和dB
xlabel('Frequency (MHz)');
ylabel('Power Spectral Density (dB/Hz)');
title('Power Spectral Density using Periodogram with Window');
grid on;
% 带宽估计
threshold = -9; % 带宽估计的门限值 (例如 -3 dB)
psd_dB = 10*log10(psd);
peak_power = max(psd_dB);
bandwidth_indices = find(psd_dB > (peak_power + threshold));
bandwidth_frequencies = f(bandwidth_indices);
% 计算带宽
estimated_bandwidth = max(bandwidth_frequencies) - min(bandwidth_frequencies);
fprintf('Estimated Bandwidth: %.2f MHz\n', estimated_bandwidth / 1e6);