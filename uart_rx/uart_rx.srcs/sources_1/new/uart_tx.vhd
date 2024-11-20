library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    Port ( En : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           o_uart : out  STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is
TYPE state IS (S0,SS, S1, S2,S3,S4,S5,S6,S7,S8 ,ST);
SIGNAL Present_State, Next_State: state;
signal rst_sh,tick_b,sout_uart,sEn : std_logic;
signal s_data: std_logic_vector(7 downto 0);
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
begin



process(Present_State,sEn,tick_b)
begin
Next_State<= Present_State;
sout_uart<='1';
s_data<=s_data;
rst_sh<='1';
CASE Present_State IS
			WHEN S0 =>
				if sEn='1' then
					Next_State<=SS;
					s_data<=data;
					rst_sh<='0';
					end if;
			WHEN SS =>
					
					sout_uart<='0';
					if tick_b='1' then
					Next_State<=S1;
				
					end if;
			WHEN S1 =>
				
					sout_uart<=s_data(0);
					if tick_b='1' then
					Next_State<=S2;

					end if;
			WHEN S2 =>
					
					sout_uart<=s_data(1);
					if tick_b='1' then
					Next_State<=S3;

					end if;
			WHEN S3 =>
				
					sout_uart<=s_data(2);
					if tick_b='1' then
					Next_State<=S4;
	
					end if;
			WHEN S4 =>
			
					sout_uart<=s_data(3);
					if tick_b='1' then
					Next_State<=S5;
	
					end if;
			WHEN S5 =>
			
sout_uart<=s_data(4);
					if tick_b='1' then
					Next_State<=S6;
	
					end if;
			WHEN S6 =>
		
					sout_uart<=s_data(5);
					if tick_b='1' then
					Next_State<=S7;

					end if;
			WHEN S7 =>
			
					sout_uart<=s_data(6);

					if tick_b='1' then
					Next_State<=S8;
			
					end if;
			WHEN S8 =>
			
					sout_uart<=s_data(7);

					if tick_b='1' then
					Next_State<=ST;
		
					end if;
			WHEN ST =>
			
					sout_uart<='1';
					if tick_b='1' then
					Next_State<=S0;
				
					end if;
					when others=>
					Next_State<=S0;
			END CASE;
end process;
o_uart<=sout_uart;
PROCESS (clk, rst,En,data,Next_State)
BEGIN
	IF(rst = '0') THEN
		Present_State <= S0;
	ELSIF rising_edge(clk) THEN
		Present_State <= Next_State;
		sEn<=En;
       END IF;
END PROCESS;

	Inst_mod_m_counter: mod_m_counter 
	GENERIC MAP(N=>13 ,M=> 5208)
	PORT MAP(
		clk => clk,
		reset => rst_sh,
		max_tick => tick_b
	);
end Behavioral;

