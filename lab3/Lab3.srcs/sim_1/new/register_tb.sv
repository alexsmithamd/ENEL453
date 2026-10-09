`timescale 1ns / 1ps

module register_tb;

    logic [15:0] reg_input;
    logic select;
    logic reset;
    logic clk = 0; // initialize starting value
    logic [15:0] reg_output;
    
    register UUT (
        .reg_input(reg_input),
        .select(select),
        .reset(reset),
        .clk(clk),
        .reg_output(reg_output)
    );
    
    always #5 clk = ~clk; // generates a 5 time unit delay which is 5ns. full period will be 10ns
    
    initial begin
        reset = 0;
        select = 0;
        reg_input = 16'h0000;
        #10;
        
        reset = 1; #20; //setting reg to 0000
        reset = 0; #20;
        
        //change the input
        reg_input = 16'hA123; #20;
        
        //capture reg change, store it and reset select to 0
        select = 1; #20;
        select = 0; #20;
        
        //test if writing new input overrides previous
        reg_input = 16'hB456; #20;
        
        //capture reg change, store it and reset select to 0
        select = 1; #20;
        select = 0; #20;
        
        //test reset and select together and then return reset and select to 0
        reg_input = 16'hC789; #20;
        reset = 1;
        select = 1;
        #20;
        reset = 0;
        select = 0;     
      
        $stop;
    end
endmodule
