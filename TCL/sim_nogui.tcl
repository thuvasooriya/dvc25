set MDIR_PATH $env(MDIR_PATH)
set PJT_PATH "$MDIR_PATH/VIVADO_PROJECT"
set SIM_RUN_TIME $env(SIM_RUN_TIME)

set today [clock seconds]
set Project_Suffix [clock format $today -format  %d_%m_%H_%M]

# start_gui
create_project DVCon_pjt $PJT_PATH/DVCon_PJT_nogui_$Project_Suffix -part xc7k325tffg900-2
set_property part xc7k325tffg900-2 [current_project]
set_property target_language VHDL [current_project]

# Handle the locked IP issue
puts "Attempting to import IP..."
if {[catch {import_ip $MDIR_PATH/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.xci} result]} {
    puts "IP import failed: $result"
    puts "Attempting to upgrade existing IP..."
    # Try to upgrade the IP if it exists
    if {[catch {upgrade_ip [get_ips rom_32KB_axi] -force} upgrade_result]} {
        puts "IP upgrade failed: $upgrade_result"
        puts "Attempting to reset and regenerate IP..."
        # Reset and regenerate the IP
        catch {reset_target all [get_ips rom_32KB_axi]}
        catch {generate_target all [get_ips rom_32KB_axi]}
    }
} else {
    puts "IP imported successfully"
}

add_files $MDIR_PATH/DVCon_SoC_SRC/AT1051_SYSTEM/AT1051_SYSTEM_TOP.v $MDIR_PATH/DVCon_SoC_SRC/TOP/Top.vhd
add_files $MDIR_PATH/DVCon_SoC_SRC/TB/test_bench.vhd
# add_files $MDIR_PATH/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.xci

# ++ Add new Gemma3 Accelerator IP source files ++
set ACC_IP_PATH "$MDIR_PATH/DVCon_SoC_SRC/ACC_IP_NEW"

# Add the VHDL Wrapper
add_files -norecurse [glob $ACC_IP_PATH/accelerator_top.vhd]

# Add the Verilog cores
add_files -norecurse [glob $ACC_IP_PATH/pe_int8.v]
add_files -norecurse [glob $ACC_IP_PATH/accelerator_buffer.v]
add_files -norecurse [glob $ACC_IP_PATH/output_processor.v]
add_files -norecurse [glob $ACC_IP_PATH/dequant_engine.v]
add_files -norecurse [glob $ACC_IP_PATH/systolic_array_16x16.v]
add_files -norecurse [glob $ACC_IP_PATH/gemma_accelerator.v]
# ----------------------------------------------

update_compile_order -fileset sources_1
set_property top test_bench [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

launch_simulation -simset sim_1
# if {[file exists $MDIR_PATH/GEN_BIT_OUT/DVCon_SoC_Simulation_Waveform.wcfg]} {
#     open_wave_config $MDIR_PATH/GEN_BIT_OUT/DVCon_SoC_Simulation_Waveform.wcfg
# }

# VCD Signal Dumping Setup
set VCD_Dump_Suffix [clock format $today -format %H_%M]
file mkdir $MDIR_PATH/GEN_BIT_OUT
open_vcd $MDIR_PATH/GEN_BIT_OUT/sim_dump_$VCD_Dump_Suffix.vcd

# Comprehensive signal logging
# Log all signals from the testbench hierarchy
log_vcd -level 5 /test_bench/*

# Log specific design hierarchy for better organization
log_vcd -level 5 /test_bench/u_Top/*

# Log the new Gemma3 accelerator signals specifically
# log_vcd -level 8 /test_bench/u_Top/*/accelerator_top/*

# Optional: Log specific clock and reset signals at top level
# log_vcd /test_bench/clk_in1_p
# log_vcd /test_bench/clk_in1_n
# log_vcd /test_bench/rst
# log_vcd /test_bench/rst_led
# log_vcd /test_bench/locked_led
# log_vcd /test_bench/proc_beat

puts "VCD logging started for DVCon SoC simulation"

run $SIM_RUN_TIME us

close_vcd
puts "VCD logging completed - file saved to: $MDIR_PATH/GEN_BIT_OUT/DVCon_SoC_simulation_dump.vcd"

