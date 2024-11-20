
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_uart is
    Port ( 
          clk : in  STD_LOGIC;
          
          rst : in  STD_LOGIC;
          o_rx : in  STD_LOGIC;
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
	COMPONENT uart_rx
	Port (
	       rcho_en : out  STD_LOGIC;
           rst : in  STD_LOGIC;
           data : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           o_uart : out  STD_LOGIC_VECTOR (7 downto 0));
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
	signal rcho_en:std_logic;
	signal data : std_logic_vector(7 downto 0);
begin
Inst_uart_tx: uart_tx PORT MAP(
		En =>rcho_en ,
		rst => rst,
		data =>data ,
		clk => clk,
		o_uart => o_tx
	);
	
Inst_uart_rx: uart_rx PORT MAP(
           rcho_en => rcho_en,
           rst => rst,
           data => o_rx,
           clk => clk,
           o_uart => data);
	

	


end Behavioral;

