
module off_clock(
input clock, 
//output reg minutes,
output reg new_clock);

parameter MAX_COUNT = 25000000;

reg [24:0] count = 0;

    always @ (posedge clock) begin
        if (count < MAX_COUNT) begin
            count <= count + 1;
        end
        else begin
            count <= 0;
            new_clock = ~new_clock;
        end
    end

endmodule

