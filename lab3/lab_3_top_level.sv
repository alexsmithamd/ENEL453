module lab_3_top_level (
    input logic [15:0] switches_inputs,
    input logic clk, reset, // slide switches (0 towards Basys3 board edge, 1 towards board center)
    input logic select,
    input logic store,
    input logic source_select, // 0 - live output of switched, 1 - stored register value
    output logic [15:0] led,
    output logic an1, an2, an3, an4,
    output logic ca, cb, cc, cd, ce, cf, cg,
    output logic dp // mapped to the LEDs above the slide switches, LEDs: write a 1 to light LED, 0 to turn it off
);

    // Internal signal declarations
    logic [15:0] synced_switches_inputs;
    logic [15:0] switches_outputs;
    logic [15:0] reg_outputs;
    logic [15:0] bcd_outputs; 
    logic [15:0] bcd_reg;
    logic [15:0] display_outputs;
    
    logic deb_select; 
    logic deb_source_select; 
    logic deb_store; 
    
    // Instantiate components

    switch_logic SWITCHES (
         .switches_inputs(synced_switches_inputs),
         .switches_outputs(switches_outputs)
    );
    
/////////////////////////////////////////////LAB3
    register regi (
        .clk(clk),
        .select(store),
        .reset(reset),
        .reg_input(switches_outputs),
        .reg_output(reg_outputs)
    );
   
   
   bin_to_bcd BIN_LIVE (
        .clk(clk),
        .reset(reset),
        .bin_in(switches_outputs),
        .bcd_out(bcd_outputs)
    ); 
    
    bin_to_bcd BIN_STORED (
        .clk(clk),
        .reset(reset),
        .bin_in(reg_outputs),
        .bcd_out(bcd_reg)
    );
  
    mux MUX (
        .bcd_inputs(bcd_outputs),
        .bcd_reg(bcd_reg),
        .hex_inputs(switches_outputs),
        .hex_reg(reg_outputs),
        .select({source_select, select}),
        .display_outputs(display_outputs)
    );

    input_synchronizer SYNCHRONIZER (
        .switches_inputs(switches_inputs),
        .clk(clk),
        .switches_outputs(synced_switches_inputs)
    );
    
    debounce SELECT (
    .clk(clk),
    .reset(reset),
    .button(select),
    .result(deb_select)
    );
    
    debounce SOURCE_SELECT (
    .clk(clk),
    .reset(reset),
    .button(source_select),
    .result(deb_source_select)
    );
    
    debounce STORE (
    .clk(clk),
    .reset(reset),
    .button(store),
    .result(deb_store)
    );

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
