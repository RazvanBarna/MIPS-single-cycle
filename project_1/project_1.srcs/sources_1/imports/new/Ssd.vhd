library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ssd is
    Port(clk,EnCatozi: in std_logic;
         catozi: out std_logic_vector(6 downto 0);
         digits : in std_logic_vector(31 downto 0);
         anozi: out std_logic_vector(3 downto 0));
end entity;   

architecture arhi_ssd of ssd is
signal counterOut : std_logic_vector(16 downto 0 ) := (others =>'0');
signal catoziOut : std_logic_vector(3 downto 0) :=(others =>'0');
signal anoziSelect : std_logic_vector(1 downto 0) :=(others =>'0');
signal catoziSelect : std_logic_vector(1 downto 0) := (others =>'0');


begin
anoziSelect <= counterOut(16 downto 15);
catoziSelect <= counterOut(16 downto 15);

process(clk) 
begin
    if rising_edge(clk) then 
        counterOut<= counterOut+1;
        end if;
end process;

process(catoziSelect, EnCatozi)
begin
    case catoziSelect is
        when "00"  =>
            if EnCatozi = '1' then
                catoziOut <= digits(3 downto 0);
            else
                catoziOut <= digits(19 downto 16);
            end if;
        when "01" =>
            if EnCatozi = '1' then
                catoziOut <= digits(7 downto 4);
            else
                catoziOut <= digits(23 downto 20);
            end if;
        when "10" =>
            if EnCatozi = '1' then
                catoziOut <= digits(11 downto 8);
            else
                catoziOut <= digits(27 downto 24);
            end if;
        when others =>
            if EnCatozi = '1' then
                catoziOut <= digits(15 downto 12);
            else
                catoziOut <= digits(31 downto 28);
            end if;
    end case;
end process;


process(anoziSelect)
    begin
        case anoziSelect is 
            when "00" => anozi <= "1110"; 
            when "01" => anozi <= "1101"; 
            when "10" => anozi <= "1011"; 
            when others => anozi <= "0111"; 
        end case;
    end process;

process(catoziOut)
begin
case catoziOut is
when "0000" => catozi<= "1000000";
when "0001" => catozi<= "1111001";
when "0010" => catozi<= "0100100";
when "0011" => catozi<= "0110000";
when "0100" => catozi<= "0011001";
when "0101" => catozi<= "0010010";
when "0110" => catozi<= "0000010";
when "0111" => catozi<= "1111000";
when "1000" => catozi<= "0000000";
when "1001" => catozi<= "0010000";
when "1010" => catozi<= "0001000";
when "1011" => catozi<= "0000011";
when "1100" => catozi<= "1000110";
when "1101" => catozi<= "0100001";
when "1110" => catozi<= "0000110";
when others =>catozi<=  "0001110";
end case;
end process;


end architecture;