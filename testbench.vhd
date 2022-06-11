library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity test_bench is
end entity;

architecture beh of test_bench is

signal clk: std_logic:='0';
signal clk2: std_logic:='0';
signal reset: std_logic:='0';
signal state: std_logic_vector(2 downto 0):="000";

component multicycle_processor is
port(
	clk: in std_logic;
    clk2: in std_logic;
    state: in std_logic_vector(2 downto 0);
    reset: in std_logic
    );
end component;

begin
 
uut: multicycle_processor port map(clk,clk2,state,reset);

cycle_1: process
begin
clk2<='0';
wait for 0.15625 ns;
clk2<='1';
wait for 0.15625 ns;
end process;

cycle_2: process
begin
clk<='0';
state<="000";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="001";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="100";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="010";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="011";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="000";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="001";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="100";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="010";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="011";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="000";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="001";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="100";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="010";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="011";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="000";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="001";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="100";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="010";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="011";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="000";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="001";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="100";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="010";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
state<="011";
wait for 1.25 ns;
clk<='1';
wait for 1.25 ns;
clk<='0';
wait;
end process;



process
begin 
reset<='1';
wait for 10 ns;
reset<='0';
wait;
end process;
end beh;
