module sinegen #(
    parameter ADDRESS_WIDTH = 8,
              DATA_WIDTH    = 8 
) (
    input logic [DATA_WIDTH-1:0] incr,
    input logic clk,
    input logic rst,
    input logic en,
    output logic [DATA_WIDTH-1:0] dout

);

    logic [ADDRESS_WIDTH-1:0] addr;
    logic [ADDRESS_WIDTH-1:0] count;

    counter #(
        .WIDTH(ADDRESS_WIDTH)
    ) counter1 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .count(count),
        .incr(incr)
    );

    rom #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) rom1 (
        .clk(clk),
        .dout(dout),
        .addr(addr)
    );

    assign addr = count;
                
    
endmodule
