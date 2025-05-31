module change_temp (
    input wire clock,         
    input wire reset,         
    input wire btnsub,          
    input wire btnadd,          
    output reg [9:0] input_temp 
);


	 	/*/ Change Temp
	 always@(posedge clock) begin
		if (btnadd == 0) begin
			input_temp <= input_temp + 1;
		end
	   if (btnsub == 0) begin
			input_temp <= input_temp - 1;
		end
		else 
			input_temp <= input_temp;
	end

	 
	 // Temperature to HEX
	 assign temp_units = (input_temp / 100) % 10; 
    assign temp_tens = (input_temp / 10) % 10;  
    assign temp_cien  = input_temp % 10; */

	 
endmodule