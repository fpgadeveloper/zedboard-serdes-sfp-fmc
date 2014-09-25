# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
	set Page0 [ipgui::add_page $IPINST -name "Page 0" -layout vertical]
	set Component_Name [ipgui::add_param $IPINST -parent $Page0 -name Component_Name]
	set TRX0_RXCLK_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX0_RXCLK_IDELAY]
	set TRX0_RXDATA0_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX0_RXDATA0_IDELAY]
	set TRX0_RXDATA1_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX0_RXDATA1_IDELAY]
	set TRX0_RXDATA2_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX0_RXDATA2_IDELAY]
	set TRX0_RXDATA3_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX0_RXDATA3_IDELAY]
	set TRX0_RXDATA4_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX0_RXDATA4_IDELAY]
	set TRX1_RXCLK_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX1_RXCLK_IDELAY]
	set TRX1_RXDATA0_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX1_RXDATA0_IDELAY]
	set TRX1_RXDATA1_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX1_RXDATA1_IDELAY]
	set TRX1_RXDATA2_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX1_RXDATA2_IDELAY]
	set TRX1_RXDATA3_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX1_RXDATA3_IDELAY]
	set TRX1_RXDATA4_IDELAY [ipgui::add_param $IPINST -parent $Page0 -name TRX1_RXDATA4_IDELAY]
	set C_S00_AXI_DATA_WIDTH [ipgui::add_param $IPINST -parent $Page0 -name C_S00_AXI_DATA_WIDTH]
	set_property tooltip {Width of S_AXI data bus} $C_S00_AXI_DATA_WIDTH
	set C_S00_AXI_ADDR_WIDTH [ipgui::add_param $IPINST -parent $Page0 -name C_S00_AXI_ADDR_WIDTH]
	set_property tooltip {Width of S_AXI address bus} $C_S00_AXI_ADDR_WIDTH
	set C_S00_AXI_BASEADDR [ipgui::add_param $IPINST -parent $Page0 -name C_S00_AXI_BASEADDR]
	set C_S00_AXI_HIGHADDR [ipgui::add_param $IPINST -parent $Page0 -name C_S00_AXI_HIGHADDR]
	set C_M00_AXIS_TDATA_WIDTH [ipgui::add_param $IPINST -parent $Page0 -name C_M00_AXIS_TDATA_WIDTH]
	set_property tooltip {Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.} $C_M00_AXIS_TDATA_WIDTH
	set C_M00_AXIS_START_COUNT [ipgui::add_param $IPINST -parent $Page0 -name C_M00_AXIS_START_COUNT]
	set_property tooltip {Start count is the numeber of clock cycles the master will wait before initiating/issuing any transaction.} $C_M00_AXIS_START_COUNT
	set C_S00_AXIS_TDATA_WIDTH [ipgui::add_param $IPINST -parent $Page0 -name C_S00_AXIS_TDATA_WIDTH]
	set_property tooltip {AXI4Stream sink: Data Width} $C_S00_AXIS_TDATA_WIDTH
}

proc update_PARAM_VALUE.TRX0_RXCLK_IDELAY { PARAM_VALUE.TRX0_RXCLK_IDELAY } {
	# Procedure called to update TRX0_RXCLK_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX0_RXCLK_IDELAY { PARAM_VALUE.TRX0_RXCLK_IDELAY } {
	# Procedure called to validate TRX0_RXCLK_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX0_RXDATA0_IDELAY { PARAM_VALUE.TRX0_RXDATA0_IDELAY } {
	# Procedure called to update TRX0_RXDATA0_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX0_RXDATA0_IDELAY { PARAM_VALUE.TRX0_RXDATA0_IDELAY } {
	# Procedure called to validate TRX0_RXDATA0_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX0_RXDATA1_IDELAY { PARAM_VALUE.TRX0_RXDATA1_IDELAY } {
	# Procedure called to update TRX0_RXDATA1_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX0_RXDATA1_IDELAY { PARAM_VALUE.TRX0_RXDATA1_IDELAY } {
	# Procedure called to validate TRX0_RXDATA1_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX0_RXDATA2_IDELAY { PARAM_VALUE.TRX0_RXDATA2_IDELAY } {
	# Procedure called to update TRX0_RXDATA2_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX0_RXDATA2_IDELAY { PARAM_VALUE.TRX0_RXDATA2_IDELAY } {
	# Procedure called to validate TRX0_RXDATA2_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX0_RXDATA3_IDELAY { PARAM_VALUE.TRX0_RXDATA3_IDELAY } {
	# Procedure called to update TRX0_RXDATA3_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX0_RXDATA3_IDELAY { PARAM_VALUE.TRX0_RXDATA3_IDELAY } {
	# Procedure called to validate TRX0_RXDATA3_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX0_RXDATA4_IDELAY { PARAM_VALUE.TRX0_RXDATA4_IDELAY } {
	# Procedure called to update TRX0_RXDATA4_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX0_RXDATA4_IDELAY { PARAM_VALUE.TRX0_RXDATA4_IDELAY } {
	# Procedure called to validate TRX0_RXDATA4_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX1_RXCLK_IDELAY { PARAM_VALUE.TRX1_RXCLK_IDELAY } {
	# Procedure called to update TRX1_RXCLK_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX1_RXCLK_IDELAY { PARAM_VALUE.TRX1_RXCLK_IDELAY } {
	# Procedure called to validate TRX1_RXCLK_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX1_RXDATA0_IDELAY { PARAM_VALUE.TRX1_RXDATA0_IDELAY } {
	# Procedure called to update TRX1_RXDATA0_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX1_RXDATA0_IDELAY { PARAM_VALUE.TRX1_RXDATA0_IDELAY } {
	# Procedure called to validate TRX1_RXDATA0_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX1_RXDATA1_IDELAY { PARAM_VALUE.TRX1_RXDATA1_IDELAY } {
	# Procedure called to update TRX1_RXDATA1_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX1_RXDATA1_IDELAY { PARAM_VALUE.TRX1_RXDATA1_IDELAY } {
	# Procedure called to validate TRX1_RXDATA1_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX1_RXDATA2_IDELAY { PARAM_VALUE.TRX1_RXDATA2_IDELAY } {
	# Procedure called to update TRX1_RXDATA2_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX1_RXDATA2_IDELAY { PARAM_VALUE.TRX1_RXDATA2_IDELAY } {
	# Procedure called to validate TRX1_RXDATA2_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX1_RXDATA3_IDELAY { PARAM_VALUE.TRX1_RXDATA3_IDELAY } {
	# Procedure called to update TRX1_RXDATA3_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX1_RXDATA3_IDELAY { PARAM_VALUE.TRX1_RXDATA3_IDELAY } {
	# Procedure called to validate TRX1_RXDATA3_IDELAY
	return true
}

