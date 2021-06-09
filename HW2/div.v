`timescale 1ns / 10ps
module div(out, in1, in2, dbz);
parameter width = 8;
input  	[width-1:0] in1; // Dividend
input  	[width-1:0] in2; // Divisor
output  [width-1:0] out; // Quotient
output dbz;

reg [width-1:0] out , dbz;

reg[7:0] tempa;  
reg[7:0] tempb;  
reg[15:0] temp_a;  
reg[15:0] temp_b; 
integer i;  

always @(in1 or in2)  
begin  
    tempa [7:0] = in1 [7:0];  
    tempb [7:0] = in2 [7:0];  
end  

always @(tempa or tempb)
begin
	if(tempb == 0)
		dbz=1;
	else
		dbz=0;
	if(tempa-tempb < 0)
		out= 8'b00000000;
	else begin
	temp_a  = {8'b00000000,tempa};  
    temp_b  = {tempb,8'b00000000};   
    for(i =0;i < 8; i=i+1)   
    begin  
		temp_a  = {temp_a[14:0],1'b0};  
		if(temp_a[15:8]  >= tempb)  
			temp_a  =  temp_a  - temp_b + 1'b1;  
		else  
			temp_a  =  temp_a ;  
    end  
  
    out  <= temp_a[7:0];  
	end
	
	
end


endmodule