
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2014.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.0 [current_project]


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}


# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} ne "" && ${cur_design} eq ${design_name} } {

   # Checks if design is empty or not
   if { $list_cells ne "" } {
      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 1
   } else {
      puts "INFO: Constructing design in IPI design <$design_name>..."
   }
} elseif { ${cur_design} ne "" && ${cur_design} ne ${design_name} } {

   if { $list_cells eq "" } {
      puts "INFO: You have an empty design <${cur_design}>. Will go ahead and create design..."
   } else {
      set errMsg "ERROR: Design <${cur_design}> is not empty! Please do not source this script on non-empty designs."
      set nRet 1
   }
} else {

   if { [get_files -quiet ${design_name}.bd] eq "" } {
      puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

      create_bd_design $design_name

      puts "INFO: Making design <$design_name> as current_bd_design."
      current_bd_design $design_name

   } else {
      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 3
   }

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set trx0_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 trx0_iic ]
  set trx1_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 trx1_iic ]

  # Create ports
  set trx0_clk_n_i [ create_bd_port -dir I trx0_clk_n_i ]
  set trx0_clk_p_i [ create_bd_port -dir I trx0_clk_p_i ]
  set trx0_rxclk_n_i [ create_bd_port -dir I trx0_rxclk_n_i ]
  set trx0_rxclk_p_i [ create_bd_port -dir I trx0_rxclk_p_i ]
  set trx0_rxdata_n_i [ create_bd_port -dir I -from 4 -to 0 trx0_rxdata_n_i ]
  set trx0_rxdata_p_i [ create_bd_port -dir I -from 4 -to 0 trx0_rxdata_p_i ]
  set trx0_rxdcbal_o [ create_bd_port -dir O trx0_rxdcbal_o ]
  set trx0_rxlock_i [ create_bd_port -dir I trx0_rxlock_i ]
  set trx0_rxrst_o [ create_bd_port -dir O trx0_rxrst_o ]
  set trx0_txclk_n_o [ create_bd_port -dir O trx0_txclk_n_o ]
  set trx0_txclk_p_o [ create_bd_port -dir O trx0_txclk_p_o ]
  set trx0_txdata_n_o [ create_bd_port -dir O -from 4 -to 0 trx0_txdata_n_o ]
  set trx0_txdata_p_o [ create_bd_port -dir O -from 4 -to 0 trx0_txdata_p_o ]
  set trx0_txdcbal_o [ create_bd_port -dir O trx0_txdcbal_o ]
  set trx0_txlock_i [ create_bd_port -dir I trx0_txlock_i ]
  set trx0_txrst_o [ create_bd_port -dir O trx0_txrst_o ]
  set trx1_clk_n_i [ create_bd_port -dir I trx1_clk_n_i ]
  set trx1_clk_p_i [ create_bd_port -dir I trx1_clk_p_i ]
  set trx1_rxclk_n_i [ create_bd_port -dir I trx1_rxclk_n_i ]
  set trx1_rxclk_p_i [ create_bd_port -dir I trx1_rxclk_p_i ]
  set trx1_rxdata_n_i [ create_bd_port -dir I -from 4 -to 0 trx1_rxdata_n_i ]
  set trx1_rxdata_p_i [ create_bd_port -dir I -from 4 -to 0 trx1_rxdata_p_i ]
  set trx1_rxdcbal_o [ create_bd_port -dir O trx1_rxdcbal_o ]
  set trx1_rxlock_i [ create_bd_port -dir I trx1_rxlock_i ]
  set trx1_rxrst_o [ create_bd_port -dir O trx1_rxrst_o ]
  set trx1_txclk_n_o [ create_bd_port -dir O trx1_txclk_n_o ]
  set trx1_txclk_p_o [ create_bd_port -dir O trx1_txclk_p_o ]
  set trx1_txdata_n_o [ create_bd_port -dir O -from 4 -to 0 trx1_txdata_n_o ]
  set trx1_txdata_p_o [ create_bd_port -dir O -from 4 -to 0 trx1_txdata_p_o ]
  set trx1_txdcbal_o [ create_bd_port -dir O trx1_txdcbal_o ]
  set trx1_txlock_i [ create_bd_port -dir I trx1_txlock_i ]
  set trx1_txrst_o [ create_bd_port -dir O trx1_txrst_o ]

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list CONFIG.c_sg_include_stscntrl_strm {0}  ] $axi_dma_0

  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
  set_property -dict [ list CONFIG.c_sg_include_stscntrl_strm {0}  ] $axi_dma_1

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]

  # Create instance: axi_iic_1, and set properties
  set axi_iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_1 ]

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list CONFIG.NUM_MI {1} CONFIG.NUM_SI {6}  ] $axi_mem_intercon

  # Create instance: axi_serdes_fmc_0, and set properties
  set axi_serdes_fmc_0 [ create_bd_cell -type ip -vlnv opsero.com:user:axi_serdes_fmc:1.0 axi_serdes_fmc_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.4 processing_system7_0 ]
  set_property -dict [ list CONFIG.PCW_EN_CLK1_PORT {1} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200} CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_USE_S_AXI_HP0 {1} CONFIG.preset {ZedBoard*}  ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {5}  ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list CONFIG.NUM_PORTS {4}  ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins axi_serdes_fmc_0/S00_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_SG [get_bd_intf_pins axi_dma_0/M_AXI_SG] [get_bd_intf_pins axi_mem_intercon/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S] [get_bd_intf_pins axi_serdes_fmc_0/S01_AXIS]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins axi_dma_1/M_AXI_MM2S] [get_bd_intf_pins axi_mem_intercon/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_SG [get_bd_intf_pins axi_dma_1/M_AXI_SG] [get_bd_intf_pins axi_mem_intercon/S03_AXI]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports trx0_iic] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_iic_1_IIC [get_bd_intf_ports trx1_iic] [get_bd_intf_pins axi_iic_1/IIC]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_serdes_fmc_0_M00_AXIS [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins axi_serdes_fmc_0/M00_AXIS]
  connect_bd_intf_net -intf_net axi_serdes_fmc_0_M01_AXIS [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins axi_serdes_fmc_0/M01_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_serdes_fmc_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_dma_1/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins axi_iic_1/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_dma_1_mm2s_introut [get_bd_pins axi_dma_1/mm2s_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_serdes_fmc_0_trx0_clk_bufg_o [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_o] [get_bd_pins axi_serdes_fmc_0/trx0_clk_i] [get_bd_pins axi_serdes_fmc_0/trx1_clk_i]
  connect_bd_net -net axi_serdes_fmc_0_trx0_rxdcbal_o [get_bd_ports trx0_rxdcbal_o] [get_bd_pins axi_serdes_fmc_0/trx0_rxdcbal_o]
  connect_bd_net -net axi_serdes_fmc_0_trx0_rxrst_o [get_bd_ports trx0_rxrst_o] [get_bd_pins axi_serdes_fmc_0/trx0_rxrst_o]
  connect_bd_net -net axi_serdes_fmc_0_trx0_txclk_n_o [get_bd_ports trx0_txclk_n_o] [get_bd_pins axi_serdes_fmc_0/trx0_txclk_n_o]
  connect_bd_net -net axi_serdes_fmc_0_trx0_txclk_p_o [get_bd_ports trx0_txclk_p_o] [get_bd_pins axi_serdes_fmc_0/trx0_txclk_p_o]
  connect_bd_net -net axi_serdes_fmc_0_trx0_txdata_n_o [get_bd_ports trx0_txdata_n_o] [get_bd_pins axi_serdes_fmc_0/trx0_txdata_n_o]
  connect_bd_net -net axi_serdes_fmc_0_trx0_txdata_p_o [get_bd_ports trx0_txdata_p_o] [get_bd_pins axi_serdes_fmc_0/trx0_txdata_p_o]
  connect_bd_net -net axi_serdes_fmc_0_trx0_txdcbal_o [get_bd_ports trx0_txdcbal_o] [get_bd_pins axi_serdes_fmc_0/trx0_txdcbal_o]
  connect_bd_net -net axi_serdes_fmc_0_trx0_txrst_o [get_bd_ports trx0_txrst_o] [get_bd_pins axi_serdes_fmc_0/trx0_txrst_o]
  connect_bd_net -net axi_serdes_fmc_0_trx1_rxdcbal_o [get_bd_ports trx1_rxdcbal_o] [get_bd_pins axi_serdes_fmc_0/trx1_rxdcbal_o]
  connect_bd_net -net axi_serdes_fmc_0_trx1_rxrst_o [get_bd_ports trx1_rxrst_o] [get_bd_pins axi_serdes_fmc_0/trx1_rxrst_o]
  connect_bd_net -net axi_serdes_fmc_0_trx1_txclk_n_o [get_bd_ports trx1_txclk_n_o] [get_bd_pins axi_serdes_fmc_0/trx1_txclk_n_o]
  connect_bd_net -net axi_serdes_fmc_0_trx1_txclk_p_o [get_bd_ports trx1_txclk_p_o] [get_bd_pins axi_serdes_fmc_0/trx1_txclk_p_o]
  connect_bd_net -net axi_serdes_fmc_0_trx1_txdata_n_o [get_bd_ports trx1_txdata_n_o] [get_bd_pins axi_serdes_fmc_0/trx1_txdata_n_o]
  connect_bd_net -net axi_serdes_fmc_0_trx1_txdata_p_o [get_bd_ports trx1_txdata_p_o] [get_bd_pins axi_serdes_fmc_0/trx1_txdata_p_o]
  connect_bd_net -net axi_serdes_fmc_0_trx1_txdcbal_o [get_bd_ports trx1_txdcbal_o] [get_bd_pins axi_serdes_fmc_0/trx1_txdcbal_o]
  connect_bd_net -net axi_serdes_fmc_0_trx1_txrst_o [get_bd_ports trx1_txrst_o] [get_bd_pins axi_serdes_fmc_0/trx1_txrst_o]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/m_axi_sg_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk] [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/m_axi_sg_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_iic_1/s_axi_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/S02_ACLK] [get_bd_pins axi_mem_intercon/S03_ACLK] [get_bd_pins axi_mem_intercon/S04_ACLK] [get_bd_pins axi_mem_intercon/S05_ACLK] [get_bd_pins axi_serdes_fmc_0/m00_axis_aclk] [get_bd_pins axi_serdes_fmc_0/m01_axis_aclk] [get_bd_pins axi_serdes_fmc_0/s00_axi_aclk] [get_bd_pins axi_serdes_fmc_0/s00_axis_aclk] [get_bd_pins axi_serdes_fmc_0/s01_axis_aclk] [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_div_o] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins axi_serdes_fmc_0/clk_200mhz_i] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_iic_1/s_axi_aresetn] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/S02_ARESETN] [get_bd_pins axi_mem_intercon/S03_ARESETN] [get_bd_pins axi_mem_intercon/S04_ARESETN] [get_bd_pins axi_mem_intercon/S05_ARESETN] [get_bd_pins axi_serdes_fmc_0/m00_axis_aresetn] [get_bd_pins axi_serdes_fmc_0/m01_axis_aresetn] [get_bd_pins axi_serdes_fmc_0/s00_axi_aresetn] [get_bd_pins axi_serdes_fmc_0/s00_axis_aresetn] [get_bd_pins axi_serdes_fmc_0/s01_axis_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net trx0_clk_n_i_1 [get_bd_ports trx0_clk_n_i] [get_bd_pins axi_serdes_fmc_0/trx0_clk_n_i]
  connect_bd_net -net trx0_clk_p_i_1 [get_bd_ports trx0_clk_p_i] [get_bd_pins axi_serdes_fmc_0/trx0_clk_p_i]
  connect_bd_net -net trx0_rxclk_n_i_1 [get_bd_ports trx0_rxclk_n_i] [get_bd_pins axi_serdes_fmc_0/trx0_rxclk_n_i]
  connect_bd_net -net trx0_rxclk_p_i_1 [get_bd_ports trx0_rxclk_p_i] [get_bd_pins axi_serdes_fmc_0/trx0_rxclk_p_i]
  connect_bd_net -net trx0_rxdata_n_i_1 [get_bd_ports trx0_rxdata_n_i] [get_bd_pins axi_serdes_fmc_0/trx0_rxdata_n_i]
  connect_bd_net -net trx0_rxdata_p_i_1 [get_bd_ports trx0_rxdata_p_i] [get_bd_pins axi_serdes_fmc_0/trx0_rxdata_p_i]
  connect_bd_net -net trx0_rxlock_i_1 [get_bd_ports trx0_rxlock_i] [get_bd_pins axi_serdes_fmc_0/trx0_rxlock_i]
  connect_bd_net -net trx0_txlock_i_1 [get_bd_ports trx0_txlock_i] [get_bd_pins axi_serdes_fmc_0/trx0_txlock_i]
  connect_bd_net -net trx1_clk_n_i_1 [get_bd_ports trx1_clk_n_i] [get_bd_pins axi_serdes_fmc_0/trx1_clk_n_i]
  connect_bd_net -net trx1_clk_p_i_1 [get_bd_ports trx1_clk_p_i] [get_bd_pins axi_serdes_fmc_0/trx1_clk_p_i]
  connect_bd_net -net trx1_rxclk_n_i_1 [get_bd_ports trx1_rxclk_n_i] [get_bd_pins axi_serdes_fmc_0/trx1_rxclk_n_i]
  connect_bd_net -net trx1_rxclk_p_i_1 [get_bd_ports trx1_rxclk_p_i] [get_bd_pins axi_serdes_fmc_0/trx1_rxclk_p_i]
  connect_bd_net -net trx1_rxdata_n_i_1 [get_bd_ports trx1_rxdata_n_i] [get_bd_pins axi_serdes_fmc_0/trx1_rxdata_n_i]
  connect_bd_net -net trx1_rxdata_p_i_1 [get_bd_ports trx1_rxdata_p_i] [get_bd_pins axi_serdes_fmc_0/trx1_rxdata_p_i]
  connect_bd_net -net trx1_rxlock_i_1 [get_bd_ports trx1_rxlock_i] [get_bd_pins axi_serdes_fmc_0/trx1_rxlock_i]
  connect_bd_net -net trx1_txlock_i_1 [get_bd_ports trx1_txlock_i] [get_bd_pins axi_serdes_fmc_0/trx1_txlock_i]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_1/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x40410000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41610000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_1/S_AXI/Reg] SEG_axi_iic_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_serdes_fmc_0/S00_AXI/S00_AXI_reg] SEG_axi_serdes_fmc_0_S00_AXI_reg
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


