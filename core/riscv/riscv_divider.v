//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_divider
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           opcode_valid_i
    ,input  [ 31:0]  opcode_opcode_i
    ,input  [ 31:0]  opcode_pc_i
    ,input           opcode_invalid_i
    ,input  [  4:0]  opcode_rd_idx_i
    ,input  [  4:0]  opcode_ra_idx_i
    ,input  [  4:0]  opcode_rb_idx_i
    ,input  [ 31:0]  opcode_ra_operand_i
    ,input  [ 31:0]  opcode_rb_operand_i

    // Outputs
    ,output          writeback_valid_o
    ,output [ 31:0]  writeback_value_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-------------------------------------------------------------
// Registers / Wires
//-------------------------------------------------------------
reg          valid_q;
reg  [31:0]  wb_result_q;

//-------------------------------------------------------------
// Divider
//-------------------------------------------------------------
wire inst_div_w         = (opcode_opcode_i & `INST_DIV_MASK) == `INST_DIV;
wire inst_divu_w        = (opcode_opcode_i & `INST_DIVU_MASK) == `INST_DIVU;
wire inst_rem_w         = (opcode_opcode_i & `INST_REM_MASK) == `INST_REM;
wire inst_remu_w        = (opcode_opcode_i & `INST_REMU_MASK) == `INST_REMU;

wire div_rem_inst_w     = ((opcode_opcode_i & `INST_DIV_MASK) == `INST_DIV)  || 
                          ((opcode_opcode_i & `INST_DIVU_MASK) == `INST_DIVU) ||
                          ((opcode_opcode_i & `INST_REM_MASK) == `INST_REM)  ||
                          ((opcode_opcode_i & `INST_REMU_MASK) == `INST_REMU);

wire signed_operation_w = ((opcode_opcode_i & `INST_DIV_MASK) == `INST_DIV) || ((opcode_opcode_i & `INST_REM_MASK) == `INST_REM);
wire div_operation_w    = ((opcode_opcode_i & `INST_DIV_MASK) == `INST_DIV) || ((opcode_opcode_i & `INST_DIVU_MASK) == `INST_DIVU);

always @ (posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        valid_q <= 0;
        wb_result_q <= 0;
    end else begin
        valid_q <= opcode_valid_i && div_rem_inst_w;
        if (div_operation_w) begin
            if (signed_operation_w) begin
                wb_result_q <= $signed(opcode_ra_operand_i) / $signed(opcode_rb_operand_i);
            end else begin
                wb_result_q <= $unsigned(opcode_ra_operand_i) / $unsigned(opcode_rb_operand_i);
            end
        end else begin
            if (signed_operation_w) begin
                wb_result_q <= $signed(opcode_ra_operand_i) % $signed(opcode_rb_operand_i);
            end else begin
                wb_result_q <= $unsigned(opcode_ra_operand_i) % $unsigned(opcode_rb_operand_i);
            end
        end
    end
end

assign writeback_valid_o = valid_q;
assign writeback_value_o = wb_result_q;



endmodule
