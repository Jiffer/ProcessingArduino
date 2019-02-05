//////////////////////////////////////////////////
// Jiffer Harriman
// ATLAS Institute
// University of Colorado
//
// Processing to Arduino
//-----------------------------------
// Processing sends an integer to serial port when mouse button is down
// In Arduino, this sets the PWM rate for pin 9 (fade amount for an LED)
//
// Arduino to Processing
//-----------------------------------
// Arduino sends integer value of analog input A0 to serial port.
// Processing expects an integer from serial port which maps to the size of 
// a circle being drawn where the mouse is in Processing window
//////////////////////////////////////////////////

// include serial communications library
import processing.serial.*;

//////// global variables ////////
int gCircleSize = 10;

// create instance of Serial object
Serial usbPort;

void setup() {
  // the window
  size(900, 600);

  // list available serial ports
  
  println(usbPort.list()[3]);
  // connect to port /dev/tty.usbmodem*
  usbPort = new Serial (this, Serial.list( ) [3], 9600); // changed to 4 

  // collect data until you hit a new line character
  usbPort.bufferUntil ('\n');
}

void draw() {
  background(0);
  // bunch of rectangles with a gradient
  for (int i = 0; i < width/10; i++) {
    strokeWeight(10);
    stroke(200, 200, 0, map(i, 0, width/10, 0, 255));
    line(i*10, 0, i*10, height);
  }
  strokeWeight(1);
  stroke(0);

  // draw a circle unless the mouse is pressed
  // if the mouse is down then send the value to the Arduino
  if (!mousePressed) {
    ellipse(mouseX, mouseY, gCircleSize, gCircleSize);
  }
  else {
    // when mouse button is down 
    // send a value over serial port
    usbPort.write((int)map(mouseX, 0, width, 0, 255));
  }
}

// serialEvent handler
// this is called automatically by processing when there is serial data to read
void serialEvent(Serial usbPort) {
  // variable to store the input
  String usbString = usbPort.readStringUntil('\n');
  // save data into usbString variable, removing the whitespace
  usbString = trim(usbString);
  
  // display data to processing window
  //println(usbString);

  // seperate into array of ints 
  // ',' is the expected delimiter
  int sensors[ ] = int(split(usbString, ','));
  println(sensors[1]);
  println(sensors[0]);

  fill(sensors[1]*255);
  gCircleSize = (int)map(sensors[0], 0, 1023, 1, 100);

}