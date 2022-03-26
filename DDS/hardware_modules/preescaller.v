`timescale 10ns / 100ps

//`define SOURCE_CLK  50000000
//`define SCALE_CLK  50000000
module preescaller#(parameter CLK , parameter SCALE  )(
	input clock,
	input enable,
	output slow_clock

);
    //localparam Freq_in      = 50000000;
    //localparam Parts_div    = 20; 
    localparam [31:0] MAX_SIZE = CLK/(SCALE*16) ;    //Señal Resultante )Maxima Freq 2.5mhz, 4nS
	//parameter COUNTER_SIZE = MAX_SIZE;
	//parameter COUNTER_MAX_COUNT = (2 ** COUNTER_SIZE) - 1;
    parameter COUNTER_MAX_COUNT = (2 ** MAX_SIZE) - 1;
	
	reg [31:0] count;
	
	
	initial	count 		=	0;
	//initial	slow_clock	=	0;
	
    always @(posedge clock)
        if(enable)
        begin
            count = count + 1;
            if(count == COUNTER_MAX_COUNT) 
            begin
                count = 0;
                //slow_clock = 1;
            end
            if(count == 1)
            begin
                #100 count = 0;  //para que solo realice el pulso y tengo un dutty cycle de menor 10% ?? 
            end
	    end
	
    assign slow_clock = (count ==  0 ) ? 1'b1 : 1'b0;
	
endmodule




/*


    //  Clock Generation
    always  @(posedge   clkin)  begin

        oclkreg =   oclkreg + 1;
        iclkreg =   iclkreg + 1;
        fork                                // procesos en paralelo
            if (ocklreg >= divisor) begin

                ocklreg     =   0;
                xmt_clock   =   1;
                clko        =   1;
                #1
                clko        =   0;
                xmt_clock   =   0;
                
            end
            if (iclkreg >= divisor) begin

                iclkreg     =   0;
                rcv_clock  =   1;
                #1
                rcv_clock  =   0;
                                
            end
        join

    end


el join tiene que ver con pedos de replicar cuantas veces el modulo, para paralelismo tengo entendido

*/