
set outdir [pwd]
set datadir [pwd]/DATA/spice

# Set Corner
set VDD 0.8
set VSS 0.0

set_vdd VDD 0.8
set_gnd VSS 0
set_gnd VBSTN [expr $VDD * -0.125]
set_vdd VBSTP [expr $VDD * 1.125]
set_gnd -no_model -type nwell NW_BC $VSS
set_gnd -no_model -type deepnwell NW_N $VSS
set_gnd -no_model -type pwell PW_BC $VSS
set_gnd -no_model -type deeppwell PW_P $VSS
set_vdd VREFBL $VDD

#set_gnd vss -0.33

set_operating_condition -voltage $VDD -temp 85

source ./tcl/rail_gnd.tcl
source ./tcl/rail_vdd.tcl



# set_pin_vdd -supply_name vrefbl_sup vrefbl 0.8
# set_pin_vdd -supply_name vrep_sup vrep 0.8
# set_pin_vdd -supply_name vrefcp_sup vrefcp 0.4
# set_pin_vdd -supply_name vboost_sup vboost 0.96

#set_vdd -virtual I0.ARRAY_256x512/array256x256\<1\>/BC256x256/bl* $VDD
#set_vdd -virtual I0.ARRAY_256x512/array256x256\<0\>/BC256x256/bl* $VDD
#set_gnd vneg -0.2

#set_var supply_info 1 


#set_var extsim_model_include "/project/galileo/users/hwangh/ws/galileo_Liberate_test/DATA/spice/models/models_ss.scs"
set_var extsim_model_include ${datadir}/include_models_tt
set_var extsim_deck_include 1
set_var mx_require_whitebox_model_file 0
#set_var extsim_deck_header ".hdl /project/galileo/gdp/workspaces/hwangh_galileo_A0_dev/OA/tsmcN5_mim/gcrammimcap/veriloga/veriloga.va"

# Define Leafcells
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L spvnfetpd
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L spvnfetwl
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L spvpfetpu
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L hvtnfet
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L hvtpfet
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L hvtnfet_auxpc2
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L hvtpfet_auxpc2
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L hvtnfet_cnrx
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L hvtpfet_cnrx
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L nfet
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L pfet
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L nfet_auxpc2
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L pfet_auxpc2
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L nfet_cnrx
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L pfet_cnrx
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L lvtnfet
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L lvtpfet
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L lvtnfet_auxpc2
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L lvtpfet_auxpc2
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L lvtnfet_cnrx
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L lvtpfet_cnrx
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L slvtnfet
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L slvtpfet
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L slvtnfet_auxpc2
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L slvtpfet_auxpc2
define_leafcell -type nmos_soi -pin_position {0 1 2 3} -width W -length L slvtnfet_cnrx
define_leafcell -type pmos_soi -pin_position {0 1 2 3} -width W -length L slvtpfet_cnrx
define_leafcell -type diode -pin_position {0 1} diodenwx
define_leafcell -type diode -pin_position {0 1} diodepwtw
define_leafcell -type diode -pin_position {0 1} diodetwx
define_leafcell -type c -pin_position {0 1 2} parancap
define_leafcell -type c -pin_position {0 1 2} parapcap
#define_leafcell -type c -pin_position {0 1 2} esdopnpcres_va
#define_leafcell -type c -pin_position {0 1 2} esdreopnpcres_va


