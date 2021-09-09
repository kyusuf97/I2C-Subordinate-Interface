
module memory_address_checker(input logic rst_n, input logic clk, input logic sda, input logic scl,
                              input logic read_mem_address, input logic [3:0] clock_count, input logic increment_mem_address,
                              output logic [6:0] memory_address, output logic mem_read_bit, output logic mem_write_bit, output logic mem_nack);

logic [6:0] memory_start_address;

always_ff @(negedge rst_n, posedge scl) begin
  if (!rst_n)
    memory_start_address <= 7'b0;
  else if(read_mem_address && (clock_count <= 4'd6))
    memory_start_address[4'd6 - clock_count] <= sda;
end


always_ff @(negedge rst_n, posedge clk) begin
  if (!rst_n) begin
    memory_address <= 7'b0;
    mem_nack <= 1'b0;
    end
  else if (read_mem_address) begin
    memory_address <= memory_start_address;
    mem_nack <= 1'b0;
    end
  else if (increment_mem_address) begin
    if (memory_address >= 7'b1111111) begin
      memory_address <= 7'd0;
      mem_nack <= 1'b1;
      end
    else begin
      memory_address <= memory_address + 7'd1;
      mem_nack <= 1'b0;
      end
    end
end

always_ff @(negedge rst_n, posedge scl) begin
  if (!rst_n) begin
    mem_read_bit <= 0;
    mem_write_bit <= 0;
  end
  else if ((read_mem_address) && (clock_count == 4'd7)) begin
    if (sda == 1'b1) begin
      mem_read_bit <= 1'b1;
      mem_write_bit <= 1'b0;
    end
    else if (sda == 1'b0) begin
      mem_read_bit <= 1'b0;
      mem_write_bit <= 1'b1;
    end
  end
end



endmodule: memory_address_checker
