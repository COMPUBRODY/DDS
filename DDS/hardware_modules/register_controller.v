module register_controller(
			//INPUTS
			clock,
			rx_in,
			see_bauds,
			baudrate_sel,
			//OUTPUS
			tx_out,
			Byte_0,
			Byte_1,
			Byte_2,
			Byte_3,
			Byte_4,
			Byte_5
			
);

input clock;
input [7:0] rx_in;
input see_bauds;
input [1:0] baudrate_sel;

output reg [7:0] tx_out;
output reg [3:0] Byte_0;
output reg [3:0] Byte_1;
output reg [3:0] Byte_2;
output reg [3:0] Byte_3;
output reg [3:0] Byte_4;
output reg [3:0] Byte_5;

reg [7:0] 	t_buffer;
reg [7:0]	r_buffer;
reg [23:0]	displays;


initial r_buffer	= 	8'b00000011;
initial t_buffer 	= 	8'h30; //8'b00110000;       //dato dummy un 0 decimal tabla ascii es un 48 binario es un 
initial displays	=	24'hfedcb2;


always @(posedge clock) begin
	
	r_buffer <= rx_in;
	tx_out <= t_buffer;
	Byte_0 <= displays[3:0];
	Byte_1 <= displays[7:4];
	Byte_2 <= displays[11:8];
	Byte_3 <= displays[15:12];
	Byte_4 <= displays[19:16];
	Byte_5 <= displays[23:20];

end
// necesito un enable que se active al presionar el boton junto con el envio despues de unos segundos

always @(posedge clock)	begin
	if (!see_bauds) 
	begin
		if (baudrate_sel == 2'b01 )
			displays	=	24'h009600;
		if (baudrate_sel == 2'b10 )
			displays	=	24'h057600;
		if (baudrate_sel == 2'b11 )
			displays	=	24'h115200;
		if (baudrate_sel == 2'b00 )
			displays	=	24'h100000;
	end

end



/*
assign Byte_0 = 4'b0001;
assign Byte_1 = 4'b0010;
assign tx_out = 7'b00000011;
*/

endmodule
