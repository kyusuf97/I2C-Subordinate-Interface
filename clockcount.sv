//Clock counter to keep track of which bit of data is being transferred



module clockcount (input logic rst, input logic scl, input logic start, input logic stop,
                   output logic [3:0] count);

logic [3:0] count_next;
logic en;

always_ff @(negedge rst, posedge scl) begin
  if(!rst)
    en <= 1'b0;
  else if (start)
    en <= 1'b1;
  else if (stop)
    en <= 1'b0;
end

always @(*) begin
  if(count >=  4'd8)
    count_next = 4'd0;
  else
    count_next = count + 1;
end

always_ff @(negedge rst, posedge scl) begin
  if(!rst || !en)
    count <= 4'd0;
  else if (en)
    count = count_next;
end

endmodule: clockcount
