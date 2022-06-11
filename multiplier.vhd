-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
port(
	instr:in std_logic_vector(31 downto 0);
    rdlo:out std_logic_vector(31 downto 0);
    rdhi:out std_logic_vector(63 downto 0);
    opr1:in std_logic_vector(31 downto 0);
    opr2:in std_logic_vector(31 downto 0);
    acclo:in std_logic_vector(31 downto 0);
    acchi:in std_logic_vector(63 downto 0)
    );
end entity;

architecture beh of multiplier is

begin
process(instr,opr1,opr2,acclo,acchi,rdhi)
begin
	if(instr(23)='0') then
--     small
		if(instr(21)='0') then
--         	no acc
			rdhi<=std_logic_vector(unsigned(opr1)*unsigned(opr2));
            rdlo<=rdhi(31 downto 0);
		else
        	rdhi<=std_logic_vector(unsigned(opr1)*unsigned(opr2)+unsigned(acclo));
            rdlo<=rdhi(31 downto 0);
--         	acc
		end if;
    else
    	if(instr(22)='0') then
--         	unsigned
			if(instr(21)='0') then
--             	no acc
				rdhi<=std_logic_vector(unsigned(opr1)*unsigned(opr2));
			else
            	rdhi<=std_logic_vector(unsigned(opr1)*unsigned(opr2)+unsigned(acchi));
--             	acc
			end if;
		else
        	if(instr(21)='0') then
--             	no acc
				rdhi<=std_logic_vector(signed(opr1)*signed(opr2));
			else
--             	acc
				rdhi<=std_logic_vector(signed(opr1)*signed(opr2)+signed(acchi));
			end if;
--         	signed
		end if;
--     long long
	end if;
end process;
end beh;