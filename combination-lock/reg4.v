module reg4 (clock, reset, load, data, combo);

// ===== Port Declarations ===== //
input clock;
input reset;
input load;
input [3:0] data;
output reg [3:0] combo;


// ===== Register Logic ===== //

always @(posedge clock) begin
    if (reset)
        combo <= 4'b0110;   // default combo on reset
    else if (load)
        combo <= data;         // load new combo
    // else hold
end

endmodule
