// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

////////////////////////////////////////////////////////////////////////////////
// Engineer:       Matthias Baer - baermatt@student.ethz.ch                   //
//                                                                            //
// Additional contributions by:                                               //
//                 Sven Stucki - svstucki@student.ethz.ch                     //
//                                                                            //
//                                                                            //
// Design Name:    RISC-V processor core                                      //
// Project Name:   RI5CY                                                      //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    Defines for various constants used by the processor core.  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

package riscv_defines;

////////////////////////////////////////////////
//    ___         ____          _             //
//   / _ \ _ __  / ___|___   __| | ___  ___   //
//  | | | | '_ \| |   / _ \ / _` |/ _ \/ __|  //
//  | |_| | |_) | |__| (_) | (_| |  __/\__ \  //
//   \___/| .__/ \____\___/ \__,_|\___||___/  //
//        |_|                                 //
////////////////////////////////////////////////

localparam OPCODE_SYSTEM    = 7'h73;
localparam OPCODE_FENCE     = 7'h0f;
localparam OPCODE_OP        = 7'h33;
localparam OPCODE_OPIMM     = 7'h13;
localparam OPCODE_STORE     = 7'h23;
localparam OPCODE_LOAD      = 7'h03;
localparam OPCODE_BRANCH    = 7'h63;
localparam OPCODE_JALR      = 7'h67;
localparam OPCODE_JAL       = 7'h6f;
localparam OPCODE_AUIPC     = 7'h17;
localparam OPCODE_LUI       = 7'h37;
localparam OPCODE_OP_FP     = 7'h53;
localparam OPCODE_OP_FMADD  = 7'h43;
localparam OPCODE_OP_FNMADD = 7'h4f;
localparam OPCODE_OP_FMSUB  = 7'h47;
localparam OPCODE_OP_FNMSUB = 7'h4b;
localparam OPCODE_STORE_FP  = 7'h27;
localparam OPCODE_LOAD_FP   = 7'h07;

// those opcodes are now used for PULP custom instructions
// localparam OPCODE_CUST0     = 7'h0b
// localparam OPCODE_CUST1     = 7'h2b

// PULP custom
localparam OPCODE_LOAD_POST  = 7'h0b;
localparam OPCODE_STORE_POST = 7'h2b;
localparam OPCODE_PULP_OP    = 7'h5b;
localparam OPCODE_VECOP      = 7'h57;
localparam OPCODE_HWLOOP     = 7'h7b;

localparam REGC_S1   = 2'b10;
localparam REGC_S4   = 2'b00;
localparam REGC_RD   = 2'b01;
localparam REGC_ZERO = 2'b11;


//////////////////////////////////////////////////////////////////////////////
//      _    _    _   _    ___                       _   _                  //
//     / \  | |  | | | |  / _ \ _ __   ___ _ __ __ _| |_(_) ___  _ __  ___  //
//    / _ \ | |  | | | | | | | | '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \/ __| //
//   / ___ \| |__| |_| | | |_| | |_) |  __/ | | (_| | |_| | (_) | | | \__ \ //
//  /_/   \_\_____\___/   \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|___/ //
//                             |_|                                          //
//////////////////////////////////////////////////////////////////////////////

localparam ALU_OP_WIDTH = 7;

localparam ALU_ADD   = 7'b0011000;
localparam ALU_SUB   = 7'b0011001;
localparam ALU_ADDU  = 7'b0011010;
localparam ALU_SUBU  = 7'b0011011;
localparam ALU_ADDR  = 7'b0011100;
localparam ALU_SUBR  = 7'b0011101;
localparam ALU_ADDUR = 7'b0011110;
localparam ALU_SUBUR = 7'b0011111;

localparam ALU_XOR   = 7'b0101111;
localparam ALU_OR    = 7'b0101110;
localparam ALU_AND   = 7'b0010101;

// Shifts
localparam ALU_SRA   = 7'b0100100;
localparam ALU_SRL   = 7'b0100101;
localparam ALU_ROR   = 7'b0100110;
localparam ALU_SLL   = 7'b0100111;

