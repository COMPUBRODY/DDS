`timescale 10ns / 100ps

module  tb_full_duplex_uart();

	// SIGNALS OF CLOCKS

	reg clock;
	reg reset_uart; // baud rate * 16 clock
	reg enable_uart;

	// SIGNALS OF TRANSMITER

	reg [7:0] d_in; // data byte from cpu
	reg tx_send; //this enables the sending message from external trigger
	reg enable_tx;
	wire txd; // uart txd

	// SIGNALS OF RECEIVER
	reg enable_rx;
	reg rxd;
	wire [7:0] r_data; // received data bits
	wire rx_indicator; // sampling an rxd bit
	wire tx_indicator; // sending a txd bit

always #1 clock = ~clock;

full_duplex_uart    tb_full_duplex_uart_DUT(
                            .clock          (clock),
							.enable_uart    (enable_uart),
							.reset_uart     (reset_uart),
							//RX I/O
                            .rx_indicator   (rx_indicator),
                            .r_data         (r_data),
							.enable_rx      (enable_rx),
							.rxd            (rxd),
							//TX I/O
							.d_in           (d_in),
							.enable_tx      (enable_tx),
							.tx_send        (tx_send),
                            .txd            (txd),
                            .tx_indicator   (tx_indicator)

);

initial
        begin
            clock       =   0;
            reset_uart  =   0;
            enable_uart =   0;
            enable_rx   =   0;
            enable_tx   =   0;
            tx_send     =   0;
            #100
            /*=====================================
                        CASO DE PRUEBA TX
            =======================================*/
            enable_tx = 1;
            reset_uart  =   1;
            enable_uart =   1;
            #10
            reset_uart  =   0;
            /*=======================================*/
            #100
            tx_send = 1;
            #100
            tx_send = 0;
            #100
            d_in <= 8'b00001111;
            #100
            tx_send = 1;
            #100
            tx_send = 0;

            /*=====================================
                        CASO DE PRUEBA RX
            =======================================*/
            enable_tx   =   0;
            enable_rx   =   1;
            reset_uart  =   1;
            enable_uart =   1;
            #10
            reset_uart  =   0;
            /*=======================================*/
            #100
            rxd         =   1;
            #10
            rxd         =   0;
            #30         
            rxd         =   1;
            #5
            rxd         =   0;
            #80
            rxd         =   1;
            #10
            rxd         =   0;
            #300 

            $display    ("Simulation for Full duplex Uart Finished");
            $stop;

        end

endmodule