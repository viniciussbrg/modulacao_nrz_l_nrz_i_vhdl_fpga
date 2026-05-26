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
2. Abra o Tcl Console pelo menu **View → Tcl Console**
3. Navegue até `vivado_project/` e execute o script (veja a seção [Recriar o projeto Vivado](#recriar-o-projeto-vivado) para o passo a passo completo)
4. Clique em `Run Simulation` → `Run Behavioral Simulation`
5. Observe `nrz_out` no waveform e verifique que cada bit da sequência de entrada aparece diretamente como nível alto ou baixo na saída

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

O projeto não está versionado como `.xpr` para evitar dependências de caminho absoluto. O script Tcl reconstrói tudo a partir dos arquivos-fonte, com caminhos relativos, funcionando em qualquer máquina.

### Passo a passo no Tcl Console

**1. Abra o Vivado**

Inicie o Vivado normalmente. Não é necessário abrir nenhum projeto — o script cria tudo do zero.

**2. Abra o Tcl Console**

No menu superior, clique em **View → Tcl Console**. O painel abre na parte inferior da janela. Se o Vivado já tiver um projeto aberto, o console aparece automaticamente como aba na barra inferior.

**3. Navegue até a pasta `vivado_project/`**

Na linha de entrada do Tcl Console, digite o comando `cd` com o caminho completo da pasta `vivado_project/` do NRZ-L. Use **chaves** `{ }` para delimitar o caminho — elas evitam problemas com espaços e com a interpretação de caracteres especiais pelo Tcl:

```tcl
cd {C:/caminho/para/nrz_l/vivado_project}
```

> **Atenção:** use sempre barras para frente `/` no caminho, nunca barras invertidas `\`. O Tcl não reconhece `\` como separador de diretório e o comando falha silenciosamente ou com erro de parsing. Mesmo no Windows, o caminho deve ser escrito com `/`.

Exemplo correto:
```tcl
cd {C:/Users/aluno/projetos/nrz_l/vivado_project}
```

Exemplo incorreto (não use):
```tcl
cd {C:\Users\aluno\projetos\nrz_l\vivado_project}
```

**4. Confirme que está no diretório correto**

Antes de executar o script, verifique o diretório atual com:

```tcl
pwd
```

O console deve retornar um caminho terminando em `.../nrz_l/vivado_project`. Se retornar outro caminho, repita o passo 3 com o caminho correto.

**5. Execute o script**

```tcl
source create_project.tcl
```

O Vivado processa o script e exibe mensagens de log no console. Aguarde até aparecer a confirmação:

```
======================================================================
 Projeto NRZ_L_Basys3 criado com sucesso!
======================================================================
```

O projeto abre automaticamente no Vivado após a execução. A partir daí, é possível rodar a simulação, síntese, implementação e geração de bitstream normalmente.

### Problemas comuns

| Erro | Causa | Solução |
|---|---|---|
| `couldn't open "create_project.tcl"` | O `cd` foi feito no diretório errado | Verifique com `pwd` e refaça o `cd` apontando para a pasta `vivado_project/` |
| Caminho não reconhecido ou erro de parsing | Barras invertidas `\` no caminho | Substitua todas as `\` por `/` no comando `cd` |
| `Part not found` | Device family Artix-7 não instalado no Vivado | Reinstale o Vivado incluindo o suporte a **7 Series** |
| Projeto criado mas arquivos `.vhd` não encontrados | A pasta `nrz_l/` foi movida ou renomeada após o `cd` | Mantenha a estrutura de pastas intacta e execute o script a partir de `vivado_project/` dentro dela |

---

Dúvidas sobre a lógica ou sobre o mapeamento de pinos: consulte os comentários no topo de cada arquivo `.vhd`.
