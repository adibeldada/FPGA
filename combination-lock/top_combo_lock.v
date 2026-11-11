module top_combo_lock(
    input Clock,          // 50 MHz clock
    input Enter,          // Enter button
    input Change,         // Change button
    input Reset,          // Reset button
    input [3:0] SW,       // 4-bit input switches for combination
    output [1:7] HEX5     // 7-segment display output
);

// ===== Internal Wires ===== //
wire Enter_db, Change_db;            // one-clock pulses when Enter/Change are pressed
wire reset_held;                     // debounced Reset: 1 while Reset is held down
wire [3:0] combo;                    // stored combination
wire unlock, alarm, new;             // FSM outputs
wire load_combo;                     // from FSM → tells reg4 to save new combo
reg [3:0] display_code;              // 7-seg display code

// ===== Debouncers for buttons ===== //
debouncer enter_db(
    .clk(Clock),
    .btn_in(Enter),
    .btn_out(Enter_db),
    .btn_level()
);

debouncer change_db(
    .clk(Clock),
    .btn_in(Change),
    .btn_out(Change_db),
    .btn_level()
);

debouncer reset_db(
    .clk(Clock),
    .btn_in(Reset),
    .btn_out(),
    .btn_level(reset_held)
);

// ===== 4-bit register to store combination ===== //
reg4 combo_reg(
    .clock(Clock),
    .reset(reset_held),     // reg4 reset is active-high
    .load(load_combo),   // comes from FSM now, not Change button
    .data(SW),
    .combo(combo)
);

// ===== Moore FSM for combination lock ===== //
combo_fsm fsm(
    .Clock(Clock),
    .Resetn(~reset_held),   // FSM reset is active-low
    .Enter(Enter_db),
    .Change(Change_db),
    .digit(SW),
    .combo(combo),
    .unlock(unlock),
    .alarm(alarm),
    .new(new),
    .load_combo(load_combo)   // connect FSM to reg4
);

// ===== 7-segment display logic ===== //
always @(*) begin
    if (alarm)
        display_code = 4'hA; // 'A' for alarm
    else if (new)
        display_code = 4'hC; // 'n' for new combo
    else if (unlock)
        display_code = 4'hD; // 'O' for open/unlock
    else
        display_code = 4'hB; // '-' default / locked
end

lock_display display(
    .code(display_code),
    .leds(HEX5)
);

endmodule
