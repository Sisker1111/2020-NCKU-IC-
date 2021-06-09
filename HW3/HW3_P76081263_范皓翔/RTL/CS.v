`timescale 1ns/10ps
module CS(Y, X, reset, clk);

input clk, reset; 
input  [7:0] X;
output [9:0] Y;
reg  [9:0] Y;
reg  [9:0] temp;


reg [71:0] x_value;
reg [7:0] avg;
reg [7:0] min;
reg [11:0]total;
reg [11:0]tmp;


always @(posedge clk)
begin
 x_value={x_value[63:0],X}; 
 total=(((x_value[71:64]+ x_value[63:56])+(x_value[55:48]+ x_value[47:40]))+((x_value[39:32]+ x_value[31:24])+(x_value[23:16]+ x_value[15:8]))+x_value[7:0]);

 avg = total / 9;
 
 min = 8'b11111111; 

 if(x_value[71:64]<=avg)
 begin
  if( avg - x_value[71:64] < min )
   	min = avg - x_value[71:64];  
 end

 if(x_value[63:56]<=avg)
 begin
  if( avg - x_value[63:56] < min )
  	min=avg - x_value[63:56];  
 end
 
 if(x_value[55:48]<=avg)
 begin
  if( avg - x_value[55:48] < min )
   	min=avg - x_value[55:48];  
 end
 
 if(x_value[47:40]<=avg)
 begin
  if( avg - x_value[47:40] < min )
   	min=avg - x_value[47:40];  
 end
 
 if(x_value[39:32]<=avg)
 begin
  if( avg - x_value[39:32] < min )
   min=avg - x_value[39:32];  
 end
 
 if(x_value[31:24]<=avg)
 begin
  if( avg - x_value[31:24] < min )
    min=avg - x_value[31:24];  
 end
 
 if(x_value[23:16]<=avg)
 begin
  if( avg - x_value[23:16] < min )
    min=avg - x_value[23:16];  
 end
 
 if(x_value[15:8]<=avg)
 begin
  if( avg - x_value[15:8] < min )
    min=avg - x_value[15:8];  
 end
 
 if(x_value[7:0]<=avg)
 begin
  if( avg - x_value[7:0] < min )
    min=avg - x_value[7:0]; 
 end
 
 avg = avg - min;
 tmp={4'b0,avg};
 Y=( (total + tmp)  + (tmp<<3) ) >>3; 
 

    
end
   
endmodule