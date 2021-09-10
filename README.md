# I2C-Subordinate-Interface

## Table of contents

## Introduction

The goal of this project was to design an I2C interface only using the [I2C standard document](https://www.nxp.com/docs/en/user-guide/UM10204.pdf). We created a memory interface to communicate over I2C with a master device. We designed our I2C and memory interface in SystemVerilog and implemented the design on an FPGA.

This document will explain the design and specification of the subordinate device and give a couple examples of operation.






## Device Overview

The unique I2C device address is 1100110.
We created testbenches and examined each module in ModelSim's waveform viewer to verify correct operation.
We instantiated a memory block that is 8 bits wide and 128 entries deep.
We used the DE1-SoC FPGA to test.
We interfaced the FPGA with an Arduino using the Wire library to act as a master device.
State machine diagrams and block diagrams can be found in the [diagrams](#diagrams) section



## Objectives

- Learn about the I2C standard
- Gain experience designing according to a standard
- Gain experience with SystemVerilog design and verification
- Implement digital design on hardware (FPGA)
- Interface FPGA with external devices



## Operation

### Write Operation
We have two modes of operation, write mode and read mode. During a write operation the master sends data to memory, and during a read operation the master receives data from memory.

As specified in the I2C standard, during a write operation the master initiates the transmission by sending a start condition followed by the device address (7b) and a write bit. The next byte of data sent is the memory address (7b) followed by a write bit. After each byte of data is stored, the memory address is incremented by one. This process repeats until either the master sends a stop condition or the final memory address (0x7F) is reached. In the case where the final memory address is reached, the subordinate device will go to a wait state and the master will received a NACK on the next byte of data.

Write figure
![I2C Write Operation](Documentation/I2C_Write_to_Memory.png)

### Read Operation
During a read operation the master initiates the transmission by sending a start condition followed by the device address (7b) and a write bit. The next byte of data sent is the memory address (7b) followed by a read bit. Next the master sends a repeated start condition followed by the device address (7b) and a read bit. The subsequent bytes are read from the specified memory address. After each data byte is received, the memory address is incremented by one until the final memory address is reached. When the final memory address is reached the subordinate device will go to a wait state and the master will receive garbage values for the rest of the transmission if bytes of data were requested beyond the final memory address.  


![I2C Read Operation](Documentation/I2C_Read_from_Memory.png)
Read figure

## Example

We will cover two examples interfacing with our I2C device using an Arduino with the Wire library. We used the Quartus software to program our FPGA and used the in-system memory content editor to view the memory running on our FPGA. We initialized our memory with some random values.

### Write to memory example

This example covers how to write data to memory. We start the transmission and write the device address of '1100110'. We then write the memory address '1111110' (0x7E) followed by a write bit '0'. Next we write the value 0xA2 to memory address 0x7E. The memory address will increment automatically, and we write the value 0xB2 to memory address 0x7F. To demonstrate a corner case, we try to write the value 0xC2 however this action is not valid since we have reached the last memory address 0x7F and the master will receive a NACK.

```C
#include <Wire.h>

void setup() {
  Wire.begin();

  //WRITE
  Wire.beginTransmission(0b1100110);         // Device address bits (7b)
  Wire.write(0b11111100);                    // Memory address (7b) and write bit (1b) (0x7E)
  Wire.write(0xA2);                          // Data to be written to memory location 0x7E
  Wire.write(0xB2);                          // Data to be written to memory location 0x7F
  Wire.write(0xC2);                          // This is a garbage value that shouldn't be written into memory because NACK will be set (address only increments to 0x7F)
  Wire.endTransmission(1);
}
```

Memory contents before write operation

![RAM Initial Contents](Documentation/initial_memory_contents.png)

Memory contents after write operation

![RAM Updated Contents](Documentation/updated_memory_contents.png)

### Read from memory example

This example covers how to read data from memory. We start the transmission and write the device address '1100110'. We then write the memory address '0000011' (0x03) followed by a read bit '1'. Next we send a repeated start condition and write the device address and specify the number of bytes we want to read using the requestFrom() function. After receiving the specified number of bytes, we read from the buffer on the Arduino and print the result to the serial monitor.

```C
#include <Wire.h>

#define NUM_BYTES 3

void setup() {
  Serial.begin(9600);
  Wire.begin();

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
}
```

Serial monitor contents after read operation
![Serial Monitor Screenshot](Documentation/Serial_monitor_read.png)

## Diagrams

Block Diagram
![Block Diagram](Documentation/I2C_Top_Block_Diagram.png)

I2C State Machine Diagram
![I2C State Machine Diagram](Documentation/I2C_Subordinate_State_Machine_Diagram.png)

RAM State Machine Diagram
![RAM State Machine Diagram](Documentation/RAM_State_Machine_Diagram.png)
