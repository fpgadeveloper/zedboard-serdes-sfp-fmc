library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity axi_serdes_fmc_v1_0 is
	generic (
		-- Users to add parameters here
    TRX0_RXCLK_IDELAY      : integer := 0;
    TRX0_RXDATA0_IDELAY    : integer := 15;
    TRX0_RXDATA1_IDELAY    : integer := 15;
    TRX0_RXDATA2_IDELAY    : integer := 15;
    TRX0_RXDATA3_IDELAY    : integer := 15;
    TRX0_RXDATA4_IDELAY    : integer := 15;
    TRX1_RXCLK_IDELAY      : integer := 0;
    TRX1_RXDATA0_IDELAY    : integer := 15;
    TRX1_RXDATA1_IDELAY    : integer := 15;
    TRX1_RXDATA2_IDELAY    : integer := 15;
    TRX1_RXDATA3_IDELAY    : integer := 15;
    TRX1_RXDATA4_IDELAY    : integer := 15;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4;

		-- Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 32;

		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 32
	);
	port (
		-- Users to add ports here
    clk_200mhz_i        : in std_logic;
    --------------------------------------------------------
    -- Transceiver 0 ports
    --------------------------------------------------------
    -- Input clock from FMC
    trx0_clk_p_i        : in  std_logic;
    trx0_clk_n_i        : in  std_logic;
    -- Output clocks
    trx0_clk_bufg_div_o : out std_logic;
    trx0_clk_bufr_o     : out std_logic;
    -- Input clock from user design
    trx0_clk_i          : in std_logic;
    -- Transmitter interface
    trx0_txdata_p_o     : out std_logic_vector(4 downto 0);
    trx0_txdata_n_o     : out std_logic_vector(4 downto 0);
    trx0_txclk_p_o      : out std_logic;
    trx0_txclk_n_o      : out std_logic;
    -- Transmitter control
    trx0_txrst_o        : out std_logic;
    trx0_txdcbal_o      : out std_logic;
    trx0_txlock_i       : in std_logic;
    -- Receiver interface
    trx0_rxdata_p_i     : in std_logic_vector(4 downto 0);
    trx0_rxdata_n_i     : in std_logic_vector(4 downto 0);
    trx0_rxclk_p_i      : in std_logic;
    trx0_rxclk_n_i      : in std_logic;
    -- Receiver control
    trx0_rxrst_o        : out std_logic;
    trx0_rxdcbal_o      : out std_logic;
    trx0_rxlock_i       : in std_logic;

    --------------------------------------------------------
    -- Transceiver 1 ports
    --------------------------------------------------------
    -- Input clock from FMC
    trx1_clk_p_i        : in  std_logic;
    trx1_clk_n_i        : in  std_logic;
    -- Output clocks
    trx1_clk_bufg_div_o : out std_logic;
    trx1_clk_bufr_o     : out std_logic;
    -- Input clock from user design
    trx1_clk_i          : in std_logic;
    -- Transmitter interface
    trx1_txdata_p_o     : out std_logic_vector(4 downto 0);
    trx1_txdata_n_o     : out std_logic_vector(4 downto 0);
    trx1_txclk_p_o      : out std_logic;
    trx1_txclk_n_o      : out std_logic;
    -- Transmitter control
    trx1_txrst_o        : out std_logic;
    trx1_txdcbal_o      : out std_logic;
    trx1_txlock_i       : in std_logic;
    -- Receiver interface
    trx1_rxdata_p_i     : in std_logic_vector(4 downto 0);
    trx1_rxdata_n_i     : in std_logic_vector(4 downto 0);
    trx1_rxclk_p_i      : in std_logic;
    trx1_rxclk_n_i      : in std_logic;
    -- Receiver control
    trx1_rxrst_o        : out std_logic;
    trx1_rxdcbal_o      : out std_logic;
    trx1_rxlock_i       : in std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic;

		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_aclk	: in std_logic;
		s00_axis_aresetn	: in std_logic;
		s00_axis_tready	: out std_logic;
		s00_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s00_axis_tstrb	: in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic;
    
		-- Ports of Axi Slave Bus Interface S01_AXIS
		s01_axis_aclk	: in std_logic;
		s01_axis_aresetn	: in std_logic;
		s01_axis_tready	: out std_logic;
		s01_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s01_axis_tstrb	: in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s01_axis_tlast	: in std_logic;
		s01_axis_tvalid	: in std_logic;

		-- Ports of Axi Master Bus Interface M01_AXIS
		m01_axis_aclk	: in std_logic;
		m01_axis_aresetn	: in std_logic;
		m01_axis_tvalid	: out std_logic;
		m01_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m01_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m01_axis_tlast	: out std_logic;
		m01_axis_tready	: in std_logic
	);
