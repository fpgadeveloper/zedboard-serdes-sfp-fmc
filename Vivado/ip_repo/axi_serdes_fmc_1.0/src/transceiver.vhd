----------------------------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_misc.all;
  use ieee.std_logic_unsigned.all;
library unisim;
  use unisim.vcomponents.all;

entity transceiver is
generic (
    RXDATA_IDELAY : integer := 16
);
port (
    rst_i          : in std_logic;
    clk_i          : in std_logic;
    clk_200mhz_i   : in std_logic;
    -- Input clock
    clk_p_i        : in  std_logic;
    clk_n_i        : in  std_logic;
    -- Output clock
    clk_bufg_o     : out std_logic;
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
end transceiver;

architecture transceiver_syn of transceiver is

  component clk_buf
  port (
    -- Input clock
    clk_p_i      : in  std_logic;
    clk_n_i      : in  std_logic;
    -- Output clock
    clk_bufg_o   : out std_logic
  );
  end component;

  component tx_interface
  port (
    -- Input ports
    txclk_i        : in std_logic;
    txdata_i       : in std_logic_vector(9 downto 0);
    -- Output pins
    txdata_p_o     : out std_logic_vector(4 downto 0);
    txdata_n_o     : out std_logic_vector(4 downto 0);
    txclk_p_o      : out std_logic;
    txclk_n_o      : out std_logic
  );
  end component;

  component rx_interface
  generic (
    RXDATA_IDELAY : integer := 16
  );
  port (
    rst_i          : in std_logic;
    clk_i          : in std_logic;
    -- IDELAY Control
    iodelay_inc_i  : in std_logic;
    iodelay_dec_i  : in std_logic;
    -- Input pins
    rxdata_p_i     : in std_logic_vector(4 downto 0);
    rxdata_n_i     : in std_logic_vector(4 downto 0);
    rxclk_p_i      : in std_logic;
    rxclk_n_i      : in std_logic;
    -- Output ports
    rxclk_o        : out std_logic;
    rxdata_o       : out std_logic_vector(9 downto 0)
  );
  end component;

begin

  ----------------------------------------------------------------------------------------------------
  -- Reference clock buffer
  ----------------------------------------------------------------------------------------------------
  clk_buf_inst : clk_buf
  port map (
    clk_p_i    => clk_p_i,
    clk_n_i    => clk_n_i,
    clk_bufg_o => clk_bufg_o
  );

  ----------------------------------------------------------------------------------------------------
  -- Transmitter interface
  ----------------------------------------------------------------------------------------------------
  tx_interface_inst : tx_interface
  port map (
    txclk_i    => txclk_i,
    txdata_i   => txdata_i,
    txdata_p_o => txdata_p_o,
    txdata_n_o => txdata_n_o,
    txclk_p_o  => txclk_p_o,
    txclk_n_o  => txclk_n_o
  );
  
  ----------------------------------------------------------------------------------------------------
  -- Transmitter control input/output buffers
  ----------------------------------------------------------------------------------------------------
  txrst_inst : OBUF
  generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
  port map (
    O => txrst_o,
    I => txrst_i
  );
  
  txdcbal_inst : OBUF
  generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
  port map (
    O => txdcbal_o,
    I => txdcbal_i
  );
  
  txlock_inst : IBUF
  generic map (
    IBUF_LOW_PWR => TRUE,
    IOSTANDARD => "LVCMOS25")
  port map (
    O => txlock_o,
    I => txlock_i
  );

  ----------------------------------------------------------------------------------------------------
  -- Receiver interface
  ----------------------------------------------------------------------------------------------------
  rx_interface_inst : rx_interface
  port map (
    rst_i          => rst_i,
    clk_i          => clk_i,
    iodelay_inc_i  => iodelay_inc_i,
    iodelay_dec_i  => iodelay_dec_i,
    rxdata_p_i     => rxdata_p_i,
    rxdata_n_i     => rxdata_n_i,
    rxclk_p_i      => rxclk_p_i,
    rxclk_n_i      => rxclk_n_i,
    rxclk_o        => rxclk_o,
    rxdata_o       => rxdata_o
  );
  
  ----------------------------------------------------------------------------------------------------
  -- Receiver control input/output buffers
  ----------------------------------------------------------------------------------------------------
  rxrst_inst : OBUF
  generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
  port map (
    O => rxrst_o,
    I => rxrst_i
  );
  
  rxdcbal_inst : OBUF
  generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
  port map (
    O => rxdcbal_o,
    I => rxdcbal_i
  );
  
  rxlock_inst : IBUF
  generic map (
    IBUF_LOW_PWR => TRUE,
    IOSTANDARD => "LVCMOS25")
  port map (
    O => rxlock_o,
    I => rxlock_i
  );

  ----------------------------------------------------------------------------------------------------
  -- IDELAYCTRL - each transceiver is routed to a separate bank and thus must have its own IDELAYCTRL
  ----------------------------------------------------------------------------------------------------
  idelayctrl_inst : IDELAYCTRL
  port map (
    RDY => open,
    REFCLK => clk_200mhz_i,
    RST => rst_i
  );
  
end transceiver_syn;
