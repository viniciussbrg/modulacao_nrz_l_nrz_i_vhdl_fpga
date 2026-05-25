----------------------------------------------------------------------------------
-- Projeto: NRZ-L na Basys 3 com saida no PMOD JA1
--
-- Funcionamento:
-- SW15 ate SW0 definem os 16 bits de entrada.
-- LED15 ate LED0 mostram os switches em tempo real.
-- PMOD JA1 envia a modulacao NRZ-L para o Analog Discovery 3.
--
-- Regra NRZ-L:
-- bit '1' -> nivel alto
-- bit '0' -> nivel baixo
--
-- A transmissao ocorre continuamente:
-- SW15, SW14, SW13, ..., SW0, e depois reinicia em SW15.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_nrz_l_basys3 is
    port (
        clk      : in  std_logic;
        sw       : in  std_logic_vector(15 downto 0);
        led      : out std_logic_vector(15 downto 0);
        pmod_ja1 : out std_logic
    );
end top_nrz_l_basys3;

architecture Behavioral of top_nrz_l_basys3 is

    constant N_BITS : integer := 16;

    -- Clock da Basys 3 = 100 MHz.
    -- 100 MHz significa 10 ns por ciclo.
    --
    -- 2.000.000 ciclos x 10 ns = 20 ms por bit.
    --
    -- Cada quadro completo tem 16 bits:
    -- 16 x 20 ms = 320 ms.
    --
    -- Assim, qualquer mudanca nos switches aparece no WaveForms
    -- em no maximo aproximadamente 320 ms.
    constant CYCLES_PER_BIT : integer := 2000000;

    signal bit_index   : integer range 0 to N_BITS - 1 := N_BITS - 1;
    signal cycle_count : integer range 0 to CYCLES_PER_BIT - 1 := 0;

    signal nrz_out_reg : std_logic := '0';

begin

    --------------------------------------------------------------------------
    -- LEDs:
    -- Os LEDs mostram os switches diretamente.
    -- Isso permite conferir visualmente a palavra de entrada.
    --------------------------------------------------------------------------
    led <= sw;

    --------------------------------------------------------------------------
    -- PMOD:
    -- O sinal enviado ao Analog Discovery 3 sai pelo JA1.
    --------------------------------------------------------------------------
    pmod_ja1 <= nrz_out_reg;

    --------------------------------------------------------------------------
    -- Geração contínua da modulação NRZ-L:
    -- A placa lê os switches na ordem:
    -- SW15, SW14, SW13, ..., SW0
    --
    -- Para NRZ-L:
    -- se o switch atual é 1, a saída fica em nível alto;
    -- se o switch atual é 0, a saída fica em nível baixo.
    --------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then

            -- Mantém o bit atual durante CYCLES_PER_BIT ciclos de clock.
            if cycle_count = CYCLES_PER_BIT - 1 then
                cycle_count <= 0;

                -- Atualiza a saída com o switch correspondente ao bit atual.
                nrz_out_reg <= sw(bit_index);

                -- Passa para o próximo bit.
                if bit_index = 0 then
                    bit_index <= N_BITS - 1;
                else
                    bit_index <= bit_index - 1;
                end if;

            else
                cycle_count <= cycle_count + 1;
            end if;

        end if;
    end process;

end Behavioral;