end axi_serdes_fmc_v1_0;

architecture arch_imp of axi_serdes_fmc_v1_0 is

	-- component declaration
	component axi_serdes_fmc_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component axi_serdes_fmc_v1_0_S00_AXI;

	component axi_serdes_fmc_v1_0_S00_AXIS is
		generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
		);
		port (
    -- Ten-bit interface to drive transceiver block
    txclk_i        : in std_logic;
    txdata_o       : out std_logic_vector(9 downto 0);
    -- AXI streaming slave interface
		S_AXIS_ACLK	: in std_logic;
		S_AXIS_ARESETN	: in std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		S_AXIS_TLAST	: in std_logic;
		S_AXIS_TVALID	: in std_logic
		);
	end component axi_serdes_fmc_v1_0_S00_AXIS;

	component axi_serdes_fmc_v1_0_M00_AXIS is
		generic (
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M_START_COUNT	: integer	:= 32
		);
		port (
    -- Ten-bit interface from transceiver block
    rxclk_i        : in std_logic;
    rxdata_i       : in std_logic_vector(9 downto 0);
    -- AXI streaming master interface
		M_AXIS_ACLK	: in std_logic;
		M_AXIS_ARESETN	: in std_logic;
		M_AXIS_TVALID	: out std_logic;
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		M_AXIS_TLAST	: out std_logic;
		M_AXIS_TREADY	: in std_logic
		);
	end component axi_serdes_fmc_v1_0_M00_AXIS;

  component transceiver
  generic (
      RXCLK_IDELAY   : integer := 15;
      RXDATA0_IDELAY : integer := 15;
      RXDATA1_IDELAY : integer := 15;
      RXDATA2_IDELAY : integer := 15;
      RXDATA3_IDELAY : integer := 15;
      RXDATA4_IDELAY : integer := 15
  );
  port (
      rst_i          : in std_logic;
      clk_i          : in std_logic;
      clk_200mhz_i   : in std_logic;
      -- Input clock
      clk_p_i        : in  std_logic;
      clk_n_i        : in  std_logic;
      -- Output clocks
      clk_bufg_div_o : out std_logic;
      clk_bufr_o     : out std_logic;
      -- Transmitter interface
      txclk_i        : in std_logic;
      txdata_i       : in std_logic_vector(9 downto 0);
      txdata_p_o     : out std_logic_vector(4 downto 0);
      txdata_n_o     : out std_logic_vector(4 downto 0);
      txclk_p_o      : out std_logic;
      txclk_n_o      : out std_logic;
      -- Transmitter control
      txrst_i        : in std_logic;
      txrst_o        : out std_logic;
      txdcbal_i      : in std_logic;
      txdcbal_o      : out std_logic;
      txlock_i       : in std_logic;
      txlock_o       : out std_logic;
      -- Receiver interface
      iodelay_inc_i  : in std_logic;
      iodelay_dec_i  : in std_logic;
      rxdata_p_i     : in std_logic_vector(4 downto 0);
      rxdata_n_i     : in std_logic_vector(4 downto 0);
      rxclk_p_i      : in std_logic;
      rxclk_n_i      : in std_logic;
      rxclk_o        : out std_logic;
      rxdata_o       : out std_logic_vector(9 downto 0);
      -- Receiver control
      rxrst_i        : in std_logic;
      rxrst_o        : out std_logic;
      rxdcbal_i      : in std_logic;
      rxdcbal_o      : out std_logic;
      rxlock_i       : in std_logic;
      rxlock_o       : out std_logic
  );
  end component;
  
  -- Ten-bit interface signals between transceivers and AXI blocks
  signal trx0_txclk    : std_logic;
  signal trx0_txdata   : std_logic_vector(9 downto 0);
  signal trx1_txclk    : std_logic;
  signal trx1_txdata   : std_logic_vector(9 downto 0);
  signal trx0_rxclk    : std_logic;
  signal trx0_rxdata   : std_logic_vector(9 downto 0);
  signal trx1_rxclk    : std_logic;
  signal trx1_rxdata   : std_logic_vector(9 downto 0);
  
begin

