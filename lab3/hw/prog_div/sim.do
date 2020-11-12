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
vlog  hw/prog_div/prog_div.v hw/prog_div/prog_div_tb.v

# Open testbench module for simulation
vsim work.testbench

# Add all testbench signals to waveform diagram
add wave sim:/testbench/*
add wave sim:/testbench/prog_div_inst/cnt_ff
add wave sim:/testbench/prog_div_inst/div_const_ff
add wave sim:/testbench/prog_div_inst/preload_cnt

onbreak resume

# Run simulation
run -all

wave zoom full
