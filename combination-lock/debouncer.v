module debouncer(clk, btn_in, btn_out, btn_level);

// ===== Port Declarations ===== //
input clk;            // FPGA clock (50 MHz)
input btn_in;         // raw button input (DE1-SoC KEYs are active-low: 0 = pressed)
output reg btn_out;   // one-clock pulse when the button is PRESSED (not on release)
output btn_level;     // debounced level: 1 while the button is held down

// ===== Parameters ===== //
parameter DEBOUNCE_MAX = 20'd1_000_000; // ~20 ms at 50 MHz
parameter ACTIVE_LOW   = 1;             // set to 0 for an active-high button or switch

// ===== Internal Registers ===== //
reg [19:0] count     = 20'd0; // how long the input has been stable in its new state
reg        btn_sync_0 = 1'b0;
reg        btn_sync_1 = 1'b0;
reg        btn_state  = 1'b0; // debounced "pressed" state (1 = pressed)

initial btn_out = 1'b0;

// Convert to "1 = pressed" no matter how the button is wired
wire pressed_raw = ACTIVE_LOW ? ~btn_sync_1 : btn_sync_1;

// ===== Synchronize button to clock (avoids metastability) ===== //
always @(posedge clk) begin
    btn_sync_0 <= btn_in;
    btn_sync_1 <= btn_sync_0;
end

// ===== Debounce Logic ===== //
always @(posedge clk) begin
    btn_out <= 1'b0; // default: no pulse

    if (pressed_raw != btn_state) begin
        count <= count + 1'b1;

        // Input stayed in its new state long enough -> accept it
        if (count >= DEBOUNCE_MAX) begin
            btn_state <= pressed_raw;
            count     <= 20'd0;
            if (pressed_raw)
                btn_out <= 1'b1; // pulse once, only when pressed
        end
    end
    else begin
        count <= 20'd0;   // bounced back -> start counting again
    end
end

assign btn_level = btn_state;

endmodule
