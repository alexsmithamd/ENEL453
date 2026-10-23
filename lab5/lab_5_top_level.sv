`timescale 1ns / 1ps

// Correct working starter design for Lab 5.
//
// This version intentionally places the XADC, averaging, and scaling logic in
// the top level. The lab exercise asks students to refactor those elements into
// an ADC subsystem while preserving behaviour.
module lab_5_top_level #(
    parameter int SCALE_MULTIPLIER = 5001,
    parameter int SCALE_SHIFT      = 15
) (
    input  logic       clk,
    input  logic       reset,
    input  logic [1:0] display_select,
    input              vauxp15,
    input              vauxn15,
    output logic       CA, CB, CC, CD, CE, CF, CG, DP,
    output logic       AN1, AN2, AN3, AN4,
    output logic [15:0] led
);

    localparam logic [6:0] CHANNEL_ADDRESS = 7'h1F;
 
    logic        xadc_enable;
    logic        xadc_data_ready;
    logic [15:0] raw_adc_data;
    logic [15:0] averaged_adc_data;
    logic [31:0] scaled_product;
    logic [15:0] scaled_adc_data;
    logic [15:0] bcd_data;
    logic [15:0] display_data;
    logic [3:0]  decimal_point;

    // The XADC IP must be generated in Vivado as xadc_wiz_0 using the settings
    // in the Lab 5 instructions.
    adc_subsys ADC_SUBSYS (
        .clk(clk),
        .reset(reset),
        .vauxp15(vauxp15),
        .vauxn15(vauxn15),
        .raw_adc_data(raw_adc_data),
        .averaged_adc_data(averaged_adc_data),
        .scaled_product(scaled_product),
        .scaled_adc_data(scaled_adc_data)
    );
    
        bin_to_bcd BIN_TO_BCD (
        .clk(clk),
        .reset(reset),
        .bin_in(scaled_adc_data),
        .bcd_out(bcd_data)
    );

    display_mode_selector DISPLAY_SELECTOR (
        .display_select(display_select),
        .raw_adc_data(raw_adc_data[15:4]),
        .averaged_adc_data(averaged_adc_data),
        .scaled_adc_data(scaled_adc_data),
        .bcd_data(bcd_data),
        .display_data(display_data),
        .led_data(led),
        .decimal_point(decimal_point)
    );

    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk(clk),
        .reset(reset),
        .digit_0(display_data[3:0]),
        .digit_1(display_data[7:4]),
        .digit_2(display_data[11:8]),
        .digit_3(display_data[15:12]),
        .decimal_point(decimal_point),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD),
        .CE(CE), .CF(CF), .CG(CG), .DP(DP),
        .AN1(AN1), .AN2(AN2), .AN3(AN3), .AN4(AN4)
    );

endmodule
// left commented just incase needed again
//    xadc_wiz_0 XADC_INST (
//        .di_in(16'h0000),
//        .daddr_in(CHANNEL_ADDRESS),
//        .den_in(xadc_enable),
//        .dwe_in(1'b0),
//        .drdy_out(xadc_data_ready),
//        .do_out(raw_adc_data),
//        .dclk_in(clk),
//        .reset_in(reset),
//        .vp_in(1'b0),
//        .vn_in(1'b0),
//        .vauxp15(vauxp15),
//        .vauxn15(vauxn15),
//        .channel_out(),
//        .eoc_out(xadc_enable),
//        .alarm_out(),
//        .eos_out(),
//        .busy_out()
//    );

//    averager #(
//        .N(12),                 // 2**12 = 4096 samples
//        .DATA_WIDTH(16)
//    ) AVERAGER (
//        .clk(clk),
//        .reset(reset),
//        .EN(xadc_data_ready),
//        .Din(raw_adc_data),
//        .Q(averaged_adc_data)
//    );

//    // Two-stage scaling pipeline. The XADC full-scale representation is FFF0,
//    // and (FFF0 * 5001) >> 15 = 9999 after truncation.
//    always_ff @(posedge clk) begin
//        if (reset) begin
//            scaled_product  <= '0;
//            scaled_adc_data <= '0;
//        end
//        else if (xadc_data_ready) begin
//            scaled_product  <= averaged_adc_data * SCALE_MULTIPLIER;
//            scaled_adc_data <= scaled_product >> SCALE_SHIFT;
//        end
//    end