// bit manipulation
localparam ALU_BEXT  = 7'b0101000;
localparam ALU_BEXTU = 7'b0101001;
localparam ALU_BINS  = 7'b0101010;
localparam ALU_BCLR  = 7'b0101011;
localparam ALU_BSET  = 7'b0101100;

// Bit counting
localparam ALU_FF1   = 7'b0110110;
localparam ALU_FL1   = 7'b0110111;
localparam ALU_CNT   = 7'b0110100;
localparam ALU_CLB   = 7'b0110101;

// Sign-/zero-extensions
localparam ALU_EXTS  = 7'b0111110;
localparam ALU_EXT   = 7'b0111111;

// Comparisons
localparam ALU_LTS   = 7'b0000000;
localparam ALU_LTU   = 7'b0000001;
localparam ALU_LES   = 7'b0000100;
localparam ALU_LEU   = 7'b0000101;
localparam ALU_GTS   = 7'b0001000;
localparam ALU_GTU   = 7'b0001001;
localparam ALU_GES   = 7'b0001010;
localparam ALU_GEU   = 7'b0001011;
localparam ALU_EQ    = 7'b0001100;
localparam ALU_NE    = 7'b0001101;

// Set Lower Than operations
localparam ALU_SLTS  = 7'b0000010;
localparam ALU_SLTU  = 7'b0000011;
localparam ALU_SLETS = 7'b0000110;
localparam ALU_SLETU = 7'b0000111;

// Absolute value
localparam ALU_ABS   = 7'b0010100;
localparam ALU_CLIP  = 7'b0010110;
localparam ALU_CLIPU = 7'b0010111;

// Insert/extract
localparam ALU_INS   = 7'b0101101;

// min/max
localparam ALU_MIN   = 7'b0010000;
localparam ALU_MINU  = 7'b0010001;
localparam ALU_MAX   = 7'b0010010;
localparam ALU_MAXU  = 7'b0010011;

// div/rem
localparam ALU_DIVU  = 7'b0110000; // bit 0 is used for signed mode, bit 1 is used for remdiv
localparam ALU_DIV   = 7'b0110001; // bit 0 is used for signed mode, bit 1 is used for remdiv
localparam ALU_REMU  = 7'b0110010; // bit 0 is used for signed mode, bit 1 is used for remdiv
localparam ALU_REM   = 7'b0110011; // bit 0 is used for signed mode, bit 1 is used for remdiv

localparam ALU_SHUF  = 7'b0111010;
localparam ALU_SHUF2 = 7'b0111011;
localparam ALU_PCKLO = 7'b0111000;
localparam ALU_PCKHI = 7'b0111001;

// fpu
localparam ALU_FKEEP   = 7'b1111111;   // hack, to support fcvt.s.d
localparam ALU_FSGNJ   = 7'b1000000;
localparam ALU_FSGNJN  = 7'b1000001;
localparam ALU_FSGNJX  = 7'b1000010;
localparam ALU_FEQ     = 7'b1000011;
localparam ALU_FLT     = 7'b1000100;
localparam ALU_FLE     = 7'b1000101;
localparam ALU_FMAX    = 7'b1000110;
localparam ALU_FMIN    = 7'b1000111;
localparam ALU_FCLASS  = 7'b1001000;

localparam MUL_MAC32 = 3'b000;
localparam MUL_MSU32 = 3'b001;
localparam MUL_I     = 3'b010;
localparam MUL_IR    = 3'b011;
localparam MUL_DOT8  = 3'b100;
localparam MUL_DOT16 = 3'b101;
localparam MUL_H     = 3'b110;

// vector modes
localparam VEC_MODE32 = 2'b00;
localparam VEC_MODE16 = 2'b10;
localparam VEC_MODE8  = 2'b11;

