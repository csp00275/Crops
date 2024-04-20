#include <MQ135.h>
#include <DHT.h>
#include <U8g2lib.h>

#ifdef U8X8_HAVE_HW_SPI
#include <SPI.h>
#endif
#ifdef U8X8_HAVE_HW_I2C
#include <Wire.h>
#endif


#define PIN_MQ135 A0 // MQ135 Analog Input Pin
#define DHTPIN D4 // DHT Digital Input Pin
#define DHTTYPE DHT22 // DHT11 or DHT22, depends on your sensor

MQ135 mq135_sensor(PIN_MQ135);
DHT dht(DHTPIN, DHTTYPE);

U8G2_SSD1306_128X64_NONAME_1_SW_I2C u8g2(U8G2_R0, /* clock=*/ SCL, /* data=*/ SDA, /* reset=*/ U8X8_PIN_NONE);   // All Boards without Reset of the Display

void setup() {
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

  float rzero = mq135_sensor.getRZero();
  float correctedRZero = mq135_sensor.getCorrectedRZero(t, h);
  float resistance = mq135_sensor.getResistance();
  float ppm = mq135_sensor.getPPM();
  int correctedPPM = mq135_sensor.getCorrectedPPM(t, h);


  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print(" %\t");
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.print(" *C ");
//  Serial.print("MQ135 RZero: ");
//  Serial.print(rzero);
//  Serial.print("\t Corrected RZero: ");
//  Serial.print(correctedRZero);
//  Serial.print("\t Resistance: ");
//  Serial.print(resistance);
//  Serial.print("\t PPM: ");
//  Serial.print(ppm);
//  Serial.print("ppm");
  Serial.print("\t CO2 : ");
  Serial.print(correctedPPM);
  Serial.println("ppm");

    int yi = 15;
  int yinc = 15;
  int ci = 10;
  int di = 60;
  
  u8g2.firstPage();
  do {
    u8g2.setFont(u8g2_font_ncenB10_tr);
    u8g2.drawStr(ci, yi, "Temp: ");
    u8g2.drawStr(ci, yi+yinc, "Hum  : ");
    u8g2.drawStr(ci, yi+yinc*2, "CO2  : ");

    u8g2.setCursor(di, yi);
    u8g2.print(t);
    u8g2.print(" C");
    
    u8g2.setCursor(di, yi+yinc);
    u8g2.print(h);
    u8g2.print(" %");

    u8g2.setCursor(di, yi+yinc*2);
    u8g2.print(correctedPPM);
    u8g2.print(" ppm");
    
  } while ( u8g2.nextPage() );
  delay(1000);

}
