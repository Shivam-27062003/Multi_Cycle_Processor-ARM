-- glueing all the shifters namely 1_bit_shifter, 2_bit_shifter, 4_bit_shifter, 8_bit_shifter and 16_bit_shifter.
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
port(
	shift_amount: in std_logic_vector(4 downto 0);
--     the amount of shift/rotation inputted by signal "shift_amount".
    typee: in std_logic_vector(1 downto 0);
--     two bit vector input signal for deciding the type of shift/rotation. 
    carryin: in std_logic;
--     single bit vector for input carry
    datain: in std_logic_vector(31 downto 0);
--     32 bit vector signal for inputting data for shifting/rotation.
    carryout: out std_logic;
--     single bit carry ouput signal.
    dataout: out std_logic_vector(31 downto 0)
--     32 bit vector output for processed data.
    );
    
end entity;

architecture beh of shifter is

-- declaring signal
signal datin,dat1,dat2,dat3,dat4,dat5,dat6,dat7,dat8,dat9: std_logic_vector(31 downto 0);
signal s1,s2,s3,s4,s5: std_logic;

-- importing the component for 1 bit shifting/rotation
component bitshifter1 is
port(
	type1: in std_logic_vector(1 downto 0);
    select1: in std_logic;
    datain1: in std_logic_vector(31 downto 0);
    dataout1: out std_logic_vector(31 downto 0)
);
end component;

-- importing the component for 2 bit shifting/rotation
component bitshifter2 is
port(
	type2: in std_logic_vector(1 downto 0);
    select2: in std_logic;
    datain2: in std_logic_vector(31 downto 0);
    dataout2: out std_logic_vector(31 downto 0)
);
end component;

-- importing the component for 4 bit shifting/rotation
component bitshifter4 is
port(
	type4: in std_logic_vector(1 downto 0);
    select4: in std_logic;
    datain4: in std_logic_vector(31 downto 0);
    dataout4: out std_logic_vector(31 downto 0)
);
end component;

-- importing the component for 8 bit shifting/rotation
component bitshifter8 is
port(
	type8: in std_logic_vector(1 downto 0);
    select8: in std_logic;
    datain8: in std_logic_vector(31 downto 0);
    dataout8: out std_logic_vector(31 downto 0)
);
end component;

-- importing the component for 16 bit shifting/rotation.
component bitshifter16 is
port(
	type16: in std_logic_vector(1 downto 0);
    select16: in std_logic;
    datain16: in std_logic_vector(31 downto 0);
    dataout16: out std_logic_vector(31 downto 0)
);
end component;

begin

-- port mapping for all the imported components.
comp1: bitshifter1 port map(typee,s1,datin,dat1);
comp2: bitshifter2 port map(typee,s2,dat2,dat3);
comp3: bitshifter4 port map(typee,s3,dat4,dat5);
comp4: bitshifter8 port map(typee,s4,dat6,dat7);
comp5: bitshifter16 port map(typee,s5,dat8,dat9);

-- this process "carr" is determining the value of output carry as following
-- if shift amount is 0 then the carryin is assigned as carryout otherwise assignment of carryout signal is depends on the amount and the type of shift/rotation.
carr: process(carryin,datain,shift_amount)
begin
if(shift_amount="00000") then
	carryout<=carryin;
else
	if(typee="00") then
    	carryout<=datain(32-to_integer(unsigned(shift_amount)));
   	else
    	carryout<=datain(to_integer(unsigned(shift_amount))-1);
  	end if;
end if;
end process;

-- the process for glueing all the shifters so that with the combination all the standart bit shifter one can get any amount of shift ranging from 0 to 31.

process(shift_amount,typee,datain,dat1,dat2,dat3,dat4,dat5,dat6,dat7,dat8,dat9,s1,s2,s3,s4,s5)
begin
s1<=shift_amount(0);
s2<=shift_amount(1);
s3<=shift_amount(2);
s4<=shift_amount(3);
s5<=shift_amount(4);
datin<=datain;
dat2<=dat1;
dat4<=dat3;
dat6<=dat5;
dat8<=dat7;
dataout<=dat9;
end process;
end beh;
