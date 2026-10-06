module mux(
    input  logic [15:0] hex_inputs, bcd_inputs,
    input logic select,
    output logic [15:0] display_outputs 
);

    assign display_outputs = select ? hex_inputs : bcd_inputs;
   
endmodule
