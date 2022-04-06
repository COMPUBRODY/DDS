//`define <name> <macro_text>
//`define <name>(<args>) <macro_text>

// SystemVerilog supports three special strings in the macro text.  The
// first two strings allow you to construct string literals from macro
// arguments.  The third string allows you to construct identifiers
// from macro arguments.
// 
//     `"            -->          Include " character in macro expansion
//     `\`"          -->          Include \" in macro expansion
//     ``            -->          Delimits without introducing white space

// Example(s)
//`define msg(type, text)   `"type: `\`"text`\`"`"
//`msg(warning, undefined macro) returns "warning: \"undefined macro\""

//`define make_name(prefix, base, suffix) prefix``base``suffix
//`make_name(altera_, tmp, _variable) returns altera_tmp_variable

`define MHZ(freq) freq*1000000
`define PRESCALE_CNT(ref_clk,freq) (ref_clk/freq)

//CLOCKS
`define SOURCE_CLK `MHZ(50)
`define Output_frequency `MHZ(5)

//MEMORY
`define DATA_LEN 11
`define MEMORY_HEIGHT 109
`define ROWS_BASE_2 7 //2^7
`define NULL 0 

