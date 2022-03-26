`timescale 1ns / 10ps
module tb_display_7seg();

	reg 	[3:0]	bcd;
	wire 	[6:0]	segment;

	display_7seg	tb_display_7seg_DUT(		.num	(bcd),
														.seg	(segment)
														);
	
		initial
			begin
				#1	bcd = 4'h0;
				#1	bcd = 4'h1;
				#1	bcd = 4'h2;
				#1	bcd = 4'h3;
				#1	bcd = 4'h4;
				#1	bcd = 4'h5;
				#1	bcd = 4'h6;
				#1	bcd = 4'h7;
				#1	bcd = 4'h8;
				#1	bcd = 4'h9;
				#1	bcd = 4'ha;
				#1	bcd = 4'hb;
				#1	bcd = 4'hc;
				#1	bcd = 4'hd;
				#1	bcd = 4'he;
				#1	bcd = 4'hf;
				
				$display("Simulation in display_7seg Finished!");
				$stop;
				
			end
		
				
	

endmodule
