library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nrz_l is
    generic (
        N_BITS       : integer := 16;
        CLKS_PER_BIT : integer := 50_000_000  -- 0,5 s por bit com clock de 100 MHz
    );
    Port (
        clk           : in  STD_LOGIC;
        rst           : in  STD_LOGIC;
        data_in       : in  STD_LOGIC_VECTOR(N_BITS-1 downto 0);
        nrz_out       : out STD_LOGIC;
        bit_index_out : out STD_LOGIC_VECTOR(3 downto 0)
    );
end nrz_l;

architecture Behavioral of nrz_l is
    signal bit_index   : integer range 0 to N_BITS-1 := 0;
    signal clk_counter : integer range 0 to CLKS_PER_BIT-1 := 0;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            bit_index   <= 0;
            clk_counter <= 0;
        elsif rising_edge(clk) then
            if clk_counter = CLKS_PER_BIT-1 then
                clk_counter <= 0;
                if bit_index = N_BITS-1 then
                    bit_index <= 0;
                else
                    bit_index <= bit_index + 1;
                end if;
            else
                clk_counter <= clk_counter + 1;
            end if;
        end if;
    end process;

    nrz_out <= data_in(N_BITS-1 - bit_index);
    bit_index_out <= std_logic_vector(to_unsigned(bit_index, 4));
end Behavioral;