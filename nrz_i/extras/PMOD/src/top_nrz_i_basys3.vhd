----------------------------------------------------------------------------------
-- Projeto: NRZ-I na Basys 3 com saida no PMOD JA1
--
-- Placa: Basys 3 - Artix-7 XC7A35T-1CPG236C
--
-- Funcionamento:
-- SW15 ate SW0 definem os 16 bits de entrada.
-- LED15 ate LED0 mostram a palavra modulada em NRZ-I.
-- PMOD JA1 envia a modulacao NRZ-I para o Analog Discovery 3.
--
-- Regra NRZ-I:
-- bit '1' -> inverte o nivel anterior
-- bit '0' -> mantem o nivel anterior
--
-- A leitura ocorre continuamente:
-- SW15, SW14, SW13, ..., SW0, e depois reinicia em SW15.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_nrz_i_basys3 is
    port (
        clk      : in  std_logic;
        sw       : in  std_logic_vector(15 downto 0);
        led      : out std_logic_vector(15 downto 0);
        pmod_ja1 : out std_logic
    );
end top_nrz_i_basys3;

architecture Behavioral of top_nrz_i_basys3 is

    constant N_BITS : integer := 16;

    -- Clock da Basys 3 = 100 MHz.
    -- 100 MHz significa 10 ns por ciclo.
    --
    -- 2.000.000 ciclos x 10 ns = 20 ms por bit.
    -- 16 bits x 20 ms = 320 ms para transmitir a sequencia completa.
    --
    -- Se quiser mais rapido, use 1.000.000.
    -- Se quiser mais lento, use 5.000.000.
    constant CYCLES_PER_BIT : integer := 2000000;

    signal bit_index   : integer range 0 to N_BITS - 1 := N_BITS - 1;
    signal cycle_count : integer range 0 to CYCLES_PER_BIT - 1 := 0;

    signal nivel       : std_logic_vector(15 downto 0);
    signal nrz_out_reg : std_logic := '0';

begin

    --------------------------------------------------------------------------
    -- MODULACAO NRZ-I PARA OS LEDS
    --
    -- Nivel inicial considerado: 0.
    --
    -- Se o bit for 1, inverte o nivel anterior.
    -- Se o bit for 0, mantem o nivel anterior.
    --------------------------------------------------------------------------

    nivel(15) <= sw(15);

    nivel(14) <= not nivel(15) when sw(14) = '1' else nivel(15);
    nivel(13) <= not nivel(14) when sw(13) = '1' else nivel(14);
    nivel(12) <= not nivel(13) when sw(12) = '1' else nivel(13);
    nivel(11) <= not nivel(12) when sw(11) = '1' else nivel(12);
    nivel(10) <= not nivel(11) when sw(10) = '1' else nivel(11);
    nivel(9)  <= not nivel(10) when sw(9)  = '1' else nivel(10);
    nivel(8)  <= not nivel(9)  when sw(8)  = '1' else nivel(9);
    nivel(7)  <= not nivel(8)  when sw(7)  = '1' else nivel(8);
    nivel(6)  <= not nivel(7)  when sw(6)  = '1' else nivel(7);
    nivel(5)  <= not nivel(6)  when sw(5)  = '1' else nivel(6);
    nivel(4)  <= not nivel(5)  when sw(4)  = '1' else nivel(5);
    nivel(3)  <= not nivel(4)  when sw(3)  = '1' else nivel(4);
    nivel(2)  <= not nivel(3)  when sw(2)  = '1' else nivel(3);
    nivel(1)  <= not nivel(2)  when sw(1)  = '1' else nivel(2);
    nivel(0)  <= not nivel(1)  when sw(0)  = '1' else nivel(1);

    --------------------------------------------------------------------------
    -- LEDs:
    -- Os LEDs mostram diretamente a sequencia ja modulada em NRZ-I.
    --------------------------------------------------------------------------
    led <= nivel;

    --------------------------------------------------------------------------
    -- PMOD:
    -- O sinal enviado ao Analog Discovery 3 sai pelo JA1.
    --------------------------------------------------------------------------
    pmod_ja1 <= nrz_out_reg;

    --------------------------------------------------------------------------
    -- GERACAO SERIAL DA MODULACAO PARA O WAVEFORMS
    --
    -- Enquanto os LEDs mostram os 16 niveis ao mesmo tempo,
    -- o PMOD JA1 envia esses niveis um por vez:
    --
    -- nivel(15), nivel(14), nivel(13), ..., nivel(0)
    --
    -- Assim, o WaveForms consegue mostrar a forma de onda no tempo.
    --------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then

            if cycle_count = CYCLES_PER_BIT - 1 then
                cycle_count <= 0;

                -- Envia para o PMOD o nivel NRZ-I correspondente ao bit atual.
                nrz_out_reg <= nivel(bit_index);

                -- Passa para o proximo bit.
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