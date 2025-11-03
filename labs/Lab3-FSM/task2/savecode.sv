module f1_fsm (
    input   logic       rst,
    input   logic       en,
    input   logic       clk,
    input   logic       trigger,
    input logic [7:0]  random,
    output  logic [7:0] data_out
);

    typedef enum {S0, S1, S2, S3, S4, S5, S6, S7, S8} state;
    state current_state, next_state;

    always_ff@(posedge clk, posedge rst) 
        if (rst) begin
            current_state <= S0;
            delay_count <=  random;
        end

        else if (next_state == S8) begin
            current_state <= S8;
            delay_count <= random;
        end
        else if(current_state == S8 && delay_count != 0)
            delay_count <= delay_count - 8'b1;
    
        else current_state <= next_state;



    always_comb begin
        case (current_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4; 
            S4: next_state = S5; 
            S5: next_state = S6; 
            S6: next_state = S7; 
            S7: next_state = S8; 
            S8: data_out = (delay_count == 8'b0) ? S0 : S8;

            default: next_state = S0;


        endcase
    end

    always_comb begin
        case(next_state)
        S0: data_out = 8'b0;
        S1: data_out = 8'b1;
        S2: data_out = 8'b11;
        S3: data_out = 8'b111;
        S4: data_out = 8'b1111;
        S5: data_out = 8'b11111;
        S6: data_out = 8'b111111;
        S7: data_out = 8'b1111111;
        S8: data_out = 8'b11111111;


        default: data_out = 8'b0;
        endcase

    end


    assign data_out = {current_state == S0};

    
    

    logic [7:0] random;
    lfsr_8 randomGenerator (
        .clk(clk),
        .rst(rst),
        .en(en),
        .data_out(random)
    )



    logic [7:0] lights;

    assign lights = 8'b0;

    always_ff@(posedge clk, posedge rst) begin
        if (rst)
            data_out <= 8'b0;
        else if (lights == 8'b11111111)

        else if (en)
            lights <= {lights[6:0], 1'b1};

    end

    assign data_out = lights;

    
    

endmodule
