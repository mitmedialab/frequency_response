import processing.sound.*;

FFT fft;
AudioIn in;
SoundFile file;
int cnt = 0;

Sound audio_interface; // allow setting up sampling freq, in/output device...
int samp_freq = 96000; // TODO: use 96KHz or 192KHz sound card!!

int freq_bins = 8192;
float[] spectrums = new float[freq_bins];

int smoothed_freq_bins= 1024; // = screen width!! (see below)

void setup() {
    size(1024, 256); // x = smoothed_freq_bins!! (see above)

    audio_interface = new Sound(this);
    audio_interface.sampleRate(samp_freq);

    // Create an Input stream which is routed into the Amplitude analyzer
    fft = new FFT(this, freq_bins);
    in = new AudioIn(this, 0);

    // start the Audio Input & patch the AudioIn
    in.start();
    fft.input(in);

    // ~inaudible frequency sweep
    //file = new SoundFile(this, "freq_resp/sweep17k-22k_rate96Khz_42ms.wav");
    file = new SoundFile(this, "freq_resp/sweep17-22k_rate96Khz_42ms.wav");
}

void draw() {
    // generate chirp and perform the FFT
    int t0 = millis();
    file.play();
    while (file.isPlaying()) delay(1);
    fft.analyze(spectrums);

    // prepare plot
    background(255);
    stroke(100);

    int smooth_factor = freq_bins/smoothed_freq_bins;
    for(int i = 0; i < smoothed_freq_bins; i++){

        // average measures with their neigbors:
        float smoothed_spectrum = 0;
        for (int j = 0; j < smooth_factor; j++) {
            int index = i * smooth_factor + j;
            smoothed_spectrum += spectrums[index];
        }
        smoothed_spectrum /= smooth_factor;

        // draw smoothed frequency response
        int zoom_factor = 300;
        line( i, height,
              i, height - smoothed_spectrum * height * zoom_factor );
    }

    // save spectrum in PNG file:
    if (cnt < 9) {
        if (cnt > 1)
            save("spectrum/A" + (cnt-2) + ".png");
        ++cnt;
    }
    else
        exit();

    // Ensure that ou loop is at least the lenght of an FFT window
    // FFT window = 85.3ms (freq_bins = 8192 samples at 96KHz)
    int fft_window_ms = 1000 * freq_bins / samp_freq;
    while (millis() - t0 < fft_window_ms) delay(1);
    println(millis() - t0);
}

