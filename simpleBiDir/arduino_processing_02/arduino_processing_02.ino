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

int sensorPin = A0;
int ledPin = 9;
int buttonPin = 2;

void setup()
{
  pinMode(ledPin, OUTPUT);
  pinMode(sensorPin, INPUT);
  pinMode(buttonPin, INPUT_PULLUP);
  
  Serial.begin(9600);
}

void loop(){
  // read inputs
  int a0_input = analogRead(sensorPin);
  int buttonValue = digitalRead(buttonPin);
  
  // print data from sensor pin (A0) to the serial port for processing to read
  Serial.print(a0_input);
  Serial.print(',');
  Serial.print(buttonValue);
 
  // end of message, send "new line"  
  Serial.println();
  
  // check for serial data
  if (Serial.available() > 0) {
    int serialIn = Serial.read();
    
    analogWrite(ledPin, serialIn);
  }
}
