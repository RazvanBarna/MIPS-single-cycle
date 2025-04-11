
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity testFetch is
  Port ( clk,btn,rst,muxSel,jump,PcSrc,enCatozi: in std_logic;
         catozi: out std_logic_vector(6 downto 0);
         anozi: out std_logic_vector(3 downto 0));
end testFetch;

architecture Behavioral of testFetch is

component IFetch is
  Port (rst,clk,en,jump, PcSrc : in std_logic;
        jumpAddress, branchAddress: in std_logic_vector( 31 downto 0);
        instruction, pc4 : out std_logic_vector( 31 downto 0) );
end component;

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component ssd is
    Port(clk,EnCatozi: in std_logic;
         catozi: out std_logic_vector(6 downto 0);
         digits : in std_logic_vector(31 downto 0);
         anozi: out std_logic_vector(3 downto 0));
end component;  

signal enFetch : std_logic :='0';
signal instructionMux,digits, pc4Mux : std_logic_vector(31 downto 0) :=(others =>'0');

begin
C1: MPG port map (clk=>clk, enable=>enFetch,btn=>btn);
C2: IFetch port map( rst=>rst, clk=>clk, en =>enFetch, jump =>jump, PcSrc =>PcSrc, jumpAddress => X"00000000", branchAddress => X"00000000",
                      instruction => instructionMux, pc4=>pc4Mux);
 
 digits <= pc4Mux when muxSel='1' else instructionMux;                    

C3: ssd port map (clk=>clk, EnCatozi => enCatozi, catozi =>catozi, anozi =>anozi, digits => digits);

end Behavioral;
