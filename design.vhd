library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity multicycle_processor is
port(
	clk: in std_logic;
    clk2: in std_logic;
    state: in std_logic_vector(2 downto 0);
    reset: in std_logic
    );
end entity;


architecture beh of multicycle_processor is

-- importing component ALU
component alu is 
port(
	op1: in std_logic_vector(31 downto 0);
    op2: in std_logic_vector(31 downto 0);
    opc: in std_logic_vector(3 downto 0);
    carryin: in std_logic;
    carryout: out std_logic;
    ans: out std_logic_vector(31 downto 0)
    );
end component;

-- importing component program counter
component PC is
port(
	input: in std_logic_vector(31 downto 0);
	pw: in std_logic;
    clk1: in std_logic;
	output: out std_logic_vector(6 downto 0)
	);
end component;

-- importing component memory
component mem is
port(
	mw: in std_logic;
	add1: in std_logic_vector(6 downto 0);
	data1: in std_logic_vector(31 downto 0);
	output1: out std_logic_vector(31 downto 0);
    clk2: in std_logic
	);
end component;

-- importing component flag
component flag is
	port(
        Cin: in std_logic;
    	A31: in std_logic;
        B31: in std_logic;
        S: in std_logic_vector(31 downto 0);
       	Z: out std_logic;
        N: out std_logic;
        V: out std_logic;
        C: out std_logic
        );
end component;

