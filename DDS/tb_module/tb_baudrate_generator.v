`timescale 10ns / 100ps

module tb_baudrate_generator();

    reg clock;
    reg [2:0] baudrate_sel;
    wire uart_enable;

    always #1 clock = ~clock;

    baudrate_generator     tb_baudrate_generator_DUT(
                .clock  (clock),
                .baudrate_sel (baudrate_sel),
                .uart_enable (uart_enable)

    );

    initial
        begin

            clock   =   0;
            baudrate_sel  = 1;
            #1000
            baudrate_sel  = 2;
            #1000
            baudrate_sel  = 4;
            #1000
            baudrate_sel  = 0;
            #1000
            $display    ("Simulation for Baudrate Generator Finished");
            $stop;
        end
        


endmodule