----------------------------------------------------------------------------------
-- Testbench para Modulacao Digital NRZ-L
--
-- Clock:
-- cada ciclo de clock possui 20 ns
--
-- Bit:
-- cada bit possui duracao de 100 ns
--
-- Portanto:
-- 100 ns / 20 ns = 5 ciclos de clock por bit
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_nrz_l is
end tb_nrz_l;

architecture Behavioral of tb_nrz_l is

    constant N_BITS : integer := 16;

    constant CLK_PERIOD : time := 20 ns;
    constant BIT_PERIOD : time := 100 ns;

    constant CYCLES_PER_BIT : integer := BIT_PERIOD / CLK_PERIOD;

    constant INPUT_BITS : std_logic_vector(N_BITS - 1 downto 0) := "1011001010101111";

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal start    : std_logic := '0';

    signal data_in  : std_logic_vector(N_BITS - 1 downto 0) := INPUT_BITS;

    signal nrz_out  : std_logic;
    signal bit_indx : integer range 0 to N_BITS - 1;

begin

    uut: entity work.nrz_l
        generic map (
            N_BITS         => N_BITS,
            CYCLES_PER_BIT => CYCLES_PER_BIT
        )
        port map (
            clk      => clk,
            rst      => rst,
            start    => start,
            data_in  => data_in,
            nrz_out  => nrz_out,
            bit_indx => bit_indx
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stimulus_process: process
    begin

        rst <= '1';
        start <= '0';
        wait for 40 ns;

        rst <= '0';
        wait for 40 ns;

        wait until rising_edge(clk);
        start <= '1';

        wait until rising_edge(clk);
        start <= '0';

        wait for N_BITS * BIT_PERIOD;

        wait for 100 ns;

        assert false report "Fim da simulacao NRZ-L" severity failure;

    end process;

end Behavioral;