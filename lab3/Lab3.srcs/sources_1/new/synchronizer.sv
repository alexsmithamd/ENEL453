`timescale 1ns / 1ps

module input_synchronizer (
    input logic[0:15] switches_inputs, 
    input logic clk,
    output logic[0:15] switches_outputs
);

    logic [0:15] n1; 
//ensures the value is sampled on rising clock edge
always_ff @(posedge clk)
    begin
        n1 <= switches_inputs;
        switches_outputs <= n1;
    end  
    
endmodule 