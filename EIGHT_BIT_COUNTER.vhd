LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY EIGHT_BIT_COUNTER IS
	PORT(CLK_IN : IN STD_LOGIC;
		  RST_IN : IN STD_LOGIC;
		  EN : IN STD_LOGIC;
		  BITS_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END EIGHT_BIT_COUNTER;

ARCHITECTURE BEHAVIOR OF EIGHT_BIT_COUNTER IS
	COMPONENT FOUR_BIT_COUNTER IS
		PORT(CLK : IN STD_LOGIC;
			  RST : IN STD_LOGIC;
			  BITS_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	SIGNAL CLK_ENABLE : STD_LOGIC;
	SIGNAL MIDDLE_Q : STD_LOGIC;
	SIGNAL WIRE_MOD : STD_lOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL DELAY_CLK : STD_LOGIC;
BEGIN
	CLK_ENABLE <= CLK_IN AND EN;
	DELAY_CLK <= CLK_IN AND MIDDLE_Q AND EN;
	MSB : FOUR_BIT_COUNTER PORT MAP(CLK => DELAY_CLK, RST => RST_IN, BITS_OUT(3 DOWNTO 0) => WIRE_MOD(7 DOWNTO 4));
	LSB : FOUR_BIT_COUNTER PORT MAP(CLK => CLK_ENABLE, RST => RST_IN, BITS_OUT(3 DOWNTO 0) => WIRE_MOD(3 DOWNTO 0));
	PROCESS(CLK_ENABLE, RST_IN)
	BEGIN
		IF RST_IN = '1' THEN
			MIDDLE_Q <= '0';
		ELSIF CLK_IN'EVENT AND CLK_IN = '0' THEN
			MIDDLE_Q <= WIRE_MOD(3) AND WIRE_MOD(2) AND WIRE_MOD(1) AND WIRE_MOD(0);
		END IF;
	END PROCESS;
	BITS_OUT <= WIRE_MOD;
END BEHAVIOR;