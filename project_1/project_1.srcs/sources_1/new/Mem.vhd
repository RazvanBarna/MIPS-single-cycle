library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Mem is
   Port (memWrite,En,clk: in std_logic;
         AluRes,Rd2: in std_logic_vector(31 downto 0);
             memData,aluResOut: out std_logic_vector(31 downto 0));
end Mem;

architecture Behavioral of Mem is
signal address: std_logic_vector(5 downto 0) :=(others =>'0');
type matrix is array(0 to 63) of std_logic_vector(31 downto 0);
signal m : matrix := (
    -- Date de la adresa 12 la 21 (10 elemente semnate)
    0 => x"00000005", --  +5   (pozitiv)
    1 => x"FFFFFFFD", --  -3   (negativ)
    2 => x"00000007", --  +7   (pozitiv)
    3 => x"FFFFFFF8", --  -8   (negativ)
    4 => x"0000000C", -- +12   (pozitiv)
    5 => x"FFFFFFFF", --  -1   (negativ)
    6 => x"00000004", --  +4   (pozitiv)
    7 => x"FFFFFFFA", --  -6   (negativ)
    8 => x"FFFFFFFE", --  -2   (negativ)
    9 => x"0000000A", -- +10   (pozitiv)
    -- Restul memoriei rămâne 0, suma 58 003A ,5 pozitive
    others => (others => '0'));

begin
aluResOut<=AluRes;
address<= aluRes(7 downto 2);
memData<=m(conv_integer(address));
process(clk)
begin   
    if rising_edge(clk) then 
        if en='1' and memWrite='1' then 
            m(conv_integer(address)) <= Rd2;
            end if;
            end if;
            end process;
            
end Behavioral;
