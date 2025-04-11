library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity testEnv is
  Port (clk,btnRst,btnEn,catoziSel: in std_logic;
        catozi: out std_logic_vector(6 downto 0);
        anozi: out std_logic_vector(3 downto 0);
        led : out std_logic_vector(13 downto 0);
        swSel : in std_logic_vector(2 downto 0));
end testEnv;

architecture Behavioral of testEnv is
component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component IFetch is
  Port (rst,clk,en,jump, PcSrc : in std_logic;
        jumpAddress, branchAddress: in std_logic_vector( 31 downto 0);
        instruction, pc4 : out std_logic_vector( 31 downto 0) );
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

component Execution is
 Port (RD1,RD2,Ext_imm,PC4: in std_logic_vector(31 downto 0);
        aluSrc : in std_logic;
        sa: in std_logic_vector(4 downto 0);
        func: in std_logic_vector(5 downto 0);
        aluOp : in std_logic_vector(1 downto 0);
        gtz,zero: out std_logic;
        aluRes, bAddress: out std_logic_vector(31 downto 0));
end component;

component Mem is
   Port (memWrite,En,clk: in std_logic;
         AluRes,Rd2: in std_logic_vector(31 downto 0);
         memData,aluResOut: out std_logic_vector(31 downto 0));
end component;

component ssd is
    Port(clk,EnCatozi: in std_logic;
         catozi: out std_logic_vector(6 downto 0);
         digits : in std_logic_vector(31 downto 0);
         anozi: out std_logic_vector(3 downto 0));
end component; 

signal en,jump,PcSrc,regWrite,regDst,extOp,aluSrc,zero,memWrite,memToReg,branch,bgtz,bne,gtz: std_logic :='0';
signal aluOp : std_logic_vector(1 downto 0) :=(others =>'0');
signal jumpAddress,branchAddress,PC4,instruction,RD1,RD2,WD,Ext_imm,aluResAux,aluResOut,memData: std_logic_vector(31 downto 0) :=(others =>'0');
signal muxOut: std_logic_vector(31 downto 0) :=(others =>'0');
signal func: std_logic_vector(5 downto 0) :=(others =>'0');
signal sa : std_logic_vector(4 downto 0) :=(others =>'0');

begin
MPGEn: MPG port map(clk=>clk,enable=>en,btn=>btnEn);

Fetch: IFetch port map(clk=>clk, en =>en, rst=>btnRst, jump=>jump, PcSrc=>PcSrc,branchAddress=>branchAddress,jumpAddress=>jumpAddress,
        instruction => instruction, pc4 =>PC4);
        
IDComp: ID port map(en=>en,regWrite=>regWrite, instr=>instruction(25 downto 0),regDst=>regDst,extOp=>extOp,clk=>clk,WD=>WD,RD1=>RD1,
        RD2=>RD2,extImm=>Ext_imm,func=>func,sa=>sa);    
        
EXComp: Execution port map(RD1=>RD1,aluSrc=>aluSrc,RD2=>RD2,Ext_imm=>Ext_imm,func=>func,sa=>sa,aluOp=>aluOp,PC4=>PC4,zero=>zero,
        bAddress=>branchAddress,aluRes=>aluResAux,gtz=>gtz);
        
MemComp: Mem port map (clk=>clk,RD2=>RD2,aluResOut=>aluResOut,aluRes=>aluResAux,en=>en,memWrite=>memWrite,memData=>memData);

SsdComp: ssd port map(clk=>clk,catozi=>catozi,anozi=>anozi,digits=>muxOut,EnCatozi=>catoziSel);

UCComp: UC port map(regDst=>regDst,jump=>jump,extOp=>extOp,aluSrc=>aluSrc,branch=>branch,aluOp=>aluOp,memWrite=>memWrite,memToReg=>memToReg,
        regWrite=>regWrite,bgtz=>bgtz,bne=>bne,instr=>instruction(31 downto 26));

WD<=aluResOut when memToReg='0' else memData;
PcSrc<= (branch and zero) or (bne and (not zero) ) or (bgtz and gtz);
jumpAddress<= PC4(31 downto 28) & instruction(25 downto 0) & "00";

with swSel select
  muxOut <= instruction when "000",
             PC4        when "001",
             RD1        when "010",
             RD2        when "011",
             Ext_imm    when "100",
             aluResAux  when "101",
             branchAddress    when "110",
             WD         when "111",
             (others => '0') when others;

led(11 downto 0) <= aluOp & regDst & extOp & aluSrc & branch & bne & bgtz & jump & memWrite & memToReg & regWrite;
led(12) <= zero;
led(13) <=PCSrc;


end Behavioral;
