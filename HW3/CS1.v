`timescale 1ns/10ps
module CS(Y, X, reset, clk);

input clk, reset; 
input 	[7:0] X;
output 	[9:0] Y;

reg  [7:0] A [7:0] ;
reg [7:0] distance = 8'b11111111 ;
reg flag3 = 0;
reg [15:0] temp1=0;
reg [3:0] counter = 0;
reg [15:0] temp2;
reg [3:0] i;
reg [9:0] Y;
//--------------------------------------
//  \^o^/   Write your code here~  \^o^/
//--------------------------------------
always @(posedge clk)
begin

	
	//temp1 = A[0]+A[1]+A[2]+A[3]+A[4]+A[5]+A[6]+A[7]+A[8] ;
	temp1 =(X+A[0])+(A[1]+A[2])+(A[3]+A[4])+(A[5]+A[6])+A[7];
	temp2 = temp1 / 9 ;
	for(i =0;i < 8; i=i+1)
	begin
		if(A[i] <= temp2)
		begin
			if(distance > (temp2 - A[i]))
				distance = temp2 - A[i];
		end
	end
	if(X <= temp2)
	begin
		if(distance > (temp2 - X))
			distance = temp2 - X;
	end
	temp2 = temp2 - distance;
	temp2 = ( (temp2<<3) + (temp2 + temp1) ) >> 3 ;

	A[counter] = X;
	counter = counter+1;
	if(counter == 4'b1000)
		counter=0;
	distance = 8'b11111111;
	Y  <= temp2[9:0];
		
	

end




endmodule
