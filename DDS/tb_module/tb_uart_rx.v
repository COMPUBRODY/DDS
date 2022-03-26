`timescale 10ns / 100ps

module tb_uart_rx ();

reg clk;          //general CLK
reg baud_uart; // clock for baudrate
reg rxd;                              // uart rxd
reg enable_rx;                        //for waiting a lecture

wire [7:0] r_data;                // received data bits   
wire sampling;                    // sampling an rxd bit


always #1 clk = ~clk;

uart_rx tb_uart_rx_DUT(
                    .clk        (clk),
                    .baud_uart  (baud_uart),
                    .rxd        (rxd),
                    .r_data     (r_data),
                    .sampling   (sampling),
                    .enable_rx  (enable_rx)

);

initial
    begin

        clk         =   0;
        enable_rx   =   0;
        baud_uart   =   0;
        #10
        enable_rx   =   1;
        baud_uart   =   1;
        /*=======================================*/
        #100
        rxd         =   1;
        #5
        rxd         =   0;
        #20         
        rxd         =   1;
        #5
        rxd         =   0;
        #50
        rxd         =   1;
        #10
        rxd         =   0;
        #300 


        $display    ("Simulation for RX Reciver Finished");
        $stop;
    end

/*
=============================
HOW TO READ A FRAME
===========================
==================================
TEST FRAME
==================================

==================================
NUMBER OF BITS COUNTER
==================================

==================================
TEST STATES
==================================

==================================
TEST FALLING EDGE
==================================
*/

endmodule