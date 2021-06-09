`timescale 1ns/10ps
module RC4(clk,rst,key_valid,key_in,plain_read,plain_in_valid,plain_in,plain_write,plain_out,cipher_write,cipher_out,cipher_read,cipher_in,cipher_in_valid,done);
    input clk,rst;
    input key_valid,plain_in_valid,cipher_in_valid;
    input [7:0] key_in,cipher_in,plain_in;
    output reg done;
    output reg plain_write,cipher_write,plain_read,cipher_read;
    output reg [7:0] cipher_out,plain_out;
	reg first;
	reg	[5:0] key_shuffle;
	reg	[5:0] i_ksa;
	reg	[5:0] j_ksa;
	reg [5:0] temp;
	reg shuffle_box;
	reg [7:0] key [0:31];
	reg [5:0]count;
	reg [1:0]encryption;
	reg [6:0]temp2;
	reg [7:0]count_clock;
	reg [1:0]RC4_case;
	reg [5:0] sbox [0:63];
	integer i;
	 // testbench1 clock 38 , 120716883ps , clock 40 ,70749883
	initial begin
		done=0;
		encryption=2'b00;
		RC4_case=2'b00;
		plain_write=0;
		cipher_write=0;
		plain_read=0;
		cipher_read=0;
		first=1'b0;
		shuffle_box=1'b0;
		count = 6'b000000;
		count_clock = 8'b00000000;
		key_shuffle = 6'b000000;
		temp =  6'b000000;
		i_ksa = 6'b000000;
		j_ksa = 6'b000000;
	end
	
	
	always @(posedge clk)
	begin
		
		if(key_valid==1 && first==0)
			first<=first+1;
		
		if(cipher_read==1)begin
			if(cipher_in_valid==1)
			begin
				encryption = 2'b10;
				/*i_ksa = i_ksa+1;
				j_ksa = j_ksa+sbox[i_ksa];
				temp=sbox[i_ksa];
				sbox[i_ksa]=sbox[j_ksa];
				sbox[j_ksa]=temp;
				temp = sbox[i_ksa]+sbox[j_ksa];
				plain_out = cipher_in ^ sbox[temp];
				plain_write=1;*/
			end
			else begin
				done=1;
			end
		end
		
		if(plain_read==1)begin 
			if(plain_in_valid==1)   //加密
			begin
				encryption = 2'b01;
				/*i_ksa = i_ksa+1;
				j_ksa = j_ksa+sbox[i_ksa];
				temp=sbox[i_ksa];
				sbox[i_ksa]=sbox[j_ksa];
				sbox[j_ksa]=temp;
				temp = sbox[i_ksa]+sbox[j_ksa];
				cipher_out = plain_in ^ sbox[temp];
				cipher_write = 1;*/
				
			end
			else begin 
				shuffle_box=1;
				i_ksa = 6'b000000;
				j_ksa = 6'b000000;
			end
		end
		
		if(key_valid==1 && first==1)
		begin
			key[count]=key_in;
			count=count+1;
			if(count==32)
			begin
				shuffle_box=1;
			end
		end
		
		if(encryption)begin
		
			if(encryption == 2'b01)begin
				i_ksa = i_ksa+1;
				j_ksa = j_ksa+sbox[i_ksa];
				temp=sbox[i_ksa];
				sbox[i_ksa]=sbox[j_ksa];
				sbox[j_ksa]=temp;
				temp = sbox[i_ksa]+sbox[j_ksa];
				cipher_out = plain_in ^ sbox[temp];
				cipher_write = 1;
			end
			else begin
				i_ksa = i_ksa+1;
				j_ksa = j_ksa+sbox[i_ksa];
				temp=sbox[i_ksa];
				sbox[i_ksa]=sbox[j_ksa];
				sbox[j_ksa]=temp;
				temp = sbox[i_ksa]+sbox[j_ksa];
				plain_out = cipher_in ^ sbox[temp];
				plain_write=1;
			end
			encryption = 2'b00;
		end
		
		if(shuffle_box==1)
		begin  
			if(first==1)
			begin
				if(count_clock < 64)
					sbox[count_clock]=count_clock;
				else begin
					if(count_clock == 64)
						key_shuffle = 6'b000000;
					temp = {1'b0,count_clock[4:0]};
					key_shuffle = (key_shuffle+sbox[count_clock-64]+key[temp]);
					temp = sbox[count_clock-64];
					sbox[count_clock-64]=sbox[key_shuffle];
					sbox[key_shuffle]=temp;
				end
				count_clock = count_clock + 1;
				if(count_clock==128) begin
					shuffle_box = 0;
					count_clock = 0;
					if(RC4_case==0)begin
						plain_write=0;
						plain_read=1;
						RC4_case = RC4_case +1;
					end
					else if(RC4_case==1)begin
						//RC4_case = RC4_case +1;
						plain_read=0;
						cipher_write=0;
						cipher_read=1;
					end
				end
			end
		end 
		
	end	

endmodule