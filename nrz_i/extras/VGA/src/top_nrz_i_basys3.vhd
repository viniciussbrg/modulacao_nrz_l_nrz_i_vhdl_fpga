----------------------------------------------------------------------------------
-- Projeto: NRZ-I na Basys 3 com saída VGA
--
-- Funcionamento:
-- SW15 até SW0 definem os 16 bits de entrada.
-- LED15 até LED0 mostram a sequência modulada em NRZ-I.
--
-- A saída VGA mostra a cor da tela conforme o nível modulado atual:
--
-- NRZ-I:
-- bit '1' -> inverte o nível anterior
-- bit '0' -> mantém o nível anterior
--
-- Nível modulado alto  -> tela azul
-- Nível modulado baixo -> tela vermelha
--
-- A leitura dos bits ocorre continuamente:
-- SW15, SW14, SW13, ..., SW0, e depois reinicia em SW15.
--
-- Tempo de duração de cada bit:
-- 2 segundos.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_nrz_i_basys3 is
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
end top_nrz_i_basys3;

architecture Behavioral of top_nrz_i_basys3 is

    --------------------------------------------------------------------------
    -- CONFIGURAÇÃO DA MODULAÇÃO NRZ-I
    --------------------------------------------------------------------------

    constant N_BITS : integer := 16;

    -- Clock da Basys 3 = 100 MHz.
    -- 100 MHz significa 100.000.000 ciclos por segundo.
    --
    -- Para cada bit durar 2 segundos:
    -- 100.000.000 ciclos/s x 2 s = 200.000.000 ciclos.
    --
    -- Portanto, cada bit permanece por 2 segundos na tela.
    constant CYCLES_PER_BIT : integer := 200000000;

    signal bit_index   : integer range 0 to N_BITS - 1 := N_BITS - 1;
    signal cycle_count : integer range 0 to CYCLES_PER_BIT - 1 := 0;

    signal nivel       : std_logic_vector(15 downto 0);
    signal nrz_out_reg : std_logic := '0';

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
    -- MODULAÇÃO NRZ-I PARA OS LEDS
    --
    -- Nível inicial considerado: 0.
    --
    -- Se o bit for 1, inverte o nível anterior.
    -- Se o bit for 0, mantém o nível anterior.
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
    -- Os LEDs mostram a sequência resultante da modulação NRZ-I.
    --------------------------------------------------------------------------

    led <= nivel;

    --------------------------------------------------------------------------
    -- SELEÇÃO TEMPORIZADA DO BIT MODULADO
    --
    -- A tela VGA mostra um único estado por vez.
    -- A cada 2 segundos, o circuito passa para o próximo nível modulado:
    --
    -- nivel(15), nivel(14), nivel(13), ..., nivel(0)
    --------------------------------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then

            if cycle_count = 0 then
                nrz_out_reg <= nivel(bit_index);
            end if;

            if cycle_count = CYCLES_PER_BIT - 1 then
                cycle_count <= 0;

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
    -- h_count percorre a linha.
    -- v_count percorre as linhas do quadro.
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
    -- Os pulsos de sincronismo VGA são ativos em nível baixo.
    --------------------------------------------------------------------------

    Hsync <= '0' when (h_count >= 656 and h_count < 752) else '1';
    Vsync <= '0' when (v_count >= 490 and v_count < 492) else '1';

    --------------------------------------------------------------------------
    -- CORES DA TELA
    --
    -- Se o nível modulado NRZ-I estiver alto:
    -- tela azul.
    --
    -- Se o nível modulado NRZ-I estiver baixo:
    -- tela vermelha.
    --------------------------------------------------------------------------

    vgaRed <= "1111" when (video_on = '1' and nrz_out_reg = '0') else
              "0000";

    vgaGreen <= "0000";

    vgaBlue <= "1111" when (video_on = '1' and nrz_out_reg = '1') else
               "0000";

end Behavioral;