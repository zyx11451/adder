/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

module adder(
	input  [15:0] a,
	input  [15:0] b,
	output [15:0] ans,
	output carry
);
wire[16:0] c;
assign c[0]=0;

genvar  i;
generate
	for(i=0;i<16;i=i+1) begin
	FullAdder fa(
		.a   (a[i]),
		.b   (b[i]),
		.carry_in (c[i]),
		.carry_out (c[i+1]),
		.ans (ans[i])
	);
	end
endgenerate



assign carry=c[16];

endmodule

module FullAdder(
	input a,
	input b,
	input carry_in,
	output carry_out,
	output ans
);
assign ans = a^b^carry_in;
assign carry_out=(a&b)|(carry_in&(a|b));

endmodule
