import i2c_state_pkg::*;


module memory_state_machine(input logic rst_n, input logic clk, input logic read_bit, input logic write_bit,
                            input logic [7:0] i2c_state, input logic mem_read_bit, input logic mem_write_bit,
                            input logic sda_en, input logic recieved_nack,
                            output logic write_ack, output logic read_mem_address, output logic write_mem,
                            output logic read_mem, output logic wren, output logic increment_mem_address);

  sub_state_t i2c_state_i;
  ram_state_t state;
  ram_state_t next_state;

  assign i2c_state_i = i2c_state; // Logic to Type

  always_ff @ (negedge rst_n, posedge clk) begin
    if (!rst_n) begin
      state <= MEM_WAIT;
    end
    else begin
        if(state != next_state) begin
            state <= next_state;
        end
    end
  end

  always_comb begin
    unique case(1'b1)
      state[MEM_WAIT_bit]:                begin
                                              if(write_bit && i2c_state_i[I2C_WRITE_ACK_1_bit]) begin
                                                  next_state = MEM_WRITE_ACK_1;
                                              end
                                              else begin
                                                  next_state = MEM_WAIT;
                                              end
                                          end
      state[MEM_WRITE_ACK_1_bit]:         begin
                                              if(i2c_state_i[I2C_READ_DATA_bit] && !sda_en) begin //S_ReadData in state_machine
                                                  next_state = MEM_ADDRESS;
                                              end
                                              else begin
                                                  next_state = MEM_WRITE_ACK_1;
                                              end
                                          end
      state[MEM_ADDRESS_bit]:             begin
                                              if(i2c_state_i[I2C_WRITE_ACK_2_bit]) begin //S_WRITE_ACK_2 in state_machine
                                                  next_state = MEM_WRITE_ACK_2;
                                              end
                                              else begin
                                                  next_state = MEM_ADDRESS;
                                              end       
                                          end
      state[MEM_WRITE_ACK_2_bit]:         begin
                                              if (mem_write_bit && (i2c_state_i[I2C_READ_DATA_bit]) && !sda_en) begin
                                                  next_state = MEM_WRITE_DATA;
                                              end                                      
                                              else if(mem_read_bit && (i2c_state_i[I2C_READ_DATA_bit]) && !sda_en) begin
                                                  next_state = MEM_DEVICE_ADDRESS;
                                              end
                                              else begin
                                                  next_state = MEM_WRITE_ACK_2;
                                              end
                                          end
      state[MEM_WRITE_DATA_bit]:          begin
                                              if (i2c_state_i[I2C_WAIT_bit] || i2c_state_i[I2C_READ_ADDRESS_bit]) begin
                                                  next_state = MEM_WAIT;
                                              end
                                              else if(i2c_state_i[I2C_WRITE_ACK_2_bit]) begin // i2c_state == S_WRITE_ACK_2
                                                  next_state = MEM_WRITE_ACK_3;
                                              end
                                              else begin
                                                  next_state = MEM_WRITE_DATA;
                                              end
                                          end
      state[MEM_WRITE_ACK_3_bit]:         begin //(save mem data)
                                              if(i2c_state_i[I2C_READ_DATA_bit] && !sda_en) begin
                                                  next_state = MEM_INCREMENT_ADDRESS;
                                              end
                                              else begin
                                                  next_state = MEM_WRITE_ACK_3;
                                              end
                                          end
      state[MEM_INCREMENT_ADDRESS_bit]:   begin
                                              next_state = MEM_WRITE_DATA;
                                          end
      state[MEM_DEVICE_ADDRESS_bit]:      begin
                                              if(read_bit && (i2c_state_i[I2C_WRITE_ACK_1_bit])) begin
                                                  next_state = MEM_WRITE_ACK_4;
                                              end
                                              else if(write_bit && (i2c_state_i[I2C_WRITE_ACK_1_bit])) begin
                                                  next_state = MEM_WAIT;
                                              end
                                              else begin
                                                  next_state = MEM_DEVICE_ADDRESS;
                                              end
                                          end
      state[MEM_WRITE_ACK_4_bit]:         begin
                                              if(i2c_state_i[I2C_WRITE_DATA_bit]) begin
                                                  next_state = MEM_READ_DATA;
                                              end
                                              else begin
                                                  next_state = MEM_WRITE_ACK_4;
                                              end
                                          end
      state[MEM_READ_DATA_bit]:           begin
                                              if(i2c_state_i[I2C_READ_ACK_bit]) begin
                                                  next_state = MEM_READ_ACK;
                                              end
                                              else begin
                                                  next_state = MEM_READ_DATA;
                                              end
                                          end
      state[MEM_READ_ACK_bit]:            begin
                                              if (recieved_nack) begin
                                                  next_state = MEM_WAIT;
                                              end
                                              else if(i2c_state_i[I2C_WRITE_DATA_bit]) begin
                                                  next_state = MEM_INCREMENT_ADDRESS_2;
                                              end
                                              else begin
                                                  next_state = MEM_READ_ACK;
                                              end
                                          end
      state[MEM_INCREMENT_ADDRESS_2_bit]: begin
                                              next_state = MEM_READ_DATA;
                                          end
      default:                            begin
                                              next_state = MEM_WAIT;
                                          end
    endcase
  end

  assign write_ack             = state[WRITE_ACK_1_bit] | state[WRITE_ACK_2_bit] | state[WRITE_ACK_3_bit] | state[WRITE_ACK_4_bit];
  assign read_mem_address      = state[MEM_ADDRESS_bit];
  assign write_mem             = state[WRITE_MEM_DATA_bit];
  assign wren                  = state[WRITE_ACK_3_bit];
  assign increment_mem_address = state[INCREMENT_MEM_ADDRESS_bit] | state[INCREMENT_MEM_ADDRESS_2_bit];
  assign read_mem              = state[MEM_READ_DATA_bit];

endmodule: memory_state_machine
