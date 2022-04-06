`timescale 1ns / 10ps

module mem_read_file #(parameter M=3, N=4)(

    input   rd, wr,
    input   [M-1:0] addr,
    inout   [N-1:0] data

);
    reg     [N-1:0] mem [0:2**M-1];
    reg     [N-1:0] temp;
    assign data =   rd ? temp : 'bZ;
    always @(data, addr, rd,wr )
        begin
            if(wr)
                #4 mem[addr] = data;
            if (rd)
                #4  temp    =   'bZ;
            else
                #4  temp    =   'bZ;   

        end

    initial     $readmemh("../signal_source/SIGNAL.txt", mem);

    endmodule


