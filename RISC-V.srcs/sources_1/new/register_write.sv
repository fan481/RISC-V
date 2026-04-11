`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 01:57:50 PM
// Design Name: 
// Module Name: register_write
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


module register_write(
    input memr_valid, //todo: implement stalls for mem reads that take longer than 1 cycle
    input [31:0] memr_data,
    input [1:0] mem_size,
    input load_unsigned,
    input [1:0] write_from, //select write data- 00 memory, 01 ALU, 10 PC
    input [14:0] decoded_sig, //shouldn't need to access rs1/rs2
    input [31:0] pc_incr,
    input [31:0] alu_out,
    output [31:0] memr_addr,
    output [31:0] reg_sel_write,
    output logic [31:0] regw_data
    );

    assign memr_addr = alu_out; //todo: make sure this continuous drive doesn't cause issues
    assign reg_sel_write = 32'b1 << decoded_sig[4:0]; //select rd, decoder needs to make it default zero

    always_comb begin //load/select mem
        case (write_from)
            2'b00: begin //memory, memory module should return 32 bits and CPU should load byte/half into LSBs
                case (mem_size)
                    2'b01: begin //byte
                        if (load_unsigned) regw_data = {24'b0, memr_data[7:0]};
                        else regw_data = $signed(memr_data[7:0]);
                    end
                    2'b10: begin //half
                        if (load_unsigned) regw_data = {16'b0, memr_data[15:0]};
                        else regw_data = $signed(memr_data[15:0]);
                    end
                    default: regw_data = memr_data; //for lw and also for avoiding latch inference
                endcase
            end
            2'b01: begin //ALU
                regw_data = alu_out;
            end
            2'b10: begin //PC
                regw_data = pc_incr;
            end
            default: regw_data = alu_out; //avoid latch inference
        endcase
        //shouldn't need error flagging in this module, decoder should be enough
    end

endmodule
