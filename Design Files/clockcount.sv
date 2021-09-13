//Clock counter to keep track of which bit of data is being transferred



module clockcount (input logic rst_n, input logic scl, input logic start, input logic stop,
                   output logic [3:0] count);

logic [3:0] count_next;
logic en;
logic [3:0] count_in;

always_ff @(negedge rst_n, posedge start, posedge stop) begin // Counter enable active only between start and stop conditions
  if(!rst_n)
    en <= 1'b0;
  else if (start)
    en <= 1'b1;
  else if (stop)
    en <= 1'b0;
end

always @(*) begin // Saturating counter: Once the counter hits 8, its next increment rolls over to start again at 0.
  if(count >=  4'd8)
    count_next = 4'd0;
  else
    count_next = count + 4'd1;
end

always @(*) begin // Reset the counter with start condition, otherwise count takes on the value of the register
  if(start)
    count = 4'd0;
  else
    count = count_in;
end

always_ff @(negedge rst_n, posedge scl) begin // If the counter is enabled, the register is updated with count_next. Otherwise it is set to 0.
  if(!rst_n)
    count_in <= 4'd0;
  else if (en)
    count_in <= count_next;
  else
    count_in <= 4'd0;
end


endmodule: clockcount
