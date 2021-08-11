

module i2c_top (input logic rst, inout wire scl, inout wire sda, input logic hold_clock_low);

//SM Inputs
logic start;
logic stop;
logic address_match;
logic read_bit;
logic write_bit;
logic [3:0] count;
logic recieved_nack;

//SM Outputs
logic read_address;
logic write_ack;
logic read_data;
logic write_data;
logic read_ack;




//SCL and SDA ports
//logic scl_en;
logic scl_in;
logic scl_out;
logic scl_en;
logic set_scl_low;
logic hold_scl_low;
//logic sda_en;
logic sda_in;
logic sda_out;
logic sda_en;

assign scl = scl_en ? scl_out: 1'bz;
assign scl_in = scl;

assign sda = sda_en ? sda_out : 1'bz;
assign sda_in = sda;

assign scl_out = 1'b0;
assign sda_out = 1'b0;


startstop ss(rst, scl_in, sda_in, start, stop);

clockcount cc(rst, scl_in, start, stop, count);


state_machine sm(rst, scl_in, start, stop, address_match,
                 read_bit, write_bit, count, hold_clock_low, recieved_nack,
                 read_address, write_ack, read_ack, read_data, write_data, scl_low_en);


address_checker ac(rst, sda_in, scl_in, read_address,
                   count, start, stop,
                   address_match, read_bit, write_bit);


always_ff @(negedge scl, negedge rst) begin
  if (!rst)
    sda_en = 0;
  else begin
    if (write_ack)
      sda_en = 1'b1;
    else
      sda_en = 0;
  end
end


always_ff @(negedge scl, negedge rst) begin
  if (!rst)
    set_scl_low = 1'b0;
  else begin
    if (scl_low_en)
      set_scl_low <= 1'b1;
    else
      set_scl_low <= 1'b0;
  end
end

always_ff @(negedge scl, negedge rst) begin
  if (!rst)
    hold_scl_low = 1'b0;
  else begin
    if (set_scl_low)
      hold_scl_low = 1'b1;
    else
      hold_scl_low = 1'b0;
  end
end

always_comb begin
  if (hold_scl_low && hold_clock_low)
    scl_en = 1'b1;
  else
    scl_en = 1'b0;
end

//Read Ack
always_ff @ (posedge scl, negedge rst) begin
  if (!rst)
    recieved_nack = 1'b0;
  else begin
    if (read_ack && (sda == 1'b1))
      recieved_nack = 1'b1;
    else
      recieved_nack = 1'b0;
  end


end

endmodule: i2c_top
