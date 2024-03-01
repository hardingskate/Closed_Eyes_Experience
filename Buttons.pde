import controlP5.*;  //import ControlP5 library
import processing.serial.*;

Serial port;

ControlP5 cp5; //create ControlP5 object
PFont font;

void setup() {
  size(300, 600);
  
  printArray(Serial.list()); //print available serial ports
  port = new Serial(this, "COM6", 9600); //I have 
  
  //ADD TO THE EMPTY WINDOW
  cp5 = new ControlP5(this);
  font = createFont("calibri light", 20);
  
  cp5.addButton("red")
    .setPosition(100, 50) //x and y cordinates of upper left
    .setSize(100, 80)
    .setFont(font)
    ;
  cp5.addButton("yellow")
    .setPosition(100, 150) //x and y cordinates of upper left
    .setSize(100, 80)
    .setFont(font)
    ;
  cp5.addButton("blue")
    .setPosition(100, 250) //x and y cordinates of upper left
    .setSize(100, 80)
    .setFont(font)
    ;
  cp5.addButton("green")
    .setPosition(100, 350) //x and y cordinates of upper left
    .setSize(100, 80)
    .setFont(font)
    ;
  cp5.addButton("off")
    .setPosition(100, 450) //x and y cordinates of upper left
    .setSize(100, 80)
    .setFont(font)
    ;
}

void draw() {

    background(150, 0, 150); //background color of window
    
    text("LED CONTROL", 100, 30);
}

void red(){
  port.write('r');
}
void yellow(){
  port.write('y');
}
void blue(){
  port.write('b');
}
void green(){
  port.write('g');
}
void off(){
  port.write('f');
}
