#include <SPI.h>
#include "U8glib.h"
#include "DHT.h"

// Set the OLED display pins
#define OLED_CLK 13
#define OLED_MOSI 11
#define OLED_CS 10
#define OLED_DC 9
#define OLED_RESET 8

// Set the DHT sensor pin
#define DHTPIN 5
#define DHTTYPE DHT22   // DHT 22  (AM2302), AM2321

// Create an OLED display object
U8GLIB_SSD1306_128X64 u8g(OLED_CLK, OLED_MOSI, OLED_CS, OLED_DC, OLED_RESET);

// Initialize DHT sensor
DHT dht(DHTPIN, DHTTYPE);
const int analogInPin = A0;  // 아날로그 입력 핀 0번



void setup() {
  // Initialize the OLED display
  u8g.setFont(u8g_font_unifont);
  u8g.setColorIndex(1);

  // Initialize the serial port for debugging
  Serial.begin(9600);

  // Initialize the DHT sensor
  dht.begin();
}

void loop() {
  // Read the temperature and humidity values from the DHT sensor
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  int Soil_AO = analogRead(analogInPin);
  double SHum = 0.2765*pow(M_E,0.0105*Soil_AO);
  String Soil_status = "";
  Serial.print(Soil_AO);
  Serial.print(" ");
  Serial.println(SHum);
  if (Soil_AO < 300) {
    Soil_status = "dry";
  } else if (Soil_AO < 700) {
    Soil_status = "humid";
  } else if (Soil_AO > 700) {
    Soil_status = "water";
  } else {
    Soil_status = "error";
  }



  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  // Compute heat index in Celsius (isFahrenheit = false)
  float hi = dht.computeHeatIndex(t, h, false);

  int yi = 10;
  int yinc = 15;
  int ci = 10;
  int di = 50;
  // Clear the OLED display
  u8g.firstPage();
  do {
    u8g.drawStr(ci, yi, "Temp: ");
    u8g.drawStr(ci, yi+yinc, "Hum : ");
    u8g.drawStr(ci, yi+yinc*2, "SHum: ");
    u8g.drawStr(ci, yi+yinc*3, "Stat: ");

    u8g.setPrintPos(di, yi);
    u8g.print(t);
    u8g.print("C");
    u8g.setPrintPos(di, yi+yinc);
    u8g.print(h);
    u8g.print("%");
    u8g.setPrintPos(di, yi+yinc*2);
    u8g.print(SHum);
    u8g.print("%");
    u8g.setPrintPos(di, yi+yinc*3);
    u8g.print(Soil_status);
  } while ( u8g.nextPage() );



  // Wait a few seconds before taking the next readings
  delay(2000);
}

