
module tb_clockcount();


//Inputs
logic scl;
logic rst;
logic start;
logic stop;

//Outputs
logic [3:0] count;

clockcount DUT(rst, scl, start, stop, count);

initial begin
  scl = 1'b0;
  forever #5 scl = ~scl;
end

initial begin
  rst = 1'b0;
  #10;
  rst = 1'b1;
  #10;
  start = 1'b1;
  #10;
  start = 1'b0;
  #500;
  stop = 1'b1;
  #100;
  start = 1'b1;
  #10;
  stop = 1'b0;
  start = 1'b0;
  #500;
  $stop;
end

endmodule: tb_clockcount
