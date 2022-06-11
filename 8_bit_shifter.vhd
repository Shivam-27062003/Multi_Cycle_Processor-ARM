-- EIGHT BIT SHIFTER
-- take three input signal and give the repective shift or rotation
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitshifter8 is
port(
	type8: in std_logic_vector(1 downto 0);
-- signal "type8" is a two bit vector which is used to decide the type of shift and rotation 
    select8: in std_logic;
-- signal "select8" is one bit signal which decides whether to shift/rotate or not.
    datain8: in std_logic_vector(31 downto 0);
-- 32 bits signal "datain8" which is takes input data.
    dataout8: out std_logic_vector(31 downto 0)
-- 32 bits signal "dataout8" which gives the processed data.
);
end entity;


architecture beh of bitshifter8 is
begin
process(type8,select8,datain8)
begin 
	if(select8='0') then 
    	dataout8<=datain8;
 	else
    	if(type8="01") then
        	dataout8(23 downto 0)<=datain8(31 downto 8);
            dataout8(31 downto 24)<="00000000";
--  this is for 8 bit LSR
        elsif(type8="00") then  
        	dataout8(31 downto 8)<=datain8(23 downto 0);
            dataout8(7 downto 0)<="00000000";
-- this is for 8 bit LSL
     	elsif(type8="10") then 
        	dataout8(23 downto 0)<=datain8(31 downto 8);
            if(datain8(31)='1') then
            	dataout8(31 downto 24)<="11111111";
           	else
            	dataout8(31 downto 24)<="00000000";
        	end if;
-- this is for 8 bit ASR
     	else 
       		dataout8(23 downto 0)<=datain8(31 downto 8);
            dataout8(31 downto 24)<=datain8(7 downto 0);
-- this is for 8 bit ROR
        end if;
  	end if;
end process;
end beh;
    	