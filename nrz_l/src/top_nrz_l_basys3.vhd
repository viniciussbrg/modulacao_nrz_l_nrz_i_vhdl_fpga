----------------------------------------------------------------------------------
-- Projeto: Modulação Digital NRZ-L na placa Basys 3
-- Placa: Basys 3 - Artix-7 XC7A35T-1CPG236C
--
-- Funcionamento:
-- SW15 até SW0 representam os 16 bits de entrada.
-- LED15 até LED0 representam a saída modulada NRZ-L.
--
-- Regra NRZ-L:
-- bit '1' -> saída em nível alto
-- bit '0' -> saída em nível baixo
--
-- Portanto:
-- se SW estiver ligado    -> LED correspondente acende
-- se SW estiver desligado -> LED correspondente apaga
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_nrz_l_basys3 is
    port (
        sw  : in  std_logic_vector(15 downto 0);
        led : out std_logic_vector(15 downto 0)
    );
end top_nrz_l_basys3;

architecture Behavioral of top_nrz_l_basys3 is
begin

    -- Modulação NRZ-L dinâmica:
    -- cada LED representa o nível de saída modulado do bit correspondente.
    led <= sw;

end Behavioral;