set MDIR_PATH $env(MDIR_PATH)
set PJT_PATH "$MDIR_PATH/VIVADO_PROJECT"
set SIM_RUN_TIME $env(SIM_RUN_TIME)

set today [clock seconds]
set Project_Suffix [clock format $today -format  %d_%m_%H_%M]

create_project DVCon_pjt $PJT_PATH/DVCon_PJT_nogui_$Project_Suffix -part xc7k325tffg900-2
set_property part xc7k325tffg900-2 [current_project]
set_property target_language VHDL [current_project]

# handle the locked ip issue
puts "attempting to import ip..."
if {[catch {import_ip $MDIR_PATH/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.xci} result]} {
    puts "ip import failed: $result"
    puts "attempting to upgrade existing ip..."
    # try to upgrade the ip if it exists
    if {[catch {upgrade_ip [get_ips rom_32KB_axi] -force} upgrade_result]} {
        puts "ip upgrade failed: $upgrade_result"
        puts "attempting to reset and regenerate ip..."
        # reset and regenerate the ip
        catch {reset_target all [get_ips rom_32KB_axi]}
        catch {generate_target all [get_ips rom_32KB_axi]}
    }
} else {
    puts "ip imported successfully"
}

add_files $MDIR_PATH/DVCon_SoC_SRC/AT1051_SYSTEM/AT1051_SYSTEM_TOP.v $MDIR_PATH/DVCon_SoC_SRC/TOP/Top.vhd
add_files $MDIR_PATH/DVCon_SoC_SRC/TB/test_bench.vhd

# ++ add new gemma3 accelerator ip source files ++
set ACC_IP_PATH "$MDIR_PATH/DVCon_SoC_SRC/ACC_IP_NEW"

# add the vhdl wrapper
add_files -norecurse [glob $ACC_IP_PATH/accelerator_top.vhd]

# add the verilog cores
add_files -norecurse [glob $ACC_IP_PATH/pe_int8.v]
add_files -norecurse [glob $ACC_IP_PATH/accelerator_buffer.v]
add_files -norecurse [glob $ACC_IP_PATH/output_processor.v]
add_files -norecurse [glob $ACC_IP_PATH/dequant_engine.v]
add_files -norecurse [glob $ACC_IP_PATH/systolic_array_16x16.v]
add_files -norecurse [glob $ACC_IP_PATH/gemma_accelerator.v]

update_compile_order -fileset sources_1
set_property top test_bench [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

launch_simulation -simset sim_1

# VCD setup
set VCD_FILE_SUFFIX [clock format $today -format %H_%M]
set VCD_FILE_PATH "$MDIR_PATH/GEN_BIT_OUT/sim_dump_gemma_$VCD_FILE_SUFFIX.vcd"
file mkdir $MDIR_PATH/GEN_BIT_OUT
open_vcd $VCD_FILE_PATH

# comprehensive signal logging
log_vcd -level 15 /test_bench/*
log_vcd -level 10 /test_bench/u_Top/*

# log the new gemma3 accelerator signals specifically
# log_vcd -level 8 /test_bench/u_Top/*/accelerator_top/*

# optional: log specific clock and reset signals at top level
# log_vcd /test_bench/clk_in1_p
# log_vcd /test_bench/clk_in1_n
# log_vcd /test_bench/rst
# log_vcd /test_bench/rst_led
# log_vcd /test_bench/locked_led
# log_vcd /test_bench/proc_beat

puts "VCD logging started"

run $SIM_RUN_TIME us

close_vcd
puts "logging completed - file saved to: $VCD_FILE_PATH"

