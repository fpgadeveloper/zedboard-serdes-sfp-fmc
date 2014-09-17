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
  clk_p_i      : in  std_logic;
  clk_n_i      : in  std_logic;
  -- Output clock
  clk_bufg_o   : out std_logic
);
end clk_buf;

architecture clk_buf_syn of clk_buf is

signal clk_ibufds : std_logic;
signal clk_bufr   : std_logic;
signal clk_bufg   : std_logic;

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
  
  -- Global clock buffer
  bufg_inst : BUFG
  port map (
    I  => clk_bufr,
    O  => clk_bufg
  );

----------------------------------------------------------------------------------------------------
-- Connect outputs
----------------------------------------------------------------------------------------------------
clk_bufg_o <= clk_bufg;

end clk_buf_syn;
