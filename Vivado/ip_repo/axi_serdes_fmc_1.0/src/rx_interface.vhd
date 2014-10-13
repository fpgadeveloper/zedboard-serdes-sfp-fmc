----------------------------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library unisim;
  use unisim.vcomponents.all;

entity rx_interface is
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
  -- IDELAY Control
  iodelay_inc_i  : in std_logic;
  iodelay_dec_i  : in std_logic;
  -- Input pins
  rxdata_p_i     : in std_logic_vector(4 downto 0);
  rxdata_n_i     : in std_logic_vector(4 downto 0);
  rxclk_p_i      : in std_logic;
  rxclk_n_i      : in std_logic;
  rxlock_i       : in std_logic;
  -- Output ports
  rxclk_o        : out std_logic;
  rxdata_o       : out std_logic_vector(9 downto 0)
);
end rx_interface;

architecture rx_interface_syn of rx_interface is

type INT_ARRAY is array (4 downto 0) of integer range 0 to 63;
constant RXDATA_IDELAY : INT_ARRAY := (RXDATA4_IDELAY,RXDATA3_IDELAY,RXDATA2_IDELAY,RXDATA1_IDELAY,RXDATA0_IDELAY);

signal iodelay_ce    : std_logic;
signal rxclk_ibufds  : std_logic;
signal rxclk_delay   : std_logic;
signal rxclk_bufr    : std_logic;
signal rxdata_ibufds : std_logic_vector(4 downto 0);
signal rxdata_ddr    : std_logic_vector(4 downto 0);
signal rxdata_delay  : std_logic_vector(4 downto 0);
signal rxdata_sdr    : std_logic_vector(9 downto 0);
signal rxdata_sdr_r0 : std_logic_vector(9 downto 0);
signal rxdata_sdr_r1 : std_logic_vector(9 downto 0);
signal rxdata_sdr_r2 : std_logic_vector(9 downto 0);

attribute KEEP : string;

attribute KEEP of rxdata_sdr_r0: signal is "true";
attribute KEEP of rxdata_sdr_r1: signal is "true";
attribute KEEP of rxdata_sdr_r2: signal is "true";

begin
  ----------------------------------------------------------------------------------------------------
  -- IDELAY Control
  ----------------------------------------------------------------------------------------------------
  iodelay_ce <= iodelay_inc_i or iodelay_dec_i;

  ----------------------------------------------------------------------------------------------------
  -- Receive clock
  ----------------------------------------------------------------------------------------------------
  -- Differential input buffer
  clk_ibufds_inst : IBUFDS
  port map (
    I  => rxclk_p_i,
    IB => rxclk_n_i,
    O  => rxclk_ibufds
  );

  clk_idelay_inst : IDELAY
  generic map (
    IOBDELAY_TYPE => "FIXED",
    IOBDELAY_VALUE => RXCLK_IDELAY )
  port map (
    O => rxclk_delay,
    I => rxclk_ibufds,
    C => '0',
    CE => '0',
    INC => '0',
    RST => rst_i
  );
   
  -- BUFR for clocking logic
  clk_bufr_inst : BUFR
  generic map (
    BUFR_DIVIDE => "BYPASS"
  )
  port map (
    O => rxclk_bufr,
    CE => '1',
    CLR => '0',
    I => rxclk_delay
  );

  ----------------------------------------------------------------------------------------------------
  -- Receive data
  ----------------------------------------------------------------------------------------------------

  data: for i in 0 to 4 generate

    -- Differential input buffer
    ibufds_inst : IBUFDS
    port map (
      i  => rxdata_p_i(i),
      ib => rxdata_n_i(i),
      o  => rxdata_ibufds(i)
    );

    -- Input delay
    idelay_inst : IDELAYE2
    generic map (
      IDELAY_TYPE  => "VARIABLE",
      IDELAY_VALUE => RXDATA_IDELAY(i),
      DELAY_SRC    => "IDATAIN"
    )
    port map (
      DATAOUT => rxdata_delay(i),
      IDATAIN => rxdata_ibufds(i),

      C => clk_i,
      CE => iodelay_ce,
      INC => iodelay_inc_i,
      LD => '0',
      LDPIPEEN => '0',
      DATAIN => '0',
      REGRST => rst_i,
      CNTVALUEIN => std_logic_vector(to_unsigned(RXDATA_IDELAY(i), 5)),
      CINVCTRL => '0'
    );

    -- DDR
    --------------------------------------------------------------------
    -- The deserializer presents the lower significant nibble (LSN) before
    -- the high significant nibble (HSN). The LSN must be clocked into
    -- the FPGA on the FALLING edge of the clock and the HSN on the rising.
    -- However, the IDDR primitive outputs the first data on the rising edge,
    -- therefore we need to negate the clock at the input (C).
    -- First clock cycle (rising edge) receives the lower 5-bit nibble.
    -- Second clock cycle (falling edge) receives the higher 5-bit nibble.
    --------------------------------------------------------------------
    iddr_inst : IDDR
    generic map (
      DDR_CLK_EDGE => "SAME_EDGE_PIPELINED"
    )
    port map (
      Q1 => rxdata_sdr(i),    -- Rising edge: Low nibble
      Q2 => rxdata_sdr(i+5),  -- Falling edge: High nibble
      C  => rxclk_bufr,  -- Clock is negated
      CE => '1',
      D  => rxdata_delay(i),
      R  => '0',
      S  => '0'
    );

  end generate;
  
  -- Pipelining the data to pass timing
  process (rxclk_bufr)
	begin
    if rising_edge(rxclk_bufr) then
      -- When we lose lock, reset the buffers
      if (rxlock_i = '1') then
        rxdata_sdr_r0 <= (others => '1');
        rxdata_sdr_r1 <= (others => '1');
        rxdata_sdr_r2 <= (others => '1');
      else
        rxdata_sdr_r0 <= rxdata_sdr;
        rxdata_sdr_r1 <= rxdata_sdr_r0;
        rxdata_sdr_r2 <= rxdata_sdr_r1;
      end if;
    end if;
	end process;
	
-- Assign outputs
rxclk_o <= rxclk_bufr;
rxdata_o <= rxdata_sdr_r2;

end rx_interface_syn;
