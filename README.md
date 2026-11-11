# FPGA Labs: Combination Lock and 7-Segment Display

Verilog projects for the DE1-SoC board (Intel Cyclone V), built in Quartus Prime 23.1 for McMaster SFWRENG 2DA4 (Digital Systems and Interfacing).

## Combination Lock (`combination-lock/`)

A 4-bit combination lock driven by a Moore finite-state machine.

- **Enter** checks the code one bit at a time against the switches. After all 4 bits match, the lock opens.
- **2 wrong tries** set off the alarm, which stays on until **Reset**.
- **Change** (with the current code on the switches) enters "new code" mode, and the next Enter saves the new code.
- Button presses are debounced (~20 ms at 50 MHz) and synchronized to the clock.

The display (HEX5) shows the state: `-` locked, `n` new code, `O` open, `A` alarm.

| File | What it does |
|---|---|
| `top_combo_lock.v` | Top-level module that connects the buttons, switches, register, FSM, and display |
| `combo_fsm.v` | Moore FSM: states for 0 to 4 correct bits, alarm, and new-code mode |
| `reg4.v` | 4-bit register that stores the code (defaults to `0110` on reset) |
| `debouncer.v` | Cleans up button bounce and outputs one pulse per press |
| `lock_display.v` | Turns the lock state into a 7-segment pattern |

## 7-Segment Display (`hex-display/`)

`hex_display.v` decodes a 12-bit number into three hexadecimal digits (0 to F) on three 7-segment displays, using three copies of a `hex7seg` decoder.

## How to run

Open the `.qpf` file in Quartus Prime, assign the pins for your board in Pin Planner (clock, KEY buttons, switches, HEX displays), then compile and program the board.
