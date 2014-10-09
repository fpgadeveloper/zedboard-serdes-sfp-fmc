library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity axi_serdes_fmc_v1_0_M00_AXIS is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
		-- Start count is the numeber of clock cycles the master will wait before initiating/issuing any transaction.
		C_M_START_COUNT	: integer	:= 32
	);
	port (
		-- Users to add ports here
    rxclk_i         : in std_logic;
    rxdata_i        : in std_logic_vector(9 downto 0);
    rxlock_i        : in std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global ports
		M_AXIS_ACLK	: in std_logic;
		-- 
		M_AXIS_ARESETN	: in std_logic;
		-- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		M_AXIS_TVALID	: out std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		M_AXIS_TLAST	: out std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TREADY	: in std_logic
	);
end axi_serdes_fmc_v1_0_M00_AXIS;

architecture implementation of axi_serdes_fmc_v1_0_M00_AXIS is

  -- FIFO to convert the 8-bit interface to a 32bit AXI streaming interface
  component fifo_8bit_to_32bit
    port (
      rst : in std_logic;
      wr_clk : in std_logic;
      rd_clk : in std_logic;
      din : in std_logic_vector(7 downto 0);
      wr_en : in std_logic;
      rd_en : in std_logic;
      dout : out std_logic_vector(31 downto 0);
      full : out std_logic;
      almost_empty : out std_logic;
      empty : out std_logic;
      valid : out std_logic
    );
  end component;

  signal rst     : std_logic;
  signal wr_en   : std_logic;
  signal almost_empty : std_logic;
  signal empty : std_logic;

begin
  ------------------------------------------------------------------
  -- WARNING: This code is written for testing a self-loopback
  -- where the received clock (from the deserializer) is synchronous
  -- to the transmitted clock because they originate from the same
  -- source.
  -- If you want to use this code for independent transmit and receive
  -- clocks, then an elastic buffer should be added to the design.
  ------------------------------------------------------------------

  -- Invert the AXI reset signal
  rst <= not M_AXIS_ARESETN;

  -- FIFO write enable:
  -- rxdata_i 5th and 10th bits are VALID_N signals from deserializer
  -- (applies when using DC balanced encoding)
  wr_en <= (not rxlock_i) and (not rxdata_i(9));

  fifo_8bit_to_32bit_inst : fifo_8bit_to_32bit
  PORT MAP (
    rst    => rst,
    wr_clk => rxclk_i,      -- Received clock (should be synchronous with global clock)
    rd_clk => M_AXIS_ACLK,  -- AXIS clock = Global clock / 4
    din    => rxdata_i(8 downto 5) & rxdata_i(3 downto 0),
    wr_en  => wr_en,
    rd_en  => M_AXIS_TREADY,  -- Always read from FIFO
    -- We reverse the byte order at the output of the FIFO
    -- so that the correct 32-bit word is output to AXI bus
    -- (the transmit interface reverses the byte order)
    dout(7 downto 0)   => M_AXIS_TDATA(31 downto 24),
    dout(15 downto 8)  => M_AXIS_TDATA(23 downto 16),
    dout(23 downto 16) => M_AXIS_TDATA(15 downto 8),
    dout(31 downto 24) => M_AXIS_TDATA(7 downto 0),
    full   => open,
    almost_empty => almost_empty,
    empty  => empty,
    valid  => M_AXIS_TVALID
  );

  M_AXIS_TLAST <= almost_empty and not empty;

end implementation;
