
module memory_interface(input logic rst_n, input logic clk, input logic sda_in, input logic scl_in,
                        input logic read_bit, input logic write_bit, input logic [6:0] i2c_state, input logic [3:0] clock_count,
                        input logic sda_en, input logic received_nack,
                        output logic sda_out);


//memory inputs and outputs
logic [7:0] mem_buffer;
logic [7:0] mem_rddata;
logic wren;
logic [6:0] mem_address;

//msm inputs
logic mem_read_bit;
logic mem_write_bit;

//msm outputs
logic write_ack;
logic read_mem_address;
logic write_mem;
logic read_mem;
logic increment_mem_address;

logic wren_set;
logic wren_capt;
logic mem_nack;

memory_state_machine msm(rst_n, clk, read_bit, write_bit,
                         i2c_state, mem_read_bit, mem_write_bit,
                         sda_en, received_nack, mem_nack,
                         write_ack, read_mem_address, write_mem,
                         read_mem, wren_set, increment_mem_address);

memory_address_checker mac(rst_n, clk, sda_in, scl_in,
                           read_mem_address, clock_count, increment_mem_address,
                           mem_address, mem_read_bit, mem_write_bit, mem_nack);

mem s_ram(mem_address, clk, mem_buffer, wren, mem_rddata);

assign wren = wren_set & !wren_capt;

//write enable capture
always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    wren_capt <= 1'b0;
  end
  else begin
    if (wren_set) begin
      wren_capt <= 1'b1;
    end
    else if (!wren_set) begin
      wren_capt <= 1'b0;
    end
  end
end

//memory buffer
always_ff @(negedge rst_n, posedge scl_in) begin
  if (!rst_n)
    mem_buffer <= 8'b0;
  else if (write_mem)
    mem_buffer[4'd7 - clock_count] <= sda_in;
end

//module to read data from memory and drive ack
always_ff @(negedge rst_n, negedge scl_in) begin
  if (!rst_n)
    sda_out <= 0;
  else if (read_mem)
    sda_out <= mem_rddata[4'd7 - clock_count];
  else if (write_ack)
    sda_out <= 0;
  else
    sda_out <= 1;
end



endmodule: memory_interface
