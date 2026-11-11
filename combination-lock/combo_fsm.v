module combo_fsm(Clock, Resetn, Enter, Change, digit, combo, unlock, alarm, new, load_combo);

// ===== Port Declarations ===== //
input Clock;
input Resetn;
input Enter;
input Change;
input [3:0] digit;     // 4 switches for the entered code
input [3:0] combo;

output unlock;
output alarm;
output new;
output load_combo;   // new: tells reg4 to store new combo

// ===== Internal Registers ===== //
reg [2:0] y, Y;
reg [1:0] wrong_count;

// ===== State Encoding ===== //
parameter S0 = 3'b000; // 0 digits correct
parameter S1 = 3'b001; // 1 digit correct
parameter S2 = 3'b010; // 2 digits correct
parameter S3 = 3'b011; // 3 digits correct
parameter S4 = 3'b100; // 4 digits correct → UNLOCKED
parameter SA = 3'b101; // Alarm state
parameter SN = 3'b110; // New combo entry

// ===== Next-State Logic (Combinational) ===== //
always @(*) begin
    Y = y; // default: stay in current state

    // S0
    if (y == S0) begin
        if (Enter) begin
            if (digit[3] == combo[3])
                Y = S1;
            else if (wrong_count == 1)
                Y = SA;
            else
                Y = S0;
        end
        else if (Change && (digit == combo)) // old combo check
            Y = SN;
    end

    // S1
    else if (y == S1) begin
        if (Enter) begin
            if (digit[2] == combo[2])
                Y = S2;
            else if (wrong_count == 1)
                Y = SA;
            else
                Y = S0;
        end
        else if (Change && (digit == combo))
            Y = SN;
    end

    // S2
    else if (y == S2) begin
        if (Enter) begin
            if (digit[1] == combo[1])
                Y = S3;
            else if (wrong_count == 1)
                Y = SA;
            else
                Y = S0;
        end
        else if (Change && (digit == combo))
            Y = SN;
    end

    // S3
    else if (y == S3) begin
        if (Enter) begin
            if (digit[0] == combo[0])
                Y = S4;
            else if (wrong_count == 1)
                Y = SA;
            else
                Y = S0;
        end
        else if (Change && (digit == combo))
            Y = SN;
    end

    // S4: unlocked
    else if (y == S4) begin
        if (Enter)
            Y = S0; // lock again
    end

    // SN: new combo entry
    else if (y == SN) begin
        if (Enter || Change)
            Y = S0; // store new combo after Enter/Change
    end

    // SA: alarm
    else if (y == SA) begin
        Y = SA; // stays until Reset
    end
end

// ===== State Register & Wrong Counter ===== //
always @(posedge Clock or negedge Resetn) begin
    if (!Resetn) begin
        y <= S0;
        wrong_count <= 0;
    end
    else begin
        y <= Y;

        // Increment wrong_count only when a failed entry resets to S0
        if (Enter && (y <= S3) && (Y == S0))
            wrong_count <= wrong_count + 1;

        // Reset wrong_count when successful or new combo entered
        if (Y == S4 || Y == SN)
            wrong_count <= 0;
    end
end

// ===== Moore Outputs ===== //
assign unlock = (y == S4);
assign alarm  = (y == SA);
assign new    = (y == SN);

// ===== Pulse to store new combo ===== //
assign load_combo = (y == SN) && (Enter || Change);

endmodule
