package i2c_state_pkg;

    // -----------------------------------
    // MAIN I2C SUBORDINATE STATE MACHINE
    // -----------------------------------

    // State bits for subordinate state machine
    typedef enum {

      I2C_WAIT_bit               = 0,
      I2C_MASTER_WR_DEV_ADDR_bit = 1,
      I2C_SUB_SEND_ACK_1_bit     = 2,
      I2C_MASTER_WR_DATA_bit     = 3,
      I2C_SUB_SEND_ACK_2_bit     = 4,
      I2C_MASTER_RD_DATA_bit     = 5,
      I2C_MASTER_SEND_ACK_bit    = 6

    } sub_state_bit;

    // Shift a 1 to the bit that represents each state
    typedef enum logic [6:0] {

      I2C_WAIT               = 7'b1<<I2C_WAIT_bit,
      I2C_MASTER_WR_DEV_ADDR = 7'b1<<I2C_MASTER_WR_DEV_ADDR_bit,
      I2C_SUB_SEND_ACK_1     = 7'b1<<I2C_SUB_SEND_ACK_1_bit,
      I2C_MASTER_WR_DATA     = 7'b1<<I2C_MASTER_WR_DATA_bit,
      I2C_SUB_SEND_ACK_2     = 7'b1<<I2C_SUB_SEND_ACK_2_bit,
      I2C_MASTER_RD_DATA     = 7'b1<<I2C_MASTER_RD_DATA_bit,
      I2C_MASTER_SEND_ACK    = 7'b1<<I2C_MASTER_SEND_ACK_bit

    } sub_state_t;

    // ------------------
    // RAM STATE MACHINE
    // ------------------

    typedef enum {

      RAM_WAIT_bit               = 0,
      RAM_SUB_SEND_ACK_1_bit     = 1,
      RAM_MASTER_WR_MEM_ADDR_bit = 2,
      RAM_SUB_SEND_ACK_2_bit     = 3,
      RAM_MASTER_WR_DATA_bit     = 4,
      RAM_SUB_SEND_ACK_3_bit     = 5,
      RAM_INCR_MEM_ADDR_1_bit    = 6,
      RAM_MASTER_WR_DEV_ADDR_bit = 7,
      RAM_SUB_SEND_ACK_4_bit     = 8,
      RAM_MASTER_RD_DATA_bit     = 9,
      RAM_MASTER_SEND_ACK_bit    = 10,
      RAM_INCR_MEM_ADDR_2_bit    = 11

    } ram_state_bit;

    typedef enum logic [11:0] {

      RAM_WAIT               = 12'b1<<RAM_WAIT_bit,
      RAM_SUB_SEND_ACK_1     = 12'b1<<RAM_SUB_SEND_ACK_1_bit,
      RAM_MASTER_WR_MEM_ADDR = 12'b1<<RAM_MASTER_WR_MEM_ADDR_bit,
      RAM_SUB_SEND_ACK_2     = 12'b1<<RAM_SUB_SEND_ACK_2_bit,
      RAM_MASTER_WR_DATA     = 12'b1<<RAM_MASTER_WR_DATA_bit,
      RAM_SUB_SEND_ACK_3     = 12'b1<<RAM_SUB_SEND_ACK_3_bit,
      RAM_INCR_MEM_ADDR_1    = 12'b1<<RAM_INCR_MEM_ADDR_1_bit,
      RAM_MASTER_WR_DEV_ADDR = 12'b1<<RAM_MASTER_WR_DEV_ADDR_bit,
      RAM_SUB_SEND_ACK_4     = 12'b1<<RAM_SUB_SEND_ACK_4_bit,
      RAM_MASTER_RD_DATA     = 12'b1<<RAM_MASTER_RD_DATA_bit,
      RAM_MASTER_SEND_ACK    = 12'b1<<RAM_MASTER_SEND_ACK_bit,
      RAM_INCR_MEM_ADDR_2    = 12'b1<<RAM_INCR_MEM_ADDR_2_bit

    } ram_state_t;

endpackage
