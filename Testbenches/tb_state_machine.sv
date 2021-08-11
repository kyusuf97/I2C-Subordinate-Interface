
module tb_state_machine();

//Inputs
logic rst;
logic scl;
logic start_cond;
logic stop_cond;
logic address_match;
logic read_bit;
logic write_bit;
logic ack_bit;
logic [8:0] clock_count;

//Outputs
logic read_address;
logic write_ack;
logic read_ack;
logic read_data;
logic write_data;

state_machine DUT(rst, scl, start_cond, stop_cond, address_match,
                  read_bit, write_bit, clock_count,
                  read_address, write_ack, read_data, write_data);

initial begin
  rst = 1'b0;
  scl = 1'b1;
  start_cond = 1'b0;
  stop_cond = 1'b0;
  read_bit = 1'b0;
  write_bit = 1'b0;
  #10;
  rst = 1'b1;
  #10;
  start_cond = 1'b1;
  #10;
  scl = 1'b0;
  #10;
  scl = 1'b1;
  #10;
  start_cond = 1'b0;
  scl = 1'b0;
  clock_count = 9'd6;
  address_match = 1'b1;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  read_bit = 1'b1;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  address_match = 1'b0;
  read_bit = 1'b0;
  clock_count = 9'd5;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;
  scl = 1'b1;
  #10
  scl = 1'b0;
  clock_count = 9'd6;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;
  scl = 1'b1;
  stop_cond = 1'b1;
  #30;
  start_cond = 1'b1;
  #10;
  scl = 1'b0;
  start_cond = 1'b0;
  stop_cond = 1'b0;
  clock_count = 9'd0;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  clock_count = 9'd6;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  address_match = 1'b1;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  write_bit = 1'b1;
  clock_count = 9'd0;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  clock_count = 9'd6;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;




  $stop;
end



endmodule: tb_state_machine
