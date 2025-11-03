module lfsr_7 (
    input   logic       clk,
    input   logic       rst,
    input   logic       en,
    output  logic [6:0] data_out
);

    
    logic [6:0] sreg;
    logic feedback;

    assign feedback = sreg[2] ^ sreg[6];

    always_ff@(posedge clk, posedge rst)
        if(rst)
            sreg <= 7'b0000001;
        else if (en)
            sreg <= {sreg[5:0], feedback};
    
    assign data_out = sreg;

endmodule
