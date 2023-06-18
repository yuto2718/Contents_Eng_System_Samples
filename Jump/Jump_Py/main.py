from numpy import *
from matplotlib.pyplot import *
from scipy import signal
import sys

fs = 800    #サンプリング周波数

def hampel_filter(data, window_size, threshold):    #ハンペルフィルタ　外れ値を検出し，区間的な中央値に置き換える
    filtered_data = data.copy() 

    for i in range(window_size, len(data) - window_size):
        window = data[i - window_size : i + window_size + 1] 
        dmedian = median(window) 
        deviation = median(abs(window - dmedian))

        if abs(data[i] - dmedian) > threshold * 1.4826 * deviation:
            filtered_data[i] = dmedian

    return filtered_data


try:#読み込んだ一時ファイルがあれば読み込む
    acc = load("./data.npy")

except:#一時ファイルがなければ，データを読み込んで成形
    file_path = "./teraterm.log"
    data = []
    with open(file_path, "r") as file:
        for line in file:
            try:
                data.append(line.strip().split()[-1:][0])
            except:
                pass
            
    data = array(data, dtype = double)
    save("data.npy", data)
    acc = load("./data.npy")


time = arange(size(acc, 0))/fs  #時間軸を設定

acc = hampel_filter(acc, 30, 2.0)   #ハンペルフィルタを適用．窓幅：30 point 外れ値とする範囲：2σ(標準偏差の２倍, 正規分布であれば95.45 %)

b,a = signal.butter(9, 30/(800/2))  #カットオフ周波数 30 Hz 9次バタワース特性のローパスフィルタのフィルタ係数の取得
acc = signal.filtfilt(b, a, acc)    #ゼロ位相フィルタリング

#表示
plot(time[:4000], acc[7*800:7*800+4000] - mean(acc[:2000]))
xlim(0, time[4000])
show()