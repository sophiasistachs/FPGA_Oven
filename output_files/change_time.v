module change_time(
	input wire clock,         
    input wire reset,         
    input wire btnsub,          
    input wire btnadd,          
    output reg [9:0] input_time );
	 
	 
	 // Change Temp
	 always@(posedge clock) begin
		if (btnadd == 0) begin
			input_time <= input_time + 1;
		end
	   if (btnsub == 0) begin
			input_time <= input_time - 1;
		end
		else 
			input_time <= input_time;
	end
	
		 /*/ Second and Minute to HEX
    assign set_min_units = input_time % 10;
    assign set_min_tens  = input_time / 10;*/
	 
	 endmodule