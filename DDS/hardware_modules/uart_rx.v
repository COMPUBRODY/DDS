module uart_rx (
                    clk,
                    baud_uart,
                    rxd,
                    enable_rx,
                    sampling,
                    r_data
                    
                    

); // uart receiver

input clk;                              //general CLK
input baud_uart;                        // clock for baudrate
input rxd;                              // uart rxd
input enable_rx;                        //for waiting a lecture

output reg [7:0] r_data;                // received data bits   
output reg sampling;                    // sampling an rxd bit

reg [3:0]   sampling_place;               // center of an rxd bit
reg rxd_new;                            // registered rxd
reg rxd_old;                            // registered rxd_new

reg [3:0]   no_bits_rcvd;          // # of bits received
reg [10:0]  r_buffer;             // 11-bit frame
reg r_ready;                     // receiver is ready
reg parity_error;                // parity check error
reg frame_error;                 // data frame error

/*===================================
DETECT FALLING EDGE
===================================*/
// latch 2 rxd bits for detecting a falling edge
    always @ (posedge clk) begin
        if (!enable_rx) begin
            rxd_old <= 1;               // stop bits
            rxd_new <= 1;               // stop bits
        end 
        else begin
            rxd_old <= rxd_new;         // shift registers
            rxd_new <= rxd;             // shift registers
        end
    end
/*===================================
START BIT DETECTOR
===================================*/
// detect start bit and generate sampling signal
//nyquist
    always @ (posedge clk) begin
        if (!enable_rx) begin
            sampling <= 0;                  // stop sampling
        end 
        else begin
            if (rxd_old && !rxd_new) begin                  // had a negative edge
                if (!sampling)                              // if not sampling yet
                    //sampling_place <= cnt16x + 4'd8;      // +8: center place
                    sampling_place <= baud_uart + 4'd8;    // +8: center place
                    sampling <= 1;                          // sampling please
            end 
            else begin
                if (no_bits_rcvd == 4'd11)           // got one frame
						sampling <= 0;              // stop sampling
            end
        end
    end

/*===================================
COUNTER BITS RECEIVED
===================================*/
// number of bits received
    always @ (posedge clk) begin
        if (!sampling) begin
            no_bits_rcvd <= 4'd0;    // clear counter
        end 
        else begin
            no_bits_rcvd <= no_bits_rcvd + 4'd1;    // counter++
            //r_buffer[no_bits_rcvd] <= rxd;    // save rxd to r_buffer -->ignorar de momento
            r_buffer[4'd10] <= rxd;             //11 bits in one frame
            
        end
    end

/*===================================
RECEPCION TRAMA LISTA
===================================*/
    // one frame, rdn clears r_ready
    always @ (posedge clk ) begin
        if (!enable_rx) begin            // on a reset
            r_ready       <= 0;          // clear ready
            parity_error  <= 0;          // clear parity error
            frame_error   <= 0;
            r_buffer      <= 0;
            r_data        <= 0;
        end 
        else begin
            
            if (no_bits_rcvd == 4'd11) begin            //d'11 porque serian 4'b1011  solo se pueden recibir de 5 a 8 bits, los otros 3 1 de paridad y otro de stop, 1 de error??? 
            //si hay 11 bits recibidos tenemos una trama
                r_data <= r_buffer[8:1];//la informacion de la trama pasa a r_data
                r_ready <= 1;//bandera de trama lista

                if ( ^r_buffer[9:1]) begin  //excluye todo bit del buffer 9:1 que no sea igual al anterior,
                //cada que el bit [9] sea distitnto hay un cambio de paridad 
                    parity_error <= 1;          
                end
                if (!r_buffer[10]) begin    //si se llega a un bit mayor a 10 se manda un error...si no son 10 bits transmitidos manda trama error.
                    frame_error <= 1;
                end
            end
        end
end
    //assign d_out = !rdn ? r_data : 8'hz;


//assert_always #(severity_level, property_type, msg, coverage_level)
    //instance_name(clk,reset,test_exp)
   // assert_always #(1,0, "Err:NON", 0)
     //   AA1 (clk, 1'b1, (cnt >= 0) && (cnt<= 9));
        
endmodule


