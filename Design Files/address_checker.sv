//This module checks if the device address matches the address sent by the master device
//It also checks whether the subordinate should operate in read or write mode


module address_checker (input logic rst_n, input logic sda, input logic scl, input logic read_address,
                        input logic [3:0] clock_count, input logic start, input logic stop,
                        output logic address_match, output logic read_bit, output logic write_bit);


logic [6:0] device_address;
logic [6:0] address;
assign device_address = 7'b1100110; //Unique I2C device address


always_ff @(posedge scl or negedge rst_n) begin //Store 7 bit device address
  if (!rst_n)
    address <= 7'b0;
  else begin
    if (read_address && (clock_count <= 4'd6))
      address[4'd6 - clock_count] <= sda;
  end
end

always_comb begin //Check if device address matches address received from master
  if (read_address && (clock_count == 4'd7) && (address == device_address))
    address_match = 1'b1;
  else
    address_match = 1'b0;
end


always_ff @(posedge scl, negedge rst_n, posedge start, posedge stop) begin //Store read/write bit 
  if (!rst_n || start || stop) begin
    read_bit <= 1'b0;
    write_bit <= 1'b0;
  end
  else begin
    if (read_address && (clock_count == 4'd7)) begin
      if (sda == 1'b1) begin
        read_bit <= 1'b1;
        write_bit <= 1'b0;
      end
      else if (sda == 1'b0) begin
        read_bit <= 1'b0;
        write_bit <= 1'b1;
      end
    end
  end
end




endmodule: address_checker
