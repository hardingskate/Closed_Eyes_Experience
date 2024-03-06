#include <Adafruit_NeoPixel.h>

#define PIN 6 // Pin connected to the matrices
//#define PIN 13
//#define NUMPIXELS 18 // Total number of pixels (9 pixels per matrix * 2)
#define NUMPIXELS 24

Adafruit_NeoPixel strip(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
  Serial.begin(9600);
}

void loop() {
  if (Serial.available() > 0) {
    // Expecting data in the format: R,G,B,Brightness,RefreshRate
    int R, G, B, brightness;
    char buffer[32];
    memset(buffer, 0, sizeof(buffer)); // Clear the buffer
    Serial.readBytesUntil('\n', buffer, sizeof(buffer) - 1);
    sscanf(buffer, "%d,%d,%d,%d", &R, &G, &B, &brightness);

    strip.setBrightness(brightness);
    for (int i = 0; i < NUMPIXELS; i++) {
      strip.setPixelColor(i, strip.Color(R, G, B));
    }
    strip.show();
    // Implement refresh rate handling if needed
  }
}
