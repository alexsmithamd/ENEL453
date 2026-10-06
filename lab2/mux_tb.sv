`timescale 1ns / 1ps

module mux_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock
    parameter CLK_QUARTER = CLK_PERIOD/4; 
    parameter RESET_DUR = CLK_PERIOD * 5;
    parameter CONVERSION_TIME = 10;
    
    // Signals
    logic [15:0] switches_inputs, bcd_inputs;
    logic [15:0] display_outputs;
    logic reset;
    logic clk;
    logic select; 

    // Instantiate the Unit Under Test (UUT)
    mux uut (
    .hex_inputs(switches_inputs),
    .bcd_inputs(bcd_inputs),
    .select(select),
    .display_outputs(display_outputs)
    );

    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end


    // Test stimulus
    initial begin
        // Initialize inputs
        reset = 0;
        switches_inputs = 16'h0000;
        bcd_inputs = 16'h0000;
        select = 1'b0;
        
        #CLK_QUARTER;
        
        reset = 1;
        #RESET_DUR 
        reset = 0;
        #CLK_PERIOD;

        // Test case 1:
        switches_inputs = 16'h5555;
        bcd_inputs = 16'hAAAA;
        
        select = 1'b1;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        select = 1'b0;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        // Test case 2:
        switches_inputs = 16'hAAAA;
        bcd_inputs = 16'h5555;
        
        select = 1'b1;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        select = 1'b0;
        #CLK_PERIOD;
        #CONVERSION_TIME;

        /// End simulation
        #(2 * CONVERSION_TIME);
        $stop;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("Time = %0t: switches_inputs = %b", 
                 $time, switches_inputs);
    end

endmodule