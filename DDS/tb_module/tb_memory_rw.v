`timescale 1ns / 10ps

module  tb_memory_rw();


reg src_clk;
reg set_phase;
reg [8:0] phase;
reg set_freq;
reg [31:0] freq;
reg [(`DATA_LEN-1):0] data_wr;
reg [(`ROWS_BASE_2-1):0] addr_wr;
reg we;
wire [7:0] sinwave;

always #1 src_clk=~src_clk;

DDS dds_dut(
    .src_clk(src_clk),
    .set_phase(set_phase),
    .phase(phase),
    .set_freq(set_freq),
    .freq(freq),
    .data_wr(data_wr),
    .addr_wr(addr_wr),
    .we(we),
    .sinwave(sinwave)
);

integer data_file    ; // file handler
integer scan_file    ; // file handler
integer i;
reg [(`DATA_LEN-1):0] captured_data;



initial begin
        //Set initial values to variables
    src_clk   = 1'b0;
    set_phase = 1'b0;
    set_freq  = 1'b0;
    freq      = 1'b0;
    phase     = 0;
    data_wr   = 0;
    addr_wr   = 0;
    we        = 0;
    
    
//  LEER ARCHIVO DE SEÑAL Y MANDARLO A LA MEMORIA RAM
  
    //write memory
    we = 1'b1;
    data_file = $fopen("../signal_source/SIGNAL.txt", "r");
    if (data_file == 0) 
    begin
        $display("data_file handle was NULL");
        $finish;
    end
    while(!$feof(data_file)) 
    begin
        scan_file = $fscanf(data_file, "%d\n", captured_data); 
        $display("val = %d",captured_data);
        data_wr = captured_data;
        #4
        addr_wr = addr_wr+1;
    end

//  PRUEBAS DE ESTADOS DE AUTOMATA
    // set phase 
    #4
    we = 1'b0;
    set_phase = 1'b1;
    phase = 45;
    #2
    set_phase = 1'b0;
    #10
//  EMISION DE SEÑAL CAPTURADA
    //set frecuency, this test uses Chirp function
    for (i=500; i < 6500; i=i+100) 
    begin
        //set frecuency
        set_freq = 1;
        freq = i; //1khz
        #4;
        set_freq = 0;
        #(`MHZ(100)/i); // delay
    end
    
  $stop; 
end


endmodule