#Forces Liberate to use .inc SPICE command to load cell netlist when define_leafcell command exists
#set_var extsim_flatten_netlist 0 
set_var mx_extsim_process_netlist_cmd "qreduce -cpu 32 -rc_threshold 0.1 -c_threshold 0.01e-15 -log %L -out %O %I"
set_var mx_debug "arc top_level"
#define_leafcell -type nmos_soi -pin_position {0 1 2 3} nch_mpodesvt_mac
#define_leafcell -type pmos_soi -pin_position {0 1 2 3} pch_mpodesvt_mac
#define_leafcell -type nmos_soi -pin_position {0 1 2 3} nch_mpodelvt_mac
#define_leafcell -type pmos_soi -pin_position {0 1 2 3} pch_mpodelvt_mac
#define_leafcell -type nmos_soi -pin_position {0 1 2 3} nch_mpodehvt_mac
#define_leafcell -type pmos_soi -pin_position {0 1 2 3} pch_mpodehvt_mac
#define_leafcell -type nmos_soi -pin_position {0 1 2 3} nch_mpodeulvt_mac
#define_leafcell -type pmos_soi -pin_position {0 1 2 3} pch_mpodeulvt_mac
# define_leafcell ppode_hvt_mac
# define_leafcell npode_hvt_mac
# define_leafcell ppode_svt_mac
# define_leafcell npode_svt_mac
# define_leafcell npode_ulvt_mac


#define_leafcell -type c -pin_position {0 1} gcrammimcap
#define_leafcell -type c -pin_position {0 1} cfmom_2t_p80
#define_leafcell -type c -pin_position {0 1} MiM_CAP
# Set Directories
set_var tmpdir [pwd]/tmp_dir ; exec mkdir -p [pwd]/tmp_dir ;
set_var mx_dir ${outdir}/mx
set_var extsim_deck_dir ${outdir}/decks
set_var ski_enable 0
set_var extsim_save_passed all
set_var extsim_save_failed all
set_var extsim_tar_cmd ""

# Set Characterization Options
set_var mx_simulation_interval 20e-9
set_var mx_power_window_ratio 0.5
set_var mx_push_probe_inside_array 1
set_var supply_define_mode 1

set_var mx_fastsim_reuse 1
set_var mx_find_memcores 1
set_var mx_check_arcs 1
#set_var add_margin_info 1
set_var mx_probes_report probes.rpt
set_var mx_skip_print "*"
#set_var mx_xps_inc_str .dspf_include 
set_var parse_leafcells_without_model 1
#set_var char_mos_term_cap_skip_names "nch_flrlvt_mac nch_flrlvtll_mac nch_flrsvt_mac nch_flrulvt_mac nch_lvt_mac nch_lvtll_mac nch_mpodelvt_mac nch_mpodelvtll_mac nch_mpodesvt_mac nch_mpodeulvt_mac nch_svt_mac nch_ulvt_mac npode_lvtll_mac npode_svt_mac pch_flrlvt_mac pch_flrlvtll_mac pch_flrsvt_mac pch_flrulvt_mac pch_lvt_mac pch_lvtll_mac pch_mpodelvt_mac pch_mpodelvtll_mac pch_mpodesvt_mac pch_mpodeulvt_mac pch_svt_mac pch_ulvt_mac ppode_lvtll_mac ppode_svt_mac nch_flrulvtll_mac nch_mpodeulvtll_mac nch_ulvtll_mac npode_ulvtll_mac"

set_message -id {LIBMX-915} -msg_limit 5
#set_var mx_greybox 1


#power and leakage
#only include power dissipated via the positive power supplies
set_var pin_based_power 0
#voltage_map 1 is recommended for power characterization 
set_var voltage_map 1

set_var reset_negative_power 0
set_var mx_use_negative_power 1

set_var mx_leakage_measure_final 1
set_var duplicate_risefall_power 0
set_var simultaneous_switch_from_cell_when 3
#the codes below are not effective !!! (From cadence team)
# set_var power_info 2
# set_var power_info_filename ${outdir}/power_log
# set_var power_subtract_leakage 2
# set_var power_subtract_output_load all
set_var leakage_add_input_pin 0
set_var leakage_mode 1
#the codes below are not effective !!! (From cadence team)
# set_var leakage_sim_duration 1.4e-06
# set_var subtract_hidden_power 2
set_var mx_power_leakage_report 1

