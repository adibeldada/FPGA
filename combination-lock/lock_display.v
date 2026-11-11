module lock_display(code, leds);

input  [3:0] code;
output reg [1:7] leds;

// Active-low (0 lights a segment)

always @(*) begin
    case(code)
	 
        4'hA: leds = 7'b0001000; // A = Alarm
        4'hB: leds = 7'b1111110; // "-" = idle/start
        4'hC: leds = 7'b1101010; // "n" = new code mode
        4'hD: leds = 7'b0000001; // "O" = open  

        default: leds = 7'b1111111; 
    endcase
end

endmodule