/////////////////////////////////////////////////////////
//    ____ ____    ____            _     _             //
//   / ___/ ___|  |  _ \ ___  __ _(_)___| |_ ___ _ __  //
//  | |   \___ \  | |_) / _ \/ _` | / __| __/ _ \ '__| //
//  | |___ ___) | |  _ <  __/ (_| | \__ \ ||  __/ |    //
//   \____|____/  |_| \_\___|\__, |_|___/\__\___|_|    //
//                           |___/                     //
/////////////////////////////////////////////////////////

// CSR operations
localparam CSR_OP_NONE  = 2'b00;
localparam CSR_OP_WRITE = 2'b01;
localparam CSR_OP_SET   = 2'b10;
localparam CSR_OP_CLEAR = 2'b11;


// SPR for debugger, not accessible by CPU
localparam SP_DVR0       = 16'h3000;
localparam SP_DCR0       = 16'h3008;
localparam SP_DMR1       = 16'h3010;
localparam SP_DMR2       = 16'h3011;

localparam SP_DVR_MSB = 8'h00;
localparam SP_DCR_MSB = 8'h01;
localparam SP_DMR_MSB = 8'h02;
localparam SP_DSR_MSB = 8'h04;

// Privileged mode
typedef enum logic[1:0] {
  PRIV_LVL_M = 2'b11,
  PRIV_LVL_H = 2'b10,
  PRIV_LVL_S = 2'b01,
  PRIV_LVL_U = 2'b00
} PrivLvl_t;

///////////////////////////////////////////////
//   ___ ____    ____  _                     //
//  |_ _|  _ \  / ___|| |_ __ _  __ _  ___   //
//   | || | | | \___ \| __/ _` |/ _` |/ _ \  //
//   | || |_| |  ___) | || (_| | (_| |  __/  //
//  |___|____/  |____/ \__\__,_|\__, |\___|  //
//                              |___/        //
///////////////////////////////////////////////

// forwarding operand mux
localparam SEL_REGFILE      = 2'b00;
localparam SEL_FW_EX        = 2'b01;
localparam SEL_FW_WB        = 2'b10;

// operand a selection
localparam OP_A_REGA_OR_FWD = 3'b000;
localparam OP_A_CURRPC      = 3'b001;
localparam OP_A_IMM         = 3'b010;
localparam OP_A_REGB_OR_FWD = 3'b011;
localparam OP_A_REGC_OR_FWD = 3'b100;

// immediate a selection
localparam IMMA_Z      = 1'b0;
localparam IMMA_ZERO   = 1'b1;

// operand b selection
localparam OP_B_REGB_OR_FWD = 3'b000;
localparam OP_B_REGC_OR_FWD = 3'b001;
localparam OP_B_IMM         = 3'b010;
localparam OP_B_REGA_OR_FWD = 3'b011;
localparam OP_B_BMASK       = 3'b100;

// immediate b selection
localparam IMMB_I      = 4'b0000;
localparam IMMB_S      = 4'b0001;
localparam IMMB_U      = 4'b0010;
localparam IMMB_PCINCR = 4'b0011;
localparam IMMB_S2     = 4'b0100;
localparam IMMB_S3     = 4'b0101;
localparam IMMB_VS     = 4'b0110;
localparam IMMB_VU     = 4'b0111;
localparam IMMB_SHUF   = 4'b1000;
localparam IMMB_CLIP   = 4'b1001;
localparam IMMB_BI     = 4'b1011;

// bit mask selection
localparam BMASK_A_ZERO = 1'b0;
localparam BMASK_A_S3   = 1'b1;

localparam BMASK_B_S2   = 2'b00;
localparam BMASK_B_S3   = 2'b01;
localparam BMASK_B_ZERO = 2'b10;
localparam BMASK_B_ONE  = 2'b11;

localparam BMASK_A_REG  = 1'b0;
localparam BMASK_A_IMM  = 1'b1;
localparam BMASK_B_REG  = 1'b0;
localparam BMASK_B_IMM  = 1'b1;


// multiplication immediates
localparam MIMM_ZERO    = 1'b0;
localparam MIMM_S3      = 1'b1;

// operand c selection
localparam OP_C_REGC_OR_FWD = 2'b00;
localparam OP_C_REGB_OR_FWD = 2'b01;
localparam OP_C_JT          = 2'b10;

