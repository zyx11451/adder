
//32位整数乘法器
module multiplier(
    input[31:0] a,
    input[31:0] b,
    output[63:0] c
);
reg sign;
reg[31:-1] a1;
reg[31:0] b1;
reg[63:0] pp[15:0];
wire[63:0] pp1[9:0];
wire[63:0] pp2[5:0];
wire[63:0] pp3[3:0];
wire[63:0] pp4[3:0];
wire[63:0] pp5[1:0];
wire[63:0] pp6[1:0];
wire[63:0] ans1;
reg[63:0] ans;
integer i;

CSA64 CSAI1(
    .a    	( pp[0]     ),
    .b    	( pp[1]     ),
    .c    	( pp[2]     ),
    .s    	( pp1[0]     ),
    .cout 	( pp1[1]  )
);

CSA64 CSAI2(
    .a    	( pp[3]     ),
    .b    	( pp[4]     ),
    .c    	( pp[5]     ),
    .s    	( pp1[2]     ),
    .cout 	( pp1[3]  )
);

CSA64 CSAI3(
    .a    	( pp[6]     ),
    .b    	( pp[7]     ),
    .c    	( pp[8]     ),
    .s    	( pp1[4]     ),
    .cout 	( pp1[5]  )
);

CSA64 CSAI4(
    .a    	( pp[9]     ),
    .b    	( pp[10]     ),
    .c    	( pp[11]     ),
    .s    	( pp1[6]     ),
    .cout 	( pp1[7]  )
);

CSA64 CSAI5(
    .a    	( pp[12]     ),
    .b    	( pp[13]     ),
    .c    	( pp[14]     ),
    .s    	( pp1[8]     ),
    .cout 	( pp1[9]  )
);

CSA64 CSAII1(
    .a    	( pp1[0]     ),
    .b    	( pp1[1]     ),
    .c    	( pp1[2]     ),
    .s    	( pp2[0]     ),
    .cout 	( pp2[1]  )
);

CSA64 CSAII2(
    .a    	( pp1[3]     ),
    .b    	( pp1[4]     ),
    .c    	( pp1[5]     ),
    .s    	( pp2[2]     ),
    .cout 	( pp2[3]  )
);

CSA64 CSAII3(
    .a    	( pp1[6]     ),
    .b    	( pp1[7]     ),
    .c    	( pp1[8]     ),
    .s    	( pp2[4]     ),
    .cout 	( pp2[5]  )
);

CSA64 CSAIII1(
    .a    	( pp2[0]     ),
    .b    	( pp2[1]     ),
    .c    	( pp2[2]     ),
    .s    	( pp3[0]     ),
    .cout 	( pp3[1]     )
);

CSA64 CSAIII2(
    .a    	( pp2[3]     ),
    .b    	( pp2[4]     ),
    .c    	( pp2[5]     ),
    .s    	( pp3[2]     ),
    .cout 	( pp3[3]     )
);

CSA64 CSAIV1(
    .a    	( pp3[0]     ),
    .b    	( pp3[1]     ),
    .c    	( pp3[2]     ),
    .s    	( pp4[0]     ),
    .cout 	( pp4[1]     )
);

CSA64 CSAIV2(
    .a    	( pp3[3]     ),
    .b    	( pp[15]     ),
    .c    	( pp1[9]     ),
    .s    	( pp4[2]     ),
    .cout 	( pp4[3]     )
);

CSA64 CSAV1(
    .a    	( pp4[0]     ),
    .b    	( pp4[1]     ),
    .c    	( pp4[2]     ),
    .s    	( pp5[0]     ),
    .cout 	( pp5[1]     )
);

CSA64 CSAVI1(
    .a    	( pp5[0]     ),
    .b    	( pp5[1]     ),
    .c    	( pp4[3]     ),
    .s    	( pp6[0]     ),
    .cout 	( pp6[1]     )
);



CPA64 CPA64(
    .a   	( pp6[0]    ),
    .b   	( pp6[1]    ),
    .ans 	( ans1  )
);


always begin
#1
//确认结果符号
sign=a[31]^b[31];
//sign=0;
//调整符号
//$display("b:%d ", b[31:0]);
//$display("a:%d ", a[31:0]);

a1[31:0]= (a[31]==1'b0)? a:(-a);
//a1[31:0]=303379748;
a1[-1]=1'b0;

b1[31:0]= (b[31]==1'b0)? b:(-b);
//b1[31:0]=3230228097;
//$display("sign:%d ", sign);
//$display("b1:%d ", b1[31:0]);
//$display("a1:%d ", a1[31:0]);
//Booth 算法进行变换，减少加法次数，算出部分积
for (i=0;i<=15;i=i+1) begin
    if(a1[2*i+1]==1'b0) begin
        if(a1[2*i]==1'b0) begin
            if(a1[2*i-1]==1'b0)begin
                pp[i] <= 0;
            end
            else begin
                pp[i] <= b1<<(2*i);
            end
        end
        else begin
            if(a1[2*i-1]==1'b0)begin
                pp[i] <= b1<<(2*i);
            end
            else begin
                pp[i] <= b1<<(2*i+1);
            end
        end
    end
    else begin
        if(a1[2*i]==1'b0) begin
            if(a1[2*i-1]==1'b0)begin
                pp[i] <= -b1<<(2*i+1);
            end
            else begin
                pp[i] <= -b1<<(2*i);
            end
        end
        else begin
            if(a1[2*i-1]==1'b0)begin
                pp[i] <= -b1<<(2*i);
            end
            else begin
                pp[i] <= 0;
            end
        end
    end
end
 
//累加(待优化)
#5 
//调整结果符号
//$display("pp1[0]:%d",pp1[0]);
//$display("pp1[1]:%d",pp1[1]);
//$display("pp1[2]:%d",pp1[2]);
ans=(sign==1'b0) ? ans1:-ans1;

//$display("%d ", ans);
end


assign c=ans;
endmodule

module CSA64(
    input[63:0] a,
    input[63:0] b,
    input[63:0] c,
    output[63:0] s,
    output[63:0] cout
);
//进位保留加法器
 assign   s = a^b^c;
 assign   cout[63:1] = (a[62:0]&b[62:0])|(b[62:0]&c[62:0])|(c[62:0]&a[62:0]);
 assign   cout[0]=0;


endmodule

module CPA64(
    input[63:0] a,
    input[63:0] b,
    output[63:0] ans
);

assign ans=a+b;
endmodule



