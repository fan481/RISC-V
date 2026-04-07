`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 09:56:20 AM
// Design Name: 
// Module Name: register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register(
    input clk,
    input [14:0] decoded_sig,
    input [31:0] reg_sel_write,
    input [31:0] regw_data,
    output [31:0] reg_op1,
    output [31:0] reg_op2
    );
    reg [31:0] reg_data [31:0];
    assign reg_data[0] = 32'b0; // $zero
    assign reg_op1 = reg_data[decoded_sig[14:10]];
    assign reg_op2 = reg_data[decoded_sig[9:5]];

    always @(posedge clk) begin
        for (int i = 1; i < 32; i++) begin
            if (reg_sel_write[i]) reg_data[i] <= regw_data;
        end
    end

endmodule
