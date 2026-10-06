module lab_2_top_level (
    input  logic [15:0] switches_inputs,
    input  logic clk, reset, // slide switches (0 towards Basys3 board edge, 1 towards board center)
    input logic select,
    output logic [15:0] led,
    output logic an1, an2, an3, an4,
    output logic ca, cb, cc, cd, ce, cf, cg,
    output logic dp // mapped to the LEDs above the slide switches, LEDs: write a 1 to light LED, 0 to turn it off
);

    // Internal signal declarations

    logic [15:0] switches_outputs;
    logic [15:0] display_outputs;
    logic [15:0] bcd_outputs; 
    
    // Instantiate components

    switch_logic SWITCHES (
         .switches_inputs(switches_inputs),
         .switches_outputs(switches_outputs)
    );
    
/////////////////////////////////////////////LAB2

    bin_to_bcd BIN_BCD (
    .clk(clk),
    .reset(reset),
    .bin_in(switches_outputs),
    .bcd_out(bcd_outputs)
    );
    
    mux MUX (
    .select(select),
    .hex_inputs(switches_outputs),
    .bcd_inputs(bcd_outputs),
    .display_outputs(display_outputs)
    );
    
/////////////////////////////////////////////LAB2



    seven_segment_display_subsystem SUBSYSTEM (
        .clk(clk),
        .reset(reset),
        .sec_dig1(display_outputs[3:0]),
        .sec_dig2(display_outputs[7:4]),
        .min_dig1(display_outputs[11:8]),
        .min_dig2(display_outputs[15:12]),
        .CA(ca),
        .CB(cb),
        .CC(cc),
        .CD(cd),
        .CE(ce),
        .CF(cf),
        .CG(cg),
        .DP(dp),
        .AN1(an1),
        .AN2(an2),
        .AN3(an3),
        .AN4(an4)
 );      
                
      
    assign led = switches_outputs;

endmodule
