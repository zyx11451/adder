`include "multiplier.v"

module test_multiplier;
	wire [63:0] answer;
	reg  [31:0] a, b;
	reg	 [63:0] res;

	multiplier multiplier (a, b, answer);
	
	integer i;
	initial begin
		for(i=1; i<=100; i=i+1) begin
			a[31:0] = $random;
			b[31:0] = $random;
			res		= $signed(a)* $signed(b);
			
			#15;
			$display("TESTCASE %d: %d * %d = %d ", i, $signed(a), $signed(b), $signed(answer));

			if (answer !== res[63:0] ) begin
				$display("Wrong Answer!");
				$finish;
			end
		end
		$display("Congratulations! You have passed all of the tests.");
		$finish;
	end
endmodule