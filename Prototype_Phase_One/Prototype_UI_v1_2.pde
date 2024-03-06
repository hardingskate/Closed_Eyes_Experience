import com.krab.lazy.*;
import processing.serial.*;
Serial myPort;  // Create object from Serial class
LazyGui gui;

void setup() {
  //USE TO GET "STRING" VALUE OF PORT (e.g. "
  //println(Serial.list());
  String portName = "/dev/cu.wchusbserial575E0732491"; // Change this to match your port
  myPort = new Serial(this, portName, 9600);
  
  size(1144, 880, P2D);
  smooth(8);
  gui = new LazyGui(this);
  
  gui.slider("brightness", 50, 0, 255); // Assuming brightness range is 0-255
  gui.colorPicker("RGBColor", color(100));
}

void draw() {
  background(0);

  // Check if the event comes from the brightness slider or the RGB myColor picker
    // Get the brightness value
    float brightness = gui.slider("brightness");
    
    // Get the myColor value
    int myColor = gui.colorPicker("RGBColor").hex;
    // Extract RGB components from the myColor
    int R = (myColor >> 16) & 0xFF;
    int G = (myColor >> 8) & 0xFF;
    int B = myColor & 0xFF;
    
    // Format the string to send
    String toSend = R + "," + G + "," + B + "," + (int)brightness + "\n";
    
    // Write the formatted string to the serial port
    myPort.write(toSend);
  }
