module lfsr_8 (
    input   logic       clk,
    input   logic       rst,
    input   logic       en,
    output  logic [7:0] data_out
);

    
    logic [7:0] sreg;
    logic feedback;

    assign feedback = sreg[1] ^ sreg[2] ^ sreg[3] ^ sreg[7];

    always_ff@(posedge clk, posedge rst)
        if(rst)
            sreg <= 8'b1;
        else if (en)
            sreg <= {sreg[6:0], feedback};
    
    assign data_out = sreg;

endmodule
