module f1_fsm (
    input   logic       rst,
    input   logic       en,
    input   logic       clk,
    input   logic       trigger,
    input   logic [7:0] lfsr_value,
    output  logic [7:0] data_out
);

    logic [7:0]   delay_count;

    typedef enum {S0,S1,S2,S3,S4,S5,S6,S7,S8} state;
    state current_state, next_state;

    always_ff @(posedge clk, posedge rst)

        if (rst) begin
            current_state <= S0;
            delay_count <= 8'b0;
        end else if (en) begin
            if (current_state != S8 && next_state == S8) begin
                current_state <= S8;
                delay_count <= lfsr_value;  
            end

            else if (current_state == S8 && delay_count != 8'b0) begin
                delay_count <= delay_count - 1'b1;
            end

            else begin
                current_state <= next_state;
            end
        end

    always_comb begin
        case (current_state)
            //S0: next_state = trigger ? S1 : S0;
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S5;
            S5: next_state = S6;
            S6: next_state = S7;
            S7: next_state = S8;
            S8: next_state = (delay_count == 8'b0) ? S0 : S8;
            default: next_state = S0;
        endcase
    end

    always_comb begin
        case (current_state)
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

endmodule
