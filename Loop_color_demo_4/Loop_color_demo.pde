import controlP5.*;
import processing.serial.*;

Serial port;

ControlP5 cp5;
int colorPickerTop = 10, colorPickerLeft = 10;
int MATRIX_SIZE = 3;
LEDMatrix matrix;
ArrayList<DrawAction> actions = new ArrayList<DrawAction>();
int currentColor;
int actionIndex = 0;
int lastActionTime = 0;
int actionInterval = 50;

PFont myFontType;
ColorPicker colorPicker;
float MAX_BRIGHTNESS = 1.0;
float MAX_SATURATION = 1.0;
float MAX_HUE = TWO_PI;
float MAX_ALPHA = 1;
PGraphics mainWin;
int selected = -1;
int currentFrame = 0;
int SEQUENCE_LENGTH = 16;
int NUMBER_OF_LED = 16;
float slice;

void setup() {
  size(920, 1000);
  colorMode(HSB, MAX_HUE, MAX_SATURATION, MAX_BRIGHTNESS, MAX_ALPHA);
   colorPicker = new ColorPicker(colorPickerLeft, colorPickerTop);
  mainWin = createGraphics(300, 280);
  myFontType = createFont("arial", 16);
  textFont(myFontType);
  slice = PI/NUMBER_OF_LED;
  rectMode(CENTER);
  matrix = new LEDMatrix(400, 400, 100, MATRIX_SIZE);
  cp5 = new ControlP5(this);
  
  currentColor = color(0, 0, 100); // default color is white
  colorPicker = new ColorPicker(colorPickerLeft, colorPickerTop);
  
  cp5.addButton("clearAll")
     .setPosition(600, 200)
     .setSize(100, 40)
     .setLabel("Clear All");
     
     //Arduino port
     String portName = Serial.list()[0]; // check all ports can select the first available one
     port = new Serial(this, portName, 9600); //or the Com6 if it works
}

void draw() {
  background(.5, 0, .2);
  colorPicker.display();
  colorPicker.update();
  matrix.display();
  replayActions();
  sendColorsToArduino();//send colors data to Arduino
}

void mousePressed() {
  if (mouseY > colorPickerTop && mouseY < colorPickerTop + colorPicker.pickerHeight) {
   // colorPicker.pickColor(mouseX, mouseY);
    currentColor = colorPicker.activeColor;
  } else {
    actionIndex = 0; // Reset the action index
    matrix.resetColors(); // Clear the matrix to start fresh with the new drag
  }
}

void mouseDragged() {
  if (!(mouseY > colorPickerTop && mouseY < colorPickerTop + colorPicker.pickerHeight)) {
    currentColor = colorPicker.activeColor; 
    int col = (mouseX - matrix.x) / matrix.ledSize;
    int row = (mouseY - matrix.y) / matrix.ledSize;
    if (col >= 0 && col < MATRIX_SIZE && row >= 0 && row < MATRIX_SIZE) {
      actions.add(new DrawAction(row, col, currentColor));
      matrix.setColor(row, col, currentColor); // Immediately set the color without waiting for replay
    }
  }
}

void replayActions() {
  if (!actions.isEmpty() && millis() - lastActionTime > actionInterval) {
    // reset colors and play from first action when all actions finished 
    if (actionIndex >= actions.size()) {
      actionIndex = 0; // reset
     // matrix.resetColors(); // reset color
    }
    DrawAction action = actions.get(actionIndex);
    matrix.setColor(action.row, action.col, action.currentColor); // apply current colors

    lastActionTime = millis();
    actionIndex++; // prepare for the next color
  }
}



void clearAll() {
  actions.clear();
  matrix.resetColors();
  actionIndex = 0;
}

class LEDMatrix {
  int x, y, ledSize, count;
  int[][] colors;

  LEDMatrix(int x, int y, int ledSize, int count) {
    this.x = x;
    this.y = y;
    this.ledSize = ledSize;
    this.count = count;
    colors = new int[count][count];
    resetColors();
  }

  void display() {
    for (int i = 0; i < count; i++) {
      for (int j = 0; j < count; j++) {
        fill(colors[i][j]);
        rect(x + j * ledSize, y + i * ledSize, ledSize, ledSize);
      }
    }
  }

  void setColor(int row, int col, int c) {
    if (row >= 0 && row <count && col >= 0 && col < count) {
colors[row][col] = c;
}
}

void resetColors() {
for (int i = 0; i < count; i++) {
for (int j = 0; j < count; j++) {
colors[i][j] = color(255); // Reset to white or any other background color
}
}
}
}

class DrawAction {
int row, col, currentColor;

DrawAction(int row, int col, int currentColor) {
this.row = row;
this.col = col;
this.currentColor = currentColor;
}
}

//Send colors to Arduino
void sendColorsToArduino() {
  for (int row = 0; row < MATRIX_SIZE; row++) {
    for (int col = 0; col < MATRIX_SIZE; col++) {
      int c = matrix.colors[row][col]; // get color
      int r = (c >> 16) & 0xFF; // get red
      int g = (c >> 8) & 0xFF;  // get green
      int b = c & 0xFF;        // get blue
      // send data to Arduino, format "LED number, R value, G value, B value
     port.write(row * MATRIX_SIZE + col + "," + r + "," + g + "," + b + ";");
      //test only, print value at processing console
      println("LED " + (row * MATRIX_SIZE + col) + ", R: " + r + ", G: " + g + ", B: " + b + ";");
    }
  }
}