-- importing component register file
component REGFILE IS
PORT(
	RD1: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    RD2: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    WR1: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    DATA: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    W_SEL: IN STD_LOGIC;
    CLK3: IN STD_LOGIC;
    OUT1: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    OUT2: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END component;

-- importing component conditional checker
component CC is 
	port(
    	Z1: in std_logic;
        Cond: in std_logic_vector(3 downto 0);
        Res: out std_logic
        );
end component;
-- ---------------------------------------------------------------------
-- AGENDA FOR STAGE 5 SHIFTER
-- importing the shifter/rotator component 
component shifter is
port(
	shift_amount: in std_logic_vector(4 downto 0);
    typee: in std_logic_vector(1 downto 0); 
    carryin: in std_logic;
    datain: in std_logic_vector(31 downto 0);
    carryout: out std_logic;
    dataout: out std_logic_vector(31 downto 0)
    );    
end component;
-- -----------------------------------------------------------------------------
-- importing multiplier component

component multiplier is
port(
	instr:in std_logic_vector(31 downto 0);
    rdlo:out std_logic_vector(31 downto 0);
    rdhi:out std_logic_vector(63 downto 0);
    opr1:in std_logic_vector(31 downto 0);
    opr2:in std_logic_vector(31 downto 0);
    acclo:in std_logic_vector(31 downto 0);
    acchi:in std_logic_vector(63 downto 0)
    );
end component;

-- -----------------------------------------------------------------------------

signal opc,cond,rd1,rd2,wr1: std_logic_vector(3 downto 0);
signal data,out1,out2,S,output1,data1,input,ans,op1,op2: std_logic_vector(31 downto 0);
signal output,add1: std_logic_vector(6 downto 0);
signal z1,res,w_sel,cin,a31,b31,z,n,v,c,mw,pw,carryin,carryout: std_logic;
signal s_a: std_logic_vector(4 downto 0):="11111";

-- ----------------------------------------------------------------------
-- signal declaration for shifter/rotator
signal typee: std_logic_vector(1 downto 0);
signal carryin1: std_logic;
signal datain: std_logic_vector(31 downto 0);
signal carryout1: std_logic;
signal dataout: std_logic_vector(31 downto 0);
-- ----------------------------------------------------------------------
-- signal declaration for multiplier
signal opr1,opr2,rdlo,acclo: std_logic_vector(31 downto 0);
signal rdhi,acchi: std_logic_vector(63 downto 0);
-- -------------------------------------------------------------

signal IR: std_logic_vector(31 downto 0);
signal DR: std_logic_vector(31 downto 0);
signal A: std_logic_vector(31 downto 0);
signal B: std_logic_vector(31 downto 0);
signal Res1: std_logic_vector(31 downto 0);

begin
comp1: alu port map(op1,op2,opc,carryin,carryout,ans);
comp2: PC port map(input,pw,clk2,output);
comp3: mem port map(mw,add1,data1,output1,clk2);
comp4: flag port map(cin,a31,b31,s,z,n,v,c);
comp5: REGFILE port map(rd1,rd2,wr1,data,w_sel,clk2,out1,out2);
comp6: CC port map(z1,cond,res);

-- -------------------------------------------------------------------------
-- PORT MAPPING FOR SHIFTER
comp7: shifter port map(s_a,typee,carryin1,datain,carryout1,dataout);
-- -------------------------------------------------------------------------
-- port mapping for multiplier

comp8: multiplier port map(IR,rdlo,rdhi,opr1,opr2,acclo,acchi);

-- -------------------------------------------------------------------------
process(clk,output1,output,ans,state,out1,out2,res1,ans,IR,DR,A,B,rdlo,rdhi) is
begin

	if(reset='1') then
    	input<="00000000000000000000000000000000";
        pw<='1';
  	else
    	if(state="000") then 
        	pw<='0';
            add1<=output;
            mw<='0';
            IR<=output1;
            DR<=output1;
            op1(31 downto 9)<="00000000000000000000000";
            op1(8 downto 2)<=output;
            op1(1 downto 0)<="00";
            op2<="00000000000000000000000000000100";
            opc<="0100";
            carryin<='0';
            input<=ans;
            pw<=clk;
       	elsif(state="001") then
        	rd1<=IR(19 downto 16);
            if(IR(27 downto 26)="01") then
            	rd2<=IR(15 downto 12);
           	else
            	rd2<=IR(3 downto 0);
          	end if;
            wr1<=IR(15 downto 12);
            w_sel<='0';
            A<=out1;
            B<=out2;
            pw<='0';
      	elsif(state="100") then 
        	rd1<=IR(11 downto 8);
            rd2<=IR(15 downto 12);
            w_sel<='0';
            acclo<=out2;
            acchi(31 downto 0)<=out2;
            acchi(63 downto 32)<="00000000000000000000000000000000";
            opr2<=out1;
            pw<='0';
       	elsif(state="010") then
                if(IR(27 downto 24)="0000" and IR(7 downto 4)="1001") then
                	opr1<=B;
                    if(IR(23)='0') then
                    	res1<=rdlo;
                   	else
                    	res1<=rdhi(31 downto 0);
                  	end if;
               	elsif(IR(27 downto 26)="00") then
-- -----------------------------------------------------------------------------
                    if(IR(25)='0') then
-- making use of shifter in Data Processing 
                    	datain<=B;
                        carryin1<='0';
--              assigning the signal input for type of shift/rotation
                        typee<=IR(6 downto 5);
--              condition for constant amount of shift
                        if(IR(4)='0') then 
                            s_a<=IR(11 downto 7);
                            op2<=dataout;
--             	condition when shift amount is in saved in register
                      	else
                        	w_sel<='0';
                            rd1<=IR(11 downto 8);
                            s_a<=out1(4 downto 0);
                            op2<=dataout;
                     	end if;
--              updating the carryflag after geeting the carry output from the shifter/rotator 
                        cin<=carryout1;
                  	else
--              using the shifter/rotator when operand2 is immidiate.
                    	datain(31 downto 8)<="000000000000000000000000";
                        datain(7 downto 0)<=IR(7 downto 0);
                        s_a(4 downto 1)<=IR(11 downto 8);
                        s_a(0)<='0';
                        carryin1<='0';
--              taking signal for deciding the type of shift/rotation
                        typee<="11";
--              assigning the output of the shifter as the operand2 of the alu
                        op2<=dataout;
--              updating the carry flag using the carry output from the shifter
                        cin<=carryout1;
-------------------------------------------------------------------------------
                  	end if; 
                    opc<=IR(24 downto 21);
                    carryin<='0';
                    Res1<=ans;
                    cin<=carryout;
                    a31<=op1(31);
                    b31<=op2(31);
                    s<=ans;
                elsif(IR(27 downto 26)="10") then
                    op1(31 downto 7)<="0000000000000000000000000";
                    op1(6 downto 0)<=output;
                	case IR(29 downto 28) is
                    	when "10" =>
                        	op2(31 downto 26)<="000000";
                            op2(1 downto 0)<="00";
                            op2(25 downto 2)<=IR(23 downto 0);
                      	when "11"=>
                        	op2<="00000000000000000000000000000000";
                       	when others=>
                        	z1<=z;
                            cond(3 downto 2)<="00";
                            cond(1 downto 0)<=IR(29 downto 28);
                            if(res='1') then 
                            	op2(31 downto 26)<="000000";
                            	op2(1 downto 0)<="00";
                            	op2(25 downto 2)<=IR(23 downto 0);
                          	else
                            	op2<="00000000000000000000000000000000";
                			end if;
             		end case;
                   	opc<="0100";
                    carryin<='0';
                    input<=ans;
                    pw<='1';
                elsif(IR(27 downto 26)="01") then
                	op1<=A;
                    if(IR(25)='1') then
                    	op2(31 downto 12)<="00000000000000000000";
                        op2(11 downto 0)<=IR(11 downto 0);
------------------------------------------------------------------------------
                   	else 
--                   using shifter in data dransfer 
                    	carryin1<='0';
                        w_sel<='0';
--                   taking the signal for deciding the type of shift/rotation
                        typee<=IR(6 downto 5);
                        rd1<=IR(3 downto 0);
--                   taking the data to be shifted/rotated from a register
                        datain<=out1;
                        s_a<=IR(11 downto 7);
--                   assigning output from the shifter as the operand2
                        op2<=dataout;
-- 					 updating the carry flag
                        cin<=carryout1;
                   	end if;
-- ----------------------------------------------------------------------------
                    carryin<='0';
                    if(IR(23)='1') then
                    	opc<="0100";
                	else 
                    	opc<="0011";
                  	end if;
                    Res1<=ans;
       		end if;
            
            else
        	if(IR(27 downto 26)="00") then
            	data<=Res1;
                w_sel<='1';
         	elsif(IR(27 downto 26)="01") then
            	data1<=B;
                add1<=res1(6 downto 0);
                mw<='1';
                data<=output1;
                w_sel<='1';
            end if;
      	end if;
  	end if;
end process;
end beh;
                
                
        	
        	
                	
                
                       
               
                    
            
        	
    	


