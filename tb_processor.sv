module tb_processor;

  logic clk;
  logic reset;
  wire[31:0] out0;
  
processor L1(
          .clk(clk)
         ,.reset(reset)
         ,.out0(out0)
         );

always #1 clk = ~ clk;

initial begin
	clk = 1;
	reset = 1;
	#2 reset = 0;
	#60;
	$finish;

end
endmodule
    
