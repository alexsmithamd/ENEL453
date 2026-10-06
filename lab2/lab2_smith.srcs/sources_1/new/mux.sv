module mux(
    input logic select,
    input logic [15:0] bcd_in, hex_in, 
    output logic [15:0] display_out
);

assign display_out = select ? hex_in : bcd_in;

endmodule
