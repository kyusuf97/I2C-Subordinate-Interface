import i2c_state_pkg::*;


module memory_state_machine(input logic rst_n, input logic clk, input logic read_bit, input logic write_bit,
                            input logic [6:0] i2c_state, input logic mem_read_bit, input logic mem_write_bit,
                            input logic sda_en, input logic received_nack, input logic mem_nack,
                            output logic sub_send_ack, output logic master_wr_mem_addr, output logic master_wr_data,
                            output logic master_rd_data, output logic wren, output logic increment_mem_address);

  sub_state_t i2c_state_i;
  ram_state_t state;
  ram_state_t next_state;

  assign i2c_state_i = sub_state_t'(i2c_state); // Logic to Type

  always_ff @ (negedge rst_n, posedge clk) begin
    if (!rst_n) begin
      state <= RAM_WAIT;
    end
    else begin
        if(i2c_state_i[I2C_WAIT_bit]) //Return to wait state anytime I2C state machine is in wait state
            state <= RAM_WAIT;
        else if(state != next_state) begin
            state <= next_state;
        end
    end
  end

  always_comb begin
    unique case(1'b1)
      state[RAM_WAIT_bit]:               begin
                                             if(write_bit && i2c_state_i[I2C_SUB_SEND_ACK_1_bit]) begin //Start process if we get a write bit and a valid device address is received in I2C state machine
                                                 next_state = RAM_SUB_SEND_ACK_1;
                                             end
                                             else begin
                                                 next_state = RAM_WAIT;
                                             end
                                         end
      state[RAM_SUB_SEND_ACK_1_bit]:     begin
                                             if(i2c_state_i[I2C_MASTER_WR_DATA_bit] && !sda_en) begin //Drive sda low for ack, wait for sda_en to go low before changing state
                                                 next_state = RAM_MASTER_WR_MEM_ADDR;
                                             end
                                             else begin
                                                 next_state = RAM_SUB_SEND_ACK_1;
                                             end
                                         end
      state[RAM_MASTER_WR_MEM_ADDR_bit]: begin
                                             if(i2c_state_i[I2C_SUB_SEND_ACK_2_bit]) begin //Store initial memory address
                                                 next_state = RAM_SUB_SEND_ACK_2;
                                             end
                                             else begin
                                                 next_state = RAM_MASTER_WR_MEM_ADDR;
                                             end
                                         end
      state[RAM_SUB_SEND_ACK_2_bit]:     begin
                                             if (mem_write_bit && (i2c_state_i[I2C_MASTER_WR_DATA_bit]) && !sda_en) begin //Drive sda low for ack, wait for sda_en to go low before changing state
                                                 next_state = RAM_MASTER_WR_DATA;
                                             end
                                             else if(mem_read_bit && (i2c_state_i[I2C_MASTER_WR_DATA_bit]) && !sda_en) begin
                                                 next_state = RAM_MASTER_WR_DEV_ADDR;
                                             end
                                             else begin
                                                 next_state = RAM_SUB_SEND_ACK_2;
                                             end
                                         end

      //Master write to memory
      state[RAM_MASTER_WR_DATA_bit]:     begin
                                            if (mem_nack || i2c_state_i[I2C_WAIT_bit] || i2c_state_i[I2C_MASTER_WR_DEV_ADDR_bit]) begin //Go to wait state if we receive a nack from master, or if we get a repeated start condition
                                                 next_state = RAM_WAIT;
                                             end
                                             else if(i2c_state_i[I2C_SUB_SEND_ACK_2_bit]) begin
                                                 next_state = RAM_SUB_SEND_ACK_3;
                                             end
                                             else begin
                                                 next_state = RAM_MASTER_WR_DATA;
                                             end
                                         end
      state[RAM_SUB_SEND_ACK_3_bit]:     begin
                                             if(i2c_state_i[I2C_MASTER_WR_DATA_bit] && !sda_en) begin //Drive sda low for ack, wait for sda_en to go low before changing state
                                                 next_state = RAM_INCR_MEM_ADDR_1;
                                             end
                                             else begin
                                                 next_state = RAM_SUB_SEND_ACK_3;
                                             end
                                         end
      state[RAM_INCR_MEM_ADDR_1_bit]:    begin
                                             next_state = RAM_MASTER_WR_DATA; //Increment memory address by one
                                         end

      //Master read from memory
      state[RAM_MASTER_WR_DEV_ADDR_bit]: begin
                                             if(read_bit && (i2c_state_i[I2C_SUB_SEND_ACK_1_bit])) begin
                                                 next_state = RAM_SUB_SEND_ACK_4;
                                             end
                                             else if(write_bit && (i2c_state_i[I2C_SUB_SEND_ACK_1_bit])) begin //If we get a write bit the operation is not valid, return to wait state
                                                 next_state = RAM_WAIT;
                                             end
                                             else begin
                                                 next_state = RAM_MASTER_WR_DEV_ADDR;
                                             end
                                         end
      state[RAM_SUB_SEND_ACK_4_bit]:     begin
                                             if(i2c_state_i[I2C_MASTER_RD_DATA_bit]) begin
                                                 next_state = RAM_MASTER_RD_DATA;
                                             end
                                             else begin
                                                 next_state = RAM_SUB_SEND_ACK_4;
                                             end
                                         end
      state[RAM_MASTER_RD_DATA_bit]:     begin
                                             if (mem_nack) begin //return to wait state if memory cannot execute operation
                                                 next_state = RAM_WAIT;
                                             end
                                             else if(i2c_state_i[I2C_MASTER_SEND_ACK_bit]) begin //Receive ack from master after master reads byte of data
                                                 next_state = RAM_MASTER_SEND_ACK;
                                             end
                                             else begin
                                                 next_state = RAM_MASTER_RD_DATA;
                                             end
                                         end
      state[RAM_MASTER_SEND_ACK_bit]:    begin
                                             if (received_nack) begin //Return to wait state if master sends nack
                                                 next_state = RAM_WAIT;
                                             end
                                             else if(i2c_state_i[I2C_MASTER_RD_DATA_bit]) begin
                                                 next_state = RAM_INCR_MEM_ADDR_2;
                                             end
                                             else begin
                                                 next_state = RAM_MASTER_SEND_ACK;
                                             end
                                         end
      state[RAM_INCR_MEM_ADDR_2_bit]:    begin
                                             next_state = RAM_MASTER_RD_DATA; //Increment memory address by one
                                         end
      default:                           begin
                                             next_state = RAM_WAIT;
                                         end
    endcase
  end

  assign sub_send_ack             = state[RAM_SUB_SEND_ACK_1_bit] | state[RAM_SUB_SEND_ACK_2_bit] | state[RAM_SUB_SEND_ACK_3_bit] | state[RAM_SUB_SEND_ACK_4_bit];
  assign master_wr_mem_addr      = state[RAM_MASTER_WR_MEM_ADDR_bit];
  assign master_wr_data             = state[RAM_MASTER_WR_DATA_bit];
  assign wren                  = state[RAM_SUB_SEND_ACK_3_bit];
  assign increment_mem_address = state[RAM_INCR_MEM_ADDR_1_bit] | state[RAM_INCR_MEM_ADDR_2_bit];
  assign master_rd_data              = state[RAM_MASTER_RD_DATA_bit];

endmodule: memory_state_machine