# Partition 
set_var mx_switch_wire_threshold [expr $VDD /3]
set_var mx_monitor_memcore inter
set_var mx_monitor_memcore_lprobe_level [expr $VDD/2]
set_var mx_find_virtual_rails 2
#set_var mx_virtual_rail_waveform_shift_threshold 0.5
#set_var virtual_rail_waveform_probe "worst"
#set_var mx_probe_real_rails_as_virtual "true"
set_var extsim_use_node_name 1
set_var mx_pincap_char 0
#set_var mx_verify_table 1
set_var mx_timing_report 1
#set_var mx_zip_partition_deck 1

#mpw and min_period
set_var mx_mpw_probe "seq comb"
set_var mx_mpw_mode "edge_intersection master_latch_output"
set_var mx_min_period_mode "latch bitline_precharge internal_pulse"
set_var mx_auto_minp_eq_mpw_h_plus_l 0

# Set Thresholds 
set_var constraint_probe_lower_rise 0.2
set_var constraint_probe_upper_rise 0.8
set_var constraint_probe_lower_fall 0.2
set_var constraint_probe_upper_fall 0.8
set_var mx_mpw_probe_lower_rise 0.2
set_var mx_mpw_probe_upper_rise 0.8
set_var mx_mpw_probe_lower_fall 0.2
set_var mx_mpw_probe_upper_fall 0.8

#########################################################
#fastsim settings
#set_var fastsim_cmd "spectre"
#set_var fastsim_cmd_option "-64 +spice +xps +cktpreset=sram"
#set_var fastsim_cmd_option "+fx +baseax +mt=4 +spice -format fsdb +lqtimeout 0"
#set_var fastsim_cmd_option " +aps +postlayout +errpreset=liberal +mt=32 +spice -format fsdb +lqtimeout 0"
#set_var fastsim_cmd_option "-64 +spice +xps +cktpreset=sram_pwr -f sst2"
set_var fastsim_cmd_option "+fx +preset=mx +mt=4 +spice -format fsdb +lqtimeout 0"

#set_var fastsim_cmd_option "+fx +preset=mx -mt +spice -format sst2 +lqtimeout 0"


#set_var fastsim_cmd_option "+xps +cktpreset=sram +mx +mt=4 +spice -format fsdb +lqtimeout 0"
#set_var fastsim_cmd_option "+xps +cktpreset=sram +mx +mt=28 +spice -format fsdb +lqtimeout 0"
####table based fastsim_cmd_option will overwirte what defined in mx.tcl
#########################################################


# If two subcircuits are found in models: 1-use the first one, 2-use the second one
set_var parse_ignore_duplicate_subckt 2
# if the tool has missing leafcell, it will give you a warning 


# Source in Template File
#source ./tcl/template_all_arcs.tcl
source ./tcl/template_retaindelay.tcl


# Read in the Netlist
#read_spice -format spectre -parser sfe ${datadir}/galileo_netlist_toplevel.scs
#read_spice -format spectre -parser sfe ${datadir}/petrav4_schematic.scs
#read_spice -format spectre -parser sfe ${datadir}/voyager_netlist_schematic_new.scs
#read_spice -format spectre -parser sfe ${datadir}/include_models_ff
read_spice -format spice ${datadir}/gcram3tsp686n512x532m1sb_RCC_nominal.dspf
#read_spice -format spectre -parser sfe ${datadir}/gcram3tsp686n512x532m1sb_netlist.scs
#read_spice "/Customers3/RAAAM/project/voyager/gdp/workspaces/DSPF/lib_test/gcram3tsp686n512x532m1sb_CC_typical_1a.dspf"
#read_spice -format spectre -parser sfe ${datadir}/voyager_netlist_schematic_forlvftest.scs


