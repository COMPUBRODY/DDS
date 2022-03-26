`timescale 10ns / 100ps

module  tb_uart_tx();

reg     clock;
reg     enable;
reg     uart_rate; 
reg     [7:0] d_in; 
reg     tx_send;

wire    txd;
wire    sending;

always #1 clock = ~clock;

uart_tx     tb_uart_tx_DUT(
    //INPUTS
    .clk        (clock),
    .baud_uart  (uart_rate),
    .d_in       (d_in),
    .tx_send    (tx_send),
    .enable_tx   (enable),
    //OUTPUTS
    .txd        (txd),
    .sending    (sending)
    
);

initial
    begin

        clock   =   0;
        enable  =   1;
        d_in    =   7'b00000000;
        #100
        enable  =   0;
        tx_send =   1;
        d_in    =   7'b1110000;         //frame data
        uart_rate = 1;
        #100
        enable  =   1;
        #1000


        $display    ("Simulation for TX Transmitter Finished");
        $stop;
    end



endmodule

/*
=============================
HOW TO SEND A FRAME
===========================

=============================
TEST CASES
===========================

===========================
SENDING A FRAME
===========================

===========================
LOAD DATA
===========================

===========================
GENERATE SENDING SIGNAL
===========================
*/


