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
#%% File Name        : DVCon_SIM.tcl                                                    	     %%
#%% Title            : DVCon SoC Simulation TCL Script   	   			                         %%
#%% Author           : HDG, CDAC Thiruvananthapuram						                         %%
#%% Description      : TCL Script for DVCon SoC vivado Simulation    		                     %%
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

add_files $MDIR_PATH/DVCon_SoC_SRC/AT1051_SYSTEM/AT1051_SYSTEM_TOP.v $MDIR_PATH/DVCon_SoC_SRC/TOP/Top.vhd
add_files $MDIR_PATH/DVCon_SoC_SRC/TB/test_bench.vhd
add_files $MDIR_PATH/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.xci

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
open_wave_config $MDIR_PATH/GEN_BIT_OUT/DVCon_SoC_Simulation_Waveform.wcfg
run $SIM_RUN_TIME us



