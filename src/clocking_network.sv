// main logic block containing clock muxes and dividers

module clocking_network #( 
  parameter COUNTER_MAX = 50000000
) 
(
  input logic clk,    
  input logic rst_n,
  input logic [1:0] sw_in,

  output logic [2:0] led_out  
);

  logic clk_div_2_r;
  logic clk_mux_0_s, clk_mux_1_s;
  logic count_clk_0_s, count_clk_1_s, count_clk_2_s;

  assign led_out = { count_clk_2_s, count_clk_1_s, count_clk_0_s };

  clock_wiz i_clock_wiz (
    .clk(clk),
    .rst_n(rst_n),
    .clk_out(clk0)
  );

  // mux 1
  // assign clk_mux_0_s = sw_in(0) ? clk : clk_div_2_r;

  BUFGMUX i_BUFGMUX0 (
    .O(clk_mux_0_s),  // 1-bit output: Clock output
    .I0(clk_div_2_r), // 1-bit input: Clock input (S=0)
    .I1(clk0),         // 1-bit input: Clock input (S=1)
    .S(sw_in(0))      // 1-bit input: Clock select
  );

  BUFGMUX i_BUFGMUX1 (
    .O(clk_mux_1_s),  
    .I0(clk_mux_0_s), 
    .I1(count_clk_0_s),         
    .S(sw_in(1))      
  );

  counter  #(
    .COUNTER_MAX(COUNTER_MAX)
  ) i_counter0
  (
    .clk(clk0),    
    .rst_n(rst_n),  
    .div_clk_out(count_clk_0_s)
  );

  counter  #(
    .COUNTER_MAX(COUNTER_MAX)
  ) i_counter1
  (
    .clk(clk_mux_0_s),    
    .rst_n(rst_n),  
    .div_clk_out(count_clk_1_s)
  );

  counter  #(
    .COUNTER_MAX(COUNTER_MAX)
  ) i_counter2
  (
    .clk(clk_mux_1_s),    
    .rst_n(rst_n),  
    .div_clk_out(count_clk_2_s)
  );

  always_ff @(posedge clk0 or negedge rst_n) begin
    if(~rst_n) begin
       clk_div_2_r <= 0;
    end else begin
       clk_div_2_r <= ~clk_div_2_r;
    end
  end

endmodule : clocking_network