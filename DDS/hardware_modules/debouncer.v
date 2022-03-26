module debouncer(
    input clk,
    input PB,  // "PB" is the glitchy, asynchronous to clk, active low push-button signal

    output reg PB_state  // 1 as long as the push-button is active (down)

);


wire slow_clk;
wire en = 1'b1;
reg [7:0]debouncer_cnt;

reg inter_PB;

initial PB_state = 1'b0;
initial debouncer_cnt =  7'h00;

preescaller #(.CLK(50000000),.SCALE(1000)) u1(
                        .clock      (clk),
                        .enable     (en),
                        .slow_clock (slow_clk)
);


always @(posedge clk) 
    begin
        if (PB) 
            begin
					
				inter_PB = PB;
					
					/*
                if(debouncer_cnt == 40) begin //40 ms DEBOUNCE
                    PB_state = 1'b1;
                end
                if(debouncer_cnt  > 60) // 20 ms ON HIGH
                begin
                    PB_state =1'b0;  
                end
                else
                    debouncer_cnt=debouncer_cnt+1'b1;
                    PB_state = 1'b0;
						  */
            end
        else
            debouncer_cnt = 4'b0000;
    end
    

endmodule
