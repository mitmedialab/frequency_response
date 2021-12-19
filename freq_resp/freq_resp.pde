import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
float[] response = new float[bands];

SinOsc sine;
Sound audio_interface; // allow setting up sampling freq, in/output device...
int samp_freq = 48000; // TODO: 96KHZ!!


void setup() {
    size(512, 360);

    audio_interface = new Sound(this);
    audio_interface.sampleRate(samp_freq);

    // Create an Input stream which is routed into the Amplitude analyzer
    fft = new FFT(this, bands);
    in = new AudioIn(this, 0);

    // start the Audio Input & patch the AudioIn
    in.start();
    fft.input(in);

    // create and start the sine oscillator.
    sine = new SinOsc(this);
    sine.amp(1);
    sine.play();
}

void draw() {
    float step = (samp_freq/2) / bands;

    // TODO: focus on inaudible: 17 - 22 KHz
    for(int i = 0; i < bands; i++){
        float frequency = i * step;
        sine.freq(frequency);
        delay(1);
        fft.analyze(spectrum);
        response[i] = spectrum[i];
    }

    // draw frequency response
    background(255);
    for(int i = 0; i < bands; i++){
        line( i, height, i, height - response[i]*height*50 );
    }
}

