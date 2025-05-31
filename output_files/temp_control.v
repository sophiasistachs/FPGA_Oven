module temp_control (
input wire [9:0] input_temp,
input wire clock, 
input wire heat,
output reg [9:0] oven_temp);

	 // Parameters
    reg [9:0] upper_threshold;
    reg [9:0] lower_threshold;

    always @(*) begin
        upper_threshold = input_temp + 4;
        lower_threshold = input_temp - 4;
    end
	
	/*/ Temcontrol
	always @(posedge clock) begin
		 if (minutes != input_time) begin  
			  if (on_off_sw == 1) begin
					if (oven_temp >= upper_threshold) begin  
						 oven_temp <= oven_temp - 2;
					end 
					else if (oven_temp <= lower_threshold) begin  
						 oven_temp <= oven_temp + 2;
					end 
					else begin
						 oven_temp <= oven_temp;  
					end
			  end
			  else if (on_off_sw == 0) begin
				oven_temp <= oven_temp - 1;
			  end
		 end
	end*/

endmodule 
