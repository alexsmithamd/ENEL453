module mux(
    input logic [15:0] bcd_inputs, hex_inputs, bcd_reg, hex_reg,
    input logic [1:0] select,
    output logic [15:0] display_outputs 
);
        
    always_comb begin
        case (select)
            2'b00: display_outputs = hex_inputs;
            2'b01: display_outputs = bcd_inputs;
            2'b10: display_outputs = bcd_reg;
            2'b11: display_outputs = hex_reg;
        endcase
    end
endmodule
