

module startstop (input logic rst, input logic scl, input logic sda,
                  output logic start, output logic stop);

logic start_rst;
logic stop_rst;

//Start condition
always_ff @(negedge rst, negedge sda, posedge start_rst) begin
  if (!rst || start_rst)
    start <= 1'b0;
  else
    start <= scl;
end

always_ff @(negedge rst, posedge scl) begin
  if (!rst)
    start_rst <= 1'b0;
  else
    start_rst <= start;
  end


//Stop condition
always_ff @(negedge rst, posedge sda, posedge stop_rst) begin
  if (!rst || stop_rst)
    stop <= 1'b0;
  else
    stop <= scl;
end


always_ff @(negedge rst, posedge scl) begin
  if(!rst)
    stop_rst <= 1'b0;
  else
    stop_rst <= stop;
end



endmodule: startstop
