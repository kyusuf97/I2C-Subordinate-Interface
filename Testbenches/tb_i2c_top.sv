`timescale 1ps / 1ps


module tb_i2c_top();

logic rst;
logic clk;
wire scl;
wire sda;
logic hold_clock_low;

logic scl_driver;
logic scl_enable;

logic sda_driver;
logic sda_enable;

assign scl = scl_enable ? scl_driver : 1'bz;
assign sda = sda_enable ? sda_driver : 1'bz;

i2c_top DUT(rst, clk, scl, sda, hold_clock_low);


initial begin
  clk = 1'b1;
  #1;
  forever #1 clk = ~clk;
end

initial begin
  scl_enable = 1'b1;
  scl_driver = 1'b1;
  #15;
  forever #10 scl_driver = ~scl_driver;
end

initial begin
  rst = 1'b0;
  sda_driver = 1'b1;
  sda_enable = 1'b1;
  hold_clock_low = 1'b0;
  #10;
  rst = 1'b1;
  #10;
  sda_driver = 1'b0; //Start condition
  #10;


  //Master send correct device address
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0; //Write bit
  #20;

  sda_enable = 1'b0; //Slave send ack
  #20

  //Send 7 bit memory address and write bit
  sda_enable = 1'b1;

  sda_driver = 1'b0; //Bit 1 of data
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0; //Write bit
  #20;

  sda_enable = 1'b0; //Slave send ack
  #20;


  //Send 8 bits of data
  sda_enable = 1'b1;

  sda_driver = 1'b0; //Bit 1 of data
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1; //Bit 8 of data
  #20;

  sda_enable = 1'b0; //Slave send ack
  #20;

  //Send 8 bits of data
  sda_enable = 1'b1;

  sda_driver = 1'b0; //Bit 1 of data
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0; //Bit 8 of data
  #20;

  sda_enable = 1'b0; //Slave send ack
  #20;


/*
  sda_enable = 1'b1;
  sda_driver = 1'b1;
  #10;
  sda_driver = 1'b0; //Repeated Start Condition
  #10;
  scl_enable = 1'b1;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1; //Read bit
  #20;
  sda_enable = 1'b0; //Send ack
  #20;
*/
  sda_enable = 1'b1;
  sda_driver = 1'b0;
  #10;
  sda_driver = 1'b1; //Stop condition
  #10;
  scl_enable = 1'b0;
  #100


  scl_enable = 1'b1;
  #10;
  sda_driver = 1'b0; //Start Condition
  #10;



  //Send correct device address
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0; //Write bit
  #20;
  sda_enable = 1'b0; //Slave send ack
  #20


  //Send 7 bit memory address and read bit
  sda_enable = 1'b1;

  sda_driver = 1'b0; //Bit 1 of data
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1; //Read bit
  #20;

  sda_enable = 1'b0; //Slave send ack
  #20;

  sda_enable = 1;
  #10;
  sda_driver = 1'b0; //Repeated Start Condition
  #10;


  //Master send correct device address
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1; //Read bit
  #20;

  sda_enable = 1'b0; //Slave send ack
  #20


  //Device send 8 bits of data
  sda_enable = 1'b0;
  #20; //Bit 1 of data

  #20;

  #20;

  #20;

  #20;

  #20;

  #20;

  #20; //Bit 8 of data
  sda_driver = 1'b0;
  sda_enable = 1'b1; //Master send ack
  #20;

  //Device send 8 bits of data
  sda_enable = 1'b0;
  #20; //Bit 1 of data

  #20;

  #20;

  #20;

  #20;

  #20;

  #20;

  #20; //Bit 8 of data
  sda_driver = 1'b1;
  sda_enable = 1'b1; //Master send nack
  #20;

  #20;

  #20;

  #20;

  sda_enable = 1'b1;
  sda_driver = 1'b0;
  #10;
  sda_driver = 1'b1; //Stop condition
  #10;
  scl_enable = 1'b0;
  #60
/*
  scl_enable = 1'b1;
  #10;
  sda_driver = 1'b0; //Start Condition
  #10;
  scl_enable = 1'b1;


  //Begin sending wrong device address
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1; //Read bit
  #20;
  sda_enable = 1'b0; //Slave send nack
  #20

  sda_enable = 1'b1;
  sda_driver = 1'b0;
  #10;
  sda_driver = 1'b1; //Stop condition
  #10;
  scl_enable = 1'b0;
  #60

  scl_enable = 1'b1;
  #10;
  sda_driver = 1'b0; //Start Condition
  #10;
  scl_enable = 1'b1;

  //Send correct device address
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1; //Read bit
  #20;
  sda_enable = 1'b0; //Slave send ack
  #20

  //Master send 8 bits of data
  sda_driver = 1'b1; //Bit 1 of data
  sda_enable = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b0;
  #20;
  hold_clock_low = 1'b1;
  sda_driver = 1'b1;
  #20;
  sda_driver = 1'b1; //Bit 8 of data
  #20;
  sda_enable = 1'b0; //Slave send ack
  #20;
  scl_enable = 1'b0;

  #100;
  hold_clock_low = 1'b0;
  scl_enable = 1'b1;
  sda_enable = 1'b1;
  #100;

  sda_enable = 1'b1;
  sda_driver = 1'b0;
  #10;
  sda_driver = 1'b1; //Stop condition
  #10;
  scl_enable = 1'b0;
  #60

*/


  $stop;

end

endmodule: tb_i2c_top
