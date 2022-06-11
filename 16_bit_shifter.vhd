-- SIXTEEN BIT SHIFTER
-- take three input signal and give the repective shift or rotation
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitshifter16 is
port(
	type16: in std_logic_vector(1 downto 0);
-- signal "type16" is a two bit vector which is used to decide the type of shift and rotation 
    select16: in std_logic;
-- signal "select16" is one bit signal which decides whether to shift/rotate or not.
    datain16: in std_logic_vector(31 downto 0);
-- 32 bits signal "datain16" which is takes input data.
    dataout16: out std_logic_vector(31 downto 0)
-- 32 bits signal "dataout16" which gives the processed data.
);
end entity;


architecture beh of bitshifter16 is
begin
process(type16,select16,datain16)
begin 
	if(select16='0') then 
    	dataout16<=datain16;
 	else
    	if(type16="01") then
        	dataout16(15 downto 0)<=datain16(31 downto 16);
            dataout16(31 downto 16)<="0000000000000000";
--  this is for 16 bit LSR
        elsif(type16="00") then  
        	dataout16(31 downto 16)<=datain16(15 downto 0);
            dataout16(15 downto 0)<="0000000000000000";
-- this is for 16 bit LSL
     	elsif(type16="10") then 
        	dataout16(15 downto 0)<=datain16(31 downto 16);
            if(datain16(31)='1') then
            	dataout16(31 downto 16)<="1111111111111111";
           	else
            	dataout16(31 downto 16)<="0000000000000000";
        	end if;
-- this is for 16 bit ASR
     	else 
       		dataout16(15 downto 0)<=datain16(31 downto 16);
            dataout16(31 downto 16)<=datain16(15 downto 0);
-- this is for 16 bit ROR
        end if;
  	end if;
end process;
end beh;
    	