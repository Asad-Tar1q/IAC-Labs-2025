// Delay module: assert time_out for 1 cycle after a programmable delay of k cycles
module delay #(
  parameter int WIDTH = 8                // number of bits in the delay counter
)(
  input  logic                 clk,      // clock
  input  logic                 rst,      // synchronous reset (active high)
  input  logic                 trigger,  // start signal
  input  logic [WIDTH-1:0]     k,        // delay in clock cycles
  output logic                 time_out  // 1-cycle pulse after delay
);

  
  logic [WIDTH-1:0] count /* synthesis preserve */;

  typedef enum logic [1:0] {
    IDLE,
    COUNTING,
    TIME_OUT,
    WAIT_LOW
  } my_state_t;

  my_state_t current_state, next_state;

  // ---------------------------------------------------------------------------
  // Next-state (combinational) logic
  // ---------------------------------------------------------------------------
  always_comb begin
    next_state = IDLE; // default
    unique case (current_state)
      IDLE: begin
        if (trigger) next_state = COUNTING;
        else         next_state = IDLE;
      end

      COUNTING: begin
        if (count == {WIDTH{1'b0}}) next_state = TIME_OUT;
        else                        next_state = COUNTING;
      end

      TIME_OUT: begin
        if (trigger) next_state = WAIT_LOW;
        else         next_state = IDLE;
      end

      WAIT_LOW: begin
        if (!trigger) next_state = IDLE;
        else          next_state = WAIT_LOW;
      end

      default: next_state = IDLE;
    endcase
  end

  // ---------------------------------------------------------------------------
  // Output (combinational) logic
  // ---------------------------------------------------------------------------
  always_comb begin
    unique case (current_state)
      TIME_OUT: time_out = 1'b1;   // pulse high for one cycle
      default:  time_out = 1'b0;
    endcase
  end

  // ---------------------------------------------------------------------------
  // Counter: load k-1 in IDLE/reset, decrement while COUNTING
  // ---------------------------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst || (current_state == IDLE)) begin
      count <= k - 1'b1;
    end else if (current_state == COUNTING) begin
      count <= count - 1'b1;
    end
  end

  // ---------------------------------------------------------------------------
  // State register
  // ---------------------------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end

endmodule
