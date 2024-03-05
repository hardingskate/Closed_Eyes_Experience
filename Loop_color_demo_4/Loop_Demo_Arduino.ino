#include <Adafruit_NeoPixel.h>

#define LED_PIN    6  // Pin for the NeoPixel strip
#define LED_COUNT  24 // Number of LEDs in the strip

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(9600);
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
  strip.setBrightness(5);
}

void loop() {
  if (Serial.available() > 0) {
    String input = Serial.readStringUntil('\n');
    int comma1 = input.indexOf(',');
    int comma2 = input.indexOf(',', comma1 + 1);
    int comma3 = input.indexOf(',', comma2 + 1);
    
    if (comma1 != -1 && comma2 != -1) {
      int led = input.substring(0, comma1).toInt();
      int red = input.substring(0, comma1).toInt();
      int green = input.substring(comma1 + 1, comma2).toInt();
      int blue = input.substring(comma2 + 1).toInt();
      
      // Set the color of the entire strip
      for (int i = 0; i < LED_COUNT; i++) {
        strip.setPixelColor(led, strip.Color(red, green, blue));
      }
      strip.show(); // Update strip with new colors
    }
  }
}
