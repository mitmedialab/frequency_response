import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

SinOsc sine;


void setup() {
    size(512, 360);
    background(255);

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
    background(255);
    fft.analyze(spectrum);

    float frequency = map(mouseX, 0, width, 80.0, 1000.0);
    sine.freq(frequency);


    for(int i = 0; i < bands; i++){
        // The result of the FFT is normalized
        // draw the line for frequency band i scaling it up by 5 to get more amplitude.
        line( i, height, i, height - spectrum[i]*height*5 );
    }
}
