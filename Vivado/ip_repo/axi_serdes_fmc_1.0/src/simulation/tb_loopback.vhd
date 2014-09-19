--------------------------------------------------------------------------------
-- Testbench for the Slave AXI interface
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_loopback is
end tb_loopback;

architecture tb of tb_loopback is

  -----------------------------------------------------------------------
  -- Timing constants
  -----------------------------------------------------------------------
  constant CLOCK_PERIOD   : time := 100 ns;
  constant CLOCK_PERIOD_X : time := 25 ns;
  constant T_HOLD         : time := 10 ns;
  constant T_STROBE       : time := CLOCK_PERIOD - (1 ns);
  constant T_RST          : time := 1000 ns;

  -----------------------------------------------------------------------
  -- DUT constants
  -----------------------------------------------------------------------
	-- Parameters of Axi Slave Bus Interface S00_AXI
	constant C_S00_AXI_DATA_WIDTH	: integer	:= 32;
	constant C_S00_AXI_ADDR_WIDTH	: integer	:= 4;
   
	-- Parameters of Axi Slave Bus Interface S00_AXIS
	constant C_S00_AXIS_TDATA_WIDTH	: integer	:= 32;
   
	-- Parameters of Axi Master Bus Interface M00_AXIS
	constant C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
	constant C_M00_AXIS_START_COUNT	: integer	:= 32;
  
  -----------------------------------------------------------------------
  -- DUT input signals
  -----------------------------------------------------------------------

  -- General inputs
  signal aresetn                         : std_logic := '0';
  signal aclk                            : std_logic := '0';  -- the master clock
  signal aclk_x                          : std_logic := '0';  -- the master clock
  signal rxclk_p                         : std_logic := '0';  -- the receive clock
  signal rxclk_n                         : std_logic := '0';  -- the receive clock

  signal rst_i          : std_logic := '0';
  signal clk_i          : std_logic := '0';
  signal clk_200mhz_i   : std_logic := '0';
  --------------------------------------------------------
  -- Transceiver 0 ports
  --------------------------------------------------------
  -- Input clock from FMC
  signal trx0_clk_p_i        : std_logic := '0';
  signal trx0_clk_n_i        : std_logic := '0';
  -- Output clock
  signal trx0_clk_bufg_o     : std_logic := '0';
  -- Input clock from user design
  signal trx0_clk_i          : std_logic := '0';
  -- Transmitter interface
  signal trx0_txdata_p_o     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx0_txdata_n_o     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx0_txclk_p_o      : std_logic := '0';
  signal trx0_txclk_n_o      : std_logic := '0';
  -- Transmitter control
  signal trx0_txrst_o        :  std_logic := '0';
  signal trx0_txdcbal_o      :  std_logic := '0';
  signal trx0_txlock_i       : std_logic := '0';
  -- Receiver interface
  signal trx0_rxdata_p_i     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx0_rxdata_n_i     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx0_rxclk_p_i      : std_logic := '0';
  signal trx0_rxclk_n_i      : std_logic := '0';
  -- Receiver control
  signal trx0_rxrst_o        :  std_logic := '0';
  signal trx0_rxdcbal_o      :  std_logic := '0';
  signal trx0_rxlock_i       : std_logic := '0';
  
  --------------------------------------------------------
  -- Transceiver 1 ports
  --------------------------------------------------------
  -- Input clock from FMC
  signal trx1_clk_p_i        : std_logic := '0';
  signal trx1_clk_n_i        : std_logic := '0';
  -- Output clock
  signal trx1_clk_bufg_o     : std_logic := '0';
  -- Input clock from user design
  signal trx1_clk_i          : std_logic := '0';
  -- Transmitter interface
  signal trx1_txdata_p_o     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx1_txdata_n_o     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx1_txclk_p_o      : std_logic := '0';
  signal trx1_txclk_n_o      : std_logic := '0';
  -- Transmitter control
  signal trx1_txrst_o        :  std_logic := '0';
  signal trx1_txdcbal_o      :  std_logic := '0';
  signal trx1_txlock_i       : std_logic := '0';
  -- Receiver interface
  signal trx1_rxdata_p_i     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx1_rxdata_n_i     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx1_rxclk_p_i      : std_logic := '0';
  signal trx1_rxclk_n_i      : std_logic := '0';
  -- Receiver control
  signal trx1_rxrst_o        :  std_logic := '0';
  signal trx1_rxdcbal_o      :  std_logic := '0';
  signal trx1_rxlock_i       : std_logic := '0';

	-- Ports of Axi Slave Bus Interface S00_AXI
	signal s00_axi_aclk   	: std_logic := '0';
	signal s00_axi_aresetn	: std_logic := '0';
	signal s00_axi_awaddr	  : std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
	signal s00_axi_awprot	  : std_logic_vector(2 downto 0) := (others => '0');
	signal s00_axi_awvalid	: std_logic := '0';
	signal s00_axi_awready	:  std_logic := '0';
	signal s00_axi_wdata	  : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal s00_axi_wstrb	  : std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0) := (others => '0');
	signal s00_axi_wvalid	  : std_logic := '0';
	signal s00_axi_wready	  :  std_logic := '0';
	signal s00_axi_bresp	  :  std_logic_vector(1 downto 0) := (others => '0');
	signal s00_axi_bvalid	  :  std_logic := '0';
	signal s00_axi_bready	  : std_logic := '0';
	signal s00_axi_araddr	  : std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
	signal s00_axi_arprot	  : std_logic_vector(2 downto 0) := (others => '0');
	signal s00_axi_arvalid	: std_logic := '0';
	signal s00_axi_arready	:  std_logic := '0';
	signal s00_axi_rdata	  :  std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal s00_axi_rresp	  :  std_logic_vector(1 downto 0) := (others => '0');
	signal s00_axi_rvalid	  :  std_logic := '0';
	signal s00_axi_rready	  : std_logic := '0';

	-- Ports of Axi Slave Bus Interface S00_AXIS
	signal s00_axis_aclk	  : std_logic := '0';
	signal s00_axis_aresetn	: std_logic := '0';
	signal s00_axis_tready	:  std_logic := '0';
	signal s00_axis_tdata	  : std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
	signal s00_axis_tstrb	  : std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
	signal s00_axis_tlast	  : std_logic := '0';
	signal s00_axis_tvalid	: std_logic := '0';

	-- Ports of Axi Master Bus Interface M00_AXIS
	signal m00_axis_aclk	  : std_logic := '0';
	signal m00_axis_aresetn	: std_logic := '0';
	signal m00_axis_tvalid	:  std_logic := '0';
	signal m00_axis_tdata	  :  std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
	signal m00_axis_tstrb	  :  std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0) := (others => '0');
	signal m00_axis_tlast	  :  std_logic := '0';
	signal m00_axis_tready	: std_logic := '0';
  
  -----------------------------------------------------------------------
  -- Aliases for AXI channel TDATA and TUSER fields
  -- These are a convenience for viewing data in a simulator waveform viewer.
  -- If using ModelSim or Questa, add "-voptargs=+acc=n" to the vsim command
  -- to prevent the simulator optimizing away these signals.
  -----------------------------------------------------------------------


  signal end_of_simulation : boolean := false;
     
