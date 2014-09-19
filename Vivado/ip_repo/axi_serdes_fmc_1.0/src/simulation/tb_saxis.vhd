--------------------------------------------------------------------------------
-- Testbench for the Slave AXI interface
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_saxis is
end tb_saxis;

architecture tb of tb_saxis is

  -----------------------------------------------------------------------
  -- Timing constants
  -----------------------------------------------------------------------
  constant CLOCK_PERIOD   : time := 100 ns;
  constant CLOCK_PERIOD_X : time := 25 ns;
  constant T_HOLD         : time := 10 ns;
  constant T_STROBE       : time := CLOCK_PERIOD - (1 ns);
  constant T_RST          : time := 1000 ns;

  -----------------------------------------------------------------------
  -- DUT input signals
  -----------------------------------------------------------------------

  -- General inputs
  signal aclk                            : std_logic := '0';  -- the master clock
  signal aclk_x                          : std_logic := '0';  -- the master clock

	-- Ports of Axi Slave Bus Interface S00_AXIS
	signal s00_axis_aresetn	: std_logic := '0';
	signal s00_axis_tready	: std_logic := '0';
  signal s00_axis_tdata  : std_logic_vector(31 downto 0) := (others => '0');
	signal s00_axis_tstrb	: std_logic_vector(3 downto 0) := (others => '0');
	signal s00_axis_tlast	: std_logic := '0';
	signal s00_axis_tvalid	: std_logic := '0';

  signal trx0_txdata : std_logic_vector(9 downto 0) := (others => '0');
  
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

  -- Instantiation of Axi Bus Interface S00_AXIS
  axi_serdes_fmc_v1_0_S00_AXIS_inst : entity work.axi_serdes_fmc_v1_0_S00_AXIS
    generic map (
      C_S_AXIS_TDATA_WIDTH	=> 32
    )
    port map (
      txclk_i        => aclk_x,  -- clocked by global transceiver clock
      txdata_o       => trx0_txdata,
      S_AXIS_ACLK	=> aclk,
      S_AXIS_ARESETN	=> s00_axis_aresetn,
      S_AXIS_TREADY	=> s00_axis_tready,
      S_AXIS_TDATA	=> s00_axis_tdata,
      S_AXIS_TSTRB	=> s00_axis_tstrb,
      S_AXIS_TLAST	=> s00_axis_tlast,
      S_AXIS_TVALID	=> s00_axis_tvalid
    );

    
  -----------------------------------------------------------------------
  -- Generate clock
  -----------------------------------------------------------------------

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
    s00_axis_aresetn <= '0';

    -- Drive inputs T_HOLD time after rising edge of clock
    wait until rising_edge(aclk);
    wait for T_HOLD;

    wait for T_RST;
    s00_axis_aresetn <= '1';
    
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

