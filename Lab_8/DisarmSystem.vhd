LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

Entity DisarmSystem is
	port(w: in std_logic_vector(1 downto 0);
			clockDS: in std_logic;
		sseg0, sseg1, sseg2: out std_logic_vector(6 downto 0):= "1000000";
			disarmDS: out std_logic);

end DisarmSystem;

Architecture behaviour of DisarmSystem is
	TYPE  State_type IS (A, B, C, D);
	Signal y: State_type := A;
	
	signal zero : std_logic_vector (6 downto 0):= "1000000";
	
begin 
	PROCESS(clockDS, y, w)
	begin 
	
	if rising_edge(clockDS)  then
		case y is
			when A => 
				if w = "11" then
					y <= B;
				end if;
			when B => 
				if w = "01" then
					y <= C;
				end if;
			when C => 
				if w = "10" then
					y <= D;
				end if;
			when D => 
					y <= A;
			end case;
	end if;
	end process;
	
	process(clockDS, w, y)
	begin
	if rising_edge(clockDS) then
		case y is
			when A => 
				sseg0 <= zero;
				sseg1 <= zero;
				sseg2 <= zero;
				disarmDS <= '0';
			when B => 
				sseg0 <= "0110000";
				sseg1 <= zero;
				sseg2 <= zero;
				disarmDS <= '0';
			when C => 
				sseg0 <= "0110000";
				sseg1 <= "1111001";
				sseg2 <= zero;
				disarmDS <= '0';
			when D => 
				sseg0 <= "0110000";
				sseg1 <= "1111001";
				sseg2 <= "0100100";
				disarmDS <= '1';
				
		end case;
	end if;
	end process;
end behaviour;
