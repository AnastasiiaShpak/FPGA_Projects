LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY BlinkSystem IS
PORT(EnableBS, clockBS: in std_logic;
		Seg0, Seg1, Seg2, Seg3: out std_logic_vector(6 downto 0);
		green: out std_logic_vector(7 downto 0);
		red: out std_logic_vector(17 downto 0));

END BlinkSystem;

Architecture behaviour of BlinkSystem is

signal trigger: std_logic;

component PreScale_lab8 IS
PORT(InClockPS : IN STD_LOGIC;
		OutClockPS: OUT std_logic);
END component;

signal intClockBS: std_logic;

begin


PS1: PreScale_lab8 port map(clockBS, intClockBS);

process (intclockBS)
	begin
	if intClockBS = '1' then
		if EnableBS = '1' then
			Seg0 <= "0001001";
			Seg1 <= "0000110";
			Seg2 <= "1000111";
			Seg3 <= "0001100";
			green <= (others => '1');
			red <= (others => '1');
		else
			Seg0 <= "1111111";
			Seg1 <= "1111111";
			Seg2 <= "1111111";
			Seg3 <= "1111111";
			green <= (others => '0');
			red <= (others => '0');
		end if;
	else
			Seg0 <= "1111111";
			Seg1 <= "1111111";
			Seg2 <= "1111111";
			Seg3 <= "1111111";
			green <= (others => '0');
			red <= (others => '0');
	end if;
end process;

end behaviour;

