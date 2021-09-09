#include <Wire.h>

#define NUM_BYTES 3

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Wire.begin();
  
  //WRITE
  Wire.beginTransmission(0b1100110);         // Device address bits (7b) and write bit (1b)
  Wire.write(0b11111100);                    // Memory address (7b) and write bit (1b) (0x7E)
  Wire.write(0xA2);                          // Data to be written to memory location 0x7E
  Wire.write(0xB2);                          // Data to be written to memory location 0x7F
  Wire.write(0xC2);                          // This is a garbage value that shouldn't be written into memory because NACK will be set (address only increments to 0x7F)
  Wire.endTransmission(1);
 
  //READ
  Wire.beginTransmission(0b1100110);         // Resend device address after stopping.
  Wire.write(0b00000111);                    // Write memory location (7b) to be read from and read bit (1b)
  Wire.endTransmission(0);                   // Repeat start
  Wire.requestFrom(0b1100110, NUM_BYTES);    // Device address, 3 bytes
  
  for (int i = 0; i <= NUM_BYTES-1; i++)
  {
    byte x = Wire.read();             
    Serial.println(x,HEX);
  }
  
  
  
  
  
  /*Wire.write(0b00000001);
  Wire.requestFrom(0b1100110, 2);
  byte x = Wire.read();
  byte y = Wire.read();
  byte z = Wire.read();

  Wire.endTransmission();

  Serial.println(x);
  Serial.println(y);
  Serial.println(z);
  */
}

void loop() {
  // put your main code here, to run repeatedly:

}
