// clocking block wrapper to contain instantiation of clocking wizard

module clock_wiz (
  input  logic clk,
  input  logic rst_n,   
  output logic clk_out  
);

  clk_wiz_0 instance_name (
    .clk_out1(clk_out),
    .resetn(rst_n), 
    .clk_in1(clk)
  );      

endmodule : clock_wiz