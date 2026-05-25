----------------------------------------------------------------------------------
-- Projeto: Modulação Digital NRZ-I na placa Basys 3
-- Placa: Basys 3 - Artix-7 XC7A35T-1CPG236C
--
-- Funcionamento:
-- SW15 até SW0 representam os 16 bits de entrada.
-- LED15 até LED0 representam a saída modulada NRZ-I.
--
-- Regra NRZ-I:
-- bit '1' -> ocorre inversão do nível anterior
-- bit '0' -> mantém o nível anterior
--
-- A leitura ocorre de SW15 até SW0.
--
-- Exemplo:
-- nível inicial = 0
-- entrada: 1 0 1 1
-- saída:   1 1 0 1
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_nrz_i_basys3 is
    port (
        sw  : in  std_logic_vector(15 downto 0);
        led : out std_logic_vector(15 downto 0)
    );
end top_nrz_i_basys3;

architecture Behavioral of top_nrz_i_basys3 is

    signal nivel : std_logic_vector(15 downto 0);

begin

    --------------------------------------------------------------------------
    -- Modulação NRZ-I dinâmica
    --
    -- O nível inicial antes do primeiro bit é considerado 0.
    --
    -- Para SW15:
    -- se SW15 = 1, inverte o nível inicial 0, então LED15 = 1.
    -- se SW15 = 0, mantém o nível inicial 0, então LED15 = 0.
    --------------------------------------------------------------------------

    nivel(15) <= sw(15);

    --------------------------------------------------------------------------
    -- Para os próximos bits:
    --
    -- Se o switch atual for 1:
    -- o LED atual recebe o inverso do LED anterior.
    --
    -- Se o switch atual for 0:
    -- o LED atual mantém o valor do LED anterior.
    --------------------------------------------------------------------------

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

    -- Envia a saída modulada para os LEDs.
    led <= nivel;

end Behavioral;