// branch types
localparam BRANCH_NONE = 2'b00;
localparam BRANCH_JAL  = 2'b01;
localparam BRANCH_JALR = 2'b10;
localparam BRANCH_COND = 2'b11; // conditional branches

// jump target mux
localparam JT_JAL  = 2'b01;
localparam JT_JALR = 2'b10;
localparam JT_COND = 2'b11;


///////////////////////////////////////////////
//   ___ _____   ____  _                     //
//  |_ _|  ___| / ___|| |_ __ _  __ _  ___   //
//   | || |_    \___ \| __/ _` |/ _` |/ _ \  //
//   | ||  _|    ___) | || (_| | (_| |  __/  //
//  |___|_|     |____/ \__\__,_|\__, |\___|  //
//                              |___/        //
///////////////////////////////////////////////

// PC mux selector defines
localparam PC_BOOT          = 3'b000;
localparam PC_JUMP          = 3'b010;
localparam PC_BRANCH        = 3'b011;
localparam PC_EXCEPTION     = 3'b100;
localparam PC_ERET          = 3'b101;
localparam PC_DBG_NPC       = 3'b111;

// Exception PC mux selector defines
localparam EXC_PC_ILLINSN   = 2'b00;
localparam EXC_PC_ECALL     = 2'b01;
localparam EXC_PC_LOAD      = 2'b10;
localparam EXC_PC_STORE     = 2'b10;
localparam EXC_PC_IRQ       = 2'b11;

// Exception Cause
localparam EXC_CAUSE_ILLEGAL_INSN = 6'h02;
localparam EXC_CAUSE_BREAKPOINT   = 6'h03;
localparam EXC_CAUSE_ECALL_UMODE  = 6'h08;
localparam EXC_CAUSE_ECALL_MMODE  = 6'h0B;

// Trap mux selector
localparam TRAP_MACHINE      = 1'b0;
localparam TRAP_USER         = 1'b1;

// Exceptions offsets
// target address = {boot_addr[31:8], EXC_OFF} (boot_addr must be 32 BYTE aligned!)
// offset 00 to 7e is used for external interrupts
localparam EXC_OFF_RST      = 8'h80;
localparam EXC_OFF_ILLINSN  = 8'h84;
localparam EXC_OFF_ECALL    = 8'h88;
localparam EXC_OFF_LSUERR   = 8'h8c;


// Debug module
localparam DBG_SETS_W = 6;

localparam DBG_SETS_IRQ    = 5;
localparam DBG_SETS_ECALL  = 4;
localparam DBG_SETS_EILL   = 3;
localparam DBG_SETS_ELSU   = 2;
localparam DBG_SETS_EBRK   = 1;
localparam DBG_SETS_SSTE   = 0;

localparam DBG_CAUSE_HALT   = 6'h1F;

// private FPU
localparam C_CMD               = 4;
localparam C_FPU_ADD_CMD       = 4'h0;
localparam C_FPU_SUB_CMD       = 4'h1;
localparam C_FPU_MUL_CMD       = 4'h2;
localparam C_FPU_DIV_CMD       = 4'h3;
localparam C_FPU_I2F_CMD       = 4'h4;
localparam C_FPU_F2I_CMD       = 4'h5;
localparam C_FPU_SQRT_CMD      = 4'h6;
localparam C_FPU_NOP_CMD       = 4'h7;
localparam C_FPU_FMADD_CMD     = 4'h8;
localparam C_FPU_FMSUB_CMD     = 4'h9;
localparam C_FPU_FNMADD_CMD    = 4'hA;
localparam C_FPU_FNMSUB_CMD    = 4'hB;
   
localparam C_FFLAG             = 5;
localparam C_RM                = 3;
localparam C_RM_NEAREST        = 3'h0;
localparam C_RM_TRUNC          = 3'h1;
localparam C_RM_PLUSINF        = 3'h3;
localparam C_RM_MINUSINF       = 3'h2;
localparam C_PC                = 5;

endpackage
