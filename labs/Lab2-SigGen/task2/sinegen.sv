module sinegen #(
    parameter ADDRESS_WIDTH = 8,
    parameter DATA_WIDTH = 8
) (
    input  logic             clk,  //clock
    input  logic             rst,  //rest
    input  logic             en,   //counter enable
    input  logic [ADDRESS_WIDTH-1:0]  incr,
    output logic [DATA_WIDTH-1:0] dout1,
    output logic [DATA_WIDTH-1:0] dout2
);
    
    logic [ADDRESS_WIDTH-1:0] addr1; //internal signal
    logic [ADDRESS_WIDTH-1:0] count1;

    assign addr1 = count1;

    counter #(
        .WIDTH(ADDRESS_WIDTH)
    ) counter1 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .incr(incr),
        .count(count1)
    );

    rom #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) rom1(
        .clk(clk),
        .addr(addr1),
        .dout1(dout1),
        .dout2(dout2),
        .incr(incr)

    );

endmodule
