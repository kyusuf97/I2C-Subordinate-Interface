
module tb_startstop();

//Inputs
logic rst;
logic scl;
logic sda;

//Outputs
logic start;
logic stop;


startstop DUT(rst, scl, sda, start, stop);

initial begin
  rst = 1'b0;
  scl = 1'b1;
  sda = 1'b1;
  #10;
  rst = 1'b1;
  #10;
  sda = 1'b0;
  #10;
  scl = 1'b0;
  #10
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #10;
  scl = 1'b1;
  #10;
  sda = 1'b1;
  #10;
  sda = 1'b0;
  #10;
  scl = 1'b0;
  #10;
  scl = 1'b1;
  #10;
  scl = 1'b0;
  #50;

  $stop;
end


endmodule: tb_startstop
