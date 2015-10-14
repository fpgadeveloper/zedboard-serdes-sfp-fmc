################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

set design_name design_1

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

create_bd_design $design_name

current_bd_design $design_name

set parentCell [get_bd_cells /]

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

# Add the Processor System and apply board preset
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]

# Configure the PS: Generate 200MHz clocks, Enable HP0 GP0, Enable interrupts
startgroup
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1} CONFIG.PCW_USE_M_AXI_GP0 {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {250} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_EN_CLK0_PORT {1} CONFIG.PCW_EN_CLK1_PORT {1} CONFIG.PCW_IRQ_F2P_INTR {1}] [get_bd_cells processing_system7_0]
endgroup

# Add AXI SERDES IP
startgroup
create_bd_cell -type ip -vlnv opsero.com:user:axi_serdes_fmc:1.0 axi_serdes_fmc_0
endgroup

# Connection automation
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_serdes_fmc_0/S00_AXI]

# Connect the FCLK_CLK1 (200MHz) to the AXI SERDES
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins axi_serdes_fmc_0/clk_200mhz_i]

# Add the concat for the interrupts
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
endgroup
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]
startgroup
set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]
endgroup

# Add the DMAs
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1
endgroup
set_property -dict [list CONFIG.c_sg_include_stscntrl_strm {0}] [get_bd_cells axi_dma_0]
set_property -dict [list CONFIG.c_sg_include_stscntrl_strm {0}] [get_bd_cells axi_dma_1]

# Connect the DMA AXI Streaming ports to the AXI SERDES
connect_bd_intf_net [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins axi_serdes_fmc_0/M00_AXIS]
connect_bd_intf_net [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins axi_serdes_fmc_0/M01_AXIS]
connect_bd_intf_net [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins axi_serdes_fmc_0/S00_AXIS]
connect_bd_intf_net [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S] [get_bd_intf_pins axi_serdes_fmc_0/S01_AXIS]

# Connect interrupts
connect_bd_net [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins xlconcat_0/In0]
connect_bd_net [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]
connect_bd_net [get_bd_pins axi_dma_1/mm2s_introut] [get_bd_pins xlconcat_0/In2]
connect_bd_net [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_0/In3]

# Add the I2Cs
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_1
endgroup

# Create I2C Ports
startgroup
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 trx0_iic
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 trx1_iic
connect_bd_intf_net [get_bd_intf_pins axi_iic_0/IIC] [get_bd_intf_ports trx0_iic]
connect_bd_intf_net [get_bd_intf_pins axi_iic_1/IIC] [get_bd_intf_ports trx1_iic]
endgroup

# Create AXI SERDES output ports for port 0
startgroup
create_bd_port -dir O -from 4 -to 0 trx0_txdata_p_o
create_bd_port -dir O -from 4 -to 0 trx0_txdata_n_o
create_bd_port -dir O trx0_txclk_p_o
create_bd_port -dir O trx0_txclk_n_o
create_bd_port -dir O trx0_txrst_o
create_bd_port -dir O trx0_txdcbal_o
create_bd_port -dir O trx0_rxrst_o
create_bd_port -dir O trx0_rxdcbal_o
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_txdata_p_o] [get_bd_ports trx0_txdata_p_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_txdata_n_o] [get_bd_ports trx0_txdata_n_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_txclk_p_o] [get_bd_ports trx0_txclk_p_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_txclk_n_o] [get_bd_ports trx0_txclk_n_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_txrst_o] [get_bd_ports trx0_txrst_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_txdcbal_o] [get_bd_ports trx0_txdcbal_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_rxrst_o] [get_bd_ports trx0_rxrst_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_rxdcbal_o] [get_bd_ports trx0_rxdcbal_o]
endgroup

