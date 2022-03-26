`timescale 1ns / 10ps
module tb_displays_controller();

reg     [15:0]  inputs;
wire    [6:0]   segment1, segment2, segment3, segment4;
integer i;

displays_controller     tb_displays_controller_DUT(
          .num  (inputs),
        .seg0   (segment1),
        .seg1   (segment2),
        .seg2   (segment3),
        .seg3   (segment4)

);

    initial

        begin
            $monitor(inputs);
            #1	inputs = 4'h0;
		for( i=0;    i<10; i=i+1) begin
				$display("current loop#%0d ", i);
        end

        $display("Simulation in tb_displays_controller Finished!");
        $stop;
				

        end



endmodule
