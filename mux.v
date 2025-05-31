module mux (
input wire [9:0] a, 
input wire [9:0] b, 
input sel, 
output reg [9:0] y);

	always@(*)
		case (sel)
		1'b0: y = a;
		1'b1: y = b;
		default y = a;
	endcase
	
	
endmodule   

