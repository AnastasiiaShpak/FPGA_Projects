LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY AlarmSystem is
PORT(CLOCK_50: in std_logic;
		SW: in std_logic_vector(17 downto 0);
		KEY: in std_logic_vector(0 downto 0);
		LEDR: out std_logic_vector(17 downto 0);
		LEDG: out std_logic_vector(7 downto 0);
		HEX7, HEX6, HEX5, HEX4, HEX2, HEX1, HEX0: out std_logic_vector(6 downto 0);
		I2C_SDAT : inout std_logic;
		I2C_SCLK, AUD_XCK : out std_logic;
		AUD_ADCDAT : in std_logic;
		AUD_DACDAT : out std_logic;
		AUD_ADCLRCK, AUD_DACLRCK, AUD_BCLK : in std_logic);
END AlarmSystem;

ARCHITECTURE behaviour of AlarmSystem is

signal disarm, pretrigger, trigger: std_logic:= '0';
signal preBeep : std_logic_vector(7 downto 0);
signal freGen : unsigned(15 downto 0):= "0011000100010000";
SIGNAL AudioIn, AudioOut1, AudioOut2 : signed(15 downto 0);
SIGNAL SamClk : std_logic;

component BlinkSystem is
	PORT(EnableBS, clockBS: in std_logic;
		Seg0, Seg1, Seg2, Seg3: out std_logic_vector(6 downto 0);
		green: out std_logic_vector(7 downto 0);
		red: out std_logic_vector(17 downto 0));
end component;

component DisarmSystem is
	port(w: in std_logic_vector(1 downto 0);
			clockDS: in std_logic;
		sseg0, sseg1, sseg2: out std_logic_vector(6 downto 0);
			disarmDS: out std_logic);
end component;

component AudioInterface is
	Generic ( SID : integer := 100 ); 
	Port (CLOCK_50 : in std_logic;
		init : in std_logic;
		I2C_SDAT : inout std_logic;
		I2C_SCLK, AudMclk : out std_logic;
		AUD_ADCDAT : in std_logic;
		AUD_DACDAT : out std_logic;
		AUD_ADCLRCK, AUD_DACLRCK, AUD_BCLK : in std_logic;
		SamClk : out std_logic;
		AudioIn : out signed(15 downto 0);
		AudioOut : in signed(15 downto 0));
end component;

component ToneGenerator is
		port(TGClock : in std_logic;
			TGFreq : in unsigned(15 downto 0);
			TGWaveOut : out signed(15 downto 0));
end component;
		
begin

BS: BlinkSystem 
			port map(trigger, CLOCK_50, HEX7, HEX6, HEX5, HEX4, preBeep, LEDR);
			
DS: DisarmSystem 
			port map(SW(2 downto 1), KEY(0), HEX2, HEX1, HEX0, disarm);
			
assm: AudioInterface	generic map ( SID => 66905 )
			PORT MAP( Clock_50 => CLOCK_50, AudMclk => AUD_XCK,	-- period is 80 ns ( 12.5 Mhz )
						init => KEY(0), 									-- +ve edge initiates I2C data
						I2C_Sclk => I2C_SCLK,
						I2C_Sdat => I2C_SDAT,
						AUD_BCLK => AUD_BCLK, AUD_ADCLRCK => AUD_ADCLRCK, AUD_DACLRCK => AUD_DACLRCK,
						AUD_ADCDAT => AUD_ADCDAT, AUD_DACDAT => AUD_DACDAT,
						AudioOut => AudioOut2, AudioIn => AudioIn, SamClk => SamClk );

TG0 : ToneGenerator
			port map (SamClk, freGen, AudioOut1);

-- SW(17)=FD, SW(16)=SW, SW(15)=MS

pretrigger <= (SW(17) OR SW(16) OR SW(15)) and SW(0);

process(disarm, pretrigger)
begin
	if disarm='1' then
		trigger <= '0';
	elsif rising_edge(pretrigger) then
		trigger <= '1';
	end if;
end process;

process (preBeep)
	begin
	if (preBeep(0)='1') then
		AudioOut2<=AudioOut1;
	else
		AudioOut2<=(others=>'0');
	end if;
end process;

LEDG <= PreBeep;

end behaviour;
