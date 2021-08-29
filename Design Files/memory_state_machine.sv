`define S_WAIT 4'd0
`define S_WRITE_ACK_1 4'd1
`define S_MEM_ADDRESS 4'd2
`define S_WRITE_ACK_2 4'd3
`define S_WRITE_MEM_DATA 4'd4
`define S_WRITE_ACK_3 4'd5
`define S_INCREMENT_MEM_ADDRESS 4'd6
`define S_DEVICE_ADDRESS 4'd7
`define S_WRITE_ACK_4 4'd8
`define S_MEM_READ_DATA 4'd9
`define S_READ_ACK 4'd10
`define S_INCREMENT_MEM_ADDRESS_2 4'd11


module memory_state_machine(input logic rst_n, input logic clk, input logic read_bit, input logic write_bit,
                            input logic [3:0] i2c_state, input logic mem_read_bit, input logic mem_write_bit,
                            input logic sda_en, input logic recieved_nack,
                            output logic write_ack, output logic read_mem_address, output logic write_mem,
                            output logic read_mem, output logic wren, output logic increment_mem_address);


logic [3:0] state;
logic [3:0] next_state;

always_ff @ (negedge rst_n, posedge clk) begin
  if (!rst_n)
    state <= `S_WAIT;
  else
    state <= next_state;
end

always_comb begin
  case(state)
    `S_WAIT: begin
      if(write_bit && (i2c_state == 4'd3))
        next_state = `S_WRITE_ACK_1;
      else
        next_state = `S_WAIT;
    end
    `S_WRITE_ACK_1: begin
      if(i2c_state == 4'd5 && !sda_en) //S_ReadData in state_machine
        next_state = `S_MEM_ADDRESS;
      else
        next_state = `S_WRITE_ACK_1;
    end
    `S_MEM_ADDRESS: begin
      if(i2c_state == 4'd6) //S_WRITE_ACK_2 in state_machine
        next_state = `S_WRITE_ACK_2;
      else
        next_state = `S_MEM_ADDRESS;
    end
    `S_WRITE_ACK_2: begin
      if (mem_write_bit && (i2c_state == 4'd5) && !sda_en)
        next_state = `S_WRITE_MEM_DATA;
      else if(mem_read_bit && (i2c_state == 4'd5) && !sda_en)
        next_state = `S_DEVICE_ADDRESS;
      else
        next_state = `S_WRITE_ACK_2;
    end
    `S_WRITE_MEM_DATA: begin
      if ((i2c_state == 4'd1) || (i2c_state == 4'd2))
        next_state = `S_WAIT;
      else if(i2c_state == 4'd6) // i2c_state == S_WRITE_ACK_2
        next_state = `S_WRITE_ACK_3;
      else
        next_state = `S_WRITE_MEM_DATA;
    end

    `S_WRITE_ACK_3: begin //(save mem data)
      if(i2c_state == 4'd5 && !sda_en)
        next_state = `S_INCREMENT_MEM_ADDRESS;
      else
        next_state = `S_WRITE_ACK_3;
    end
    `S_INCREMENT_MEM_ADDRESS: begin
      next_state = `S_WRITE_MEM_DATA;
    end
    `S_DEVICE_ADDRESS: begin
      if(read_bit && (i2c_state == 4'd3))
        next_state = `S_WRITE_ACK_4;
      else if(write_bit && (i2c_state == 4'd3))
        next_state = `S_WAIT;
      else
        next_state = `S_DEVICE_ADDRESS;
    end
    `S_WRITE_ACK_4: begin
      if(i2c_state == 4'd7)
        next_state = `S_MEM_READ_DATA;
      else
        next_state = `S_WRITE_ACK_4;
    end
    `S_MEM_READ_DATA: begin
      //if((i2c_state == 4'd1) || (i2c_state == 4'd2))
      //  next_state = `S_WAIT;
      if(i2c_state == 4'd8)
        next_state = `S_READ_ACK;
      else
        next_state = `S_MEM_READ_DATA;
    end
    `S_READ_ACK: begin
      if(recieved_nack)
        next_state = `S_WAIT;
      else if(i2c_state == 4'd7)
        next_state = `S_INCREMENT_MEM_ADDRESS_2;
      else
        next_state = `S_READ_ACK;
    end
    `S_INCREMENT_MEM_ADDRESS_2: begin
      next_state = `S_MEM_READ_DATA;
    end
    default: next_state = `S_WAIT;
  endcase
end

always_comb begin
  case(state)
    `S_WAIT: begin
      write_ack = 0;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 0;
    end
    `S_WRITE_ACK_1: begin
      write_ack = 1;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 0;
    end
    `S_MEM_ADDRESS: begin
      write_ack = 0;
      read_mem_address = 1;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 0;
    end
    `S_WRITE_ACK_2: begin
      write_ack = 1;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 0;
    end
    `S_WRITE_MEM_DATA: begin
      write_ack = 0;
      read_mem_address = 0;
      write_mem = 1;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 0;
    end
    `S_WRITE_ACK_3: begin
      write_ack = 1;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 1;
      increment_mem_address = 0;
    end
    `S_INCREMENT_MEM_ADDRESS: begin
      write_ack = 0;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 1;
    end
    `S_DEVICE_ADDRESS: begin
      write_ack = 0;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 0;
    end
    `S_WRITE_ACK_4: begin
      write_ack = 1;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 0;
    end
    `S_MEM_READ_DATA: begin
      write_ack = 0;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 1;
      wren = 0;
      increment_mem_address = 0;
    end
    `S_READ_ACK: begin
      write_ack = 0;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 0;
    end
    `S_INCREMENT_MEM_ADDRESS_2: begin
      write_ack = 0;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 1;
    end
    default: begin
      write_ack = 0;
      read_mem_address = 0;
      write_mem = 0;
      read_mem = 0;
      wren = 0;
      increment_mem_address = 0;
    end
  endcase
end

endmodule: memory_state_machine
