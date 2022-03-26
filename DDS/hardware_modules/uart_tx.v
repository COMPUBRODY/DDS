module uart_tx(
        clk,
        baud_uart,
        d_in, 
        tx_send,
        enable_tx,
        txd,
        sending

);

input clk;          //general CLK
input [7:0] d_in;   // data byte from buffer
input baud_uart;     // clock from baudrate
input tx_send;      // Bit de Envio de trama   
input enable_tx;    // for enable tx module
output reg txd; // uart txd   -----------------------> salida principal TX
output reg sending; // sending a txd bit   ---------------> Salida indicador Led

reg load_t_buffer;          // load t_buffer         ---> este habilitador seria de confirmacion del controlador de registros para avisar que hay un dato listo
reg [3:0] no_bits_sent;     //
reg [7:0] t_buffer;         // esto va conectado al controlador de registros directamente 
reg [7:0] t_data;           // datos que manda a la transmision
reg t_empty;

//reg data_dummy = 4'h30;     //dato dummy un 0 decimal tabla ascii es un 48 binario es un 0011 0000

// load data to t_data, then to t_buffer, and generate sending signal
always @ (posedge clk) begin
    if (!enable_tx) begin               // disabling tx
        sending <= 0;                   // clear sending
        t_empty <= 1;                   // transmitter is clean an ready
        load_t_buffer <= 0;             // clear load_t_buffer
        t_data    <= 0;                 // clear t_data
        t_buffer    <= 0;               // clear t_buffer

    end 
	 else begin
        if (!tx_send) begin         // if not button tx press
        //t_data <= d_in;           // load t_data from data dummy
        t_empty <= 0;               // empty tx flag
        load_t_buffer <= 1;         // ready to load t_buffer
        end 
        else begin

            if (!sending) begin
            // not sending
            if (load_t_buffer) begin             // if data ready
                sending <= 1;                    // sending flag
                t_buffer <= d_in;               // load t_buffer from registers directtly
                t_empty <= 1;                    // transmitter is ready
                load_t_buffer <= 0;              // clear load_t_buffer
                end
            end 
            else begin
            // sending  
                if (no_bits_sent == 4'd11)       // sent a frame
                    sending <= 0;                // clear sending
                end
        end
    end
end 

// send a frame: [start, d0, d1, ..., d7, parity, stop]
// clock for sending txd
always @ (posedge clk) begin
    if (!tx_send) begin    // if not sending button
        no_bits_sent <= 4'd0;    // clear counter
        txd <= 1;    // stop bits
    end 
    // if press sending key or botton 
	 else begin    // sending
        //sending <= 1;
        case (no_bits_sent)                   // sending serially
            0: txd <= 0;                      // sending start bit
            1: txd <= t_buffer[0];            // sending data bit 0
            2: txd <= t_buffer[1];            // sending data bit 1
            3: txd <= t_buffer[2];            // sending data bit 2
            4: txd <= t_buffer[3];            // sending data bit 3
            5: txd <= t_buffer[4];            // sending data bit 4
            6: txd <= t_buffer[5];            // sending data bit 5
            7: txd <= t_buffer[6];            // sending data bit 6
            8: txd <= t_buffer[7];            // sending data bit 7
            9: txd <= 4'h0;              // sending parity (even)    exclusive t_buffer
            default: txd <= 1;                // sending stop bit(s)
        endcase
        no_bits_sent <= no_bits_sent + 4'd1;    // counter++
    end
end

endmodule



