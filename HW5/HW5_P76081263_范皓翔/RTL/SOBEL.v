
`timescale 1ns/10ps

module  SOBEL(clk,reset,busy,ready,iaddr,idata,cdata_rd,cdata_wr,caddr_rd,caddr_wr,cwr,crd,csel	);
	input clk,reset;
	input ready;	
	input [7:0] idata;	
	input [7:0] cdata_rd;
	output reg busy;	
	output reg [16:0] iaddr;
	output reg [7:0] cdata_wr;
	output reg [15:0] caddr_rd;
	output reg [15:0] caddr_wr;
	output reg cwr,crd;
	output reg [1:0] csel;
	reg [1:0] sobel_x_finish;
	reg [1:0] sobel_y_finish;
	reg [1:0] combine_finish;
	reg [1:0] delay;
	reg [16:0] w_count;
	reg delay_combine;
	
	integer temp_sobelx;
	integer temp_sobely;
	reg [8:0] temp_combine;
	reg [4:0] count;
	integer count_iaddr;
	reg [17:0] count_caddr;
	reg done;
	reg [7:0] pixel_value [8:0];
	initial begin
		delay=2'b00;
		caddr_wr=0;
		delay_combine=0;
		cwr=0;
		done=0;
		count_iaddr=0;
		temp_sobelx=0;
		sobel_x_finish=0;
		sobel_y_finish=0;
		combine_finish=0;
		count_caddr=0;
		busy=0;
		count=0;
		iaddr=0;
		csel=0;
		w_count = 0;
	end
	
	always @(posedge clk)
	begin
		if(ready==0 && busy==1 && delay==0)
			delay<=1;
		if(ready==0 && busy==1 && delay==1)
		begin
			if(combine_finish==0)
			begin
				if(sobel_x_finish==1)
				begin
					sobel_x_finish=2;
				end
				else if(sobel_x_finish==2)begin
					//sobel_y_finish=1;
					sobel_x_finish=0;
				end
				else begin
					if(count>=0 && count<3)
						begin
							pixel_value[count] = idata;
							if(count==2)
								iaddr = iaddr + 256;
							else
								iaddr = iaddr +1;
							count = count + 1;
						end
					else if(count>=3 && count<6)
						begin
						
							pixel_value[count] = idata;
							if(count==5)
								iaddr = iaddr + 256;
							else
								iaddr = iaddr +1;
							count = count + 1;
						end
					else 
						begin
							pixel_value[count] = idata;
							if(count==8)
								begin
									if(count_iaddr%258 == 255)
										count_iaddr = count_iaddr + 3;
									else
										count_iaddr = count_iaddr + 1;
									count_caddr = count_caddr + 1;
									iaddr = count_iaddr;
									count = 0;
									sobel_x_finish=1;
								end
							else begin
								iaddr = iaddr +1;
								count = count + 1;
							end
						end
				end
			end
			/*else if(combine_finish==1)
				combine_finish=2;*/
		end
	end
	
	
	always @(negedge clk)
	begin
		if(combine_finish==1)
			combine_finish=2;
		
		if(done==1)
		begin
			busy=0;
			cwr=0;
		end
		if(ready==1)
			busy=1;
			
		if(sobel_x_finish==2) // do sobel x
		begin
			
			cwr=1;
			csel=2'b01;
			temp_sobelx = pixel_value[3]<<1 ;
			temp_sobelx = temp_sobelx + pixel_value[0] + pixel_value[6];
			temp_sobelx = temp_sobelx - (  pixel_value[5] << 1 );
			temp_sobelx = temp_sobelx - pixel_value[2] - pixel_value[8];
			if(temp_sobelx > 255)
				temp_sobelx=255;
			if(temp_sobelx < 0)
				temp_sobelx=0;
			//$display("%d",temp_sobelx);
			sobel_y_finish<=1;
			cdata_wr = temp_sobelx;
			caddr_wr = w_count;
			
			
		end
		
		if(sobel_y_finish==1) // do sobel y
		begin
			cwr=1;
			csel=2'b10;
			temp_sobely = pixel_value[1]<<1 ;
			temp_sobely = temp_sobely + pixel_value[0] + pixel_value[2];
			temp_sobely = temp_sobely - (  pixel_value[7] << 1 );
			temp_sobely = temp_sobely - pixel_value[6] - pixel_value[8];
			
			if(temp_sobely > 255)
				temp_sobely=255;
			if(temp_sobely < 0)
				temp_sobely=0;
			cdata_wr = temp_sobely;
			//sobel_x_finish=0;
			sobel_y_finish<=0;
			combine_finish=1;
			caddr_wr = w_count;
			
			
		end
		
		if(combine_finish==2) // do sobel combine
		begin
			
			cwr=1;
			csel=2'b11;
			temp_combine = temp_sobelx + temp_sobely + 1 ;
			temp_combine= temp_combine >> 1;
			
			cdata_wr = temp_combine;
			
			combine_finish=0;
			caddr_wr = w_count;
			w_count = w_count + 1;

			if(count_caddr==65536)
				begin
					done=1;
				end
		end
			
			
			
		
	end
	
	
endmodule




