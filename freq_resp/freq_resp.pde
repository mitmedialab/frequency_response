import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 2048;
float[] spectrum = new float[bands];

SinOsc sine;
Sound audio_interface; // allow setting up sampling freq, in/output device...
int samp_freq = 48000; // TODO: 96KHZ!!


void setup() {
    size(1024, 360);

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

    int t0 = millis();

    // TODO: focus on inaudible: 17 - 24 KHz
    for(int sweep = 0; sweep < 3; sweep++)
    for(int i = 0; i < bands; i++){
        float frequency = i * step;
        sine.freq(frequency);

        // hacky way to wait less than 1ms
        for (int w = 0; w < 10; w++) // wait
            print(".");
    }

    println();
    println(millis() - t0); // should be about 400ms

    fft.analyze(spectrum);

    // draw frequency response
    background(255);
    for(int i = 0; i < bands; i++){
        line( i, height, i, height - spectrum[i]*height*500 );
    }

    delay(500);
}