begin

  -----------------------------------------------------------------------
  -- Instantiate the DUT
  -----------------------------------------------------------------------

axi_serdes_fmc_v1_0_inst : entity work.axi_serdes_fmc_v1_0
	port map (
		-- Users to add ports here
    rst_i          => rst_i,
    clk_i          => clk_i,
    clk_200mhz_i   => clk_200mhz_i,
    --------------------------------------------------------
    -- Transceiver 0 ports
    --------------------------------------------------------
    -- Input clock from FMC
    trx0_clk_p_i        => trx0_clk_p_i,
    trx0_clk_n_i        => trx0_clk_n_i,
    -- Output clock
    trx0_clk_bufg_o     => trx0_clk_bufg_o,
    -- Input clock from user design
    trx0_clk_i          => trx0_clk_i,
    -- Transmitter interface
    trx0_txdata_p_o     => trx0_txdata_p_o,
    trx0_txdata_n_o     => trx0_txdata_n_o,
    trx0_txclk_p_o      => trx0_txclk_p_o ,
    trx0_txclk_n_o      => trx0_txclk_n_o ,
    -- Transmitter control
    trx0_txrst_o        => trx0_txrst_o  ,
    trx0_txdcbal_o      => trx0_txdcbal_o,
    trx0_txlock_i       => trx0_txlock_i ,
    -- Receiver interface
    trx0_rxdata_p_i     => trx0_rxdata_p_i,
    trx0_rxdata_n_i     => trx0_rxdata_n_i,
    trx0_rxclk_p_i      => trx0_rxclk_p_i ,
    trx0_rxclk_n_i      => trx0_rxclk_n_i ,
    -- Receiver control
    trx0_rxrst_o        => trx0_rxrst_o  ,
    trx0_rxdcbal_o      => trx0_rxdcbal_o,
    trx0_rxlock_i       => trx0_rxlock_i ,

    --------------------------------------------------------
    -- Transceiver 1 ports
    --------------------------------------------------------
    -- Input clock from FMC
    trx1_clk_p_i        => trx1_clk_p_i,
    trx1_clk_n_i        => trx1_clk_n_i,
    -- Output clock
    trx1_clk_bufg_o     => trx1_clk_bufg_o,
    -- Input clock from user design
    trx1_clk_i          => trx1_clk_i,
    -- Transmitter interface
    trx1_txdata_p_o     => trx1_txdata_p_o,
    trx1_txdata_n_o     => trx1_txdata_n_o,
    trx1_txclk_p_o      => trx1_txclk_p_o ,
    trx1_txclk_n_o      => trx1_txclk_n_o ,
    -- Transmitter control
    trx1_txrst_o        => trx1_txrst_o  ,
    trx1_txdcbal_o      => trx1_txdcbal_o,
    trx1_txlock_i       => trx1_txlock_i ,
    -- Receiver interface
    trx1_rxdata_p_i     => trx1_rxdata_p_i,
    trx1_rxdata_n_i     => trx1_rxdata_n_i,
    trx1_rxclk_p_i      => trx1_rxclk_p_i ,
    trx1_rxclk_n_i      => trx1_rxclk_n_i ,
    -- Receiver control
    trx1_rxrst_o        => trx1_rxrst_o  ,
    trx1_rxdcbal_o      => trx1_rxdcbal_o,
    trx1_rxlock_i       => trx1_rxlock_i ,
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	  => s00_axi_aclk	  ,
		s00_axi_aresetn	=> s00_axi_aresetn	,
		s00_axi_awaddr	=> s00_axi_awaddr	,
		s00_axi_awprot	=> s00_axi_awprot	,
		s00_axi_awvalid	=> s00_axi_awvalid	,
		s00_axi_awready	=> s00_axi_awready	,
		s00_axi_wdata	  => s00_axi_wdata	  ,
		s00_axi_wstrb	  => s00_axi_wstrb	  ,
		s00_axi_wvalid	=> s00_axi_wvalid	,
		s00_axi_wready	=> s00_axi_wready	,
		s00_axi_bresp	  => s00_axi_bresp	  ,
		s00_axi_bvalid	=> s00_axi_bvalid	,
		s00_axi_bready	=> s00_axi_bready	,
		s00_axi_araddr	=> s00_axi_araddr	,
		s00_axi_arprot	=> s00_axi_arprot	,
		s00_axi_arvalid	=> s00_axi_arvalid	,
		s00_axi_arready	=> s00_axi_arready	,
		s00_axi_rdata	  => s00_axi_rdata	  ,
		s00_axi_rresp	  => s00_axi_rresp	  ,
		s00_axi_rvalid	=> s00_axi_rvalid	,
		s00_axi_rready	=> s00_axi_rready	,

		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_aclk	    => s00_axis_aclk	  ,
		s00_axis_aresetn	=> s00_axis_aresetn,
		s00_axis_tready	  => s00_axis_tready	,
		s00_axis_tdata	  => s00_axis_tdata	,
		s00_axis_tstrb	  => s00_axis_tstrb	,
		s00_axis_tlast	  => s00_axis_tlast	,
		s00_axis_tvalid	  => s00_axis_tvalid	,

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	    => m00_axis_aclk	  ,
		m00_axis_aresetn	=> m00_axis_aresetn,
		m00_axis_tvalid	  => m00_axis_tvalid	,
		m00_axis_tdata	  => m00_axis_tdata	,
		m00_axis_tstrb	  => m00_axis_tstrb	,
		m00_axis_tlast	  => m00_axis_tlast	,
		m00_axis_tready	  => m00_axis_tready	
	);

  -- Loopback transmit pins to receive pins
  trx0_rxdata_p_i <= trx0_txdata_p_o;
  trx0_rxdata_n_i <= trx0_txdata_n_o;
  trx0_rxclk_p_i  <= rxclk_p; -- delayed transmit clock
  trx0_rxclk_n_i  <= rxclk_n; -- delayed transmit clock
  
  -- Transceiver clock
  trx0_clk_i <= aclk_x;
  trx1_clk_i <= aclk_x;
  
  -- AXI slave
  s00_axi_aclk <= aclk;
  s00_axi_aresetn <= aresetn;
  
  -- AXI streaming slave
  s00_axis_aclk <= aclk;
  s00_axis_aresetn <= aresetn;
  
  -- AXI streaming master
  m00_axis_aclk <= aclk;
  m00_axis_aresetn <= aresetn;
  
  -----------------------------------------------------------------------
  -- Generate clock
  -----------------------------------------------------------------------

  -- Adds delay to transmit clock (normally added by deserializer)
  rxclk_gen : process
  begin
    rxclk_p <= '0';
    rxclk_n <= '1';
    if (end_of_simulation) then
      wait;
    else
      wait for CLOCK_PERIOD;
      loop
        rxclk_p <= '0';
        rxclk_n <= '1';
        wait until trx0_txclk_p_o = '1';
        wait for CLOCK_PERIOD_X/2;
        rxclk_p <= '1';
        rxclk_n <= '0';
        wait until trx0_txclk_p_o = '0';
        wait for CLOCK_PERIOD_X/2;
      end loop;
    end if;
  end process rxclk_gen;

  -- AXI clock generator
  clock_gen : process
  begin
    aclk <= '0';
    if (end_of_simulation) then
      wait;
    else
      wait for CLOCK_PERIOD;
      loop
        aclk <= '0';
        wait for CLOCK_PERIOD/2;
        aclk <= '1';
        wait for CLOCK_PERIOD/2;
      end loop;
    end if;
  end process clock_gen;

  -- Data clock generator (AXI clock x 4)
  clock_x_gen : process
  begin
    aclk_x <= '0';
    if (end_of_simulation) then
      wait;
    else
      wait for CLOCK_PERIOD_X;
      loop
        aclk_x <= '0';
        wait for CLOCK_PERIOD_X/2;
        aclk_x <= '1';
        wait for CLOCK_PERIOD_X/2;
      end loop;
    end if;
  end process clock_x_gen;

  -----------------------------------------------------------------------
  -- Generate inputs
  -----------------------------------------------------------------------

  stimuli : process
    variable bytenum : unsigned(7 downto 0);  -- byte number
  begin
    aresetn <= '0';

    -- Drive inputs T_HOLD time after rising edge of clock
    wait until rising_edge(aclk);
    wait for T_HOLD;

    wait for T_RST;
    aresetn <= '1';
    
    -- Input an incrementing number each cycle
    bytenum := "00000000";  -- start with byte number 0
    for cycle in 0 to 159 loop
      s00_axis_tvalid  <= '1';
      s00_axis_tdata(7 downto 0) <= std_logic_vector(bytenum);
      s00_axis_tdata(15 downto 8) <= std_logic_vector(bytenum+"00000001");
      s00_axis_tdata(23 downto 16) <= std_logic_vector(bytenum+"00000010");
      s00_axis_tdata(31 downto 24) <= std_logic_vector(bytenum+"00000011");
      wait for CLOCK_PERIOD;
      bytenum := bytenum + "00000100";
    end loop;
    
    s00_axis_tvalid <= '0';

    -- End of test
    end_of_simulation <= true;           
    report "Not a real failure. Simulation finished successfully. Test completed successfully" severity failure;
    wait;

  end process stimuli;



end tb;