mx_set_spectre_param {  {soft_bin allmodels} }
#mx_report_supply_current -name curr_dynamic_peak_vdd -supply_pin VDD -power_type peak -table {./DATA/tables/power.tbl} gcram3tsp686n512x532m1sb
#mx_report_supply_current -name curr_dynamic_average_vdd -supply_pin VDD -power_type average -table {./DATA/tables/power.tbl} gcram3tsp686n512x532m1sb


# Define Table Files

#define_table {./DATA/tables/constraint.tbl ./DATA/tables/delay.tbl ./DATA/tables/measure.tbl ./DATA/tables/power.tbl ./DATA/tables/leakage.tbl} gcram3tsp686n512x532m1sb_extsup

#define_table {./DATA/tables/constraint.tbl ./DATA/tables/delay.tbl} gcram3tsp686n512x532m1sb_extsup
define_table "./DATA/tables/delay.tbl" gcram3tsp686n512x532m1sb
#define_table {./DATA/tables/constraint.tbl} gcram3tsp686n512x532m1sb_extsup
#######################################
set_var heartbeat_timeout 7200
set_var packet_client_health_checks 1
#######################################
# Set Job Settings for bolt flow
#######################################


#######################################
# Set Job Settings for bolt flow
#######################################



# 3. Bottom-Level (Partition) Simulation Settings
# How many parallel jobs for bottom-level charsim

# The submission command for bottom-level jobs. 
# Added '-L /bin/bash' to ensure the LSF job runs in a bash environment.
#set_var rsh_cmd "submitjob -q normal -n 8 --mem 5 -j LIBERATE "
# set_var packet_arc_job_manager bolt
# set_var packet_rsh_mode sge
# set_var packet_mode arc
# set_var packet_client_health_checks 1
# set_var packet_arcs_per_thread 2
# set_var packet_clients 2
# set_var bolt_rsh_cmd_use_arrays false
# set_var rsh_cmd "submitjob --outlikesge -q normal -n 16 --mem 64 -j LIBERATE "
# set_var bolt_connection_retry_timeout 600

# # The submission command for top-level jobs (often requires more CPUs/Memory).
# set_var -stage top_level rsh_cmd "submitjob --outlikesge -q normal -n 4 --mem 64 -j LIBERATE "
# #set_var -stage top_level rsh_cmd "qsub -V -j oe -q normal -P atlas -N LIBERATE -l -l instance_type=r6a.xlarge+r6i.xlarge+r5.xlarge,ncpus=2,mem=20Gb -- "


# # 5. Recommended Bolt Timeouts
# set_var packet_client_timeout 35000
# set_var packet_client_timeout_action "error"
# set_var bolt_connection_timeout 30



#########################################################
# Spectre Command and Options
#########################################################
#set_var extsim_cmd_option "-64 +fx +mt=16 +spice +preset=basemx -format fsdb +lqtimeout 0"
set_var extsim_cmd_option "-64 +mt=32 +spice +preset=mx -format fsdb +lqtimeout 0"
set_var spectre_use_char_opt_license 0
set_var spectre_use_mmsim_token_license 0
set_var packet_require_spectre_char_opt 0

set_var extsim_option "print_mode=1"

#add_margin -type delay -abs 50e-12 
#add_margin -type constraint -abs 50e-12 

puts ""; puts "######## Running char_macro command ########";
# char_macro -ccs -ccsn -partthread 6 -charthread 10 -charsim "spectre"  -partsim "spectre" 
char_macro -partthread 2 -charthread 2 -charsim "spectre"  -partsim "spectre" 

# Write out LDB and Lib files
write_ldb -overwrite ${outdir}/LDB/gcram3tsp686n512x532m1sb.ldb

#write_library -ccs -ccsn -overwrite -filename ${outdir}/LIBS/gcram3tsp686n512x532m1sb_extsup.cc6.lib gcram3tsp686n512x532m1sb_extsup
write_library -overwrite -filename ${outdir}/LIBS/gcram3tsp686n512x532m1sb_delay_tt85_Typical_clean.lib gcram3tsp686n512x532m1sb

