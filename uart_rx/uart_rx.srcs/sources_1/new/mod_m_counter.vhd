library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mod_m_counter is
   generic(
      N: integer := 13;     -- number of bits
      M: integer := 5208     -- mod-M
  );
   port(
      clk, reset: in std_logic;
      max_tick: out std_logic
   );
end mod_m_counter;

architecture arch of mod_m_counter is
   signal r_reg: unsigned(N-1 downto 0);
   signal r_next: unsigned(N-1 downto 0);
begin
   -- register
   process(clk,reset)
   begin
    
      if (clk'event and clk='1') then
		  if (reset='0') then
         r_reg <= (others=>'0');
			else
         r_reg <= r_next;
			end if;
      end if;
   end process;
   -- next-state logic
   r_next <= (others=>'0') when r_reg=(M-1) else
             r_reg + 1;
   -- output logic
      max_tick <= '1' when r_reg=(M-1) else '0';
end arch;
