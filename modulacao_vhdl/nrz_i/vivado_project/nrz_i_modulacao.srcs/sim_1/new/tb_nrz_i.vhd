library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_nrz_i is
end tb_nrz_i;

architecture sim of tb_nrz_i is
    constant N_BITS       : integer := 16;
    constant CLKS_PER_BIT : integer := 4;
    constant CLK_PERIOD   : time    := 10 ns;
    constant BIT_PERIOD   : time    := 40 ns;

    signal clk             : STD_LOGIC := '0';
    signal rst             : STD_LOGIC := '1';
    signal data_in         : STD_LOGIC_VECTOR(N_BITS-1 downto 0) := "1011001011010110";
    signal nrz_out         : STD_LOGIC;
    signal bit_index_out_tb : STD_LOGIC_VECTOR(3 downto 0);

begin
    uut: entity work.nrz_i
        generic map (
            N_BITS       => N_BITS,
            CLKS_PER_BIT => CLKS_PER_BIT
        )
        port map (
            clk           => clk,
            rst           => rst,
            data_in       => data_in,
            nrz_out       => nrz_out,
            bit_index_out => bit_index_out_tb
        );

    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    stim_process: process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for N_BITS * BIT_PERIOD + 50 ns;
        wait;
    end process;
end sim;