module full_duplex_uart(
							clock,
							enable_uart,
							reset_uart,// universal asynchronous	receiver transmitter               
							//RX I/O
                            rx_indicator,
                            r_data,
							enable_rx,
							rxd,
							//TX I/O
							d_in,
							enable_tx,
							tx_send,
                            txd,
                            tx_indicator
							
);


	// SIGNALS OF CLOCKS

	input clock;
	input reset_uart; // baud rate * 16 clock
	input enable_uart;

	// SIGNALS OF TRANSMITER

	input [7:0] d_in; // data byte from cpu
	input tx_send; //this enables the sending message from external trigger
	input enable_tx;
	output txd; // uart txd

	// SIGNALS OF RECEIVER
	input enable_rx;
	input rxd;
	output [7:0] r_data; // received data bits
	output rx_indicator; // sampling an rxd bit
	output tx_indicator; // sending a txd bit
	
	wire rx_led;
	wire tx_led;

	// receiver
	uart_rx recver (
							.clk		(clock),
							.baud_uart 	(enable_uart),
							.rxd		(rxd),  
							.r_data		(r_data), 
							.sampling  	(rx_led),
							.enable_rx 	(enable_rx)
	);

	assign rx_indicator = (rx_led | rxd) ? 1'b1 : 1'b0 ;
		/*always @(posedge enable_rx or negedge rxd or posedge rx_indicator)
			begin
				rx_indicator = 1;
				#50
				rx_indicator = 0;
			end
*/
	

	// transmitter
	uart_tx sender (
							.clk		(clock),
							.baud_uart	(enable_uart),
							.d_in		(d_in), 
							.txd		(txd), 
							.sending	(tx_led), 
							.tx_send	(tx_send),
							.enable_tx	(enable_tx)
							
	);
	
	
	assign tx_indicator = (tx_led | txd) ? 1'b1 : 1'b0 ;
		/*always @(posedge enable_tx or negedge txd or posedge tx_indicator)
			begin
				tx_indicator = 1;
				#50
				tx_indicator = 0;
			end*/


endmodule

