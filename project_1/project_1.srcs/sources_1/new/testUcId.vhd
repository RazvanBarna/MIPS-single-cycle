library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity testUcId is
    Port (swSel : in std_logic_vector(2 downto 0);
          swPc: in std_logic;
          btn1,btn0,clk,EnCatozi: in std_logic;
          led: out std_logic_vector(11 downto 0);
          catozi: out std_logic_vector(6 downto 0);
          anozi: out std_logic_vector(3 downto 0));
end testUcId;

architecture Behavioral of testUcId is

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

component UC is
  Port (instr: in std_logic_vector(5 downto 0);
        regDst,extOp,aluSrc,branch,jump,bgtz,bne,memWrite,memToReg, regWrite: out std_logic;
        aluOp : out std_logic_vector(1 downto 0));
end component;

component ID is
 Port (regWrite, en , regDst, extOp,clk: in std_logic; 
        instr : in std_logic_vector(25 downto 0);
        WD: in std_logic_vector(31 downto 0);
        RD1, RD2 , extImm: out std_logic_vector(31 downto 0);
        func : out std_logic_vector(5 downto 0);
        sa : out std_logic_vector(4 downto 0));
end component;

component IFetch is
  Port (rst,clk,en,jump, PcSrc : in std_logic;
        jumpAddress, branchAddress: in std_logic_vector( 31 downto 0);
        instruction, pc4 : out std_logic_vector( 31 downto 0) );
end component;

signal enMpg,jumpUc,regDstUc,extOpUc,aluSrcUc,branchuc,bgtzUc,bneUc,memWriteUc,memToRegUc,regWriteUc : std_logic :='0';
signal aluOpUc: std_logic_vector(1 downto 0) :="00";
signal instr,pc4,RD1,Rd2,extImm,funcExt,saExt, WdAux,muxOut: std_logic_vector(31 downto 0):=(others =>'0');
signal func : std_logic_vector(5 downto 0) :=(others =>'0');
signal sa: std_logic_vector(4 downto 0 ) := (others =>'0');
begin
C1: MPG port map (clk=>clk,btn=>btn0,enable => enMpg);
C2: IFetch port map(rst=>btn1, clk=>clk,en=>enMpg,jump=>jumpUc,PcSrc=>swPc,branchAddress=>X"00000000",jumpAddress=>X"00000000",instruction=>instr,pc4=>pc4);
C3: UC port map(instr=>instr(31 downto 26),aluOp=>aluOpUc,regDst=>regDstUc,extOp=>extOpUc,aluSrc=>aluSrcUc,branch=>branchUc,jump=>jumpUc,
                bgtz=>bgtzUc,bne=>bneUc,memWrite=>memWriteUc,memToReg=>memToRegUc,regWrite=>regWriteUc);
led<=aluOpUc & regDstUc & extOpUc & aluSrcUc & branchUc & bgtzUc & bneUc & jumpUc & memWriteUc & memToRegUc & regWriteUc;
funcExt<= "00000000000000000000000000" & func;
saExt <= "000000000000000000000000000" & sa;
C4: ID port map(regWrite=>regWriteUc,en=>enMpg,regDst=>regDstUc,extOp=>extOpUc,clk=>clk,instr=>instr(25 downto 0),WD=>WdAux,RD1=>RD1,RD2=>RD2,extImm=>extImm,
                func=>func, sa=>sa);
WdAux<= RD1 + RD2;

process(swSel,instr,pc4,RD1,RD2,WdAux,extImm,funcExt,saExt)
begin
    case swSel is 
    when "000"=> muxOut<= instr;
    when "001"=> muxOut<= pc4;
    when "010"=> muxOut<= RD1;
    when "011"=> muxOut<= RD2;
    when "100"=> muxOut<= WdAux;
    when "101"=> muxOut<= extImm;
    when "110"=> muxOut<= funcExt;
    when others =>muxOut<= saExt;
    end case;
end process;

C5: ssd port map(clk=>clk,EnCatozi=>EnCatozi,catozi=>catozi,anozi=>anozi,digits=>muxOut);
                
                
end Behavioral;
