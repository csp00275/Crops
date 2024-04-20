#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <time.h>
#include "secrets.h"
#include <DHT.h>
#include <U8g2lib.h>

#ifdef U8X8_HAVE_HW_SPI
#include <SPI.h>
#endif
#ifdef U8X8_HAVE_HW_I2C
#include <Wire.h>
#endif

 
#define DHTPIN D4        // Digital pin connected to the DHT sensor
#define DHTTYPE DHT22   // DHT 11
 
DHT dht(DHTPIN, DHTTYPE);

U8G2_SSD1306_128X64_NONAME_1_SW_I2C u8g2(U8G2_R0, /* clock=*/ SCL, /* data=*/ SDA, /* reset=*/ U8X8_PIN_NONE);   // All Boards without Reset of the Display
 
float h ;
float t;

int cdsVal = 0;
int cdsValueMapped =0;
float lux = 0;
float a = 0.5; // 캘리브레이션에서 구한 a 값
float b = -31; // 캘리브레이션에서 구한 b 값

unsigned long lastMillis = 0;
unsigned long previousMillis = 0;
const long interval = 5000;
 
#define AWS_IOT_PUBLISH_TOPIC   "esp8266/pub"
#define AWS_IOT_SUBSCRIBE_TOPIC "esp8266/sub"
 
WiFiClientSecure net;
 
BearSSL::X509List cert(cacert);
BearSSL::X509List client_crt(client_cert);
BearSSL::PrivateKey key(privkey);
 
PubSubClient client(net);
 
time_t now;
time_t nowish = 1510592825;
 
 
void NTPConnect(void)
{
  Serial.print("Setting time using SNTP");
configTime(TIME_ZONE * 3600, 0 * 3600, "time.bora.net", "ntp.kornet.net");
  now = time(nullptr);
  while (now < nowish)
  {
    delay(500);
    Serial.print(".");
    now = time(nullptr);
  }
  Serial.println("done!");
  struct tm timeinfo;
  localtime_r(&now, &timeinfo); // Use localtime_r() instead of gmtime_r()
  Serial.print("Current time: ");
  Serial.print(asctime(&timeinfo));
}
 
 
void messageReceived(char *topic, byte *payload, unsigned int length)
{
  Serial.print("Received [");
  Serial.print(topic);
  Serial.print("]: ");
  for (int i = 0; i < length; i++)
  {
    Serial.print((char)payload[i]);
  }
  Serial.println();
}
 
 
void connectAWS()
{
  delay(3000);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
 
  Serial.println(String("Attempting to connect to SSID: ") + String(WIFI_SSID));
 
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(1000);
  }
 
  NTPConnect();
 
  net.setTrustAnchors(&cert);
  net.setClientRSACert(&client_crt, &key);
 
  client.setServer(MQTT_HOST, 8883);
  client.setCallback(messageReceived);
 
 
  Serial.println("Connecting to AWS IOT");
 
  while (!client.connect(THINGNAME))
  {
    Serial.print(".");
    delay(100);
  }

  if (!client.connected())
  {
    Serial.print("AWS IoT connection failed, rc=");
    Serial.println(client.state());
    return;
  }
  // Subscribe to a topic
  client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
 
  Serial.println("AWS IoT Connected!");
}
 
 
void publishMessage()
{
  StaticJsonDocument<200> doc;
  doc["time"] = millis();
  doc["humidity"] = h;
  doc["temperature"] = t;
  doc["light"] = cdsValueMapped;

  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
 
  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}
 
 
void setup()
{
  Serial.begin(115200);
  connectAWS();
  dht.begin();
  pinMode(BUILTIN_LED, OUTPUT);     // Initialize the BUILTIN_LED pin as an output
  u8g2.begin();
}
 
 
void loop()
{
  h = dht.readHumidity();
  t = dht.readTemperature();
  cdsVal = analogRead(A0); // CDS 센서의 값 읽어오기
  cdsValueMapped = map(cdsVal, 0, 1023, 0, 255); // 0~1023 범위를 0~255 범위로 매핑

  float lux = a * cdsValueMapped + b; // 캘리브레이션 값으로 조도 값 계산
 
  if (isnan(h) || isnan(t) )  // Check if any reads failed and exit early (to try again).
  {
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }
 

  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print(" %\t");
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.print(" *C ");
  Serial.print("\tLux: ");
  Serial.print(lux);
  Serial.println(" lx");

  int yi = 15;
  int yinc = 15;
  int ci = 10;
  int di = 60;
  
  u8g2.firstPage();
  do {
    u8g2.setFont(u8g2_font_ncenB10_tr);
    u8g2.drawStr(ci, yi, "Temp: ");
    u8g2.drawStr(ci, yi+yinc, "Hum  : ");
    u8g2.drawStr(ci, yi+yinc*2, "Lux  : ");

    u8g2.setCursor(di, yi);
    u8g2.print(t);
    u8g2.print(" C");
    
    u8g2.setCursor(di, yi+yinc);
    u8g2.print(h);
    u8g2.print(" %");

    u8g2.setCursor(di, yi+yinc*2);
    u8g2.print(lux);
    u8g2.print(" lx");
    
  } while ( u8g2.nextPage() );

  delay(500);
 
  now = time(nullptr);
 
  if (!client.connected())
  {
    connectAWS();
  }
  else
  {
    client.loop();
    if (millis() - lastMillis > 500)
    {
      lastMillis = millis();
      publishMessage();
    }
  }
}
