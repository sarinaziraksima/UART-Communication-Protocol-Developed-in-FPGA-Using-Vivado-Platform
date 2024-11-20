library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    Port (
           rcho_en : out  STD_LOGIC;
           rst : in  STD_LOGIC;
           data : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           o_uart : out  STD_LOGIC_VECTOR (7 downto 0));
end uart_rx;

architecture Behavioral of uart_rx is
TYPE state IS (S0,SS, S1, S2,S3,S4,S5,S6,S7,S8 ,ST);
SIGNAL Present_State, Next_State: state;
signal rst_sh,rst_sh2,sEn,tick_b,tick_b2,s_data,s_old_data,sstarted : std_logic;
signal a0,a1,a2,a3,a4,a5,a6,a7 : std_logic;
signal sout_uart,b_reg,b_next : std_logic_vector(7 downto 0);
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



process(Present_State,sEn,tick_b,tick_b2,sout_uart,data)
begin

Next_State<= Present_State;
s_data<=data;
s_old_data<=s_data;
rst_sh<='1';
rst_sh2<='1';
rcho_en<='0';
b_next<=b_reg;

if s_old_data='0' and s_data='0' and sEn ='0' then 
        sEn<='1';
end if;

CASE Present_State IS
			WHEN S0 =>
			
				if sEn='1' then
                    --o_uart<="00111100";
					Next_State<=SS;
					rst_sh2<='0';
					end if;
					
			WHEN SS =>
					
					--data='0'
					if tick_b2='1' then
					rst_sh<='0';
					--o_uart<="11000000";
					Next_State<=S1;
					end if;
					
			WHEN S1 =>
				
					--o_uart(0)<='1';
					b_next(0)<=s_data;
					if tick_b='1' then
					Next_State<=S2;
					end if;
					
			WHEN S2 =>
					
					--o_uart(1)<='0';
					b_next(1)<=s_data;
					if tick_b='1' then
					Next_State<=S3;

					end if;
			WHEN S3 =>
				
					--o_uart(2)<='0';
					b_next(2)<=s_data;
					if tick_b='1' then
					Next_State<=S4;
					end if;
					
			WHEN S4 =>
			
					--o_uart(3)<='0';
					b_next(3)<=s_data;
					if tick_b='1' then
					Next_State<=S5;
					end if;
					
			WHEN S5 =>
			
                    --o_uart(4)<='0';
                    b_next(4)<=s_data;
					if tick_b='1' then
					Next_State<=S6;
					end if;
					
			WHEN S6 =>
		
					--o_uart(5)<='0';
					b_next(5)<=s_data;
					if tick_b='1' then
					Next_State<=S7;
					end if;
			WHEN S7 =>
			
					
                    --o_uart(6)<='0';
                    b_next(6)<=s_data;
					if tick_b='1' then
					Next_State<=S8;
					end if;
					
			WHEN S8 =>
					
                    --o_uart(7)<='1';
                    b_next(7)<=s_data;
					if tick_b='1' then
					Next_State<=ST;
					end if;
					
			WHEN ST =>
			
					--data='1'
					rcho_en<='1';
					if tick_b='1' then
					--o_uart<="11001100";
					rcho_en<='0';
				    sEn<='0';
					Next_State<=S0;
					end if;
					
            when others=>
                   
                    sEn<='0';
		          	Next_State<=S0;
		          	
			END CASE;
end process;

PROCESS (clk, rst,data,Next_State)
BEGIN

	IF(rst = '0') THEN
		Present_State <= S0;
		b_reg<=(others=>'0');
	ELSIF rising_edge(clk) THEN
		Present_State <= Next_State;
		b_reg<=b_next;
       END IF;
       
END PROCESS;

	Inst_mod_m_counter: mod_m_counter 
	GENERIC MAP(N=>13 ,M=> 5208)
	PORT MAP(
		clk => clk,
		reset => rst_sh,
		max_tick => tick_b
	);
	
	Inst_mod_m_counter2: mod_m_counter 
	GENERIC MAP(N=>12 ,M=> 2604)
	PORT MAP(
		clk => clk,
		reset => rst_sh2,
		max_tick => tick_b2
	);


o_uart<=b_reg;



end Behavioral;

