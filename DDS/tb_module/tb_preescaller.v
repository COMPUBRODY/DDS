`timescale 1ns / 10ps

module tb_preescaller();

    reg clock;
    reg enable;
    wire slow_clock;

    always #1 clock = ~clock;

    preescaller     tb_preescaller_DUT(
                .clock  (clock),
                .enable (enable),
                .slow_clock (slow_clock)

    );

    initial
        begin

            clock   =   0;
            enable  =   1;
            #100
            $display    ("Simulation for Preescaller Finished");
            $stop;
        end
        


endmodule