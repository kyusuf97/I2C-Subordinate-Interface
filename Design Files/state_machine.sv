`define S_Wait 4'd1
`define S_ReadAddress 4'd2
`define S_WriteAck1 4'd3
`define S_ReadRW 4'd4
`define S_ReadData 4'd5
`define S_WriteAck2 4'd6
`define S_WriteData 4'd7
`define S_ReadAck 4'd8



module state_machine(input logic rst_n, input logic scl, input logic start_cond, input logic stop_cond, input logic address_match,
                     input logic read_bit, input logic write_bit, input logic [3:0] clock_count, input logic hold_clock_low, input logic recieved_nack,
                     output logic read_address, output logic write_ack, output logic read_ack,
                     output logic read_data, output logic write_data, output logic scl_low_en, output logic [3:0] i2c_state);

logic [3:0] state;
logic [3:0] next_state;

assign i2c_state = state;

always_ff @(posedge scl, negedge rst_n, posedge start_cond, posedge stop_cond) begin
  if (!rst_n)
    state <= `S_Wait;
  else if (start_cond)
    state <= `S_ReadAddress; //Enter read address start on start or repeated start condition
  else if (stop_cond)
    state <= `S_Wait;
  else
    state <= next_state;
end

always_comb begin
  case(state)
    `S_Wait: begin
        next_state = `S_Wait; //Only exit wait state on start condition
    end

    `S_ReadAddress: begin
      if((clock_count == 9'd7) && (address_match))
        next_state = `S_WriteAck1;
      else if ((clock_count == 9'd7) && (!address_match))
        next_state = `S_Wait;
      else
        next_state = `S_ReadAddress;
    end

    `S_WriteAck1: begin
      if(write_bit) //master sends write bit, subordinate will read incoming data from master
        next_state = `S_ReadData;
      else if(read_bit) //master sends read bit, subordinate will write data to master
        next_state = `S_WriteData;
      else
        next_state = `S_Wait;
    end
    //M->S subordinate reads incoming data from master
    `S_ReadData: begin
      if(clock_count == 9'd7)
        next_state = `S_WriteAck2;
      else
        next_state = `S_ReadData;
    end

    `S_WriteAck2: begin
      next_state = `S_ReadData;
    end
    //S->M subordinate writes data to master
    `S_WriteData: begin
      if (recieved_nack == 1'b1)
        next_state = `S_Wait;
      else if(clock_count == 9'd7)
        next_state = `S_ReadAck;
      else
        next_state = `S_WriteData;
    end

    `S_ReadAck: begin
      next_state = `S_WriteData;
    end

    default: next_state = `S_Wait;
  endcase
end


always_comb begin
  case (state)
    `S_Wait: begin
      read_address = 1'b0;
      write_ack = 1'b0;
      read_ack = 1'b0;
      read_data = 1'b0;
      write_data = 1'b0;
      scl_low_en = 1'b0;
    end

    `S_ReadAddress: begin
      read_address = 1'b1;
      write_ack = 1'b0;
      read_ack = 1'b0;
      read_data = 1'b0;
      write_data = 1'b0;
      scl_low_en = 1'b0;
    end

    `S_WriteAck1: begin
      read_address = 1'b0;
      write_ack = 1'b1;
      read_ack = 1'b0;
      read_data = 1'b0;
      write_data = 1'b0;
      if (hold_clock_low)
        scl_low_en = 1'b1;
      else
        scl_low_en = 1'b0;
    end

    `S_ReadData: begin
      read_address = 1'b0;
      write_ack = 1'b0;
      read_ack = 1'b0;
      read_data = 1'b1;
      write_data = 1'b0;
      scl_low_en = 1'b0;
    end

    `S_WriteAck2: begin
      read_address = 1'b0;
      write_ack = 1'b1;
      read_ack = 1'b0;
      read_data = 1'b0;
      write_data = 1'b0;
      if (hold_clock_low)
        scl_low_en = 1'b1;
      else
        scl_low_en = 1'b0;
    end

    `S_WriteData: begin
      read_address = 1'b0;
      write_ack = 1'b0;
      read_ack = 1'b0;
      read_data = 1'b0;
      write_data = 1'b1;
      scl_low_en = 1'b0;
    end

    `S_ReadAck: begin
      read_address = 1'b0;
      write_ack = 1'b0;
      read_ack = 1'b1;
      read_data = 1'b0;
      write_data = 1'b0;
      if (hold_clock_low)
        scl_low_en = 1'b1;
      else
        scl_low_en = 1'b0;
    end

    default: begin
      read_address = 1'b0;
      write_ack = 1'b0;
      read_ack = 1'b0;
      read_data = 1'b0;
      write_data = 1'b0;
      scl_low_en = 1'b0;
    end
  endcase
end

endmodule: state_machine
