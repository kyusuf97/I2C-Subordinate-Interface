# I2C-Subordinate-Interface

## Introduction

This project is an I2C subordinate Read/Write memory device.
The memory can be instantiated on an FPGA, and be read from or written to with an I2C master device.
This document will explain the design/specification of the subordinate device so that a user may effectively use the device.

## Operation

We have two modes of operation, write mode and read mode. During a write operation the master sends data to memory, and during a read operation the master receives data from memory.

As specified in the I2C standard, during a write operation the master initiates the sequence by sending a start condition followed by the device address (7b) and a write bit. The next byte of data sent is the memory address (7b) followed by a write bit. After each byte of data is stored, the memory address is incremented by one. This process repeats until either we get a stop condition from the master or we reach the final memory address (0x7F). In the case where we reach the final memory address, the subordinate device will go to a wait state and the master will received a NACK on the next byte of data.

Write figure
![I2C Write Operation](Documentation/I2C_Write_to_memory.png)

During a read operation the master initiates the sequence by sending a start condition followed by the device address (7b) and a write bit. The next byte of data sent is the memory address (7b) followed by a read bit. Next the master sends a repeated start condition followed by the device address (7b) and a read bit. The subsequent bytes are read from the specified memory address. After each data byte received, the memory address is incremented by one.

Read figure
![I2C Read Operation](Documentation/I2C_Read_from_Memory.png)

## Example

1. Write to memory example

This example covers the case of a master device sending data to memory using the Arduino Wire library.

(embed code here)

2. Read from memory example



## Diagrams

Block Diagram
![Block Diagram](Documentation/I2C_Top_Block_Diagram.png)

I2C State Machine Diagram
![I2C State Machine Diagram](Documentation/I2C_Subordinate_State_Machine_Diagram.png)

RAM State Machine Diagram
![RAM State Machine Diagram](Documentation/RAM_State_Machine_Diagram.png)
