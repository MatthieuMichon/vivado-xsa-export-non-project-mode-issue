
################################################################
# This is a generated script based on design: bd_ps
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source bd_ps_2025_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART xilinx.com:zc702:part0:1.4 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd_ps

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:processing_system7:5.5\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [list \
    CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
    CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
    CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
    CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
    CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
    CONFIG.PCW_CLK0_FREQ {10000000} \
    CONFIG.PCW_CLK1_FREQ {10000000} \
    CONFIG.PCW_CLK2_FREQ {10000000} \
    CONFIG.PCW_CLK3_FREQ {10000000} \
    CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
    CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_EN_CAN0 {0} \
    CONFIG.PCW_EN_CLK0_PORT {0} \
    CONFIG.PCW_EN_EMIO_TTC0 {0} \
    CONFIG.PCW_EN_ENET0 {0} \
    CONFIG.PCW_EN_GPIO {1} \
    CONFIG.PCW_EN_I2C0 {1} \
    CONFIG.PCW_EN_QSPI {0} \
    CONFIG.PCW_EN_RST0_PORT {0} \
    CONFIG.PCW_EN_SDIO0 {0} \
    CONFIG.PCW_EN_TTC0 {0} \
    CONFIG.PCW_EN_UART1 {1} \
    CONFIG.PCW_EN_USB0 {0} \
    CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
    CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
    CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
    CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51} \
    CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_I2C0_RESET_ENABLE {1} \
    CONFIG.PCW_I2C0_RESET_IO {MIO 13} \
    CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_I2C_RESET_ENABLE {1} \
    CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_0_PULLUP {enabled} \
    CONFIG.PCW_MIO_0_SLEW {slow} \
    CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_10_PULLUP {enabled} \
    CONFIG.PCW_MIO_10_SLEW {slow} \
    CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_11_PULLUP {enabled} \
    CONFIG.PCW_MIO_11_SLEW {slow} \
    CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_12_PULLUP {enabled} \
    CONFIG.PCW_MIO_12_SLEW {slow} \
    CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_13_PULLUP {enabled} \
    CONFIG.PCW_MIO_13_SLEW {slow} \
    CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_14_PULLUP {enabled} \
    CONFIG.PCW_MIO_14_SLEW {slow} \
    CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_15_PULLUP {enabled} \
    CONFIG.PCW_MIO_15_SLEW {slow} \
    CONFIG.PCW_MIO_16_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_16_PULLUP {disabled} \
    CONFIG.PCW_MIO_16_SLEW {slow} \
    CONFIG.PCW_MIO_17_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_17_PULLUP {disabled} \
    CONFIG.PCW_MIO_17_SLEW {slow} \
    CONFIG.PCW_MIO_18_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_18_PULLUP {disabled} \
    CONFIG.PCW_MIO_18_SLEW {slow} \
    CONFIG.PCW_MIO_19_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_19_PULLUP {disabled} \
    CONFIG.PCW_MIO_19_SLEW {slow} \
    CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_1_PULLUP {enabled} \
    CONFIG.PCW_MIO_1_SLEW {slow} \
    CONFIG.PCW_MIO_20_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_20_PULLUP {disabled} \
    CONFIG.PCW_MIO_20_SLEW {slow} \
    CONFIG.PCW_MIO_21_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_21_PULLUP {disabled} \
    CONFIG.PCW_MIO_21_SLEW {slow} \
    CONFIG.PCW_MIO_22_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_22_PULLUP {disabled} \
    CONFIG.PCW_MIO_22_SLEW {slow} \
    CONFIG.PCW_MIO_23_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_23_PULLUP {disabled} \
    CONFIG.PCW_MIO_23_SLEW {slow} \
    CONFIG.PCW_MIO_24_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_24_PULLUP {disabled} \
    CONFIG.PCW_MIO_24_SLEW {slow} \
    CONFIG.PCW_MIO_25_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_25_PULLUP {disabled} \
    CONFIG.PCW_MIO_25_SLEW {slow} \
    CONFIG.PCW_MIO_26_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_26_PULLUP {disabled} \
    CONFIG.PCW_MIO_26_SLEW {slow} \
    CONFIG.PCW_MIO_27_IOTYPE {HSTL 1.8V} \
    CONFIG.PCW_MIO_27_PULLUP {disabled} \
    CONFIG.PCW_MIO_27_SLEW {slow} \
    CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_28_PULLUP {disabled} \
    CONFIG.PCW_MIO_28_SLEW {slow} \
    CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_29_PULLUP {disabled} \
    CONFIG.PCW_MIO_29_SLEW {slow} \
    CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_2_SLEW {slow} \
    CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_30_PULLUP {disabled} \
    CONFIG.PCW_MIO_30_SLEW {slow} \
    CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_31_PULLUP {disabled} \
    CONFIG.PCW_MIO_31_SLEW {slow} \
    CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_32_PULLUP {disabled} \
    CONFIG.PCW_MIO_32_SLEW {slow} \
    CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_33_PULLUP {disabled} \
    CONFIG.PCW_MIO_33_SLEW {slow} \
    CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_34_PULLUP {disabled} \
    CONFIG.PCW_MIO_34_SLEW {slow} \
    CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_35_PULLUP {disabled} \
    CONFIG.PCW_MIO_35_SLEW {slow} \
    CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_36_PULLUP {disabled} \
    CONFIG.PCW_MIO_36_SLEW {slow} \
    CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_37_PULLUP {disabled} \
    CONFIG.PCW_MIO_37_SLEW {slow} \
    CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_38_PULLUP {disabled} \
    CONFIG.PCW_MIO_38_SLEW {slow} \
    CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_39_PULLUP {disabled} \
    CONFIG.PCW_MIO_39_SLEW {slow} \
    CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_3_SLEW {slow} \
    CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_40_PULLUP {disabled} \
    CONFIG.PCW_MIO_40_SLEW {slow} \
    CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_41_PULLUP {disabled} \
    CONFIG.PCW_MIO_41_SLEW {slow} \
    CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_42_PULLUP {disabled} \
    CONFIG.PCW_MIO_42_SLEW {slow} \
    CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_43_PULLUP {disabled} \
    CONFIG.PCW_MIO_43_SLEW {slow} \
    CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_44_PULLUP {disabled} \
    CONFIG.PCW_MIO_44_SLEW {slow} \
    CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_45_PULLUP {disabled} \
    CONFIG.PCW_MIO_45_SLEW {slow} \
    CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_46_PULLUP {enabled} \
    CONFIG.PCW_MIO_46_SLEW {slow} \
    CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_47_PULLUP {enabled} \
    CONFIG.PCW_MIO_47_SLEW {slow} \
    CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_48_PULLUP {disabled} \
    CONFIG.PCW_MIO_48_SLEW {slow} \
    CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_49_PULLUP {disabled} \
    CONFIG.PCW_MIO_49_SLEW {slow} \
    CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_4_SLEW {slow} \
    CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_50_PULLUP {enabled} \
    CONFIG.PCW_MIO_50_SLEW {slow} \
    CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_51_PULLUP {enabled} \
    CONFIG.PCW_MIO_51_SLEW {slow} \
    CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_52_PULLUP {disabled} \
    CONFIG.PCW_MIO_52_SLEW {slow} \
    CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_53_PULLUP {disabled} \
    CONFIG.PCW_MIO_53_SLEW {slow} \
    CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_5_SLEW {slow} \
    CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_6_SLEW {slow} \
    CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_7_SLEW {slow} \
    CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_8_SLEW {slow} \
    CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_9_PULLUP {enabled} \
    CONFIG.PCW_MIO_9_SLEW {slow} \
    CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#I2C Reset#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#UART\
