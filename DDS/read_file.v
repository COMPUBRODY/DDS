// ("file_name", memory_name [, start_addr [, end_addr]]);
// ("file_name", memory_name [, start_addr [, end_addr]]);
//
// File Format:
// 
// The text file can contain Verilog whitespace characters, comments,
// and binary ($readmemb) or hexadecimal ($readmemh) data values.  Both
// types of data values can contain x or X, z or Z, and the underscore
// character.
// 
// The data values are assigned to memory words from left to right,
// beginning at start_addr or the left array bound (the default).  The
// next address to load may be specified in the file itself using @hhhhhh, 
// where h is a hexadecimal character.  Spaces between the @ and the address 
// character are not allowed.  It shall be an error if there are too many 
// words in the file or if an address is outside the bounds of the array.
//
// Example:
//
// reg [7:0] ram[0:2];
// 
// initial
// begin
//     $readmemb("init.txt", rom);
// end
//
// <init.txt>
//
// 11110000      // Loads at address 0 by default
// 10101111   
// @2 00001111   
