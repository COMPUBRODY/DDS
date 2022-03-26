`timescale 1ns / 10ps
module tb_register_controller();


reg clock;
reg [7:0] rx_in;

wire [7:0] tx_out;
wire [3:0] Byte_0;
wire [3:0] Byte_1;
wire [3:0] Byte_2;
wire [3:0] Byte_3;
wire [3:0] Byte_4;
wire [3:0] Byte_5;

always #1 clock = ~clock;

register_controller	tb_register_Controller_DUT(
			//INPUTS
			.clock	(clock),
			.rx_in	(rx_in),
			//OUTPUS
			.tx_out	(tx_out),
			.Byte_0	(Byte_0),
			.Byte_1	(Byte_1),
			.Byte_2	(Byte_2),
			.Byte_3	(Byte_3),
			.Byte_4	(Byte_4),
			.Byte_5	(Byte_5)
);

initial
	begin
		clock   =   0;
		#100
		rx_in		= 7'b00000011;
		$display("Register Module Test Bench Finialized");
		$stop;
		
	end


endmodule

