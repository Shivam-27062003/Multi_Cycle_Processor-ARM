-- ONE BIT SHIFTER
-- take three input signal and give the repective shift or rotation

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitshifter1 is
port(
	type1: in std_logic_vector(1 downto 0);
-- signal "type1" is a two bit vector which is used to decide the type of shift and rotation 
    select1: in std_logic;
-- signal "select1" is one bit signal which decides whether to shift/rotate or not.
    datain1: in std_logic_vector(31 downto 0);
-- 32 bits signal "datain1" which is takes input data.
    dataout1: out std_logic_vector(31 downto 0)
-- 32 bits signal "dataout1" which gives the processed data.
);
end entity;


architecture beh of bitshifter1 is
begin
process(type1,select1,datain1)
begin 
	if(select1='0') then 
    	dataout1<=datain1;
 	else
    	if(type1="01") then
        	dataout1(30 downto 0)<=datain1(31 downto 1);
            dataout1(31)<='0';
--  this is for 1 bit LSR
        elsif (type1="00") then
        	dataout1(31 downto 1)<=datain1(30 downto 0);
            dataout1(0)<='0';
-- this is for 1 bit LSL
     	elsif (type1="10") then
        	dataout1(30 downto 0)<=datain1(31 downto 1);
            if(datain1(31)='1') then
            	dataout1(31)<='1';
          	else
            	dataout1(31)<='0';
          	end if;
-- this is for 1 bit ASR
       	else 
        	dataout1(30 downto 0)<=datain1(31 downto 1);
            dataout1(31)<=datain1(0);
-- this is for 1 bit ROR
        end if;
  	end if;
end process;
end beh;
    	