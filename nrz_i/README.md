# Modulação NRZ-I

Implementação em VHDL da codificação **NRZ-I** (Non-Return-to-Zero Inverted) para a placa **Basys 3** (Artix-7 XC7A35T-1CPG236C). Na NRZ-I, o bit é representado pela **transição** do sinal no início do intervalo: **bit '1' provoca inversão do nível anterior**, **bit '0' mantém o nível anterior**. O nível inicial antes do primeiro bit é considerado `0`.

## Estrutura desta pasta

```
nrz_i/
├── src/                Código-fonte VHDL do circuito principal
├── sim/                Testbench e configuração de waveform
├── constraints/        Mapeamento dos pinos da FPGA (.xdc)
└── vivado_project/     Script Tcl para recriar o projeto e bitstream gerado
```

## Arquivos de código

- **`src/nrz_i.vhd`** — Encoder NRZ-I com máquina de estados síncrona: recebe `data_in(15:0)`, processa um bit por vez do MSB ao LSB com temporização configurável via genéricos (`N_BITS`, `CYCLES_PER_BIT`), e emite `nrz_out` e `bit_indx`
- **`src/top_nrz_i_basys3.vhd`** — Top-level combinacional que acopla os 16 switches da Basys 3 à lógica NRZ-I e exibe o resultado diretamente nos 16 LEDs, sem clock
- **`sim/tb_nrz_i.vhd`** — Testbench comportamental do encoder: gera clock de 20 ns, aplica reset, dispara `start` e aguarda a transmissão completa de 16 bits com período de 100 ns por bit (5 ciclos de clock)
- **`sim/tb_nrz_i_behav.wcfg`** — Configuração de waveform do XSim com os sinais relevantes já adicionados (`clk`, `rst`, `start`, `data_in`, `nrz_out`, `bit_indx`)
- **`constraints/basys3_nrz_i.xdc`** — Mapeamento de `sw[15:0]` e `led[15:0]` para os pinos físicos da Basys 3

## Por onde começar

### Simulação rápida

1. Abra o Vivado
2. No Tcl Console, navegue até `vivado_project/` e execute:
   ```tcl
   source create_project.tcl
   ```
3. Clique em `Run Simulation` → `Run Behavioral Simulation`
4. Observe `nrz_out` no waveform e verifique que cada bit `1` na sequência de entrada causa uma inversão do nível, enquanto cada bit `0` mantém o nível anterior

### Para reproduzir o projeto do zero

Siga esta ordem:

1. **Entenda a codificação NRZ-I**

   A NRZ-I é baseada em transições, não em níveis absolutos. O nível do sinal de saída em cada intervalo depende do bit atual e do nível do intervalo anterior:

   | Nível anterior | Bit atual | Nível atual |
   |:-:|:-:|:-:|
   | 0 | 0 | 0 |
   | 0 | 1 | 1 |
   | 1 | 0 | 1 |
   | 1 | 1 | 0 |

   Exemplo com nível inicial `0` e entrada `1 0 1 1`:

   | Nível inicial | 1 | 0 | 1 | 1 |
   |:-:|:-:|:-:|:-:|:-:|
   | Entrada | 1 | 0 | 1 | 1 |
   | Saída   | 1 | 1 | 0 | 1 |

2. **Estude o código**

   - `src/nrz_i.vhd` implementa a lógica sequencial com `bit_index_reg` percorrendo o vetor de entrada do MSB ao LSB, avançando a cada `CYCLES_PER_BIT` ciclos de clock
   - `src/top_nrz_i_basys3.vhd` implementa a mesma lógica de forma puramente combinacional, sem clock, para feedback imediato via switches e LEDs da placa

3. **Simule no Vivado**

   - Execute o projeto gerado pelo script (`vivado_project/create_project.tcl`)
   - Em `Run Simulation` → `Run Behavioral Simulation`, carregue `tb_nrz_i_behav.wcfg` para visualizar os sinais já configurados
   - A sequência de entrada padrão no testbench é `1011001110001111`; verifique a saída manualmente pela tabela de transições

4. **Sintetize e implemente**

   - Clique em `Run Synthesis` e verifique o relatório de utilização
   - Clique em `Run Implementation`
   - Clique em `Generate Bitstream`

5. **Grave na FPGA**

   - Conecte a placa Basys 3 via USB
   - Clique em `Open Hardware Manager` → `Program Device`
   - Use os switches SW15 a SW0 para inserir os 16 bits de entrada e observe o resultado nos LEDs LD15 a LD0

   O bitstream já compilado está disponível em `vivado_project/top_nrz_i_basys3.bit` caso queira gravar diretamente sem recompilar.

## Recriar o projeto Vivado

O projeto não está versionado como `.xpr` para evitar dependências de caminho absoluto. O script Tcl reconstrói tudo a partir dos arquivos-fonte:

```tcl
cd {C:/caminho/para/nrz_i/vivado_project}
source create_project.tcl
```

O script cria o projeto na pasta `vivado_project/`, adiciona os fontes de `src/`, o testbench de `sim/` e as constraints de `constraints/` com caminhos relativos, funcionando em qualquer sistema.

---

Dúvidas sobre a lógica de transição ou sobre o mapeamento de pinos: consulte os comentários no topo de cada arquivo `.vhd`.
