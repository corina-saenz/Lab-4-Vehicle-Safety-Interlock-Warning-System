`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 12:11:59 PM
// Design Name: 
// Module Name: car_safety_system
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module car_safety_system(
    input [15:0] sw,
    output [15:0] led
    );
    
    wire SB       = sw[15]; // driver seatbelt fastened
    wire DOOR     = sw[14]; // driver door closed
    wire KEY      = sw[13]; // key inserted
    wire BRK      = sw[12]; // brake pedal pressed
    wire PARK     = sw[11]; // gear in Park
    wire HOOD     = sw[10]; // hood closed
    wire BAT_OK   = sw[9];  // battery OK
    wire AIB_OK   = sw[8];  // airbag OK
    wire TMP_OK   = sw[7];  // coolant temp OK
    wire PASS_OCC = sw[6];  // passenger seat occupied
    wire SB_P     = sw[5];  // passenger seatbelt fastened
    wire TRUNK    = sw[4];  // trunk closed
    wire PBRK     = sw[3];  // parking brake engaged
    wire SRV      = sw[2];  // service mode bypass (jumper or switch)
    // sw[1:0] unused

    
    wire SEAT_WARN   = (~SB) | (PASS_OCC & ~SB_P); // driver belt OR passenger unbelted
    wire DOOR_WARN   = ~DOOR;                      // door open
    wire HOOD_WARN   = ~HOOD;                      // hood open
    wire TRUNK_WARN  = ~TRUNK;                     // trunk open
    wire BAT_WARN    = ~BAT_OK;                    // battery fault
    wire AIRBAG_WARN = ~AIB_OK;                    // airbag fault
    wire TEMP_WARN   = ~TMP_OK;                    // over-temp

    
    wire CHIME = KEY & (SEAT_WARN | DOOR_WARN); //If key is inserted and either seat warning or door warning is on, then chime is on

    //If everything's ok/safe start is allowed
    wire START_PERMIT = SRV ? 1'b1 : (
        SB & DOOR & KEY & BRK & PARK &
        HOOD & BAT_OK & AIB_OK & TMP_OK &
        TRUNK & PBRK
    );

    wire WARN_PRI1 = BAT_WARN | AIRBAG_WARN; //highest priority warnings
    wire WARN_PRI2 = SEAT_WARN | DOOR_WARN | HOOD_WARN | TRUNK_WARN | TEMP_WARN; //other important warnings

    assign led[15] = START_PERMIT; // LED15
    assign led[14] = CHIME;        // LED14
    assign led[13] = WARN_PRI2;    // LED13
    assign led[12] = WARN_PRI1;    // LED12
    assign led[11] = SEAT_WARN;    // LED11
    assign led[10] = DOOR_WARN;    // LED10
    assign led[9]  = HOOD_WARN;    // LED9
    assign led[8]  = TRUNK_WARN;   // LED8
    assign led[7]  = BAT_WARN;     // LED7
    assign led[6]  = AIRBAG_WARN;  // LED6
    assign led[5]  = TEMP_WARN;    // LED5

    // Keep unused LEDs off
    assign led[4:0] = 5'b00000;

endmodule
