`timescale 10ns / 100ps

module tb_debouncer();

reg clk;
reg btn;

//wire	b_out_down;
//wire	b_out_up;
wire 	b_state;

always #1 clk = ~clk;

debouncer	debouncer_DUT(
				.clk		(clk),
				.PB			(btn),
				.PB_state	(b_state)
				//.PB_down		(b_out_down),
				//.PB_up		(b_out_up)
			);
			
initial

	begin
		
		clk		=	0;
		#10	btn	=	1;
		#10	btn	=	0;
		#10	btn	=	1;
		#10	btn	=	0;
		#10	btn	=	1;


		$display("Simulation Finished Correctly");

		$stop;

	end

endmodule