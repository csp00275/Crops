#include <SPI.h>
#include "U8glib.h"

// Set the OLED display pins
#define OLED_CLK D1
#define OLED_MOSI D2
#define OLED_CS D3
#define OLED_DC D4
#define OLED_RESET D5


// Create an OLED display object
U8GLIB_SSD1306_128X64 u8g(OLED_CLK, OLED_MOSI, OLED_CS, OLED_DC, OLED_RESET);

// Initialize DHT sensor

void setup() {
  // Initialize the OLED display
  u8g.setFont(u8g_font_unifont);
  u8g.setColorIndex(1);


}

void loop() {

  int yi = 10;
  int yinc = 15;
  int ci = 10;
  int di = 50;
  // Clear the OLED display
  u8g.firstPage();
  do {
    u8g.drawStr(ci, yi, "Temp: ");
    u8g.drawStr(ci, yi+yinc, "Hum : ");
    //u8g.drawStr(ci, yi+yinc*2, "Heat: ");
  }while ( u8g.nextPage() );
  delay(2000);
}