# Create AXI SERDES output ports for port 1
startgroup
create_bd_port -dir O -from 4 -to 0 trx1_txdata_p_o
create_bd_port -dir O -from 4 -to 0 trx1_txdata_n_o
create_bd_port -dir O trx1_txclk_p_o
create_bd_port -dir O trx1_txclk_n_o
create_bd_port -dir O trx1_txrst_o
create_bd_port -dir O trx1_txdcbal_o
create_bd_port -dir O trx1_rxrst_o
create_bd_port -dir O trx1_rxdcbal_o
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_txdata_p_o] [get_bd_ports trx1_txdata_p_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_txdata_n_o] [get_bd_ports trx1_txdata_n_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_txclk_p_o] [get_bd_ports trx1_txclk_p_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_txclk_n_o] [get_bd_ports trx1_txclk_n_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_txrst_o] [get_bd_ports trx1_txrst_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_txdcbal_o] [get_bd_ports trx1_txdcbal_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_rxrst_o] [get_bd_ports trx1_rxrst_o]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_rxdcbal_o] [get_bd_ports trx1_rxdcbal_o]
endgroup

# Create AXI SERDES input ports for port 0
startgroup
create_bd_port -dir I trx0_clk_p_i
create_bd_port -dir I trx0_clk_n_i
create_bd_port -dir I trx0_txlock_i
create_bd_port -dir I -from 4 -to 0 trx0_rxdata_p_i
create_bd_port -dir I -from 4 -to 0 trx0_rxdata_n_i
create_bd_port -dir I trx0_rxclk_p_i
create_bd_port -dir I trx0_rxclk_n_i
create_bd_port -dir I trx0_rxlock_i
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_clk_p_i] [get_bd_ports trx0_clk_p_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_clk_n_i] [get_bd_ports trx0_clk_n_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_txlock_i] [get_bd_ports trx0_txlock_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_rxdata_p_i] [get_bd_ports trx0_rxdata_p_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_rxdata_n_i] [get_bd_ports trx0_rxdata_n_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_rxclk_p_i] [get_bd_ports trx0_rxclk_p_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_rxclk_n_i] [get_bd_ports trx0_rxclk_n_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx0_rxlock_i] [get_bd_ports trx0_rxlock_i]
endgroup

# Create AXI SERDES input ports for port 1
startgroup
create_bd_port -dir I trx1_clk_p_i
create_bd_port -dir I trx1_clk_n_i
create_bd_port -dir I trx1_txlock_i
create_bd_port -dir I -from 4 -to 0 trx1_rxdata_p_i
create_bd_port -dir I -from 4 -to 0 trx1_rxdata_n_i
create_bd_port -dir I trx1_rxclk_p_i
create_bd_port -dir I trx1_rxclk_n_i
create_bd_port -dir I trx1_rxlock_i
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_clk_p_i] [get_bd_ports trx1_clk_p_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_clk_n_i] [get_bd_ports trx1_clk_n_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_txlock_i] [get_bd_ports trx1_txlock_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_rxdata_p_i] [get_bd_ports trx1_rxdata_p_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_rxdata_n_i] [get_bd_ports trx1_rxdata_n_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_rxclk_p_i] [get_bd_ports trx1_rxclk_p_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_rxclk_n_i] [get_bd_ports trx1_rxclk_n_i]
connect_bd_net [get_bd_pins /axi_serdes_fmc_0/trx1_rxlock_i] [get_bd_ports trx1_rxlock_i]
endgroup

# Hook up the output clock of the AXI SERDES to the GP0 and HP0 port clocks
#connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins axi_serdes_fmc_0/s00_axi_aclk]
connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins axi_serdes_fmc_0/s01_axis_aclk]
connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins axi_serdes_fmc_0/m01_axis_aclk]
connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins axi_serdes_fmc_0/m00_axis_aclk]
connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins axi_serdes_fmc_0/s00_axis_aclk]

