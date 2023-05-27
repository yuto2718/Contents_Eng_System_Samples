from numpy import *
from matplotlib.pyplot import *
from scipy import signal
import sys

fs = 800

def hampel_filter(data, window_size, threshold):
    filtered_data = data.copy() 

    for i in range(window_size, len(data) - window_size):
        window = data[i - window_size : i + window_size + 1] 
        dmedian = median(window) 
        deviation = median(abs(window - dmedian))

        if abs(data[i] - dmedian) > threshold * 1.4826 * deviation:
            filtered_data[i] = dmedian

    return filtered_data

try:
    acc = load("./data.npy")

except:
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


time = arange(size(acc, 0))/fs

acc[argmax(acc)] = mean([acc[argmax(acc)-1], acc[argmax(acc)+1]])

acc = hampel_filter(acc, 30, 2.0)

b,a = signal.butter(9, 30/(800/2))
acc = signal.filtfilt(b, a, acc)

plot(time[:4000], acc[7*800:7*800+4000] - mean(acc[:2000]))
xlim(0, time[4000])
show()