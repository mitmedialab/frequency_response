"""
Plays a frequency sweep through an object and simultaneously records the resulting sound
FFT is used to calculate the frequency response of the object.
"""

import sounddevice as sd
import numpy as np
from scipy.fft import fft, ifft
from scipy.io.wavfile import read, write

# path = "audio/sweep17-22k_rate96Khz_42ms.wav"

# Warning: sounddevice can't play very short sounds
# It also has a relatively long delay after playing a sound
path = "audio/8sweep17-22k_rate96Khz_42ms.wav"

fs, data = read(path)

# setup sounddevice
sd.default.samplerate = fs
sd.default.channels = 2

print("playing sound")
print(data)

# play and record responses
trials = 8
responses = []
for i in range(trials):
    resp = sd.playrec(data)
    sd.wait()
    responses.append(resp)

# TODO: print out graphs of the frequency response instead of raw response audio
for i in range(len(responses)):
    write("data/response{0}.wav".format(i), fs, responses[i])
