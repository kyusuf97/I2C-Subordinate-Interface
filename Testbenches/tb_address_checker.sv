
module tb_address_checker();

//Inputs
logic rst;
logic sda;
logic scl;
logic read_address;
logic [3:0] clock_count;


//Outputs
logic address_match;
logic read_bit;
logic write_bit;


address_checker DUT(rst, sda, scl, read_address, clock_count,
                    address_match, read_bit, write_bit);



initial begin
  rst = 1'b0;
  scl = 1'b0;
  sda = 1'b0;
  read_address = 1'b0;
  clock_count = 4'd0;
  #10;
  rst = 1'b1;
  #10;
  sda = 1'b1;
  read_address = 1'b1;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;

  clock_count = 4'd1;
  sda = 1'b1;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;

  clock_count = 4'd2;
  sda = 1'b0;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;

  clock_count = 4'd3;
  sda = 1'b0;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;

  clock_count = 4'd4;
  sda = 1'b1;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;

  clock_count = 4'd5;
  sda = 1'b1;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;

  clock_count = 4'd6;
  sda = 1'b1;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;

  clock_count = 4'd7; //Read write bit
  sda = 1'b0;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;


  clock_count = 4'd8;
  sda = 1'b0;
  read_address = 1'b0;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;

  clock_count = 4'd0;
  sda = 1'b0;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;
  //$stop;

end


endmodule: tb_address_checker
