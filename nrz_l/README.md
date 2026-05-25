# Modulação NRZ-L

Implementação em VHDL da codificação **NRZ-L** (Non-Return-to-Zero Level) para a placa **Basys 3** (Artix-7 XC7A35T-1CPG236C). Na NRZ-L, cada bit é representado diretamente pelo nível do sinal durante todo o intervalo: **bit '1' = nível alto**, **bit '0' = nível baixo**.

## Estrutura desta pasta

```
nrz_l/
├── src/                Código-fonte VHDL do circuito principal
├── sim/                Testbench e configuração de waveform
├── constraints/        Mapeamento dos pinos da FPGA (.xdc)
└── vivado_project/     Script Tcl para recriar o projeto e bitstream
```

## Arquivos de código

- **`src/nrz_l.vhd`** — Encoder NRZ-L com máquina de estados síncrona: recebe `data_in(15:0)`, processa um bit por vez do MSB ao LSB com temporização configurável via genéricos (`N_BITS`, `CYCLES_PER_BIT`), e emite `nrz_out` e `bit_indx`
- **`src/top_nrz_l_basys3.vhd`** — Top-level combinacional que conecta diretamente os 16 switches aos 16 LEDs (`led <= sw`), refletindo a natureza da NRZ-L onde o nível de saída é o próprio valor do bit
- **`sim/tb_nrz_l.vhd`** — Testbench comportamental do encoder: gera clock de 20 ns, aplica reset, dispara `start` e aguarda a transmissão completa de 16 bits com período de 100 ns por bit (5 ciclos de clock)
- **`sim/tb_nrz_l_behav.wcfg`** — Configuração de waveform do XSim com os sinais relevantes já adicionados (`clk`, `rst`, `start`, `data_in`, `nrz_out`, `bit_indx`)
- **`constraints/basys3_nrz_l.xdc`** — Mapeamento de `sw[15:0]` e `led[15:0]` para os pinos físicos da Basys 3

## Por onde começar

### Simulação rápida

1. Abra o Vivado
2. No Tcl Console, navegue até `vivado_project/` e execute:
   ```tcl
   source create_project.tcl
   ```
3. Clique em `Run Simulation` → `Run Behavioral Simulation`
4. Observe `nrz_out` no waveform e verifique que cada bit da sequência de entrada aparece diretamente como nível alto ou baixo na saída

### Para reproduzir o projeto do zero

Siga esta ordem:

1. **Entenda a codificação NRZ-L**

   A NRZ-L é a codificação de linha mais direta: o nível do sinal de saída em cada intervalo de bit corresponde exatamente ao valor do bit transmitido.

   | Bit | Nível de saída |
   |:-:|:-:|
   | 1 | Alto |
   | 0 | Baixo |

   Exemplo com entrada `1 0 1 1`:

   | Entrada | 1 | 0 | 1 | 1 |
   |:-:|:-:|:-:|:-:|:-:|
   | Saída   | 1 | 0 | 1 | 1 |

   Na NRZ-L, a saída é uma cópia direta da entrada. A simplicidade é sua principal característica, mas também sua limitação: sequências longas de bits iguais não produzem transições, dificultando a recuperação de clock no receptor.

2. **Estude o código**

   - `src/nrz_l.vhd` implementa a lógica sequencial com `bit_index_reg` percorrendo o vetor de entrada do MSB ao LSB, emitindo `data_in(bit_index_reg)` diretamente em `out_reg` a cada `CYCLES_PER_BIT` ciclos de clock
   - `src/top_nrz_l_basys3.vhd` implementa a lógica de forma puramente combinacional com uma única atribuição (`led <= sw`), sem clock, para feedback imediato via switches e LEDs

3. **Simule no Vivado**

   - Execute o projeto gerado pelo script (`vivado_project/create_project.tcl`)
   - Em `Run Simulation` → `Run Behavioral Simulation`, carregue `tb_nrz_l_behav.wcfg` para visualizar os sinais já configurados
   - A sequência de entrada padrão no testbench é `1011001010101111`; verifique que a saída reproduz exatamente os mesmos níveis

4. **Sintetize e implemente**

   - Clique em `Run Synthesis` e verifique o relatório de utilização
   - Clique em `Run Implementation`
   - Clique em `Generate Bitstream`

5. **Grave na FPGA**

   - Conecte a placa Basys 3 via USB
   - Clique em `Open Hardware Manager` → `Program Device`
   - Ligue e desligue os switches SW15 a SW0 e observe os LEDs correspondentes acenderem e apagarem instantaneamente

   O bitstream já compilado está disponível em `vivado_project/top_nrz_l_basys3.bit` caso queira gravar diretamente sem recompilar.

## Recriar o projeto Vivado

O projeto não está versionado como `.xpr` para evitar dependências de caminho absoluto. O script Tcl reconstrói tudo a partir dos arquivos-fonte:

```tcl
cd {C:/caminho/para/nrz_l/vivado_project}
source create_project.tcl
```

O script cria o projeto na pasta `vivado_project/`, adiciona os fontes de `src/`, o testbench de `sim/` e as constraints de `constraints/` com caminhos relativos, funcionando em qualquer sistema.

---

Dúvidas sobre a lógica ou sobre o mapeamento de pinos: consulte os comentários no topo de cada arquivo `.vhd`.
