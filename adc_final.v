module adc_final(
	//Clock
	input wire clock,
	//Switches
	input reset_sw,
	input on_off_sw,
	input state2_sw,
	input state3_sw,
	input state4_sw,
	input state5_sw,
	// Buttons
	input btnadd,
	input btnsub,
	// Displays
	output reg led,
	output wire [6:0] HEX0, HEX1, HEX3,
	output wire [7:0] HEX2);

	//States
	localparam A = 0, B = 1, C = 2, D = 3, E = 4;
	reg [3:0] next_state, present_state;
	reg [3:0] seg_reg0, seg_reg1, seg_reg2, seg_reg3;
	
	//Timing vars
	reg [5:0] seconds;
	reg [5:0] minutes;
	
	wire [3:0] sec_units, sec_tens, min_units, min_tens;
	reg [5:0] input_time;
	
	//timer timing vars 
	reg [5:0] set_seconds;
	reg [5:0] set_minutes;
	
	wire [3:0] set_sec_units, set_sec_tens, set_min_units, set_min_tens;

	
	// Teperature
	reg [9:0] input_temp = 10'd300;
	wire [3:0] temp_unit, temp_tens, temp_cien; 
	reg [9:0] oven_temp = 10'b0;
	reg [9:0] oven_temp_set = 10'b0;

	// Clock Module
	off_clock time_clk (clock, new_clock);	
	
	// Flip-Flop for seconds and minutes
	always @(posedge new_clock) begin
		seconds <= seconds + 1;
		if (seconds > 59) begin
		minutes <= minutes + 1;
		seconds <= 0;
		end
	end
	
	 // Second and Minute to HEX
    assign sec_units = seconds % 10;
    assign sec_tens  = seconds / 10;
    assign min_units = minutes % 10;
    assign min_tens  = minutes / 10;
	 
	 // Temperature to HEX
	 assign temp_units = (oven_temp / 100) % 10; 
    assign temp_tens = (oven_temp / 10) % 10;  
    assign temp_cien  = oven_temp % 10; 
	 
	 	 // Parameters
    reg [9:0] upper_threshold;
    reg [9:0] lower_threshold;

    always @(*) begin
        upper_threshold = input_temp + 4;
        lower_threshold = input_temp - 4;
    end
	 
	 // Set time 
	 // Flip-Flop for seconds and minutes (timer)
    always @(posedge new_clock) begin
        set_seconds <= set_seconds - 1;
		  if (state5_sw==0)begin
		  
			  if (btnadd==0) begin
			  set_minutes <= set_minutes + 1;
			  end 
			  if (btnsub==0) begin
			  set_minutes <= set_minutes - 1;
			  end 
			  if (set_seconds ==0) begin
			  set_minutes <= set_minutes - 1;
			  set_seconds <= 59;
			  end
			  if ((set_seconds ==0)&&(set_minutes ==0))
				led=1;
			end
			
			if (state5_sw==1)begin
				if(btnadd==0) begin
					oven_temp_set <= oven_temp_set + 50;
				end 
				if (btnsub==0) begin
					oven_temp_set <= oven_temp_set - 50;
				end 
		end 	
    end
	 
	 assign set_sec_units = set_seconds % 10;
    assign set_sec_tens  = set_seconds / 10;
    assign set_min_units = set_minutes % 10;
    assign set_min_tens  = set_minutes / 10;
	 
	 //settemp
	 
//	 always @(*) begin
//		if(btnadd==0) begin
//        oven_temp_set <= oven_temp_set + 50;
//      end 
//      if (btnsub==0) begin
//        oven_temp_set <= oven_temp_set - 50;
//      end 
//	 end 
//	 
	 
	 
	 // Heating up
	 always @(posedge new_clock) begin
			if (on_off_sw == 1) begin	
				 oven_temp <= oven_temp + 2;          
			end 
			else if (on_off_sw == 0) begin  
				 oven_temp <= oven_temp - 1;          
			end 
			else begin
				 oven_temp <= oven_temp;              
			end
		end
	 
	 
	// Temcontrol
	always @(posedge new_clock) begin
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
	end
		 
	
	// State Transition 
always @ (*) begin
    case (present_state)
        // Display Time of Day
        A: begin
            if (on_off_sw == 1) 
                next_state = B;
            else 
                next_state = A;
        end
        
        // Set bake time 
        B: begin
            if (on_off_sw == 1 && state2_sw == 1)   
                next_state = C;
            else if (on_off_sw == 0)
               next_state = A;
            else
                next_state = B;
        end
        
        // Set bake temp 
        C: begin 
            if (on_off_sw == 1 && state3_sw == 1) 
                next_state = D; 
            else if (on_off_sw == 0)
                next_state = A;
            else
                next_state = C;
        end
        
        // Heating Up
        D: begin 
            if (on_off_sw == 1 && oven_temp >= input_temp) 
                next_state = E;
            else
                next_state = D;
					 end
        
        
        // Temp Control
        E: begin 
            if (on_off_sw == 0) 
                next_state = B;
            else if (on_off_sw == 1 && minutes != input_time)
                next_state = D;
					 else 
					 next_state = E;
        end
        
        // Default State
        default: next_state = A;
    endcase
end

	// Flip Flop & Reset
	always @(posedge clock or posedge reset_sw) begin
		 if (reset_sw) begin
			  present_state <= A;
		 end else begin
			  present_state <= next_state;
		 end
	end

	
    // Output Logic based on State
    always @ (*) begin
        case (present_state)
            A: begin// Display Time of Day
                seg_reg0 = sec_units;
                seg_reg1 = sec_tens;
                seg_reg2 = min_units;
                seg_reg3 = min_tens;
            end
				
            B: begin// Set bake time 
                seg_reg2 = set_min_units;
                seg_reg3 = set_min_tens;
                seg_reg0 = 4'b0000;  
                seg_reg1 = 4'b0000;  
            end
				
				C: begin// Set bake temp 
					seg_reg0 = temp_cien;  
               seg_reg1 = temp_tens;  
               seg_reg2 = temp_unit;
               seg_reg3 = 4'b0000;
				end
				
				D: begin// Heating Up
					seg_reg0 = temp_cien;  
               seg_reg1 = temp_tens;  
               seg_reg2 = temp_unit;
               seg_reg3 = 4'b0000;
				end
				
				E: begin// Temp Control
					seg_reg0 = temp_cien;  
               seg_reg1 = temp_tens;  
               seg_reg2 = temp_unit;
               seg_reg3 = 4'b0000;
				end
        endcase
    end

    // Sev Seg Display
    sevseg seg0 (seg_reg0, HEX0); 
    sevseg seg1 (seg_reg1, HEX1);   
    sevseg seg2 (seg_reg2, HEX2);  
    sevseg seg3 (seg_reg3, HEX3);

endmodule