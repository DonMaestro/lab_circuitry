module clock_my(CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

parameter       DIV_CONST = 50_000_000;
//parameter       DIV_CONST_2 = 200_000;
parameter	Start_clock = 24'b00000010_00110000_00000000;
//parameter	Start_clock = 24'h;

input           CLOCK_50;
input   [1:0]   KEY;
output  [6:0]   HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

wire	[3:0]   sec0, sec1, min0, min1, hour0, hour1;  
wire            sec0_to_sec1, sec1_to_min0, min0_to_min1, min1_to_hour0, hour0_to_hour1;
wire            tick_1hz;

//wire		tick_250hz;
//reg		tick;

wire sys_clk    = CLOCK_50;
//wire speed_n	= KEY[0];
wire sys_rst_n  = KEY[1];
wire clr_hrs    = (8'h24 == {hour1, hour0}); 




//always @(negedge sys_rst_n)
//	if(!sys_rst_n)
//		{hour1, hour0, min1, min0, sec1, sec0} <= Start_clock;


//assign tick = (!speed_n) ? tick_250hz : tick_1hz ;

//always @(posedge sys_clk, negedge speed_n) begin
//	if(!speed_n)
//		tick <= tick_250hz;
//	else
//		tick <= tick_1hz;
//end




// Creating 1 Hz reference signal

counter_my #(.MAX_VAL(DIV_CONST-1), .WIDTH(26) ) freq_div(.i_clk (sys_clk), 
                                                        .i_rst_n (sys_rst_n), 
						.i_initial_v (26'b0),
                                                        .i_srst (1'b0),
                                                        .i_cnt_en (1'b1), 
                                                        .o_data (),
                                                        .o_tick (tick_1hz)
                                                       );

//counter #(.MAX_VAL(DIV_CONST_2-1), .WIDTH(26) ) freq_2_div(.i_clk (sys_clk), 
//                                                        .i_rst_n (sys_rst_n), 
//                                                        .i_srst (1'b0),
//                                                        .i_cnt_en (1'b1), 
//                                                        .o_data (),
//                                                        .o_tick (tick_250hz)
//                                                       );


// Counters for secs, mins, hours

counter_my #(.MAX_VAL(9), .WIDTH(4) ) sec_0(.i_clk (sys_clk), 
                                          .i_rst_n (sys_rst_n), 
					  .i_initial_v (Start_clock[3:0]),
                                          .i_srst (1'b0),
                                          .i_cnt_en (tick_1hz), 
                                          .o_data (sec0),
                                          .o_tick (sec0_to_sec1)
                                        );

counter_my #(.MAX_VAL(5), .WIDTH(4) ) sec_1(.i_clk (sys_clk), 
                                          .i_rst_n (sys_rst_n), 
					  .i_initial_v (Start_clock[7:4]),
                                          .i_srst (1'b0),
                                          .i_cnt_en (sec0_to_sec1),
                                          .o_data(sec1), 
                                          .o_tick (sec1_to_min0)
                                        );

counter_my #(.MAX_VAL(9), .WIDTH(4) ) min_0(.i_clk (sys_clk), 
                                          .i_rst_n (sys_rst_n), 
					  .i_initial_v (Start_clock[11:8]),
                                          .i_srst (1'b0),
                                          .i_cnt_en (sec1_to_min0), 
                                          .o_data(min0),
                                          .o_tick (min0_to_min1)
                                        );

counter_my #(.MAX_VAL(5), .WIDTH(4) ) min_1(.i_clk (sys_clk), 
                                          .i_rst_n (sys_rst_n), 
					  .i_initial_v (Start_clock[15:12]),
                                          .i_srst (1'b0),
                                          .i_cnt_en (min0_to_min1), 
                                          .o_data(min1),
                                          .o_tick (min1_to_hour0)
                                        );

counter_my #(.MAX_VAL(9), .WIDTH(4) ) hour_0(.i_clk (sys_clk), 
                                          .i_rst_n (sys_rst_n), 
					  .i_initial_v (Start_clock[19:16]),
                                          .i_srst (clr_hrs),
                                          .i_cnt_en (min1_to_hour0), 
                                          .o_data(hour0),
                                          .o_tick (hour0_to_hour1)
                                        );

counter_my #(.MAX_VAL(5), .WIDTH(4) ) hour_1(.i_clk (sys_clk), 
                                          .i_rst_n (sys_rst_n), 
					  .i_initial_v (Start_clock[23:20]),
                                          .i_srst (clr_hrs),
                                          .i_cnt_en (hour0_to_hour1), 
                                          .o_data(hour1),
                                          .o_tick ()
                                        );

// Decoding secs, mins, hours from bin to 7-seg control signals

dec_7seg    dec_sec_0(.i_dat (sec0), 
                      .o_seg (HEX0)
                      );

dec_7seg    dec_sec_1(.i_dat (sec1), 
                      .o_seg (HEX1)
                      );

dec_7seg    dec_min_0(.i_dat (min0), 
                      .o_seg (HEX2)
                      );

dec_7seg    dec_min_1(.i_dat (min1), 
                      .o_seg (HEX3)
                      );

dec_7seg    dec_hour_0(.i_dat (hour0), 
                      .o_seg (HEX4)
                      );

dec_7seg    dec_hour_1(.i_dat (hour1), 
                      .o_seg (HEX5)
                      );

endmodule

