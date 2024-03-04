#include <Adafruit_NeoPixel.h>

#define MIC A0 // Microphone is connected at pin A)
#define LED_PIN 11 // LED are connected to D11
#define N_PIXELS 180 // Number of LED 
#define N 100 // Number of samples 
#define fadeDelay 10 // fade amount
#define noiseLevel 15 // Amount of noice we want to chop off 

Adafruit_NeoPixel strip = Adafruit_NeoPixel(N_PIXELS, LED_PIN, NEO_GRB + NEO_KHZ800);

int samples[N]; // storage for a sample 
int periodFactor = 0; // For period calculation
int t1 = -1; 
int T; 
int slope; 
byte periodChanged = 0;


void setup() {
  // Serial.begin(9600);
  strip.begin();
  ledsOff();
  delay(500);
  displayColor(Wheel(100));
  strip.show();
  delay(500);
}


void loop() {
  Samples();
}

void Samples() {
  for(int i=0; i<N; i++) {
    samples[i] = analogRead(0);
    if(i>0) {
      slope = samples[i] - samples[i-1];
    }
    else {
      slope = samples[i] - samples[N-1];
    }
    
    if(abs(slope) > noiseLevel) {
      if(slope < 0) {
        calculatePeriod(i);
        if(periodChanged == 1) {
          displayColor(getColor(T));
        }
      }
    }
    else {
      ledsOff();
    }
    periodFactor += 1;
    delay(1);
  }
}

void calculatePeriod(int i) {
  if(t1 == -1) {
  
    t1 = i;
  }
  else {
    
    int period = periodFactor*(i - t1);
    periodChanged = T==period ? 0 : 1;
    T = period;
  // Serial.println(T);
   
    t1 = i;
    periodFactor = 0;
  }
}

uint32_t getColor(int period) {
  if(period == -1)
    return Wheel(0);
  else if(period > 400)
    return Wheel(5);
  else
    return Wheel(map(-1*period, -400, -1, 50, 255));
}

void fadeOut()
{
  for(int i=0; i<5; i++) {
    strip.setBrightness(110 - i*20);
    strip.show(); // Update strip
    delay(fadeDelay);
    periodFactor +=fadeDelay;
  }
}

void fadeIn() {
  strip.setBrightness(100);
  strip.show();

  for(int i=0; i<5; i++) {
    //strip.setBrightness(20*i + 30);
    //strip.show();
    delay(fadeDelay);
    periodFactor+=fadeDelay;
  }
}

void ledsOff() {
  fadeOut();
  for(int i=0; i<N_PIXELS; i++) {
    strip.setPixelColor(i, 0, 0, 0);
  }
}

void displayColor(uint32_t color) {
  for(int i=0; i<N_PIXELS; i++) {
    strip.setPixelColor(i, color);
  }
  fadeIn();
}


uint32_t Wheel(byte WheelPos) {
  // Serial.println(WheelPos);
  if(WheelPos < 85) {
   
    return strip.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
  } 
  else if(WheelPos < 170) {
    WheelPos -= 85;
    return strip.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  } 
  else {
    WheelPos -= 170;
    return strip.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
}

