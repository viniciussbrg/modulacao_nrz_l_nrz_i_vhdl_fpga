# Modulação NRZ-I

Implementação em VHDL da codificação **NRZ-I** (Non-Return-to-Zero Inverted) para a placa **Basys 3** (Artix-7 XC7A35T-1CPG236C). Na NRZ-I, o bit é representado pela **transição** do sinal no início do intervalo: **bit '1' provoca inversão do nível anterior**, **bit '0' mantém o nível anterior**. O nível inicial antes do primeiro bit é considerado `0`.

## Estrutura desta pasta

```
nrz_i/
├── src/                Código-fonte VHDL do circuito principal
├── sim/                Testbench e configuração de waveform
├── constraints/        Mapeamento dos pinos da FPGA (.xdc)
├── vivado_project/     Script Tcl para recriar o projeto e bitstream
└── extras/             Atividades opcionais
    ├── PMOD/           Saída serial pelo PMOD JA1 (Analog Discovery)
    └── VGA/            Saída VGA com cores por nível
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
2. Abra o Tcl Console pelo menu **View → Tcl Console**
3. Navegue até `vivado_project/` e execute o script (veja a seção [Recriar o projeto Vivado](#recriar-o-projeto-vivado) para o passo a passo completo)
4. Clique em `Run Simulation` → `Run Behavioral Simulation`
5. Observe `nrz_out` no waveform e verifique que cada bit `1` na sequência de entrada causa uma inversão do nível, enquanto cada bit `0` mantém o nível anterior

### Para reproduzir o projeto do zero

Siga esta ordem:

1. **Entenda a codificação NRZ-I**

   A NRZ-I é baseada em transições, não em níveis absolutos. O nível de saída em cada intervalo depende do bit atual e do nível do intervalo anterior:

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

   Compare com o [NRZ-L](../nrz_l/): enquanto na NRZ-L a saída copia o valor do bit diretamente, na NRZ-I o que importa é se houve ou não mudança em relação ao intervalo anterior.

2. **Estude o código**

   - `src/nrz_i.vhd` implementa a lógica sequencial com `bit_index_reg` percorrendo o vetor de entrada do MSB ao LSB, invertendo `out_reg` quando o bit atual é `1` e mantendo quando é `0`, a cada `CYCLES_PER_BIT` ciclos de clock
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

O projeto não está versionado como `.xpr` para evitar dependências de caminho absoluto. O script Tcl reconstrói tudo a partir dos arquivos-fonte, com caminhos relativos, funcionando em qualquer máquina.

### Passo a passo no Tcl Console

**1. Abra o Vivado**

Inicie o Vivado normalmente. Não é necessário abrir nenhum projeto — o script cria tudo do zero.

**2. Abra o Tcl Console**

No menu superior, clique em **View → Tcl Console**. O painel abre na parte inferior da janela. Se o Vivado já tiver um projeto aberto, o console aparece automaticamente como aba na barra inferior.

**3. Navegue até a pasta `vivado_project/`**

Na linha de entrada do Tcl Console, digite o comando `cd` com o caminho completo da pasta `vivado_project/` do NRZ-I. Use **chaves** `{ }` para delimitar o caminho:

```tcl
cd {C:/caminho/para/nrz_i/vivado_project}
```

> **Atenção:** use sempre barras para frente `/` no caminho, nunca barras invertidas `\`. O Tcl não reconhece `\` como separador de diretório e o comando falha silenciosamente ou com erro de parsing. Mesmo no Windows, o caminho deve ser escrito com `/`.

Exemplo correto:
```tcl
cd {C:/Users/aluno/projetos/nrz_i/vivado_project}
```

Exemplo incorreto (não use):
```tcl
cd {C:\Users\aluno\projetos\nrz_i\vivado_project}
```

**4. Confirme que está no diretório correto**

```tcl
pwd
```

O console deve retornar um caminho terminando em `.../nrz_i/vivado_project`. Se retornar outro caminho, repita o passo 3 com o caminho correto.

**5. Execute o script**

```tcl
source create_project.tcl
```

O Vivado processa o script e exibe mensagens de log no console. Aguarde até aparecer a confirmação:

```
======================================================================
 Projeto NRZ_I_Basys3 criado com sucesso!
======================================================================
```

O projeto abre automaticamente no Vivado. A partir daí, é possível rodar a simulação, síntese, implementação e geração de bitstream normalmente.

### Problemas comuns

| Erro | Causa | Solução |
|---|---|---|
| `couldn't open "create_project.tcl"` | O `cd` foi feito no diretório errado | Verifique com `pwd` e refaça o `cd` apontando para a pasta `vivado_project/` |
| Caminho não reconhecido ou erro de parsing | Barras invertidas `\` no caminho | Substitua todas as `\` por `/` no comando `cd` |
| `Part not found` | Device family Artix-7 não instalado no Vivado | Reinstale o Vivado incluindo o suporte a **7 Series** |
| Projeto criado mas arquivos `.vhd` não encontrados | A pasta `nrz_i/` foi movida ou renomeada | Mantenha a estrutura de pastas intacta e execute o script a partir de `vivado_project/` dentro dela |

## Extras (opcionais)

Este projeto implementou as duas atividades extras:

- [**PMOD — Analog Discovery**](./extras/PMOD/) — saída serial pelo conector PMOD JA1, visualizada em tempo real com o WaveForms
- [**VGA — Visualização em monitor**](./extras/VGA/) — exibe o nível modulado como cor de tela inteira (azul = alto, vermelho = baixo) em qualquer monitor VGA

## Próximo passo

Você concluiu os dois projetos do trabalho. Acesse a [documentação técnica](../relatorio_final/) para ver a análise comparativa entre NRZ-L e NRZ-I, os resultados obtidos e as conclusões do grupo.

---

Dúvidas sobre a lógica de transição ou sobre o mapeamento de pinos: consulte os comentários no topo de cada arquivo `.vhd`.
