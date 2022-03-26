`timescale 10ns / 100ps
//`define size_counter 5


module clock_divider(
							fast_clock,
							rst,
							slow_clock
);

	input fast_clock;
	input rst;
	output slow_clock;
	
	
	
	parameter COUNTER_SIZE = 15;
	parameter COUNTER_MAX_COUNT = (2 ** COUNTER_SIZE) - 1;
	
	reg [COUNTER_SIZE-1:0] count;
	
	always @(posedge fast_clock)
	if(rst)
		begin
			count = count +1;
			if(count == COUNTER_MAX_COUNT)
				count = 0;
			if(count==1)
			begin
				count = 0;
			end
		end

	
	assign slow_clock = count[COUNTER_SIZE-1];
	
endmodule

