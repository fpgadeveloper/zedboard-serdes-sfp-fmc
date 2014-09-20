----------------------------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_misc.all;
  use ieee.std_logic_unsigned.all;
library unisim;
  use unisim.vcomponents.all;

entity clk_buf is
port (
  -- Input clock
  clk_p_i        : in  std_logic;
  clk_n_i        : in  std_logic;
  -- Output clocks
  clk_bufg_div_o : out std_logic;
  clk_bufr_o     : out std_logic
);
end clk_buf;

architecture clk_buf_syn of clk_buf is

signal clk_ibufds   : std_logic;
signal clk_bufr     : std_logic;
signal clk_bufr_div : std_logic;
signal clk_bufg_div : std_logic;

begin

  -- Differential input buffer
  ibufds_inst : IBUFDS
  generic map (
    IOSTANDARD => "LVDS_25",
    DIFF_TERM  => TRUE
  )
  port map (
    I  => clk_p_i,
    IB => clk_n_i,
    O  => clk_ibufds
  );

  -- Regional clock buffer
  bufr_inst : BUFR
  generic map (
    BUFR_DIVIDE => "BYPASS"
  )
  port map (
    CE  => '1',
    CLR => '0',
    I   => clk_ibufds,
    O   => clk_bufr
  );
  
  -- Regional clock buffer divided by 4
  bufr_div_inst : BUFR
  generic map (
    BUFR_DIVIDE => "4"
  )
  port map (
    CE  => '1',
    CLR => '0',
    I   => clk_bufr,
    O   => clk_bufr_div
  );
  
  -- Global clock buffer
  bufg_inst : BUFG
  port map (
    I  => clk_bufr_div,
    O  => clk_bufg_div
  );

----------------------------------------------------------------------------------------------------
-- Connect outputs
----------------------------------------------------------------------------------------------------
clk_bufg_div_o <= clk_bufg_div;
clk_bufr_o <= clk_bufr;

end clk_buf_syn;
