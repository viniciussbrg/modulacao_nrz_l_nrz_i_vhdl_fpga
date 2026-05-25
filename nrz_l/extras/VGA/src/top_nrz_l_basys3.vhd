----------------------------------------------------------------------------------
-- Projeto: NRZ-L na Basys 3 com saída VGA
--
-- Funcionamento:
-- SW15 até SW0 definem os 16 bits de entrada.
-- LED15 até LED0 mostram os switches em tempo real.
--
-- A saída VGA mostra a cor da tela conforme o nível modulado:
--
-- NRZ-L:
-- bit '1' -> nível alto  -> tela azul
-- bit '0' -> nível baixo -> tela vermelha
--
-- A leitura dos bits ocorre continuamente:
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

        vgaRed   : out std_logic_vector(3 downto 0);
        vgaGreen : out std_logic_vector(3 downto 0);
        vgaBlue  : out std_logic_vector(3 downto 0);
        Hsync    : out std_logic;
        Vsync    : out std_logic
    );
end top_nrz_l_basys3;

architecture Behavioral of top_nrz_l_basys3 is

    --------------------------------------------------------------------------
    -- CONFIGURAÇÃO DA MODULAÇÃO NRZ-L
    --------------------------------------------------------------------------

    constant N_BITS : integer := 16;

    -- Clock da Basys 3 = 100 MHz.
    -- 100 MHz significa 10 ns por ciclo.
    --
    -- 10.000.000 ciclos x 10 ns = 100 ms por bit.
    --
    -- Como são 16 bits:
    -- 16 x 100 ms = 1,6 s para percorrer a sequência inteira.
    --
    -- Se quiser a tela piscando mais devagar, use 25.000.000 ou 50.000.000.
    -- Se quiser mais rápido, use 5.000.000.
    constant CYCLES_PER_BIT : integer := 200000000;

    signal bit_index   : integer range 0 to N_BITS - 1 := N_BITS - 1;
    signal cycle_count : integer range 0 to CYCLES_PER_BIT - 1 := 0;

    signal nrz_out_reg : std_logic := '0';
    signal led_state   : std_logic_vector(15 downto 0);

    --------------------------------------------------------------------------
    -- CONFIGURAÇÃO VGA 640x480 @ aproximadamente 60 Hz
    --
    -- A Basys 3 possui clock de 100 MHz.
    -- Para VGA 640x480, usamos aproximadamente 25 MHz.
    -- Portanto, dividimos o clock por 4.
    --------------------------------------------------------------------------

    signal pixel_div : unsigned(1 downto 0) := (others => '0');

    signal h_count : integer range 0 to 799 := 0;
    signal v_count : integer range 0 to 524 := 0;

    signal video_on : std_logic := '0';

begin

    --------------------------------------------------------------------------
    -- LEDs:
    -- Mantém a mesma lógica anterior.
    -- Os LEDs mostram os bits de entrada definidos pelos switches.
    --------------------------------------------------------------------------

    led_state <= sw;
    led <= led_state;

    --------------------------------------------------------------------------
    -- MODULAÇÃO NRZ-L:
    --
    -- A saída modulada acompanha diretamente o valor do bit:
    -- bit 1 -> nível alto
    -- bit 0 -> nível baixo
    --
    -- O bit atual é escolhido pelo bit_index:
    -- 15, 14, 13, ..., 0.
    --------------------------------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then

            -- No início de cada intervalo de bit, atualiza o nível modulado.
            if cycle_count = 0 then
                nrz_out_reg <= led_state(bit_index);
            end if;

            -- Conta o tempo de permanência do bit atual.
            if cycle_count = CYCLES_PER_BIT - 1 then
                cycle_count <= 0;

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

    --------------------------------------------------------------------------
    -- GERADOR DE SINCRONISMO VGA
    --
    -- Resolução lógica usada: 640x480.
    -- h_count percorre uma linha inteira.
    -- v_count percorre todas as linhas do quadro.
    --------------------------------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then

            -- Divide o clock de 100 MHz por 4 para obter aproximadamente 25 MHz.
            pixel_div <= pixel_div + 1;

            -- Atualiza os contadores VGA somente a cada 4 ciclos de clock.
            if pixel_div = "11" then

                if h_count = 799 then
                    h_count <= 0;

                    if v_count = 524 then
                        v_count <= 0;
                    else
                        v_count <= v_count + 1;
                    end if;

                else
                    h_count <= h_count + 1;
                end if;

            end if;

        end if;
    end process;

    --------------------------------------------------------------------------
    -- Área visível da tela
    --------------------------------------------------------------------------

    video_on <= '1' when (h_count < 640 and v_count < 480) else '0';

    --------------------------------------------------------------------------
    -- Sinais de sincronismo VGA
    --
    -- Para VGA, os pulsos de Hsync e Vsync são ativos em nível baixo.
    --------------------------------------------------------------------------

    Hsync <= '0' when (h_count >= 656 and h_count < 752) else '1';
    Vsync <= '0' when (v_count >= 490 and v_count < 492) else '1';

    --------------------------------------------------------------------------
    -- CORES DA TELA
    --
    -- Se o sinal modulado estiver em nível alto:
    -- tela azul.
    --
    -- Se o sinal modulado estiver em nível baixo:
    -- tela vermelha.
    --------------------------------------------------------------------------

    vgaRed <= "1111" when (video_on = '1' and nrz_out_reg = '0') else
              "0000";

    vgaGreen <= "0000";

    vgaBlue <= "1111" when (video_on = '1' and nrz_out_reg = '1') else
               "0000";

end Behavioral;