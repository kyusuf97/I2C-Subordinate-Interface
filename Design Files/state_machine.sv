import i2c_state_pkg::*;


module state_machine(input logic rst_n, input logic scl, input logic start_cond, input logic stop_cond, input logic address_match,
                     input logic read_bit, input logic write_bit, input logic [3:0] clock_count, input logic hold_clock_low,
                     input logic received_nack, input logic sda,
                     output logic read_address, output logic write_ack, output logic read_ack,
                     output logic read_data, output logic write_data, output logic scl_low_en, output logic [6:0] i2c_state);

sub_state_t state;
sub_state_t next_state;


always_ff @(posedge scl, negedge rst_n, posedge start_cond, posedge stop_cond) begin
  if (!rst_n) begin
    state <= I2C_WAIT;
  end
  else begin                            // Order of conditions here is important: check for repeated start condition before checking for stop condition.
    if (start_cond) begin               // If a start condition occurs, start checking for the device address and read/write bit (only way to leave I2C_WAIT)
      state <= I2C_MASTER_WR_DEV_ADDR;
    end
    else if (stop_cond) begin           // Return to wait state if a stop condition occurs
      state <= I2C_WAIT;
    end
    else if (state != next_state) begin // Only update the state value if the next state is different from the current state (low power technique)
      state <= next_state;
    end
  end
end

always_comb begin : next_state_comb_logic
  unique case (1'b1)
    state[I2C_WAIT_bit]:                begin
                                            next_state = I2C_WAIT;
                                        end
    state[I2C_MASTER_WR_DEV_ADDR_bit]:  begin
                                            if((clock_count == 4'd7) && (address_match)) begin // Address  from master matches device address
                                              next_state = I2C_SUB_SEND_ACK_1;
                                            end
                                            else if ((clock_count == 4'd7) && (!address_match)) begin // Address from master doesn't match device address
                                              next_state = I2C_WAIT;
                                            end
                                            else begin // Not done collecting address
                                              next_state = I2C_MASTER_WR_DEV_ADDR;
                                            end
                                        end
    state[I2C_SUB_SEND_ACK_1_bit]:      begin
                                            if(sda == 1'b1) // If memory_state_machine sends does not send an ack go to wait state
                                              next_state = I2C_WAIT;
                                            else if(write_bit) begin // Master sends write bit, subordinate will read incoming data from master
                                                next_state = I2C_MASTER_WR_DATA;
                                            end
                                            else if (read_bit) begin // Master sends read bit, subordinate will write data to master
                                                next_state = I2C_MASTER_RD_DATA;
                                            end
                                            else begin
                                                next_state = I2C_WAIT;
                                            end
                                        end
    state[I2C_MASTER_WR_DATA_bit]:      begin // M->S subordinate reads incoming data from master
                                            if(clock_count == 4'd7) begin // After last bit of data is sent from master to subordinate, enter state to send ACK
                                                next_state = I2C_SUB_SEND_ACK_2;
                                            end
                                            else begin // Still receiving data from master, so stay in same state
                                                next_state = I2C_MASTER_WR_DATA;
                                            end
                                        end
    state[I2C_SUB_SEND_ACK_2_bit]:      begin // ACK has been sent to master, so return to receiving data from master
                                            next_state = I2C_MASTER_WR_DATA;
                                        end
    state[I2C_MASTER_RD_DATA_bit]:      begin // S->M subordinate writes data to master
                                            if(received_nack) begin // If a NACK is received from the master, return to wait state
                                                next_state = I2C_WAIT;
                                            end
                                            else if(clock_count == 4'd7) begin // Once subordinate has sent 8 bits of data, enter state to receive ACK
                                                next_state = I2C_MASTER_SEND_ACK;
                                            end
                                            else begin // Still sending data to master, so stay in same state
                                                next_state = I2C_MASTER_RD_DATA;
                                            end
                                        end
  state[I2C_MASTER_SEND_ACK_bit]:       begin // ACK has been received from master, so return to sending data to master (NACK check happens after state transition)
                                            next_state = I2C_MASTER_RD_DATA;
                                        end
  default:                              begin
                                            next_state = I2C_WAIT;
                                        end
  endcase
end :next_state_comb_logic

  assign read_address = state[I2C_MASTER_WR_DEV_ADDR_bit];                             // Reading address being sent over SDA line
  assign write_ack    = state[I2C_SUB_SEND_ACK_1_bit] | state[I2C_SUB_SEND_ACK_2_bit]; // States allowing for SDA to be pulled low to send ACK
  assign read_data    = state[I2C_MASTER_WR_DATA_bit];                                 // Device is reading data from the master
  assign write_data   = state[I2C_MASTER_RD_DATA_bit];                                 // Device is writing data to the master
  assign read_ack     = state[I2C_MASTER_SEND_ACK_bit];                                // ACK (0) / NACK (1) from master can be checked on SDA line
  assign scl_low_en   = hold_clock_low & (state[I2C_SUB_SEND_ACK_1_bit] | state[I2C_SUB_SEND_ACK_2_bit] | state[I2C_MASTER_SEND_ACK_bit]);

  assign i2c_state = ({state}); // Cast type to logic 

endmodule: state_machine
