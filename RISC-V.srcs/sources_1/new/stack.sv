`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 02:41:45 PM
// Design Name: 
// Module Name: stack
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


module stack(
    input clk,
    input [31:0] memr_addr,
    input memw_valid,
    input [1:0] memw_size, //00 lw, 01 lb, 10 lh
    input [31:0] memw_addr,
    input [31:0] memw_data,
    output [31:0] memr_data,
    output memr_valid
    );
    reg [7:0] stack_data [1023:0];
    assign memr_valid = 1; //intra-cycle stack so memr_valid always 1
    assign memr_data = {stack_data[memr_addr - 3], stack_data[memr_addr - 2], stack_data[memr_addr - 1], stack_data[memr_addr]};

    always_ff @(posedge clk) begin //todo: check synthesis/optimization
        if (memw_valid) begin
            case (memw_size) 
                2'b00: begin //word
                    stack_data[memw_addr] <= memw_data[7:0];
                    stack_data[memw_addr - 1] <= memw_data[15:8];
                    stack_data[memw_addr - 2] <= memw_data[23:16];
                    stack_data[memw_addr - 3] <= memw_data[31:24];
                end
                2'b01: begin //byte
                    stack_data[memw_addr] <= memw_data[7:0];
                end
                2'b10: begin //half
                    stack_data[memw_addr] <= memw_data[7:0];
                    stack_data[memw_addr - 1] <= memw_data[15:8];
                end
            endcase
        end
    end
endmodule
