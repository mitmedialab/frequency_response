import processing.sound.*;

FFT fft;
AudioIn in;

Sound audio_interface; // allow setting up sampling freq, in/output device...
int samp_freq = 96000; // TODO: use 96KHz or 192KHz sound card!!

int freq_bins = 8192;
int spectrum_number = 8; // to smooth over multiple measures
float[][] spectrums = new float[spectrum_number][freq_bins];

SoundFile file;


void setup() {
    size(1024, 512);

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
    int t0 = millis();

    for (int n = 0; n < spectrum_number; n++) {
        file.play();
        while (file.isPlaying()) {
            delay(1);
        }
        // freq_bins = 8192 samples at 96KHz => FFT window = 85.3ms
        fft.analyze(spectrums[n]);
    }
    println(millis() - t0);

    // draw frequency response
    background(255);
    stroke(100);

    for(int i = 0; i < freq_bins; i++){

        // average measures:
        float spectrum = 0;
        for (int n = 0; n < spectrum_number; n++)
            spectrum += spectrums[n][i];
        spectrum /= spectrum_number;

        int zoom_factor = 300;
        line( i, height, i, height - spectrum * height * zoom_factor );
    }
}

