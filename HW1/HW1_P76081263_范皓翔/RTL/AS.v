module AS(sel, A, B, S, O , c_out);
	input [3:0] A, B;
	input sel;
	output [3:0] S;
	output O,c_out;
	wire c_in2,c_in3,c_in4;
	wire [3:0]temp;
	xor (temp[0],B[0],sel);
	xor (temp[1],B[1],sel);
	xor (temp[2],B[2],sel);
	xor (temp[3],B[3],sel);
	Fulladder G1(A[0],temp[0],S[0],sel,c_in2);
	Fulladder G2(A[1],temp[1],S[1],c_in2,c_in3);
	Fulladder G3(A[2],temp[2],S[2],c_in3,c_in4);
	Fulladder G4(A[3],temp[3],S[3],c_in4,c_out);
	
	xor	(O,c_in4,c_out);
	
endmodule


module Fulladder(a,b,sum,c_in,c_out);
	input a,b,c_in;
	output sum,c_out;
	wire temp,temp2,temp3;
	xor (temp,a,b);
	xor (sum,temp,c_in);
	and (temp2,temp,c_in);
	and (temp3,a,b);
	or  (c_out,temp2,temp3);
endmodule