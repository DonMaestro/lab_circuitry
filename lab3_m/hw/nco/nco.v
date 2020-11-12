module nco(CLOCK_50, KEY, SW, VGA_R, GPIO_0);

input           CLOCK_50;
input   [1:0]   KEY;
input   [9:0]   SW;
output  [9:0]   VGA_R;
output		GPIO_0;			//output 

reg     [9:0]   sin_table_rom[1023:0];
reg     [31:0]  phase;
reg     [9:0]   dac_data;
reg     [31:0]  freq_step;

reg     [9:0]   cnt_ff;			//add

wire    sys_clk     = CLOCK_50;
wire    sys_rst_n   = KEY[1];
//wire    preload_cnt = ~|cnt_ff;		// check at 00 0000 0000 address
wire    preload_cnt = &cnt_ff;

assign  VGA_R = dac_data; 
assign  GPIO_0 = preload_cnt;   	//add
assign	cnt_ff = phase[31:22];

initial $readmemh("hw/nco/sin_table_8bit.hex", sin_table_rom);

always @(posedge sys_clk)
    dac_data <= sin_table_rom[phase[31:22]];

always @(posedge sys_clk, negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        freq_step <= 0;
    end else begin
        freq_step <= {14'd0, SW, 8'd0};   //for simplicity here we dont use synchronization
    end
end

always @(posedge sys_clk, negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        phase <= 0;
    end else begin
        phase <= phase + freq_step;
    end
end

endmodule

