

//module i2c_top(input logic rst_n, input logic clk, inout wire scl, inout wire sda, input logic hold_clock_low);
module i2c_top(input logic [3:0] KEY, input logic CLOCK_50, inout wire [35:0] GPIO_0, output logic [9:0] LEDR);

logic rst_n;
assign rst_n = KEY[0];

logic clk;
assign clk = CLOCK_50;

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
logic [7:0] i2c_state;



//SCL and SDA ports
//logic scl_en;
logic scl_in;
logic scl_out;
logic scl_en;
logic set_scl_low;
logic hold_scl_low;
logic scl_low_en;
logic hold_clock_low;
//logic sda_en;
logic sda_in;
logic sda_out;
logic sda_en;

//GPIO_0[0] = sda
assign GPIO_0[0] = sda_en ? sda_out : 1'bz;
assign sda_in = GPIO_0[0];
//assign sda = sda_en ? sda_out : 1'bz;
//assign sda_in = sda;

//GPIO_0[1] = scl
assign GPIO_0[1] = scl_en ? scl_out: 1'bz;
assign scl_in = GPIO_0[1];
//assign scl = scl_en ? scl_out: 1'bz;
//assign scl_in = scl;

assign scl_out = 1'b0;

assign hold_clock_low = 0;

startstop ss(rst_n, scl_in, sda_in, start, stop);

clockcount cc(rst_n, scl_in, start, stop, count);


state_machine sm(rst_n, scl_in, start, stop, address_match,
                 read_bit, write_bit, count, hold_clock_low, recieved_nack,
                 read_address, write_ack, read_ack, read_data, write_data, scl_low_en, i2c_state);


address_checker ac(rst_n, sda_in, scl_in, read_address,
                   count, start, stop,
                   address_match, read_bit, write_bit);

memory_interface mi(rst_n, clk, sda_in, scl_in,
                   read_bit, write_bit, i2c_state, count,
                   sda_en, recieved_nack,
                   sda_out);


always_ff @(negedge scl_in, negedge rst_n) begin
  if (!rst_n)
    sda_en <= 0;
  else begin
    if (recieved_nack)
      sda_en <= 0;
    else if (write_ack || write_data)
      sda_en <= 1;
    else
      sda_en <= 0;
  end
end


always_ff @(negedge scl_in, negedge rst_n) begin
  if (!rst_n)
    set_scl_low <= 1'b0;
  else begin
    if (scl_low_en)
      set_scl_low <= 1'b1;
    else
      set_scl_low <= 1'b0;
  end
end

always_ff @(negedge scl_in, negedge rst_n) begin
  if (!rst_n)
    hold_scl_low <= 1'b0;
  else begin
    if (set_scl_low)
      hold_scl_low <= 1'b1;
    else
      hold_scl_low <= 1'b0;
  end
end

always_comb begin
  if (hold_scl_low && hold_clock_low)
    scl_en = 1'b1;
  else
    scl_en = 1'b0;
end

//Read Ack
always_ff @ (posedge scl_in, negedge rst_n) begin
  if (!rst_n)
    recieved_nack <= 1'b0;
  else begin
    if (read_ack && (sda_in == 1'b1))
      recieved_nack <= 1'b1;
    else
      recieved_nack <= 1'b0;
  end
end


assign LEDR[3:0] = i2c_state;

endmodule: i2c_top
