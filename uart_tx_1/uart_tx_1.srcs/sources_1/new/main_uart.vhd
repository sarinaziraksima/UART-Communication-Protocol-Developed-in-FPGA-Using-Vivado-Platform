
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_uart is
    Port ( 
           clk : in  STD_LOGIC;
			  led:out  STD_LOGIC;
			  rst : in  STD_LOGIC;
           o_tx : out  STD_LOGIC);
end main_uart;

architecture Behavioral of main_uart is
	COMPONENT uart_tx
	PORT(
		En : IN std_logic;
		rst : IN std_logic;
		data : IN std_logic_vector(7 downto 0);
		clk : IN std_logic;          
		o_uart : OUT std_logic
		);
	END COMPONENT;
	COMPONENT mod_m_counter
	  generic(
      N: integer := 13;     -- number of bits
      M: integer := 5208     -- mod-M
  );
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		max_tick : OUT std_logic
		);
	END COMPONENT;
	signal max_tick,sled:std_logic;
begin
Inst_uart_tx: uart_tx PORT MAP(
		En =>max_tick ,
		rst => rst,
		data =>"01101110" ,
		clk => clk,
		o_uart => o_tx
	);
	
Inst_mod_m_counter: mod_m_counter 
GENERIC MAP(N=>26 ,M=> 50000000)
PORT MAP(
		clk => clk,
		reset => rst,
		max_tick => max_tick
	);
	
	process(clk,sled)
	begin
	if (clk'event and clk='1') then
	if max_tick='1' then
	sled<=not sled;
	end if;
	end if;
	end process;
	led<=sled;
end Behavioral;

