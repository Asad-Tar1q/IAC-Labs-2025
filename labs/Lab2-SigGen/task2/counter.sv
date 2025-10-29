module counter #(
    parameter WIDTH = 8
)(
    input logic clk, //clock
    input logic rst, //reset
    input logic en, //enable
    input logic [WIDTH-1:0] incr,
    output logic [WIDTH-1:0] count //counter value
);
    always_ff@ (posedge clk, posedge rst)
    if(rst) count <= {WIDTH{1'b0}}; // 0000 0000
    else count <= count + 1;

endmodule
