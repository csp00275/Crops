#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>
#include <U8g2lib.h>

#ifdef U8X8_HAVE_HW_SPI
#include <SPI.h>
#endif
#ifdef U8X8_HAVE_HW_I2C
#include <Wire.h>
#endif

float h = 0;
float t = 0;

#define DHTPIN D4 // DHT Digital Input Pin
#define DHTTYPE DHT22 // DHT11 or DHT22, depends on your sensor

DHT dht(DHTPIN, DHTTYPE);

U8G2_SSD1306_128X64_NONAME_1_SW_I2C u8g2(U8G2_R0, /* clock=*/ SCL, /* data=*/ SDA, /* reset=*/ U8X8_PIN_NONE);   // All Boards without Reset of the Display

void setup() {
  pinMode(BUILTIN_LED, OUTPUT);     // Initialize the BUILTIN_LED pin as an output
  Serial.begin(115200);

  dht.begin();
  u8g2.begin();
}



void loop() {

  
  float h = dht.readHumidity();
  float t = dht.readTemperature();
 

  if (isnan(h) || isnan(t)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }

  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print(" %\t");
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.println(" *C");

  int yi = 15;
  int yinc = 15;
  int ci = 10;
  int di = 60;
  
  u8g2.firstPage();
  do {
    u8g2.setFont(u8g2_font_ncenB10_tr);
    u8g2.drawStr(ci, yi, "Temp: ");
    u8g2.drawStr(ci, yi+yinc, "Hum  : ");

    u8g2.setCursor(di, yi);
    u8g2.print(t);
    u8g2.print(" C");
    
    u8g2.setCursor(di, yi+yinc);
    u8g2.print(h);
    u8g2.print(" %");
    
  } while ( u8g2.nextPage() );

  delay(500);

}

