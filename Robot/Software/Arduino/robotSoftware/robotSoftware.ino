#include <SoftwareSerial.h>
#include <Servo.h>

SoftwareSerial Bluetooth(3, 4); // RX, TX
Servo servos[6];
int speedDelay = 50; // Default speed

void setup() {
  Serial.begin(9600);
  Bluetooth.begin(9600);
  for (int i = 0; i < 6; i++) {
    servos[i].attach(5 + i); // Attach servos to pins 5 to 10
    servos[i].write(90); // Initial position
  }
}

void loop() {
  processSerialCommunication(Serial); // Process Serial Communication
  processSerialCommunication(Bluetooth); // Process Bluetooth Communication
}

void processSerialCommunication(Stream &communication) {
  if (communication.available() > 0) {
    String dataIn = communication.readStringUntil('E'); // Read the data until 'E'
    if (dataIn.length() > 2 && dataIn[0] == 'S') {
      char command = dataIn[1];
      if (command >= 'a' && command <= 'f') {
        int servoIndex = command - 'a';
        int position = dataIn.substring(2).toInt();
        moveTo(servos[servoIndex], position, speedDelay);
        String response = String(command) + String(position);
        Serial.println(response); // Send echo response
      } else if (command == 'g') {
        speedDelay = dataIn.substring(2).toInt(); // Extract speed value
      }
    }
  }
}

void moveTo(Servo servo, int position, int delayTime) {
  int currentPosition = servo.read();
  if (currentPosition > position) {
    for (int j = currentPosition; j >= position; j--) {
      servo.write(j);
      delay(60-delayTime);
    }
  }
  if (currentPosition < position) {
    for (int j = currentPosition; j <= position; j++) {
      servo.write(j);
      delay(60-delayTime);
    }
  }
}
