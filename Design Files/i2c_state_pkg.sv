package i2c_state_pkg;

    // -----------------------------------
    // MAIN I2C SUBORDINATE STATE MACHINE
    // -----------------------------------

    // State bits for subordinate state machine
    typedef enum {

        I2C_WAIT_bit         = 0,
        I2C_READ_ADDRESS_bit = 1,
        I2C_WRITE_ACK_1_bit  = 2,
        I2C_READ_RW_bit      = 3,
        I2C_READ_DATA_bit    = 4,
        I2C_WRITE_ACK_2_bit  = 5,
        I2C_WRITE_DATA_bit   = 6,
        I2C_READ_ACK_bit     = 7

    } sub_state_bit;

    // Shift a 1 to the bit that represents each state
    typedef enum logic [7:0] {

        I2C_WAIT         = 8'b00000001<<I2C_WAIT_bit,
        I2C_READ_ADDRESS = 8'b00000001<<I2C_READ_ADDRESS_bit,
        I2C_WRITE_ACK_1  = 8'b00000001<<I2C_WRITE_ACK_1_bit,
        I2C_READ_RW      = 8'b00000001<<I2C_READ_RW_bit,
        I2C_READ_DATA    = 8'b00000001<<I2C_READ_DATA_bit,
        I2C_WRITE_ACK_2  = 8'b00000001<<I2C_WRITE_ACK_2_bit,
        I2C_WRITE_DATA   = 8'b00000001<<I2C_WRITE_DATA_bit,
        I2C_READ_ACK     = 8'b00000001<<I2C_READ_ACK_bit

    } sub_state_t;

    // ------------------
    // RAM STATE MACHINE
    // ------------------

    typedef enum {

        MEM_WAIT_bit                    = 0,
        MEM_WRITE_ACK_1_bit             = 1,
        MEM_ADDRESS_bit                 = 2,
        MEM_WRITE_ACK_2_bit             = 3,
        MEM_WRITE_MEM_DATA_bit          = 4,
		MEM_WRITE_ACK_3_bit             = 5,
        MEM_INCREMENT_MEM_ADDRESS_bit   = 6,
        MEM_DEVICE_ADDRESS_bit          = 7,
        MEM_WRITE_ACK_4_bit             = 8,
		MEM_READ_DATA_bit               = 9,
		MEM_READ_ACK_bit                = 10,
		MEM_INCREMENT_MEM_ADDRESS_2_bit = 11

    } ram_state_bit;

    typedef enum logic [10:0] {

        MEM_WAIT                = 11'b1<<MEM_WAIT_bit,
        MEM_WRITE_ACK_1         = 11'b1<<MEM_WRITE_ACK_1_bit,
        MEM_ADDRESS             = 11'b1<<MEM_ADDRESS_bit,
        MEM_WRITE_ACK_2         = 11'b1<<MEM_WRITE_ACK_2_bit,
		MEM_WRITE_DATA          = 11'b1<<MEM_WRITE_DATA_bit, 
		MEM_WRITE_ACK_3         = 11'b1<<MEM_WRITE_ACK_3_bit,
	    MEM_INCREMENT_ADDRESS   = 11'b1<<MEM_INCREMENT_ADDRESS_bit,
		MEM_DEVICE_ADDRESS      = 11'b1<<MEM_DEVICE_ADDRESS_bit,
		MEM_WRITE_ACK_4         = 11'b1<<MEM_WRITE_ACK_4_bit,
        MEM_READ_DATA           = 11'b1<<MEM_READ_DATA_bit,        
        MEM_READ_ACK            = 11'b1<<MEM_READ_ACK_bit,
        MEM_INCREMENT_ADDRESS_2 = 11'b1<<MEM_INCREMENT_ADDRESS_2_bit        

    } ram_state_t;

endpackage
