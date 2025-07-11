set MDIR_PATH $env(MDIR_PATH)
set PJT_PATH "$MDIR_PATH/VIVADO_PROJECT"
set SIM_RUN_TIME $env(SIM_RUN_TIME)

set today [clock seconds]
set Project_Folder [clock format $today -format  %d_%m_%y-%H_%M_%S]

# start_gui
create_project DVCon_pjt $PJT_PATH/DVCon_PJT_$Project_Folder -part xc7k325tffg900-2
set_property part xc7k325tffg900-2 [current_project]
set_property target_language VHDL [current_project]

add_files $MDIR_PATH/DVCon_SoC_SRC/AT1051_SYSTEM/AT1051_SYSTEM_TOP.v $MDIR_PATH/DVCon_SoC_SRC/TOP/Top.vhd
add_files $MDIR_PATH/DVCon_SoC_SRC/TB/test_bench.vhd

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
# add_files $MDIR_PATH/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.xci

##------- Add design source files [Accelerator] ---------------

add_files -norecurse $MDIR_PATH/DVCon_SoC_SRC/ACCELERATOR_IP/Accelerator_Top.vhd
#add_files -norecurse $MDIR_PATH/DVCon_SoC_SRC/ACCELERATOR_IP/Accelerator_Top.v

add_files $MDIR_PATH/DVCon_SoC_SRC/ACCELERATOR_IP/axi_acc_dwidth_converter_0/axi_acc_dwidth_converter_0.xci

add_files $MDIR_PATH/DVCon_SoC_SRC/ACCELERATOR_IP/matrix_multiply_64.v

##-------------------------------------------------------------

update_compile_order -fileset sources_1
set_property top test_bench [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

launch_simulation -simset sim_1

# VCD setup
set VCD_FILE_SUFFIX [clock format $today -format %H_%M]
set VCD_FILE_PATH "$MDIR_PATH/GEN_BIT_OUT/sim_dump_cdac_$VCD_FILE_SUFFIX.vcd"
file mkdir $MDIR_PATH/GEN_BIT_OUT
open_vcd $VCD_FILE_PATH

# comprehensive signal logging
log_vcd -level 15 /test_bench/*
log_vcd -level 10 /test_bench/u_Top/*

puts "VCD logging started"

run $SIM_RUN_TIME us

close_vcd
puts "logging completed - file saved to: $VCD_FILE_PATH"
