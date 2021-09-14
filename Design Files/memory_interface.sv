
module memory_interface(input logic rst_n, input logic clk, input logic sda_in, input logic scl_in,
                        input logic read_bit, input logic write_bit, input logic [6:0] i2c_state, input logic [3:0] clock_count,
                        input logic sda_en, input logic received_nack,
                        output logic sda_out);


//memory inputs and outputs
logic [7:0] mem_buffer;
logic [7:0] mem_rddata;
logic wren;
logic [6:0] mem_address;
logic mem_nack;

//mmeory state machine inputs
logic mem_read_bit;
logic mem_write_bit;

//mmeory state machine outputs
logic sub_send_ack;
logic master_wr_mem_addr;
logic master_wr_data;
logic master_rd_data;
logic increment_mem_address;
logic wren_set;

logic wren_capt;



memory_state_machine msm(rst_n, clk, read_bit, write_bit,
                         i2c_state, mem_read_bit, mem_write_bit,
                         sda_en, received_nack, mem_nack,
                         sub_send_ack, master_wr_mem_addr, master_wr_data,
                         master_rd_data, wren_set, increment_mem_address);

memory_address_checker mac(rst_n, clk, sda_in, scl_in,
                           master_wr_mem_addr, clock_count, increment_mem_address,
                           mem_address, mem_read_bit, mem_write_bit, mem_nack);

mem s_ram(mem_address, clk, mem_buffer, wren, mem_rddata);


assign wren = wren_set & !wren_capt; //Wren high on only one clock cycle


always_ff @(posedge clk or negedge rst_n) begin //write enable capture
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


always_ff @(negedge rst_n, posedge scl_in) begin //memory buffer for incoming data from sda
  if (!rst_n)
    mem_buffer <= 8'b0;
  else if (master_wr_data)
    mem_buffer[4'd7 - clock_count] <= sda_in;
end


always_ff @(negedge rst_n, negedge scl_in) begin //Read data from memory and drive ack
  if (!rst_n)
    sda_out <= 0;
  else if (master_rd_data)
    sda_out <= mem_rddata[4'd7 - clock_count];
  else if (sub_send_ack)
    sda_out <= 0;
  else
    sda_out <= 1;
end



endmodule: memory_interface
