module mux(
    input  logic [15:0] hex_in, bcd_in,
    input logic select,
    output logic [15:0] display_outputs 
);

    assign display_outputs = select ? hex_in : bcd_in;
   
endmodule
