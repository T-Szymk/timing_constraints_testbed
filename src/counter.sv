// configurable counter that inverts output every time timer is reset

module counter #(
  parameter COUNTER_MAX = 50000
) 
(
  input  logic clk,    // Clock
  input  logic rst_n,  // Asynchronous reset active low
  output logic div_clk_out
);

  logic [15:0] counter_r;
  logic div_clk_r; 

  assign div_clk_out = div_clk_r;

  always_ff @(posedge clk or negedge rst_n) begin
    
    if(~rst_n) begin
       counter_r <= '0;
       div_clk_r <= 1'b0;
    end else begin
      if (counter_r == COUNTER_MAX) begin
        counter_r <= '0;
        div_clk_r <= ~div_clk_r;
      end else begin 
        counter_r <= counter_r + 1;
      end
    end
  end

endmodule : counter