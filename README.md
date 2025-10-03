# Lab-4-Vehicle-Safety-Interlock-Warning-System

## Project Description
This project implements a Vehicle Safety Interlock and Warning System on the Basys3 FPGA using Verilog.  
The system models real-world automotive logic to determine conditions such as:  
- Can the engine be started (`START_PERMIT`)?  
- Should the chime sound (`CHIME`)?  
- Which safety warnings should be activated (seatbelt, door, hood, trunk, battery, airbag, temperature)?  

The design is purely combinational (no clocks or memory) and uses the FPGA board’s switches (SW15–SW3) as input sensors, with LEDs (LED15–LED5) as outputs for start permissions and warning indicators.  

---

## Simulation Instructions
1. Open Vivado and create a new project.  
2. Add the source file:  
   - `car_safety_system.v`  
3. Add the testbench:  
   - `tb_car_safety_system.v`  
4. Run **Behavioral Simulation**.  
   - Verify outputs (`START_PERMIT`, `CHIME`, warnings) change correctly for different input switch combinations.  
   - Example test:  
     - All conditions OK → `START_PERMIT=1`  
     - Passenger present, no seatbelt → `SEAT_WARN=1`  
     - Battery not OK → `BAT_WARN=1` and `WARN_PRI1=1`  

---

## FPGA Implementation Instructions
1. Assign FPGA pins on the Basys3 board:  

   **Inputs (Switches):**  
   - SW15 → Driver Seatbelt (SB)  
   - SW14 → Driver Door Closed (DOOR)  
   - SW13 → Key Inserted (KEY)  
   - SW12 → Brake Pedal (BRK)  
   - SW11 → Gear in Park (PARK)  
   - SW10 → Hood Closed (HOOD)  
   - SW9  → Battery OK (BAT_OK)  
   - SW8  → Airbag OK (AIB_OK)  
   - SW7  → Coolant Temp OK (TMP_OK)  
   - SW6  → Passenger Seat Occupied (PASS_OCC)  
   - SW5  → Passenger Seatbelt (SB_P)  
   - SW4  → Trunk Closed (TRUNK)  
   - SW3  → Parking Brake Engaged (PBRK)  

   **Outputs (LEDs):**  
   - LED15 → START_PERMIT (green)  
   - LED14 → CHIME  
   - LED13 → WARN_PRI2  
   - LED12 → WARN_PRI1  
   - LED11 → SEAT_WARN  
   - LED10 → DOOR_WARN  
   - LED9  → HOOD_WARN  
   - LED8  → TRUNK_WARN  
   - LED7  → BAT_WARN  
   - LED6  → AIRBAG_WARN  
   - LED5  → TEMP_WARN  

2. Run **Synthesis → Implementation → Generate Bitstream** in Vivado.  
3. Program the Basys3 board with the generated bitstream.  
4. Verify functionality:  
   - Example: Set SW15=1, SW14=1, SW13=1, SW12=1, SW11=1, others OK → `START_PERMIT=1`.  
   - Example: Set SW6=1, SW5=0 → `SEAT_WARN=1`.  
   - Example: Set SW9=0 → `BAT_WARN=1` and `WARN_PRI1=1`.  

---