-- Instantiation of Axi Bus Interface S00_AXI
axi_serdes_fmc_v1_0_S00_AXI_inst : axi_serdes_fmc_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

-- Instantiation of Axi Bus Interface S00_AXIS
axi_serdes_fmc_v1_0_S00_AXIS_inst : axi_serdes_fmc_v1_0_S00_AXIS
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
	)
	port map (
    txclk_i        => trx0_clk_i,  -- clocked by global transceiver clock
    txdata_o       => trx0_txdata,
		S_AXIS_ACLK	=> s00_axis_aclk,
		S_AXIS_ARESETN	=> s00_axis_aresetn,
		S_AXIS_TREADY	=> s00_axis_tready,
		S_AXIS_TDATA	=> s00_axis_tdata,
		S_AXIS_TSTRB	=> s00_axis_tstrb,
		S_AXIS_TLAST	=> s00_axis_tlast,
		S_AXIS_TVALID	=> s00_axis_tvalid
	);

-- Instantiation of Axi Bus Interface M00_AXIS
axi_serdes_fmc_v1_0_M00_AXIS_inst : axi_serdes_fmc_v1_0_M00_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH,
		C_M_START_COUNT	=> C_M00_AXIS_START_COUNT
	)
	port map (
    rxclk_i        => trx0_rxclk,  -- clocked by received clock
    rxdata_i       => trx0_rxdata,
		M_AXIS_ACLK	=> m00_axis_aclk,
		M_AXIS_ARESETN	=> m00_axis_aresetn,
		M_AXIS_TVALID	=> m00_axis_tvalid,
		M_AXIS_TDATA	=> m00_axis_tdata,
		M_AXIS_TSTRB	=> m00_axis_tstrb,
		M_AXIS_TLAST	=> m00_axis_tlast,
		M_AXIS_TREADY	=> m00_axis_tready
	);

-- Instantiation of Axi Bus Interface S01_AXIS
axi_serdes_fmc_v1_0_S01_AXIS_inst : axi_serdes_fmc_v1_0_S00_AXIS
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
	)
	port map (
    txclk_i        => trx1_clk_i,  -- clocked by global transceiver clock
    txdata_o       => trx1_txdata,
		S_AXIS_ACLK	   => s01_axis_aclk,
		S_AXIS_ARESETN => s01_axis_aresetn,
		S_AXIS_TREADY	 => s01_axis_tready,
		S_AXIS_TDATA	 => s01_axis_tdata,
		S_AXIS_TSTRB	 => s01_axis_tstrb,
		S_AXIS_TLAST	 => s01_axis_tlast,
		S_AXIS_TVALID	 => s01_axis_tvalid
	);

