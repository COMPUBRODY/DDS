`include "../config_files/config.v"

module dds(

    input src_clk,
    input set_phase,
    input [8:0] phase,
    input set_freq,
    input [31:0] freq,
    input [(`DATA_LEN-1):0] data_wr,
    input [(`ROWS_BASE_2-1):0] addr_wr,
    input we,
    output reg [7:0]sinwave
	 
);

//DDS USE
reg wave_ena;
initial wave_ena=1'b1;

// Prescaler
wire en_clk = 1'b1;
wire wave_clk_en;

//MEMORY
wire [(`DATA_LEN-1):0]data_rd;

wire [(`ROWS_BASE_2-1):0] read_dir; // use to get the module initial dir
reg [(`ROWS_BASE_2-1):0] addr_rd;

wire [(`ROWS_BASE_2-1):0] addr = we?addr_wr:addr_rd;
reg read_mem;
initial read_mem = 1'b0;


//FSM
reg trigger;
reg [1:0]state_sel;
wire memdir;
wire data_pol;


// Declare states
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
// State variables
parameter FORWARD = 1'b0,BACKWARD = 1'b1;
parameter POL_POS = 1'b0,POL_NEG  = 1'b1;

//PHASE
reg [9:0] phase_indx;
initial phase_indx = 10'd0;
reg fts;

/***************************************
************ MODULES *****************
***************************************/

wire [31:0]freq_div = freq*32'd 1456;

preescaller #(.DIV(`MHZ(5))) wave_clk 
(   .src_clk(src_clk),
    .en(en_clk),
    .set_div(set_freq),<a
    .div(freq_div),
    .clk_div(wave_clk_en)
);

FSM fsm
(
    .src_clk(src_clk),
    .set_phase(fts),
    .trigger(trigger),
    .state_sel(state_sel),
	.memdir(memdir),
    .addr_rd(read_dir),
	.data_pol(data_pol)
);

Memory mem(
	.data(data_wr),
	.addr(addr),
	.we(we),
    .clk(src_clk),
	.q(data_rd)
);

wire tic_tac = wave_clk_en;
/***************************************
************ PHASE  ********************
***************************************/

always @(posedge src_clk) begin

    //PULSE to set phase, must be in read mode
    if(set_phase & !we)begin
        //first time setup
        fts = 1'b1;
        // disable waveform output
        wave_ena   = 1'b0; 
        // transform degree to discrete index form [0,360]->[0,1024]
        phase_indx = 2'd3*phase-phase/3'd6+phase/7'd90;

        // Chosse the state where the phase is
        if(phase_indx < 255) 
		  begin 
            state_sel  = S0;
            phase_indx = phase_indx-10'd0;
		  end
        else if (phase_indx >= 256 && phase_indx < 512) 
        begin
            state_sel = S1;
            phase_indx = phase_indx-10'd256;
        end
        else if (phase_indx >= 512 && phase_indx < 768) 
        begin
            state_sel = S2;
            phase_indx = phase_indx-10'd512;
        end
        else if (phase_indx >= 768 && phase_indx < 1024) 
        begin
            state_sel = S3;
            phase_indx = phase_indx-10'd768;
        end
        else begin
            state_sel = S0;
            phase_indx = phase_indx-10'd0;
        end
    end
    else if(!we)
        // set_phase pulse is over and decrement phase_indx until zero
        // once counter is 0 enable wave output.
        if(tic_tac) //stay sync with memory manager
        begin
            fts = 1'b0;
            if(phase_indx != 0)
                phase_indx = phase_indx-1'b1;
            else
                wave_ena = 1'b1;
        end
end

/***************************************
************ MEMORY MANAGER*************
***************************************/


reg [3:0] huffman;
initial huffman = 4'b0000;

//address movment depending on states outputs
//when we are looking the phase the signal output is disable and the tic_tac is the same as clk
always @(posedge src_clk) begin

    if(trigger  == 1'b1)
    begin
        trigger = 1'b0;
    end

    if(tic_tac & !we & !set_phase) 
    begin
        if(huffman == 4'b0) 
        begin
            // dont reach a condition limit 
            // diferent from first time setup
            if(!trigger & !fts) 
            begin
                if(memdir == FORWARD)
                begin 
                    addr_rd = addr_rd +1'b1;
                    if(addr_rd > (`MEMORY_HEIGHT-1)) begin 
                        trigger = 1'b1;
                    end
                end
                else if (memdir == BACKWARD) 
                begin
                    addr_rd = addr_rd - 1'b1;
                    if(addr_rd == 1'b0)
                        trigger = 1'b1; // triger will be catch next cycle
                end
            end
            else begin
                trigger  = 1'b0;
                addr_rd  = read_dir;
            end
            // send signal to read memory
            read_mem = 1'b1;
        end
        //decrement huffman
        else begin 
            read_mem = 1'b0;
            huffman  = huffman-1'b1;
        end
    end
    /***************************************
    ************ MEMORY READ  **************
    ***************************************/
    if(read_mem)
        huffman = data_rd[3:0];
        if(wave_ena) 
        begin 
            if(data_pol == POL_POS)
            begin
                sinwave = 7'h7F +(data_rd[10:4]); // 7F -> 127
            end
            else if(data_pol == POL_NEG) begin
                sinwave = 7'h7F-(data_rd[10:4]);
            end
        end
    else
        sinwave = 1'b0;
end

endmodule