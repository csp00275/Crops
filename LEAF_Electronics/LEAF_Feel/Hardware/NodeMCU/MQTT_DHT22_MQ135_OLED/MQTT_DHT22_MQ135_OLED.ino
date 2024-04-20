#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <MQ135.h>
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
int co2 = 0;

#define PIN_MQ135 A0 // MQ135 Analog Input Pin
#define DHTPIN D4 // DHT Digital Input Pin
#define DHTTYPE DHT22 // DHT11 or DHT22, depends on your sensor

MQ135 mq135_sensor(PIN_MQ135);
DHT dht(DHTPIN, DHTTYPE);

U8G2_SSD1306_128X64_NONAME_1_SW_I2C u8g2(U8G2_R0, /* clock=*/ SCL, /* data=*/ SDA, /* reset=*/ U8X8_PIN_NONE);   // All Boards without Reset of the Display

const char* client_id = "ESP8266_1";
const char* ssid = "JH_HOME_2.4GHz_2G";
const char* password = "STiG051*";
const char* mqtt_server = "192.168.50.84";
WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];
int value = 0;

void setup() {
  pinMode(BUILTIN_LED, OUTPUT);     // Initialize the BUILTIN_LED pin as an output
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  dht.begin();
  u8g2.begin();
}

void setup_wifi() {

  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();

  // Switch on the LED if an 1 was received as first character
  if ((char)payload[0] == '1') {
    digitalWrite(BUILTIN_LED, LOW);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because
    // it is acive low on the ESP-01)
  } else {
    digitalWrite(BUILTIN_LED, HIGH);  // Turn the LED off by making the voltage HIGH
  }

}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect(client_id)) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish("sensors", "hello world");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void loop() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  
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

  if (client.connect(client_id)) {
  char data[30];
  snprintf(data, 30, "%.2f,%.2f,%d,2.0,6.8", t, h, correctedPPM);
  client.publish("sensors", data);
  }
  delay(500);

}