proc update_PARAM_VALUE.TRX1_RXDATA4_IDELAY { PARAM_VALUE.TRX1_RXDATA4_IDELAY } {
	# Procedure called to update TRX1_RXDATA4_IDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRX1_RXDATA4_IDELAY { PARAM_VALUE.TRX1_RXDATA4_IDELAY } {
	# Procedure called to validate TRX1_RXDATA4_IDELAY
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_START_COUNT { PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to update C_M00_AXIS_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_START_COUNT { PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to validate C_M00_AXIS_START_COUNT
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_START_COUNT { MODELPARAM_VALUE.C_M00_AXIS_START_COUNT PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_START_COUNT}] ${MODELPARAM_VALUE.C_M00_AXIS_START_COUNT}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.TRX0_RXCLK_IDELAY { MODELPARAM_VALUE.TRX0_RXCLK_IDELAY PARAM_VALUE.TRX0_RXCLK_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX0_RXCLK_IDELAY}] ${MODELPARAM_VALUE.TRX0_RXCLK_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX0_RXDATA0_IDELAY { MODELPARAM_VALUE.TRX0_RXDATA0_IDELAY PARAM_VALUE.TRX0_RXDATA0_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX0_RXDATA0_IDELAY}] ${MODELPARAM_VALUE.TRX0_RXDATA0_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX0_RXDATA1_IDELAY { MODELPARAM_VALUE.TRX0_RXDATA1_IDELAY PARAM_VALUE.TRX0_RXDATA1_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX0_RXDATA1_IDELAY}] ${MODELPARAM_VALUE.TRX0_RXDATA1_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX0_RXDATA2_IDELAY { MODELPARAM_VALUE.TRX0_RXDATA2_IDELAY PARAM_VALUE.TRX0_RXDATA2_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX0_RXDATA2_IDELAY}] ${MODELPARAM_VALUE.TRX0_RXDATA2_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX0_RXDATA3_IDELAY { MODELPARAM_VALUE.TRX0_RXDATA3_IDELAY PARAM_VALUE.TRX0_RXDATA3_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX0_RXDATA3_IDELAY}] ${MODELPARAM_VALUE.TRX0_RXDATA3_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX0_RXDATA4_IDELAY { MODELPARAM_VALUE.TRX0_RXDATA4_IDELAY PARAM_VALUE.TRX0_RXDATA4_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX0_RXDATA4_IDELAY}] ${MODELPARAM_VALUE.TRX0_RXDATA4_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX1_RXCLK_IDELAY { MODELPARAM_VALUE.TRX1_RXCLK_IDELAY PARAM_VALUE.TRX1_RXCLK_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX1_RXCLK_IDELAY}] ${MODELPARAM_VALUE.TRX1_RXCLK_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX1_RXDATA0_IDELAY { MODELPARAM_VALUE.TRX1_RXDATA0_IDELAY PARAM_VALUE.TRX1_RXDATA0_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX1_RXDATA0_IDELAY}] ${MODELPARAM_VALUE.TRX1_RXDATA0_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX1_RXDATA1_IDELAY { MODELPARAM_VALUE.TRX1_RXDATA1_IDELAY PARAM_VALUE.TRX1_RXDATA1_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX1_RXDATA1_IDELAY}] ${MODELPARAM_VALUE.TRX1_RXDATA1_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX1_RXDATA2_IDELAY { MODELPARAM_VALUE.TRX1_RXDATA2_IDELAY PARAM_VALUE.TRX1_RXDATA2_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX1_RXDATA2_IDELAY}] ${MODELPARAM_VALUE.TRX1_RXDATA2_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX1_RXDATA3_IDELAY { MODELPARAM_VALUE.TRX1_RXDATA3_IDELAY PARAM_VALUE.TRX1_RXDATA3_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX1_RXDATA3_IDELAY}] ${MODELPARAM_VALUE.TRX1_RXDATA3_IDELAY}
}

proc update_MODELPARAM_VALUE.TRX1_RXDATA4_IDELAY { MODELPARAM_VALUE.TRX1_RXDATA4_IDELAY PARAM_VALUE.TRX1_RXDATA4_IDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRX1_RXDATA4_IDELAY}] ${MODELPARAM_VALUE.TRX1_RXDATA4_IDELAY}
}

