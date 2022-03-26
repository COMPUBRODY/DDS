/*
'define SOURCE_CLK  50000000
'define BAUD_9600       9600
'define BAUD_57600      57600
'define BAUD_115200     115200
*/
module baudrate_generator(
	input clock,
	input [1:0] baudrate_sel,
	output reg uart_enable

);

reg [2:0] enable_bauds;


wire output_9600;
wire output_57600;
wire output_115200;

//initial	uart_enable	=	0;

preescaller#(.CLK (50000000), .SCALE (9600))     p_scaler_9600(
                        .clock      (clock),
                        .enable     (enable_bauds[0]),
                        .slow_clock (output_9600)
);

preescaller#(.CLK (50000000), .SCALE (57600))     p_scaler_57600(
                        .clock  (clock),
                        .enable  (enable_bauds[1]),
                        .slow_clock (output_57600)
                      
);

preescaller#(.CLK (50000000), .SCALE (115200))     p_scaler_115200(
                        .clock  (clock),
                        .enable  (enable_bauds[2]),
                        .slow_clock (output_115200)
                      
);

//falta un multiplexor 

always @(posedge clock) //@(baudrate_sel)
    begin
        case( baudrate_sel )

            2'b01   : begin
                        enable_bauds = 3'b001;
                        //uart_enable <= output_bauds[0];
                        uart_enable = output_9600;
                    end
            
            2'b10 : begin
                        enable_bauds = 3'b010;
                        //uart_enable <= output_bauds[1];
                        uart_enable = output_57600;
                    end
            2'b11 : begin
                        enable_bauds = 3'b100;
                        //uart_enable <= output_bauds[2];
                        uart_enable = output_115200;
                    end
            default : begin
                        enable_bauds <= 3'b000;
                        //uart_enable <= output_bauds[0];
                        uart_enable = 0;
                       
                    end
			endcase
						 

    end
//assign uart_enable = output_9600;

/*assign enable_9600      = (baudrate_sel ==  2'b01 ) ? 1'b1 : 1'b0;
assign enable_57600     = (baudrate_sel ==  2'b10 ) ? 1'b1 : 1'b0;
assign enable_115200    = (baudrate_sel ==  2'b11 ) ? 1'b1 : 1'b0;
*/

endmodule