-- Instantiation of Axi Bus Interface M01_AXIS
axi_serdes_fmc_v1_0_M01_AXIS_inst : axi_serdes_fmc_v1_0_M00_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH,
		C_M_START_COUNT	=> C_M00_AXIS_START_COUNT
	)
	port map (
    rxclk_i        => trx1_rxclk,  -- clocked by received clock
    rxdata_i       => trx1_rxdata,
		M_AXIS_ACLK	   => m01_axis_aclk,
		M_AXIS_ARESETN => m01_axis_aresetn,
		M_AXIS_TVALID	 => m01_axis_tvalid,
		M_AXIS_TDATA	 => m01_axis_tdata,
		M_AXIS_TSTRB	 => m01_axis_tstrb,
		M_AXIS_TLAST	 => m01_axis_tlast,
		M_AXIS_TREADY	 => m01_axis_tready
	);

	-- Add user logic here

  transceiver0_inst : transceiver
  generic map (
    RXCLK_IDELAY   => TRX0_RXCLK_IDELAY,
    RXDATA0_IDELAY => TRX0_RXDATA0_IDELAY,
    RXDATA1_IDELAY => TRX0_RXDATA1_IDELAY,
    RXDATA2_IDELAY => TRX0_RXDATA2_IDELAY,
    RXDATA3_IDELAY => TRX0_RXDATA3_IDELAY,
    RXDATA4_IDELAY => TRX0_RXDATA4_IDELAY
  )
  port map (
    rst_i          => not s00_axi_aresetn, -- For IDELAY control
    clk_i          => s00_axi_aclk,        -- For IDELAY control
    clk_200mhz_i   => clk_200mhz_i,        -- For IDELAYCTRL
    -- Input clock
    clk_p_i        => trx0_clk_p_i,
    clk_n_i        => trx0_clk_n_i,
    -- Output clocks
    clk_bufg_div_o => trx0_clk_bufg_div_o,
    clk_bufr_o     => trx0_clk_bufr_o,
    -- Transmitter interface
    txclk_i        => trx0_clk_i,  -- clocked by global transceiver clock
    txdata_i       => trx0_txdata, -- from AXIS slave
    txdata_p_o     => trx0_txdata_p_o,
    txdata_n_o     => trx0_txdata_n_o,
    txclk_p_o      => trx0_txclk_p_o,
    txclk_n_o      => trx0_txclk_n_o,
    -- Transmitter control
    txrst_i        => '0', -- from registers
    txrst_o        => trx0_txrst_o,
    txdcbal_i      => '0', -- from registers
    txdcbal_o      => trx0_txdcbal_o,
    txlock_i       => trx0_txlock_i,
    txlock_o       => open, -- from registers
    -- Receiver interface
    iodelay_inc_i  => '0', -- from registers
    iodelay_dec_i  => '0', -- from registers
    rxdata_p_i     => trx0_rxdata_p_i,
    rxdata_n_i     => trx0_rxdata_n_i,
    rxclk_p_i      => trx0_rxclk_p_i,
    rxclk_n_i      => trx0_rxclk_n_i,
    rxclk_o        => trx0_rxclk, -- to AXIS master
    rxdata_o       => trx0_rxdata, -- to AXIS master
    -- Receiver control
    rxrst_i        => '0', -- from registers
    rxrst_o        => trx0_rxrst_o,
    rxdcbal_i      => '0', -- from registers
    rxdcbal_o      => trx0_rxdcbal_o,
    rxlock_i       => trx0_rxlock_i,
    rxlock_o       => open -- from registers
  );
  
  
  transceiver1_inst : transceiver
  generic map (
    RXCLK_IDELAY   => TRX1_RXCLK_IDELAY,
    RXDATA0_IDELAY => TRX1_RXDATA0_IDELAY,
    RXDATA1_IDELAY => TRX1_RXDATA1_IDELAY,
    RXDATA2_IDELAY => TRX1_RXDATA2_IDELAY,
    RXDATA3_IDELAY => TRX1_RXDATA3_IDELAY,
    RXDATA4_IDELAY => TRX1_RXDATA4_IDELAY
  )
  port map (
    rst_i          => not s00_axi_aresetn, -- For IDELAY control
    clk_i          => s00_axi_aclk,        -- For IDELAY control
    clk_200mhz_i   => clk_200mhz_i,        -- For IDELAYCTRL
    -- Input clock
    clk_p_i        => trx1_clk_p_i,
    clk_n_i        => trx1_clk_n_i,
    -- Output clocks
    clk_bufg_div_o => trx1_clk_bufg_div_o,
    clk_bufr_o     => trx1_clk_bufr_o,
    -- Transmitter interface
    txclk_i        => trx1_clk_i,  -- clocked by global transceiver clock
    txdata_i       => trx1_txdata, -- from AXIS slave
    txdata_p_o     => trx1_txdata_p_o,
    txdata_n_o     => trx1_txdata_n_o,
    txclk_p_o      => trx1_txclk_p_o,
    txclk_n_o      => trx1_txclk_n_o,
    -- Transmitter control
    txrst_i        => '0', -- from registers
    txrst_o        => trx1_txrst_o,
    txdcbal_i      => '0', -- from registers
    txdcbal_o      => trx1_txdcbal_o,
    txlock_i       => trx1_txlock_i,
    txlock_o       => open, -- from registers
    -- Receiver interface
    iodelay_inc_i  => '0', -- from registers
    iodelay_dec_i  => '0', -- from registers
    rxdata_p_i     => trx1_rxdata_p_i,
    rxdata_n_i     => trx1_rxdata_n_i,
    rxclk_p_i      => trx1_rxclk_p_i,
    rxclk_n_i      => trx1_rxclk_n_i,
    rxclk_o        => trx1_rxclk, -- to AXIS master
    rxdata_o       => trx1_rxdata, -- to AXIS master
    -- Receiver control
    rxrst_i        => '0', -- from registers
    rxrst_o        => trx1_rxrst_o,
    rxdcbal_i      => '0', -- from registers
    rxdcbal_o      => trx1_rxdcbal_o,
    rxlock_i       => trx1_rxlock_i,
    rxlock_o       => open -- from registers
  );

	-- User logic ends

end arch_imp;
