`timescale 1ns / 1ps

module lab_1b_top_level_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock
    parameter CLK_QUARTER = CLK_PERIOD/4; 
    parameter RESET_DUR = CLK_PERIOD * 5;
    parameter CONVERSION_TIME = 6_000_000;
    
/////////////////////////////LAB1B
    // Signals
    logic [15:0] switches_inputs;
    logic [15:0] led;
    logic an1, an2, an3, an4;
    logic ca, cb, cc, cd, ce, cf, cg;
    logic dp;
    logic reset;
    logic clk;
    logic select;
/////////////////////////////LAB1B
  
/////////////////////////////LAB1B 
    // Instantiate the Unit Under Test (UUT)
    lab_1b_top_level uut (
        .switches_inputs(switches_inputs),
        .led(led),
        .clk(clk),
        .reset(reset),
        .select(select),
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
/////////////////////////////LAB1B 
    
/////////////////////////////LAB1B
    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end
/////////////////////////////LAB1B
    // Test stimulus
    initial begin
        // Initialize inputs
        reset = 0;
        switches_inputs = 16'h0000;
        
        #CLK_QUARTER;
        
        reset = 1;
        #RESET_DUR 
        reset = 0;
        #CLK_PERIOD;
        
       
        // Test case 1:
        switches_inputs = 16'b0000_0000_0000_0000; 
        
        select = 1'b1;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        select = 1'b0;
        #CLK_PERIOD;
        #CONVERSION_TIME;

        
        // Test case 2:
        switches_inputs = 16'b0001_0000_0000_0000; 
        select = 1'b1;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        select = 1'b0;
        #CLK_PERIOD;
        #CONVERSION_TIME;
 

        // Test case 2:
        switches_inputs = 16'b0101_0101_0101_0101; 
        select = 1'b1;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        select = 1'b0;
        #CLK_PERIOD;
        #CONVERSION_TIME;
        
        // Test case 3:
        switches_inputs = 16'b000_1010_1001_1001; 
        select = 1'b1;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        select = 1'b0;
        #CLK_PERIOD;
        #CONVERSION_TIME;

        // Test case 4:
        switches_inputs = 16'b1010_1010_1010_1010; 
        select = 1'b1;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        select = 1'b0;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        // Test case 5:
        switches_inputs = 16'b0000_0000_0101_1111; 
        select = 1'b1;
        #CLK_PERIOD;
        #CONVERSION_TIME; 
        
        select = 1'b0;
        #CLK_PERIOD;
        #CONVERSION_TIME;
        
        // End simulation
        #(6 * CONVERSION_TIME);
        $stop;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("Time = %0t: switches_inputs = %b, led = %b", 
                 $time, switches_inputs, led);
    end

endmodule