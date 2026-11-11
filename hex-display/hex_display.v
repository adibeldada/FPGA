module hex7seg(bcd, leds);

//======= Input Output Declaration =======//
	 
input [3:0] bcd;
output reg  [1:7] leds;   

//======== DATA FLOW MODEL =======//

always @(bcd)
	case (bcd)
	
		 0: leds = 7'b0000001;  // 0
       1: leds = 7'b1001111;  // 1
       2: leds = 7'b0010010;  // 2
       3: leds = 7'b0000110;  // 3
       4: leds = 7'b1001100;  // 4
       5: leds = 7'b0100100;  // 5
       6: leds = 7'b0100000;  // 6
       7: leds = 7'b0001111;  // 7
       8: leds = 7'b0000000;  // 8
       9: leds = 7'b0000100;  // 9
       10: leds = 7'b0001000; // A
       11: leds = 7'b1100000; // b
       12: leds = 7'b0110001; // C
       13: leds = 7'b1000010; // d
       14: leds = 7'b0110000; // E
       15: leds = 7'b0111000; // F

		default: leds = 7'b1111111;
	endcase
endmodule

module hex_display (Digits, Lights);

//======= Input Output Declaration =======//

input [11:0] Digits;
output [1:21] Lights;

//======== DATA FLOW MODEL =======//

hex7seg digit0 (Digits[3:0], Lights[1:7]);
hex7seg digit1 (Digits[7:4], Lights[8:14]);
hex7seg digit2 (Digits[11:8], Lights[15:21]);

endmodule

