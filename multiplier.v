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
reg[63:0] ans;
integer i;
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
#1   
//累加(待优化)
ans=0;
for (i=0;i<=15;i=i+1) begin
    ans = ans+pp[i];
    //$display("%d ", ans);
    //$display("pp[%d]: %d ",i, pp[i]);
end
//调整结果符号
ans=(sign==1'b0) ? ans:-ans;

//$display("%d ", ans);
end


assign c=ans;
endmodule


