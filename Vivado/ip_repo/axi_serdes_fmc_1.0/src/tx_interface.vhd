----------------------------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library unisim;
  use unisim.vcomponents.all;

entity tx_interface is
port (
  rst_i          : in std_logic;
  -- Input ports
  txclk_i        : in std_logic;
  txdata_i       : in std_logic_vector(9 downto 0);
  txlock_i       : in std_logic;
  -- Output pins
  txready_o      : out std_logic;
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
signal txdata_ddr_in : std_logic_vector(9 downto 0);
signal txdata_ddr    : std_logic_vector(4 downto 0);
signal txready       : std_logic;
signal counter       : std_logic_vector(7 downto 0);

begin

  -- Pipelining the data to pass timing
  process (txclk_i)
	begin
    if rising_edge(txclk_i) then 
      -- When we lose lock, reset the buffers
      if (txlock_i = '1') then
        txdata_r0 <= (others => '1');
        txdata_r1 <= (others => '1');
        txdata_r2 <= (others => '1');
      elsif (txready = '1') then
        txdata_r0 <= (others => '1');
        txdata_r1 <= txdata_r0;
        txdata_r2 <= txdata_r1;
      else
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
  -- nibble and high on the higher significant nibble according to the datasheet.
  -- However, the TI application note AN-1887 shows timing diagrams that indicate
  -- the opposite levels.
  -- Our tests have shown the application note's information to be correct.
  clk_oddr_inst : ODDR
  generic map (
    DDR_CLK_EDGE => "SAME_EDGE"
  )
  port map (
    Q => txclk_ddr,
    C => txclk_i,
    CE => '1',
    D1 => '1', -- Rising edge, low nibble, high clock
    D2 => '0', -- Falling edge, high nibble, low clock
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
  
  -- Counter for transmitting 110 SYNC characters
  process (txclk_i)
  begin
    if (rising_edge(txclk_i)) then
      -- When we lose lock, reset the counter
      if (txlock_i = '1') then
        counter <= (others => '0');
        txready <= '1';  -- Send SYNC characters for 120 clock cycles
      -- While counter has not yet reached timeout, increment
      elsif (counter /= std_logic_vector(to_unsigned(120,8))) then
        counter <= std_logic_vector(unsigned(counter) + 1);
        txready <= '1';  -- Send SYNC characters for 120 clock cycles
      -- After timeout, stop sending SYNC and assert TXREADY
      else
        txready <= '0';
      end if;
    end if;
  end process;
  
  -- Output assignments
  txready_o <= txready;
  
end tx_interface_syn;
