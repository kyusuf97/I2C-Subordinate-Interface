module i2c_top(input logic [3:0] KEY, input logic CLOCK_50, inout wire [35:0] GPIO_0, output logic [9:0] LEDR);

  //
  // INTERNAL SIGNALS
  //

  logic rst_n;
  logic clk;

  //SM Inputs
  logic start;
  logic stop;
  logic address_match;
  logic read_bit;
  logic write_bit;
  logic [3:0] count;
  logic received_nack;

  //SM Outputs
  logic master_wr_addr;
  logic sub_send_ack;
  logic master_rd_data;
  logic master_send_ack;
  logic [6:0] i2c_state;

  //SCL and SDA ports
  logic scl_in;
  logic scl_out;
  logic scl_en;
  logic set_scl_low;
  logic hold_scl_low;
  logic scl_low_en;
  logic hold_clock_low;
  logic sda_in;
  logic sda_out;
  logic sda_en;


  //
  // RTL
  //

  // CLOCK_50 = clk
  assign clk = CLOCK_50;

  // KEY[0] = rst_n
  assign rst_n = KEY[0];

  // GPIO_0[0] = sda
  assign GPIO_0[0] = sda_en ? sda_out : 1'bz;
  assign sda_in = GPIO_0[0];

  // GPIO_0[1] = scl
  assign GPIO_0[1] = scl_en ? scl_out: 1'bz;
  assign scl_in = GPIO_0[1];

  // LEDR[6:0] = i2c_state (one hot)
  assign LEDR[6:0] = i2c_state;


  assign scl_out = 1'b0;        // Currently not in use. (Memory device does not require holding clock low)
  assign hold_clock_low = 1'b0; // Memory device does not hold clock low


  // Module Instantiations

  startstop ss(rst_n, scl_in, sda_in, start, stop);

  clockcount cc(rst_n, scl_in, start, stop, count);


  state_machine sm(rst_n, scl_in, start, stop, address_match,
                  read_bit, write_bit, count, hold_clock_low,
                  received_nack, sda_in,
                  master_wr_addr, sub_send_ack, master_send_ack, master_rd_data, scl_low_en, i2c_state);


  address_checker ac(rst_n, sda_in, scl_in, master_wr_addr,
                    count, start, stop,
                    address_match, read_bit, write_bit);

  memory_interface mi(rst_n, clk, sda_in, scl_in,
                    read_bit, write_bit, i2c_state, count,
                    sda_en, received_nack,
                    sda_out);


  always_ff @(negedge scl_in, negedge rst_n) begin // SDA driving logic
    if (!rst_n)
      sda_en <= 0;
    else begin
      if (received_nack)
        sda_en <= 0;
      else if (sub_send_ack || master_rd_data) // sda_en is only set when sending an ACK or sending data to the master
        sda_en <= 1;
      else
        sda_en <= 0;
    end
  end


  always_ff @(negedge scl_in, negedge rst_n) begin // Set SCL low logic (currently not in use)
    if (!rst_n)
      set_scl_low <= 1'b0;
    else begin
      if (scl_low_en)
        set_scl_low <= 1'b1;
      else
        set_scl_low <= 1'b0;
    end
  end

  always_ff @(negedge scl_in, negedge rst_n) begin // Hold SCL low logic (currently not in use)
    if (!rst_n)
      hold_scl_low <= 1'b0;
    else begin
      if (set_scl_low)
        hold_scl_low <= 1'b1;
      else
        hold_scl_low <= 1'b0;
    end
  end

  always_comb begin // SCL driving logic
    if (hold_scl_low && hold_clock_low)
      scl_en = 1'b1;
    else
      scl_en = 1'b0;
  end

  //Read Ack
  always_ff @ (posedge scl_in, negedge rst_n) begin // Detecting ACK (sda = 0) / NACK (sda = 1) logic
    if (!rst_n)
      received_nack <= 1'b0;
    else begin
      if (master_send_ack && (sda_in == 1'b1))
        received_nack <= 1'b1;
      else
        received_nack <= 1'b0;
    end
  end

endmodule: i2c_top
