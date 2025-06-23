package require Vivado
set current_vivado_version [version -short]

proc build_2025_1 {} {

    create_project -in_memory -part xc7z020clg484-1
    set_property -dict [ list \
        BOARD_PART xilinx.com:zc702:part0:1.4 \
        SOURCE_MGMT_MODE All] [current_project]
    foreach sv [glob ../*.sv] {read_verilog -sv ${sv}}
    foreach xdc [glob -nocomplain ../*.xdc] {read_xdc ${xdc}}
    foreach bd [glob ../bd_*_2025_1.tcl] {source ${bd}}
    set bd_files [get_files -filter "NAME=~*.bd && IS_GENERATED==0"]
    set_property synth_checkpoint_mode None ${bd_files}
    generate_target all ${bd_files}
    export_ip_user_files \
        -of_objects ${bd_files} \
        -no_script -sync -force -quiet
    compile_c [get_ips]
    set top [lindex [find_top] 0]

    synth_design -top ${top} -verilog_define DEBUG=TRUE -debug_log -assert -verbose
    opt_design -debug_log -verbose
    place_design -debug_log -timing_summary -verbose
    route_design -debug_log -tns_cleanup -verbose

    set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
    set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]
    write_bitstream -force -file ${top}.bit -verbose
    write_debug_probes -force ${top}.ltx
    write_checkpoint -force ${top}.dcp
    set_property PLATFORM.NAME ${top} [current_project]
    report_property [current_design] -file properties_current_design.txt
    report_property [current_project] -file properties_current_project.txt
    report_property [get_files -filter NAME=~*.bd] -file properties_bd.txt
    write_hw_platform -include_bit -force -file ${top}.xsa
}

proc build_2024_2 {} {

    create_project -in_memory -part xc7z020clg484-1
    set_property -dict [ list \
        BOARD_PART xilinx.com:zc702:part0:1.4 \
        SOURCE_MGMT_MODE All] [current_project]
    foreach sv [glob ../*.sv] {read_verilog -sv ${sv}}
    foreach xdc [glob -nocomplain ../*.xdc] {read_xdc ${xdc}}
    foreach bd [glob ../bd_*_2024_2.tcl] {source ${bd}}
    set bd_files [get_files -filter "NAME=~*.bd && IS_GENERATED==0"]
    set_property synth_checkpoint_mode None ${bd_files}
    generate_target all ${bd_files}
    export_ip_user_files \
        -of_objects ${bd_files} \
        -no_script -sync -force -quiet
    compile_c [get_ips]
    set top [lindex [find_top] 0]

    synth_design -top ${top} -verilog_define DEBUG=TRUE -debug_log -assert -verbose
    opt_design -debug_log -verbose
    place_design -debug_log -timing_summary -verbose
    route_design -debug_log -tns_cleanup -verbose

    set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
    set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]
    write_bitstream -force -file ${top}.bit -verbose
    write_debug_probes -force ${top}.ltx
    write_checkpoint -force ${top}.dcp
    write_hw_platform -fixed -include_bit -force -file ${top}.xsa
}

proc build_2024_1 {} {

    create_project -in_memory -part xc7z020clg484-1
    set_property -dict [ list \
        BOARD_PART xilinx.com:zc702:part0:1.4 \
        SOURCE_MGMT_MODE All] [current_project]
    foreach sv [glob ../*.sv] {read_verilog -sv ${sv}}
    foreach xdc [glob -nocomplain ../*.xdc] {read_xdc ${xdc}}
    foreach bd [glob ../bd_*_2024_1.tcl] {source ${bd}}
    set bd_files [get_files -filter "NAME=~*.bd && IS_GENERATED==0"]
    set_property synth_checkpoint_mode None ${bd_files}
    generate_target all ${bd_files}
    export_ip_user_files \
        -of_objects ${bd_files} \
        -no_script -sync -force -quiet
    compile_c [get_ips]
    set top [lindex [find_top] 0]

    synth_design -top ${top} -verilog_define DEBUG=TRUE -debug_log -assert -verbose
    opt_design -debug_log -verbose
    place_design -debug_log -timing_summary -verbose
    route_design -debug_log -tns_cleanup -verbose

    set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
    set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]
    write_bitstream -force -file ${top}.bit -verbose
    write_debug_probes -force ${top}.ltx
    write_checkpoint -force ${top}.dcp
    write_hw_platform -fixed -include_bit -force -file ${top}.xsa
}

switch ${current_vivado_version} {
    2025.1 { build_2025_1 }
    2024.2 { build_2024_2 }
    2024.1 { build_2024_1 }
    default { common::send_gid_msg -ssname BD::TCL -id 1000 -severity "ERROR" " Usupported ${current_vivado_version} version of Vivado." } 
}
