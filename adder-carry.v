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
	wire zero;
	assign zero=0;
	wire G;
	wire P;
	Add16 add(
		.a (a),
		.b (b),
		.carry_in (zero),
		.ans (ans),
		.p_out (P),
		.g_out (G)
	);
	assign carry=G;
endmodule


module Adder(
    input     a,
    input     b,
    input     carry_in,
    output    G,
    output    P,
    output    temp_ans
);
assign P = a|b;
assign G = a&b;
assign temp_ans = a^b^carry_in;
endmodule

module Add4(
    input[3:0]    a,
    input[3:0]    b,
    input         carry_in,
    output[3:0]   ans,
    output   p_out,
    output   g_out
);
wire[4:1]   c;
wire[3:0]   G;
wire[3:0]   P;
Adder a1(
    .a    (a[0]),
    .b    (b[0]),
    .carry_in (carry_in),
    .G    (G[0]),
    .P    (P[0]),
    .temp_ans (ans[0])
);
Adder a2(
    .a    (a[1]),
    .b    (b[1]),
    .carry_in (c[1]),
    .G    (G[1]),
    .P    (P[1]),
    .temp_ans (ans[1])
);
Adder a3(
    .a    (a[2]),
    .b    (b[2]),
    .carry_in (c[2]),
    .G    (G[2]),
    .P    (P[2]),
    .temp_ans (ans[2])
);
Adder a4(
    .a    (a[3]),
    .b    (b[3]),
    .carry_in (c[3]),
    .G    (G[3]),
    .P    (P[3]),
    .temp_ans (ans[3])
);
CLA4 cla(
    .P    (P),
    .G    (G),
    .carry_in (carry_in),
    .c    (c),
    .P4 (p_out),
    .G4 (g_out)
);
endmodule

module CLA4(
    input[3:0] P,
    input[3:0] G,
    input carry_in,
    output[4:1] c,
    output P4,
    output G4
);
assign c[1]=(G[0])|(P[0]&carry_in);
assign c[2]=(G[1])|(P[1]&G[0])|(P[1]&P[0]&carry_in);
assign c[3]=(G[2])|(P[2]&G[1])|(P[2]&P[1]&G[0])|(P[2]&P[1]&P[0]&carry_in);
assign c[4]=(G[3])|(P[3]&G[2])|(P[3]&P[2]&G[1])|(P[3]&P[2]&P[1]&G[0])|((P[3]&P[2]&P[1]&P[0]&carry_in));
assign G4=(G[3])|(P[3]&G[2])|(P[3]&P[2]&G[1])|(P[3]&P[2]&P[1]&G[0]);
assign P4=P[3]&P[2]&P[1]&P[0];
endmodule

module Add16(
    input[15:0]    a,
    input[15:0]    b,
    input         carry_in,
    output[15:0]   ans,
    output   p_out,
    output   g_out
);
wire[4:1]   c;
wire[3:0]   G;
wire[3:0]   P;
Add4 a1(
    .a   (a[3:0]),
    .b   (b[3:0]),
    .carry_in (carry_in),
    .ans (ans[3:0]),
    .p_out (P[0]),
    .g_out (G[0])
);
Add4 a2(
    .a   (a[7:4]),
    .b   (b[7:4]),
    .carry_in (c[1]),
    .ans (ans[7:4]),
    .p_out (P[1]),
    .g_out (G[1])
);
Add4 a3(
    .a   (a[11:8]),
    .b   (b[11:8]),
    .carry_in (c[2]),
    .ans (ans[11:8]),
    .p_out (P[2]),
    .g_out (G[2])
);
Add4 a4(
    .a   (a[15:12]),
    .b   (b[15:12]),
    .carry_in (c[3]),
    .ans (ans[15:12]),
    .p_out (P[3]),
    .g_out (G[3])
);
CLA4 cla(
    .P    (P),
    .G    (G),
    .carry_in (carry_in),
    .c    (c),
    .P4 (p_out),
    .G4 (g_out)
);
endmodule