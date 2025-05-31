module heating_up (
input wire [9:0] input_temp,
input wire clock, 
input wire heat,
output reg [9:0] oven_temp);


	 // Heating up
	 always @(posedge clock) begin
		if (oven_temp <= input_temp)begin
			if (heat == 1) begin	
						 oven_temp <= oven_temp + 2;          
					end 
					else if (heat == 0) begin  
						 oven_temp <= oven_temp - 1;          
					end 
					else begin
						 oven_temp <= oven_temp;              
					end
				end
			end
	  

endmodule 