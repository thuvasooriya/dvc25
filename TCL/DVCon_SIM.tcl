#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
#%%                      Centre for Development of Advanced Computing                            %%
#%%                          Vellayambalam, Thiruvananthapuram.                                  %%
#%%==============================================================================================%%
#%% This confidential and proprietary software may be used only as authorised by a licensing     %%
#%% agreement from Centre for Development of Advanced Computing, India (C-DAC).In the event of   %%
#%% publication, the following notice is applicable:                                             %%
#%% Copyright (c) 2025 C-DAC                                                                     %%
#%% ALL RIGHTS RESERVED                                                                          %%
#%% The entire notice above must be reproduced on all authorised copies.                         %%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%% File Name        : DVCon_SIM.tcl                                                             %%
#%% Title            : DVCon SoC Simulation TCL Script                                           %%
#%% Author           : HDG, CDAC Thiruvananthapuram                                              %%
#%% Description      : TCL Script for DVCon SoC vivado Simulation                                %%
#%% Version          : 00                                                                        %%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%% Modification / Updation  History %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%    Date                By              Version          Change Description                   %%
#%%                                                                                              %%
#%%                                                                                              %%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

set MDIR_PATH $env(MDIR_PATH)
set PJT_PATH "$MDIR_PATH/VIVADO_PROJECT"
set SIM_RUN_TIME $env(SIM_RUN_TIME)

set today [clock seconds]
set Project_Folder [clock format $today -format  %d_%m_%y-%H_%M_%S]

start_gui
create_project DVCon_pjt $PJT_PATH/DVCon_PJT_$Project_Folder -part xc7k325tffg900-2
set_property part xc7k325tffg900-2 [current_project]
set_property target_language VHDL [current_project]

# Handle the locked IP issue
puts "attempting to import ip..."
if {[catch {import_ip $MDIR_PATH/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.xci} result]} {
    puts "ip import failed: $result"
    puts "attempting to upgrade existing ip..."
    # Try to upgrade the IP if it exists
    if {[catch {upgrade_ip [get_ips rom_32KB_axi] -force} upgrade_result]} {
        puts "ip upgrade failed: $upgrade_result"
        puts "attempting to reset and regenerate ip..."
        # Reset and regenerate the IP
        catch {reset_target all [get_ips rom_32KB_axi]}
        catch {generate_target all [get_ips rom_32KB_axi]}
    }
} else {
    puts "ip imported successfully"
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
if {[file exists $MDIR_PATH/GEN_BIT_OUT/DVCon_SoC_Simulation_Waveform.wcfg]} {
    open_wave_config $MDIR_PATH/GEN_BIT_OUT/DVCon_SoC_Simulation_Waveform.wcfg
}

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

puts "VCD logging started"

run $SIM_RUN_TIME us

close_vcd
puts "logging completed - file saved to: $MDIR_PATH/GEN_BIT_OUT/sim_dump_$VCD_Dump_Suffix.vcd"

