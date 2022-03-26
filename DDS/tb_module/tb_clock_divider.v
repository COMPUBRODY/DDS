`timescale 10ns / 100ps

module tb_clock_divider();

    reg clk, rst;
    wire[9:0] slow;

    always #1 clk = ~clk;
    
    clock_divider   tb_clock_divider_DUT(       .fast_clock (clk),
                                                .rst        (rst),
												.slow_clock (slow)
    );    

 
    initial

        begin
            $display("Repeat");

            clk     =   1'b0;
           rst      =   1'b1;
           #50;
           rst      =   1'b0;
           #10;
           $stop;
        end

        initial repeat  (2)   #100 rst = ~rst;
       
    //$display("Simulation in clock_divider Finished!");
	


endmodule
