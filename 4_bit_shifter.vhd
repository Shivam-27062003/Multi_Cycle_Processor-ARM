-- EIGHT BIT SHIFTER
-- take three input signal and give the repective shift or rotation
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitshifter4 is
port(
	type4: in std_logic_vector(1 downto 0);
-- signal "type4" is a two bit vector which is used to decide the type of shift and rotation 
    select4: in std_logic;
-- signal "select4" is one bit signal which decides whether to shift/rotate or not.
    datain4: in std_logic_vector(31 downto 0);
-- 32 bits signal "datain4" which is takes input data.
    dataout4: out std_logic_vector(31 downto 0)
-- 32 bits signal "dataout4" which gives the processed data.
);
end entity;


architecture beh of bitshifter4 is
begin
process(type4,select4,datain4)
begin 
	if(select4='0') then 
    	dataout4<=datain4;
 	else
    	if(type4="01") then
        	dataout4(27 downto 0)<=datain4(31 downto 4);
            dataout4(31 downto 28)<="0000";
--  this is for 4 bit LSR
        elsif(type4="00") then 
        	dataout4(31 downto 4)<=datain4(27 downto 0);
            dataout4(3 downto 0)<="0000";
-- this is for 4 bit LSL
       	elsif(type4="10") then
        	dataout4(27 downto 0)<=datain4(31 downto 4);
            if(datain4(31)='1') then
            	dataout4(31 downto 28)<="1111";
           	else
            	dataout4(31 downto 28)<="0000";
        	end if;
-- this is for 4 bit ASR
       	else
        	dataout4(27 downto 0)<=datain4(31 downto 4);
            dataout4(31 downto 28)<=datain4(3 downto 0);
-- this is for 4 bit ROR
        end if;
  	end if;
end process;
end beh;
    	