#connect_bd_net [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_div_o] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
#connect_bd_net [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_div_o] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK]
#connect_bd_net [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_div_o] [get_bd_pins axi_serdes_fmc_0/s00_axi_aclk]
#connect_bd_net [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_div_o] [get_bd_pins axi_serdes_fmc_0/s01_axis_aclk]
#connect_bd_net [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_div_o] [get_bd_pins axi_serdes_fmc_0/m01_axis_aclk]
#connect_bd_net [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_div_o] [get_bd_pins axi_serdes_fmc_0/m00_axis_aclk]
#connect_bd_net [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_div_o] [get_bd_pins axi_serdes_fmc_0/s00_axis_aclk]

# Hook up the reset signals
#connect_bd_net [get_bd_pins rst_processing_system7_0_250M/peripheral_aresetn] [get_bd_pins axi_serdes_fmc_0/s00_axi_aresetn]
connect_bd_net [get_bd_pins rst_processing_system7_0_250M/peripheral_aresetn] [get_bd_pins axi_serdes_fmc_0/s01_axis_aresetn]
connect_bd_net [get_bd_pins rst_processing_system7_0_250M/peripheral_aresetn] [get_bd_pins axi_serdes_fmc_0/m01_axis_aresetn]
connect_bd_net [get_bd_pins rst_processing_system7_0_250M/peripheral_aresetn] [get_bd_pins axi_serdes_fmc_0/m00_axis_aresetn]
connect_bd_net [get_bd_pins rst_processing_system7_0_250M/peripheral_aresetn] [get_bd_pins axi_serdes_fmc_0/s00_axis_aresetn]

# Run connection automation
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/axi_dma_0/M_AXI_SG" Clk "Auto" }  [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_dma_1/S_AXI_LITE]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_iic_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_iic_1/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP0" Clk "Auto" }  [get_bd_intf_pins axi_dma_0/M_AXI_MM2S]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP0" Clk "Auto" }  [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP0" Clk "Auto" }  [get_bd_intf_pins axi_dma_1/M_AXI_SG]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP0" Clk "Auto" }  [get_bd_intf_pins axi_dma_1/M_AXI_MM2S]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP0" Clk "Auto" }  [get_bd_intf_pins axi_dma_1/M_AXI_S2MM]
endgroup

# Now disconnect FCLK0 and replace it with axi_serdes_fmc_0/trx0_clk_bufg_div_o through a clock wizard
disconnect_bd_net /processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0
endgroup
connect_bd_net [get_bd_pins axi_serdes_fmc_0/trx0_clk_bufg_div_o] [get_bd_pins clk_wiz_0/clk_in1]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
startgroup
set_property -dict [list CONFIG.PRIMITIVE {MMCM} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.CLKOUT1_DRIVES {BUFG} CONFIG.CLKOUT2_DRIVES {BUFG} CONFIG.CLKOUT3_DRIVES {BUFG} CONFIG.CLKOUT4_DRIVES {BUFG} CONFIG.CLKOUT5_DRIVES {BUFG} CONFIG.CLKOUT6_DRIVES {BUFG} CONFIG.CLKOUT7_DRIVES {BUFG} CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} CONFIG.MMCM_DIVCLK_DIVIDE {1} CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} CONFIG.MMCM_COMPENSATION {ZHOLD} CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} CONFIG.RESET_PORT {resetn} CONFIG.CLKOUT1_JITTER {130.958} CONFIG.CLKOUT1_PHASE_ERROR {98.575}] [get_bd_cells clk_wiz_0]
endgroup
delete_bd_objs [get_bd_nets processing_system7_0_FCLK_RESET0_N]
connect_bd_net [get_bd_pins rst_processing_system7_0_250M/ext_reset_in] [get_bd_pins clk_wiz_0/locked]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins clk_wiz_0/resetn]

# Connect the FCLK_CLK0 to the AXI SERDES clock inputs
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_serdes_fmc_0/trx0_clk_i]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_serdes_fmc_0/trx1_clk_i]

# Restore current instance
current_bd_instance $oldCurInst

save_bd_design
