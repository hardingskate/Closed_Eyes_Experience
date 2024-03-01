#include <Adafruit_NeoPixel.h>
#define PIN 6

Adafruit_NeoPixel strip = Adafruit_NeoPixel(12, PIN, NEO_GRB + NEO_KHZ800);


void setup() {
  // put your setup code here, to run once:

  strip.begin();
  strip.setBrightness(50);
  strip.show(); 
  Serial.begin(9600);// Initialize all pixels to 'off'
}

void loop() {
  // put your main code here, to run repeatedly:
  uint32_t red = strip.Color(255, 0, 0, 0);
  uint32_t green = strip.Color(0, 255, 0, 0);
  uint32_t blue = strip.Color(0, 0, 255, 0);
  uint32_t yellow = strip.Color(255, 255, 224, 0);


  if(Serial.available()){
    char val = Serial.read();
    strip.show();
    uint32_t red = strip.Color(255, 0, 0, 0);
    uint32_t green = strip.Color(0, 255, 0, 0);
    uint32_t blue = strip.Color(0, 0, 255, 0);
    uint32_t yellow = strip.Color(225, 235, 54, 0);

    if(val == 'r'){
  
      strip.fill(red, 0, 12);
      strip.show();
    }
    if(val == 'b'){

      strip.fill(blue, 0, 12);
      strip.show();
    }
    if(val == 'g'){

      strip.fill(green, 0, 12);
      strip.show();
    }
    if(val == 'y'){

      strip.fill(yellow, 0, 12);
      strip.show();
    }
    if(val == 'f'){
      strip.show();
    }

  }
}
