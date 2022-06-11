-- TWO BIT SHIFTER
-- take three input signal and give the repective shift or rotation
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitshifter2 is
port(
	type2: in std_logic_vector(1 downto 0);
-- signal "type2" is a two bit vector which is used to decide the type of shift and rotation 
    select2: in std_logic;
-- signal "select2" is one bit signal which decides whether to shift/rotate or not.
    datain2: in std_logic_vector(31 downto 0);
-- 32 bits signal "datain2" which is takes input data.
    dataout2: out std_logic_vector(31 downto 0)
-- 32 bits signal "dataout2" which gives the processed data.
);
end entity;


architecture beh of bitshifter2 is
begin
process(type2,select2,datain2)
begin 
	if(select2='0') then 
    	dataout2<=datain2;
 	else
    	if(type2="01") then
        	dataout2(29 downto 0)<=datain2(31 downto 2);
            dataout2(31 downto 30)<="00";
--  this is for 2 bit LSR
        elsif(type2="00") then
        	dataout2(31 downto 2)<=datain2(29 downto 0);
            dataout2(1 downto 0)<="00";
-- this is for 2 bit LSL
      	elsif(type2="10") then
        	dataout2(29 downto 0)<=datain2(31 downto 2);
            if(datain2(31)='1') then
            	dataout2(31 downto 30)<="11";
           	else
            	dataout2(31 downto 30)<="00";
        	end if;
-- this is for 2 bit ASR
      	else
        	dataout2(29 downto 0)<=datain2(31 downto 2);
            dataout2(31 downto 30)<=datain2(1 downto 0);
-- this is for 2 bit ROR
        end if;
  	end if;
end process;
end beh;
    	