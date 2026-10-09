`timescale 1ns / 1ps

module lab_3_top_level_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock
    parameter CLK_QUARTER = CLK_PERIOD/4; 
    parameter RESET_DUR = CLK_PERIOD * 5;
    parameter CONVERSION_TIME = 1000;
    
    // Signals
    logic [15:0] switches_inputs;
    logic [15:0] led;
    logic an1, an2, an3, an4;
    logic ca, cb, cc, cd, ce, cf, cg;
    logic dp;
    logic reset;
    logic clk;
    logic select;
    logic source_select;
    logic store;

    // Instantiate the Unit Under Test (UUT)
    lab_3_top_level uut (
        .switches_inputs(switches_inputs),
        .led(led),
        .clk(clk),
        .reset(reset),
        .select(select),
        .source_select(source_select),
        .store(store),
        .an1(an1),
        .an2(an2),
        .an3(an3),
        .an4(an4),
        .ca(ca),
        .cb(cb),
        .cc(cc),
        .cd(cd),
        .ce(ce),
        .cf(cf),
        .cg(cg)
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
        select = 0;
        source_select = 0;
        store = 0;
        
        #CLK_QUARTER;
        
        reset = 1;
        #RESET_DUR 
        reset = 0;
        #CLK_PERIOD;
        
        // Test case 1: testing each possible output
        switches_inputs = 16'h1234; 
        
        select = 0;
        source_select = 0;
        #CONVERSION_TIME;
        
        select = 1;
        source_select = 0;
        #CONVERSION_TIME;
                
        select = 0;
        source_select = 1;
        #CONVERSION_TIME;        

        select = 1;
        source_select = 1;
        #CONVERSION_TIME;
        
        reset = 1;
        #RESET_DUR;
        reset = 0;
        #CLK_PERIOD;
        
        //initialize reg test
        store = 1;
        #(2*CLK_PERIOD);
        store = 0;
        #CLK_PERIOD;
         
        // Test case 2: testing each possible output
        switches_inputs = 16'h5678; 
        
        select = 0;
        source_select = 0;
        #CONVERSION_TIME;
        
        select = 1;
        source_select = 0;
        #CONVERSION_TIME;
        
        select = 0;
        source_select = 1;
        #CONVERSION_TIME;
        
        select = 1;
        source_select = 1;
        #CONVERSION_TIME;
        
        reset = 1;
        #RESET_DUR;
        reset = 0;
        #CLK_PERIOD;
        // End simulation
        #CONVERSION_TIME;
        $stop;
    end

    // Optional: Monitor changes
//    initial begin
//        $monitor("Time = %0t: switches_inputs = %b, led = %b", 
//                 $time, switches_inputs, led);
//    end

endmodule