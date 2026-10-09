`timescale 1ns / 1ps

module register(
    input  logic [15:0] reg_input,
    input logic select,
    input logic reset,
    input clk,
    output logic [15:0] reg_output
    );
    
    always_ff @(posedge clk)begin
        if (reset)
            reg_output <= 16'h0000;
        else if (select)
            reg_output <= reg_input;
    end
    
endmodule
