library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity axi_serdes_fmc_v1_0_S00_AXIS is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- AXI4Stream sink: Data Width
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
		-- Users to add ports here
    txclk_i        : in std_logic;
    txdata_o       : out std_logic_vector(9 downto 0);

		-- User ports ends
		-- Do not modify the ports beyond this line

		-- AXI4Stream sink: Clock
		S_AXIS_ACLK	: in std_logic;
		-- AXI4Stream sink: Reset
		S_AXIS_ARESETN	: in std_logic;
		-- Ready to accept data in
		S_AXIS_TREADY	: out std_logic;
		-- Data in
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		-- Byte qualifier
		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- Indicates boundary of last packet
		S_AXIS_TLAST	: in std_logic;
		-- Data is in valid
		S_AXIS_TVALID	: in std_logic
	);
end axi_serdes_fmc_v1_0_S00_AXIS;

architecture arch_imp of axi_serdes_fmc_v1_0_S00_AXIS is

  -- FIFO to convert the 32bit AXI streaming interface to an 8-bit interface
  component fifo_32bit_to_8bit
    port (
      rst : in std_logic;
      wr_clk : in std_logic;
      rd_clk : in std_logic;
      din : in std_logic_vector(31 downto 0);
      wr_en : in std_logic;
      rd_en : in std_logic;
      dout : out std_logic_vector(7 downto 0);
      full : out std_logic;
      empty : out std_logic;
      valid : out std_logic
    );
  end component;

  signal rst     : std_logic;
  signal valid_n : std_logic;
  
begin
  -- Invert the AXI reset signal
  rst <= not S_AXIS_ARESETN;
  
  fifo_32bit_to_8bit_inst : fifo_32bit_to_8bit
  port map (
    rst    => rst,
    wr_clk => S_AXIS_ACLK, -- AXIS clock = global clock / 4
    rd_clk => txclk_i,     -- Global clock
    din    => S_AXIS_TDATA,
    wr_en  => S_AXIS_TVALID,
    rd_en  => '1',  -- Always read from FIFO
    dout   => txdata_o(7 downto 0),
    full   => open,
    empty  => open,
    valid  => valid_n
  );

  -- The 9th and 10th bits are the VALID_N signal
  -- (applies when using DC balanced encoding)
  txdata_o(8) <= valid_n;
  txdata_o(9) <= valid_n;
  
end arch_imp;
