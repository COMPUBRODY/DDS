// 4-State Mealy state machine

// A Mealy machine has outputs that depend on both the state and 
// the inputs.  When the inputs change, the outputs are updated
// immediately, without waiting for a clock edge.  The outputs
// can be written more than once per state or per clock cycle.

module four_state_mealy_state_machine
(
	input	clk, in, reset,
	output reg [1:0] out
);

	// Declare state register
	reg		[1:0]state;

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

	// Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or posedge reset) begin
		if (reset)
			state <= S0;
		else
			case (state)
				S0:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end
				S1:
					if (in)
					begin
						state <= S2;
					end
					else
					begin
						state <= S1;
					end
				S2:
					if (in)
					begin
						state <= S3;
					end
					else
					begin
						state <= S1;
					end
				S3:
					if (in)
					begin
						state <= S2;
					end
					else
					begin
						state <= S3;
					end
			endcase
	end

	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (state or in)
	begin
			case (state)
				S0:
					if (in)
					begin
						out = 2'b00;
					end
					else
					begin
						out = 2'b10;
					end
				S1:
					if (in)
					begin
						out = 2'b01;
					end
					else
					begin
						out = 2'b00;
					end
				S2:
					if (in)
					begin
						out = 2'b10;
					end
					else
					begin
						out = 2'b01;
					end
				S3:
					if (in)
					begin
						out = 2'b11;
					end
					else
					begin
						out = 2'b00;
					end
			endcase
	end

endmodule
