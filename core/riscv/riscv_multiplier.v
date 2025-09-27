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

module riscv_multiplier
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
    ,input           hold_i

    // Outputs
    ,output [ 31:0]  writeback_value_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

localparam MULT_STAGES = 2; // 2 or 3

//-------------------------------------------------------------
// Multiplier
//-------------------------------------------------------------
// Stage 1

reg mult_sel;
reg [31:0] a_low;
reg [31:0] a_high;
reg [31:0] b_low;
reg [31:0] b_high;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin 
        mult_sel <= 0;
        a_low <= 32'b0;
        a_high <= 32'b0;
        b_low <= 32'b0;
        b_high <= 32'b0;
    end
    else if (!hold_i) begin
        a_low <= opcode_ra_operand_i;
        b_low <= opcode_rb_operand_i;
        a_high <= 32'b0;
        b_high <= 32'b0;
        mult_sel <= 0;
        if ((opcode_opcode_i & `INST_MUL_MASK) == `INST_MUL) begin
            mult_sel <= 1;
        end else if ((opcode_opcode_i & `INST_MULH_MASK) == `INST_MULH) begin
            a_high <= ($signed(opcode_ra_operand_i) < 0) ? 32'hffff_ffff:32'h0; 
            b_high <= ($signed(opcode_rb_operand_i) < 0) ? 32'hffff_ffff:32'h0;
        end else if ((opcode_opcode_i & `INST_MULHSU_MASK) == `INST_MULHSU) begin
            a_high <= ($signed(opcode_ra_operand_i) < 0) ? 32'hffff_ffff:32'h0; 
        end else if ((opcode_opcode_i & `INST_MULHU_MASK) == `INST_MULHU) begin
            ;
        end
    end
end

// Stage 2

reg [31:0] result_e2_q;
reg [31:0] result_e3_q;
wire [64:0] mult_result_w;
assign mult_result_w = {a_high, a_low} * {b_high, b_low};
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        result_e2_q <= 32'b0;
    else if (~hold_i)
        result_e2_q <= mult_sel ? mult_result_w[31:0] : mult_result_w[63:32];
end

// Stage 3

always @(posedge clk_i or posedge rst_i)
if (rst_i)
    result_e3_q <= 32'b0;
else if (~hold_i)
    result_e3_q <= result_e2_q;

// End of stages

assign writeback_value_o  = (MULT_STAGES == 3) ? result_e3_q : result_e2_q;


endmodule
