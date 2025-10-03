`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 12:23:36 PM
// Design Name: 
// Module Name: tb_car_safety_system
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


module tb_car_safety_system;

    reg  [15:0] sw;
    wire [15:0] led;

    // DUT
    car_safety_system dut (.sw(sw), .led(led));

    // Handy aliases for wave window / $display
    wire START_PERMIT = led[15];
    wire CHIME        = led[14];
    wire WARN_PRI2    = led[13];
    wire WARN_PRI1    = led[12];
    wire SEAT_WARN    = led[11];
    wire DOOR_WARN    = led[10];
    wire BAT_WARN     = led[7];
    wire AIRBAG_WARN  = led[6];
    wire TEMP_WARN    = led[5];

    task set_safe_defaults;
        begin
            sw = 16'b0;
            sw[15] = 1; // SB
            sw[14] = 1; // DOOR
            sw[13] = 1; // KEY
            sw[12] = 1; // BRK
            sw[11] = 1; // PARK
            sw[10] = 1; // HOOD
            sw[9]  = 1; // BAT_OK
            sw[8]  = 1; // AIB_OK
            sw[7]  = 1; // TMP_OK
            sw[6]  = 0; // PASS_OCC
            sw[5]  = 1; // SB_P (irrelevant if PASS_OCC=0)
            sw[4]  = 1; // TRUNK
            sw[3]  = 1; // PBRK
            sw[2]  = 0; // SRV off
        end
    endtask

    initial begin

        // All safe -> start allowed, no chime
        set_safe_defaults(); #10;

        // Driver not belted
        sw[15]=0; #10;

        // Door open with key -> chime
        set_safe_defaults(); sw[14]=0; #10;

        // Passenger present but unbelted
        set_safe_defaults(); sw[6]=1; sw[5]=0; #10;

        // Battery failure -> high priority
        set_safe_defaults(); sw[9]=0; #10;


        // Service mode bypass (even with faults)
        sw[2]=1; #10;

        $finish;
    end
endmodule
