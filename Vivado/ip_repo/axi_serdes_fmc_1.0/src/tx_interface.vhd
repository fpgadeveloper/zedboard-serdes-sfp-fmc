----------------------------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_misc.all;
  use ieee.std_logic_unsigned.all;
library unisim;
  use unisim.vcomponents.all;

entity tx_interface is
port (
  rst_i          : in std_logic;
  -- Input ports
  txclk_i        : in std_logic;
  txdata_i       : in std_logic_vector(9 downto 0);
  -- Output pins
  txdata_p_o     : out std_logic_vector(4 downto 0);
  txdata_n_o     : out std_logic_vector(4 downto 0);
  txclk_p_o      : out std_logic;
  txclk_n_o      : out std_logic
);
end tx_interface;

architecture tx_interface_syn of tx_interface is

signal txdata_r0     : std_logic_vector(9 downto 0);
signal txdata_r1     : std_logic_vector(9 downto 0);
signal txdata_r2     : std_logic_vector(9 downto 0);
signal txclk_ddr     : std_logic;
signal txdata_ddr    : std_logic_vector(4 downto 0);

begin

  -- Pipelining the data to pass timing
  process (txclk_i)
	begin
	  if rst_i = '1' then
        txdata_r0 <= (others => '1');
        txdata_r1 <= (others => '1');
        txdata_r2 <= (others => '1');
	  else  
      if rising_edge(txclk_i) then 
        txdata_r0 <= txdata_i;
        txdata_r1 <= txdata_r0;
        txdata_r2 <= txdata_r1;
      end if;
    end if;
	end process;
  
  ----------------------------------------------------------------------------------------------------
  -- Forwarded transmit clock
  ----------------------------------------------------------------------------------------------------

  -- Clock DDR for clock forwarding
  -----------------------------------------------------
  -- The serializer wants the clock LEVEL to be low on the lower significant
  -- nibble and high on the higher significant nibble. When the internal delay
  -- is applied to the clock, this allows the lower nibble to be clocked in on
  -- the falling edge and the higher nibble on the rising edge.
  -- For more information on the LVDS DDR interface,
  -- see datasheet of DS32EL0124, specifically page 11, figure 6.
  clk_oddr_inst : ODDR
  generic map (
    DDR_CLK_EDGE => "SAME_EDGE"
  )
  port map (
    Q => txclk_ddr,
    C => txclk_i,
    CE => '1',
    D1 => '0', -- Rising edge, low nibble, low clock
    D2 => '1', -- Falling edge, high nibble, high clock
    R => '0',
    S => '0'
  );

  -- Differential output buffer
  clk_obufds_inst : OBUFDS
  port map (
    O  => txclk_p_o,
    OB => txclk_n_o,
    I  => txclk_ddr
  );
  
  ----------------------------------------------------------------------------------------------------
  -- Transmit data
  ----------------------------------------------------------------------------------------------------

  data: for i in 0 to 4 generate

    -- Data DDRs
    --------------------------------------------------------------------
    -- The serializer wants the lower nibble to precede the higher nibble.
    -- First clock cycle (rising edge) transmits the lower 5-bit nibble.
    -- Second clock cycle (falling edge) transmits the higher 5-bit nibble.
    -- This ensures that the serializer outputs the bits in order
    -- from the LSB to the MSB.
    --------------------------------------------------------------------
    data_iddr_inst : ODDR
    generic map (
      DDR_CLK_EDGE => "SAME_EDGE"
    )
    port map (
      Q => txdata_ddr(i),
      C => txclk_i,
      CE => '1',
      D1 => txdata_r2(i),   -- Rising edge: Low nibble
      D2 => txdata_r2(i+5), -- Falling edge: High nibble
      R => '0',
      S => '0'
    );

    -- Differential output buffer
    data_obufds_inst : OBUFDS
    port map (
      O  => txdata_p_o(i),
      OB => txdata_n_o(i),
      I  => txdata_ddr(i)
    );

  end generate;
  
end tx_interface_syn;