1#UART 1#I2C 0#I2C 0#GPIO#GPIO} \
    CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#gpio[1]#gpio[2]#gpio[3]#gpio[4]#gpio[5]#gpio[6]#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#reset#gpio[14]#gpio[15]#gpio[16]#gpio[17]#gpio[18]#gpio[19]#gpio[20]#gpio[21]#gpio[22]#gpio[23]#gpio[24]#gpio[25]#gpio[26]#gpio[27]#gpio[28]#gpio[29]#gpio[30]#gpio[31]#gpio[32]#gpio[33]#gpio[34]#gpio[35]#gpio[36]#gpio[37]#gpio[38]#gpio[39]#gpio[40]#gpio[41]#gpio[42]#gpio[43]#gpio[44]#gpio[45]#gpio[46]#gpio[47]#tx#rx#scl#sda#gpio[52]#gpio[53]}\
\
    CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V} \
    CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
    CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_SDIO_PERIPHERAL_VALID {0} \
    CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
    CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
    CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
    CONFIG.PCW_UIPARAM_DDR_BL {8} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.537} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.442} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.464} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.521} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.217} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.133} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.089} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.248} \
    CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
    CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
    CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M8 HX-15E} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
    CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
    CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_USB_RESET_ENABLE {0} \
    CONFIG.PCW_USE_M_AXI_GP0 {0} \
    CONFIG.preset {ZC702} \
  ] $processing_system7_0


  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]

  # Create port connections

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


