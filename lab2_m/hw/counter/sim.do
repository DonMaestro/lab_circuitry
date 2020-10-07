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
vlog  hw/counter/counter.v hw/counter/counter_tb.v

# Open testbench module for simulation
vsim work.testbench

# Add all testbench signals to waveform diagram
add wave sim:/testbench/*

# Run simulation
run -all
