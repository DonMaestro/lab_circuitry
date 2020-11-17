`timescale 1ns / 1ps

module testbench;

parameter PERIOD = 20;

reg         i_clk, i_rst_n;
//reg  [31:0]  i_freq_step;
reg	[9:0]	i_freq_step;
wire [9:0]  o_dac;
wire 		gpio;

nco  nco_inst(.CLOCK_50 (i_clk), 
                .KEY ({i_rst_n, 1'b0}),
                .SW (i_freq_step), 
                .VGA_R (o_dac),
		.GPIO_0 (gpio)
                );

initial begin
    i_clk = 0;
    forever #(PERIOD/2) i_clk = ~i_clk;
end

initial begin
    i_rst_n = 1'b0;
//    i_freq_step = 31'h19999999;
    i_freq_step = 10'b0010000100;

    @(negedge i_clk) i_rst_n = 1'b1;
end

initial #1000000 $finish;
  
endmodule
