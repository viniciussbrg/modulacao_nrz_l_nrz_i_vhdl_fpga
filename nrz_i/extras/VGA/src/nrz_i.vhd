----------------------------------------------------------------------------------
-- Projeto: Modulacao Digital por Inversao de Nivel
-- Placa alvo: Basys 3 - Artix-7 xc7a35tcpg236-1
--
-- Regra da modulacao:
--
-- O primeiro nivel de saida recebe o primeiro bit transmitido: data_in(15)
--
-- Para os bits seguintes:
-- bit '1' -> inverte o nivel anterior da saida
-- bit '0' -> mantem o nivel anterior da saida
--
-- Exemplo:
-- nivel anterior = '1'
-- bit atual = '1' -> saida inverte para '0'
-- bit atual = '0' -> saida permanece em '1'
--
-- A transmissao ocorre do MSB para o LSB:
-- data_in(15), data_in(14), ..., data_in(0)
--
-- O sinal bit_indx indica qual bit do vetor data_in esta sendo analisado.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nrz_i is
    generic (
        N_BITS         : integer := 16;
        CYCLES_PER_BIT : integer := 5
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        start    : in  std_logic;
        data_in  : in  std_logic_vector(N_BITS - 1 downto 0);

        nrz_out  : out std_logic;
        bit_indx : out integer range 0 to N_BITS - 1
    );
end nrz_i;

architecture Behavioral of nrz_i is

    signal bit_index_reg : integer range 0 to N_BITS - 1 := N_BITS - 1;
    signal cycle_count   : integer range 0 to CYCLES_PER_BIT - 1 := 0;

    signal active        : std_logic := '0';
    signal out_reg       : std_logic := '0';

begin

    nrz_out  <= out_reg;
    bit_indx <= bit_index_reg;

    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                bit_index_reg <= N_BITS - 1;
                cycle_count   <= 0;
                active        <= '0';
                out_reg       <= '0';

            else

                if start = '1' and active = '0' then
                    active        <= '1';
                    bit_index_reg <= N_BITS - 1;
                    cycle_count   <= 0;

                    -- Primeiro nivel da onda de resposta
                    out_reg <= data_in(N_BITS - 1);

                elsif active = '1' then

                    if cycle_count = CYCLES_PER_BIT - 1 then
                        cycle_count <= 0;

                        if bit_index_reg = 0 then
                            active <= '0';

                        else
                            bit_index_reg <= bit_index_reg - 1;

                            -- Proximo bit a ser analisado
                            -- Se o bit posterior for 1, inverte o nivel
                            -- Se o bit posterior for 0, mantem o nivel anterior
                            if data_in(bit_index_reg - 1) = '1' then
                                out_reg <= not out_reg;
                            else
                                out_reg <= out_reg;
                            end if;

                        end if;

                    else
                        cycle_count <= cycle_count + 1;
                    end if;

                end if;

            end if;

        end if;
    end process;

end Behavioral;