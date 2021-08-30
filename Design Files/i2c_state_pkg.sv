package i2c_state_pkg;

    // -----------------------------------
    // MAIN I2C SUBORDINATE STATE MACHINE
    // -----------------------------------

    // State bits for subordinate state machine
    typedef enum {

        WAIT_bit         = 0,
        READ_ADDRESS_bit = 1,
        WRITE_ACK_1_bit  = 2,
        READ_RW_bit      = 3,
        READ_DATA_bit    = 4,
        WRITE_ACK_2_bit  = 5,
        WRITE_DATA_bit   = 6,
        READ_ACK_bit     = 7

    } sub_state_bit;

    // Shift a 1 to the bit that represents each state
    typedef enum logic [7:0] {

        WAIT         = 8'b00000001<<WAIT_bit,
        READ_ADDRESS = 8'b00000001<<READ_ADDRESS_bit,
        WRITE_ACK_1  = 8'b00000001<<WRITE_ACK_1_bit,
        READ_RW      = 8'b00000001<<READ_RW_bit,
        READ_DATA    = 8'b00000001<<READ_DATA_bit,
        WRITE_ACK_2  = 8'b00000001<<WRITE_ACK_2_bit,
        WRITE_DATA   = 8'b00000001<<WRITE_DATA_bit,
        READ_ACK     = 8'b00000001<<READ_ACK_bit

    } sub_state_t;

    // ------------------
    // RAM STATE MACHINE
    // ------------------

    typedef enum {

        WAIT_bit                    = 0,
        WRITE_ACK_1_bit             = 1,
        MEM_ADDRESS_bit             = 2,
        WRITE_ACK_2_bit             = 3,
        WRITE_MEM_DATA_bit          = 4,
		WRITE_ACK_3_bit             = 5,
        INCREMENT_MEM_ADDRESS_bit   = 6,
        DEVICE_ADDRESS_bit          = 7,
        WRITE_ACK_4_bit             = 8,
		MEM_READ_DATA_bit           = 9,
		READ_ACK_bit                = 10,
		INCREMENT_MEM_ADDRESS_2_bit = 11

    } ram_state_bit;

    typedef enum logic [10:0] {

        WAIT                    = 11'b1<<WAIT_bit,
        WRITE_ACK_1             = 11'b1<<WRITE_ACK_1_bit,
        MEM_ADDRESS             = 11'b1<<MEM_ADDRESS_bit,
        WRITE_ACK_2             = 11'b1<<WRITE_ACK_2_bit,
		WRITE_MEM_DATA          = 11'b1<<WRITE_MEM_DATA_bit, 
		WRITE_ACK_3             = 11'b1<<WRITE_ACK_3_bit,
		INCREMENT_MEM_ADDRESS   = 11'b1<<INCREMENT_MEM_ADDRESS_bit,
		DEVICE_ADDRESS          = 11'b1<<DEVICE_ADDRESS_bit,
		WRITE_ACK_4             = 11'b1<<WRITE_ACK_4_bit,
        MEM_READ_DATA           = 11'b1<<MEM_READ_DATA_bit,        
        READ_ACK                = 11'b1<<READ_ACK_bit,
        INCREMENT_MEM_ADDRESS_2 = 11'b1<<INCREMENT_MEM_ADDRESS_2_bit
        

    } ram_state_t;




endpackage
