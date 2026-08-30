## This file is a general .xdc for the Basys3 Rev. B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]


## Push Buttons
# BTNL - Left Button - Mode
set_property PACKAGE_PIN W19 [get_ports mode_sw]
set_property IOSTANDARD LVCMOS33 [get_ports mode_sw]

# BTNU - Up Button - Start
set_property PACKAGE_PIN T18 [get_ports start_sw]
set_property IOSTANDARD LVCMOS33 [get_ports start_sw]

# BTNR - Right Button - Done
set_property PACKAGE_PIN T17 [get_ports done_sw]
set_property IOSTANDARD LVCMOS33 [get_ports done_sw]

# BTND - Down Button - Silence
set_property PACKAGE_PIN U17 [get_ports silence_sw]
set_property IOSTANDARD LVCMOS33 [get_ports silence_sw]

## Switches
# Reset - SW1
set_property PACKAGE_PIN V16 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# SW0 - Alarm Enable
set_property PACKAGE_PIN V17 [get_ports alarm_en]
set_property IOSTANDARD LVCMOS33 [get_ports alarm_en]

## 7 Segment Display
# Segments (active low)
set_property PACKAGE_PIN W7  [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

set_property PACKAGE_PIN W6  [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]

set_property PACKAGE_PIN U8  [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]

set_property PACKAGE_PIN V8  [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]

set_property PACKAGE_PIN U5  [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]

set_property PACKAGE_PIN V5  [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]

set_property PACKAGE_PIN U7  [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

# Decimal Point
set_property PACKAGE_PIN V7  [get_ports dp]
set_property IOSTANDARD LVCMOS33 [get_ports dp]

# Anodes (active low)
set_property PACKAGE_PIN U2  [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]

set_property PACKAGE_PIN U4  [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]

set_property PACKAGE_PIN V4  [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]

set_property PACKAGE_PIN W4  [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

## LEDs
# LD0 - Mode bit 0
set_property PACKAGE_PIN U16 [get_ports {led_mode[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_mode[0]}]

# LD1 - Mode bit 1
set_property PACKAGE_PIN E19 [get_ports {led_mode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_mode[1]}]

# LD2 - Mode bit 2
set_property PACKAGE_PIN U19 [get_ports {led_mode[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_mode[2]}]

# LD3 - Edit Enable
set_property PACKAGE_PIN V19 [get_ports led_edit]
set_property IOSTANDARD LVCMOS33 [get_ports led_edit]

# LD4 - Clock Enable (1Hz heartbeat)
set_property PACKAGE_PIN W18 [get_ports led_clken]
set_property IOSTANDARD LVCMOS33 [get_ports led_clken]

# LD5 - Alarm Request
set_property PACKAGE_PIN U15 [get_ports led_alarm]
set_property IOSTANDARD LVCMOS33 [get_ports led_alarm]

# LD6 - Timer Request
set_property PACKAGE_PIN U14 [get_ports led_timer]
set_property IOSTANDARD LVCMOS33 [get_ports led_timer]

# LD7 - Buzzer Active
set_property PACKAGE_PIN V14 [get_ports led_buzzer]
set_property IOSTANDARD LVCMOS33 [get_ports led_buzzer]

## Buzzer - JA PMOD Connector Pin 1
set_property PACKAGE_PIN J1  [get_ports buzzer]
set_property IOSTANDARD LVCMOS33 [get_ports buzzer]

## Configuration options
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
