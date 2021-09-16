

module startstop (input logic rst_n, input logic scl, input logic sda,
                  output logic start, output logic stop);

logic start_rst;
logic stop_rst;

//Start condition
always_ff @(negedge rst_n, negedge sda, posedge start_rst) begin // Reset conditions and mapping start to SCL on falling edge of SDA
  if (!rst_n || start_rst)                                       
    start <= 1'b0;
  else
    start <= scl;
end

always_ff @(negedge rst_n, posedge scl) begin // start_rst makes sure the start condition doesn't remain high for more than one rising edge of SCL
  if (!rst_n)
    start_rst <= 1'b0;
  else
    start_rst <= start;
  end


//Stop condition
always_ff @(negedge rst_n, posedge sda, posedge stop_rst) begin // Reset conditions and mapping stop to SCL on rising edge of SDA
  if (!rst_n || stop_rst)
    stop <= 1'b0;
  else
    stop <= scl;
end


always_ff @(negedge rst_n, posedge scl) begin // stop_rst makes sure the stop condition doesn't remain high for more than one rsing edge of SCL
  if(!rst_n)
    stop_rst <= 1'b0;
  else
    stop_rst <= stop;
end



endmodule: startstop
