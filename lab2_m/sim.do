###########################
# Simple modelsim do file #
###########################

# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog  hw/simple_sin_gen/sin_gen.v hw/simple_sin_gen/sin_gen_tb.v

# Open testbench module for simulation

vsim work.testbench

# Add all testbench signals to waveform diagram

add wave /testbench/i_clk
add wave /testbench/i_rst_n
add wave -format Analog-Step -height 84 -max 255.0 -radix unsigned /testbench/o_dac

onbreak resume

# Run simulation
run -all

wave zoom full


