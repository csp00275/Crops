#include <SoftwareSerial.h>
#include <Servo.h>

Servo servos[6];
SoftwareSerial Bluetooth(3, 4); // Arduino(RX, TX) - HC-05 Bluetooth (TX, RX)

int currentPos[6];
int previousPos[6] = {90, 150, 35, 140, 85, 80};
int servoSteps[6][50];
int speedDelay = 20;
String dataIn = "";

void setup() {
  for (int i = 0; i < 6; i++) {
    servos[i].attach(i + 5);
    servos[i].write(previousPos[i]);
  }
  Bluetooth.begin(9600); // Default baud rate of the Bluetooth module
  Bluetooth.setTimeout(1);
  delay(20);
}
void loop(){
  
}