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
  signal aresetn              : std_logic := '0';
  signal aclk_x               : std_logic := '0';  -- the master clock
  signal trx0_rxclk_p         : std_logic := '0';  -- the receive clock
  signal trx0_rxclk_n         : std_logic := '0';  -- the receive clock
  signal trx1_rxclk_p         : std_logic := '0';  -- the receive clock
  signal trx1_rxclk_n         : std_logic := '0';  -- the receive clock

  signal clk_200mhz_i   : std_logic := '0';
  --------------------------------------------------------
  -- Transceiver 0 ports
  --------------------------------------------------------
  -- Input clock from FMC
  signal trx0_clk_p_i        : std_logic := '0';
  signal trx0_clk_n_i        : std_logic := '0';
  -- Output clocks
  signal trx0_clk_bufg_div_o : std_logic := '0';
  signal trx0_clk_bufr_o     : std_logic := '0';
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
  -- Output clocks
  signal trx1_clk_bufg_div_o : std_logic := '0';
  signal trx1_clk_bufr_o     : std_logic := '0';
  -- Input clock from user design
  signal trx1_clk_i          : std_logic := '0';
  -- Transmitter interface
  signal trx1_txdata_p_o     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx1_txdata_n_o     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx1_txclk_p_o      : std_logic := '0';
  signal trx1_txclk_n_o      : std_logic := '0';
  -- Transmitter control
  signal trx1_txrst_o        : std_logic := '0';
  signal trx1_txdcbal_o      : std_logic := '0';
  signal trx1_txlock_i       : std_logic := '0';
  -- Receiver interface
  signal trx1_rxdata_p_i     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx1_rxdata_n_i     : std_logic_vector(4 downto 0) := (others => '0');
  signal trx1_rxclk_p_i      : std_logic := '0';
  signal trx1_rxclk_n_i      : std_logic := '0';
  -- Receiver control
  signal trx1_rxrst_o        : std_logic := '0';
  signal trx1_rxdcbal_o      : std_logic := '0';
  signal trx1_rxlock_i       : std_logic := '0';

	-- Ports of Axi Slave Bus Interface S00_AXI
	signal s00_axi_aclk   	: std_logic := '0';
	signal s00_axi_aresetn	: std_logic := '0';
	signal s00_axi_awaddr	  : std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
	signal s00_axi_awprot	  : std_logic_vector(2 downto 0) := (others => '0');
	signal s00_axi_awvalid	: std_logic := '0';
	signal s00_axi_awready	: std_logic := '0';
	signal s00_axi_wdata	  : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal s00_axi_wstrb	  : std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0) := (others => '0');
	signal s00_axi_wvalid	  : std_logic := '0';
	signal s00_axi_wready	  : std_logic := '0';
	signal s00_axi_bresp	  : std_logic_vector(1 downto 0) := (others => '0');
	signal s00_axi_bvalid	  : std_logic := '0';
	signal s00_axi_bready	  : std_logic := '0';
	signal s00_axi_araddr	  : std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
	signal s00_axi_arprot	  : std_logic_vector(2 downto 0) := (others => '0');
	signal s00_axi_arvalid	: std_logic := '0';
	signal s00_axi_arready	: std_logic := '0';
	signal s00_axi_rdata	  : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal s00_axi_rresp	  : std_logic_vector(1 downto 0) := (others => '0');
	signal s00_axi_rvalid	  : std_logic := '0';
	signal s00_axi_rready	  : std_logic := '0';

	-- Ports of Axi Slave Bus Interface S00_AXIS
	signal s00_axis_aclk	  : std_logic := '0';
	signal s00_axis_aresetn	: std_logic := '0';
	signal s00_axis_tready	: std_logic := '0';
	signal s00_axis_tdata	  : std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
	signal s00_axis_tlast	  : std_logic := '0';
	signal s00_axis_tvalid	: std_logic := '0';

	-- Ports of Axi Master Bus Interface M00_AXIS
	signal m00_axis_aclk	  : std_logic := '0';
	signal m00_axis_aresetn	: std_logic := '0';
	signal m00_axis_tvalid	: std_logic := '0';
	signal m00_axis_tdata	  : std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
	signal m00_axis_tlast	  : std_logic := '0';
	signal m00_axis_tready	: std_logic := '0';
  
	-- Ports of Axi Slave Bus Interface S01_AXIS
	signal s01_axis_aclk	  : std_logic := '0';
	signal s01_axis_aresetn	: std_logic := '0';
	signal s01_axis_tready	: std_logic := '0';
	signal s01_axis_tdata	  : std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
	signal s01_axis_tlast	  : std_logic := '0';
	signal s01_axis_tvalid	: std_logic := '0';

	-- Ports of Axi Master Bus Interface M01_AXIS
	signal m01_axis_aclk	  : std_logic := '0';
	signal m01_axis_aresetn	: std_logic := '0';
	signal m01_axis_tvalid	: std_logic := '0';
	signal m01_axis_tdata	  : std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
	signal m01_axis_tlast	  : std_logic := '0';
	signal m01_axis_tready	: std_logic := '0';
  
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
    clk_200mhz_i   => clk_200mhz_i,
    --------------------------------------------------------
    -- Transceiver 0 ports
    --------------------------------------------------------
    -- Input clock from FMC
    trx0_clk_p_i        => trx0_clk_p_i,
    trx0_clk_n_i        => trx0_clk_n_i,
    -- Output clocks
    trx0_clk_bufg_div_o => trx0_clk_bufg_div_o,
    trx0_clk_bufr_o     => trx0_clk_bufr_o,
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
    -- Output clocks
    trx1_clk_bufg_div_o => trx1_clk_bufg_div_o,
    trx1_clk_bufr_o     => trx1_clk_bufr_o,
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
		s00_axis_tlast	  => s00_axis_tlast	,
		s00_axis_tvalid	  => s00_axis_tvalid	,

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	    => m00_axis_aclk	  ,
		m00_axis_aresetn	=> m00_axis_aresetn,
		m00_axis_tvalid	  => m00_axis_tvalid	,
		m00_axis_tdata	  => m00_axis_tdata	,
		m00_axis_tlast	  => m00_axis_tlast	,
		m00_axis_tready	  => m00_axis_tready,
    
		-- Ports of Axi Slave Bus Interface S01_AXIS
		s01_axis_aclk	    => s01_axis_aclk	  ,
		s01_axis_aresetn	=> s01_axis_aresetn,
		s01_axis_tready	  => s01_axis_tready	,
		s01_axis_tdata	  => s01_axis_tdata	,
		s01_axis_tlast	  => s01_axis_tlast	,
		s01_axis_tvalid	  => s01_axis_tvalid	,

		-- Ports of Axi Master Bus Interface M01_AXIS
		m01_axis_aclk	    => m01_axis_aclk	  ,
		m01_axis_aresetn	=> m01_axis_aresetn,
		m01_axis_tvalid	  => m01_axis_tvalid	,
		m01_axis_tdata	  => m01_axis_tdata	,
		m01_axis_tlast	  => m01_axis_tlast	,
		m01_axis_tready	  => m01_axis_tready	
	);

  -- Loopback transmit pins to receive pins
  trx0_rxdata_p_i <= trx0_txdata_p_o;
  trx0_rxdata_n_i <= trx0_txdata_n_o;
  trx0_rxclk_p_i  <= trx0_rxclk_p; -- delayed transmit clock
  trx0_rxclk_n_i  <= trx0_rxclk_n; -- delayed transmit clock
  
  trx1_rxdata_p_i <= trx1_txdata_p_o;
  trx1_rxdata_n_i <= trx1_txdata_n_o;
  trx1_rxclk_p_i  <= trx1_rxclk_p; -- delayed transmit clock
  trx1_rxclk_n_i  <= trx1_rxclk_n; -- delayed transmit clock
  
  -- Clock from FMC
  trx0_clk_p_i <= aclk_x;
  trx0_clk_n_i <= not aclk_x;
  trx1_clk_p_i <= aclk_x;
  trx1_clk_n_i <= not aclk_x;
  
  -- Regional buffer clock fed back into core
  trx0_clk_i <= trx0_clk_bufr_o;
  trx1_clk_i <= trx1_clk_bufr_o;
  
  -- AXI slave
  s00_axi_aclk <= trx0_clk_bufg_div_o;
  s00_axi_aresetn <= aresetn;
  
  -- AXI streaming slave
  s00_axis_aclk <= trx0_clk_bufg_div_o;
  s00_axis_aresetn <= aresetn;
  s01_axis_aclk <= trx1_clk_bufg_div_o;
  s01_axis_aresetn <= aresetn;
  
  -- AXI streaming master
  m00_axis_aclk <= trx0_clk_bufg_div_o;
  m00_axis_aresetn <= aresetn;
  m01_axis_aclk <= trx1_clk_bufg_div_o;
  m01_axis_aresetn <= aresetn;
  
  -----------------------------------------------------------------------
  -- Generate clock
  -----------------------------------------------------------------------

  -- Adds delay to transmit clock (normally added by deserializer)
  trx0_rxclk_gen : process
  begin
    trx0_rxclk_p <= '0';
    trx0_rxclk_n <= '1';
    if (end_of_simulation) then
      wait;
    else
      wait for CLOCK_PERIOD;
      loop
        trx0_rxclk_p <= '0';
        trx0_rxclk_n <= '1';
        wait until trx0_txclk_p_o = '1';
        wait for CLOCK_PERIOD_X/4;
        trx0_rxclk_p <= '1';
        trx0_rxclk_n <= '0';
        wait until trx0_txclk_p_o = '0';
        wait for CLOCK_PERIOD_X/4;
      end loop;
    end if;
  end process trx0_rxclk_gen;

  -- Adds delay to transmit clock (normally added by deserializer)
  trx1_rxclk_gen : process
  begin
    trx1_rxclk_p <= '0';
    trx1_rxclk_n <= '1';
    if (end_of_simulation) then
      wait;
    else
      wait for CLOCK_PERIOD;
      loop
        trx1_rxclk_p <= '0';
        trx1_rxclk_n <= '1';
        wait until trx1_txclk_p_o = '1';
        wait for CLOCK_PERIOD_X/4;
        trx1_rxclk_p <= '1';
        trx1_rxclk_n <= '0';
        wait until trx1_txclk_p_o = '0';
        wait for CLOCK_PERIOD_X/4;
      end loop;
    end if;
  end process trx1_rxclk_gen;

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
    trx0_rxlock_i <= '1';
    trx0_txlock_i <= '1';
    trx1_rxlock_i <= '1';
    trx1_txlock_i <= '1';

    -- Drive inputs T_HOLD time after rising edge of clock
    wait until rising_edge(aclk_x);
    wait for T_HOLD;

    wait for T_RST;
    aresetn <= '1';
    
    wait for CLOCK_PERIOD*3;
    
    -- Ready for receive data
    m00_axis_tready <= '1';
    m01_axis_tready <= '1';
    
    -- Transmit and receive locks achieved
    trx0_rxlock_i <= '0';
    trx0_txlock_i <= '0';
    trx1_rxlock_i <= '0';
    trx1_txlock_i <= '0';
    
    -- Send data 10 times
    for cycle in 0 to 5 loop
      s00_axis_tvalid  <= '1';
      s01_axis_tvalid  <= '1';
      -- Send 4 bytes on both transmitters
      s00_axis_tdata <= x"98FEDCBA";
      s01_axis_tdata <= x"87654321";
      wait for CLOCK_PERIOD;
      -- Send 4 bytes on both transmitters
      s00_axis_tdata <= x"98FEDCBA";
      s01_axis_tdata <= x"87654321";
      wait for CLOCK_PERIOD;
      for sync in 0 to 10 loop
          -- Send sync (valid signal LOW)
          s00_axis_tdata <= (others => '0'); -- Zeroing data is not actually necessary
          s01_axis_tdata <= (others => '0'); -- but it looks nicer in simulation
          s00_axis_tvalid  <= '0';
          s01_axis_tvalid  <= '0';
          wait for CLOCK_PERIOD;
      end loop;
    end loop;
    
    wait for CLOCK_PERIOD*50;
    
    s00_axis_tvalid <= '0';
    s01_axis_tvalid <= '0';

    -- End of test
    end_of_simulation <= true;           
    report "Not a real failure. Simulation finished successfully. Test completed successfully" severity failure;
    wait;

  end process stimuli;



end tb;

