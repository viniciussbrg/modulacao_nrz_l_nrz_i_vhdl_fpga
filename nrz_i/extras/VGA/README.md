# VGA — Saída NRZ-I com visualização em monitor

Variante do projeto NRZ-I principal que adiciona saída **VGA 640x480 @ 60 Hz** pela Basys 3, exibindo o nível modulado atual como cor de tela inteira: **azul para nível alto (bit '1')**, **vermelho para nível baixo (bit '0')**. Cada bit permanece na tela por 2 segundos, percorrendo a sequência completa de 16 bits em 32 segundos antes de reiniciar.

## Estrutura desta pasta

```
VGA/
├── src/                Código-fonte VHDL
├── sim/                Testbench e configuração de waveform
├── constraints/        Mapeamento de pinos (.xdc) com VGA
├── vivado_project/     Script Tcl para recriar o projeto e bitstream
└── docs/               Documentação adicional (capturas, esquemáticos)
```

## Diferenças em relação ao projeto principal

Este subprojeto modifica dois arquivos do projeto base (`nrz_i/`):

- **`src/top_nrz_i_basys3.vhd`** — Estendido com suporte a clock, gerador de sincronismo VGA e lógica de serialização temporizada. Exibe cada bit como cor de tela inteira por 2 segundos, do SW15 ao SW0
- **`constraints/basys3_nrz_i.xdc`** — Estendido com o mapeamento do clock da placa e dos pinos do conector VGA. Os demais arquivos são idênticos aos do projeto principal.


## Arquivos de código

- **`src/nrz_i.vhd`** — Encoder NRZ-I (idêntico ao projeto principal)
- **`src/top_nrz_i_basys3.vhd`** — Top-level com saída para LEDs, gerador VGA e serialização temporizada por bit
- **`sim/tb_nrz_i.vhd`** — Testbench do encoder (idêntico ao projeto principal)
- **`constraints/basys3_nrz_i.xdc`** — Mapeamento de pinos da Basys 3, incluindo clock e conector VGA


## Por onde começar

### O que você vai precisar

- Placa Basys 3 conectada ao computador via cabo USB
- Monitor ou TV com entrada VGA e cabo VGA para conectar à placa
- Vivado instalado com suporte a dispositivos **7 Series** (Artix-7)

### Conexão física antes de ligar

Antes de gravar o bitstream, faça as conexões:

1. Conecte o cabo VGA entre o conector VGA da Basys 3 e o monitor
2. Ligue o monitor e selecione a entrada VGA nele (caso tenha múltiplas entradas)
3. Conecte a Basys 3 ao computador via USB e ligue a chave de energia da placa

### Simulação rápida (sem a placa)

Se quiser verificar o comportamento do encoder antes de gravar na placa:

1. Abra o Vivado
2. Abra o Tcl Console pelo menu **View → Tcl Console**
3. Navegue até `vivado_project/` e execute o script (veja a seção [Recriar o projeto Vivado](#recriar-o-projeto-vivado) para o passo a passo completo)
4. Clique em `Run Simulation` → `Run Behavioral Simulation`
5. Carregue `tb_nrz_i_behav.wcfg` na janela de waveform para visualizar os sinais já configurados
6. Observe o sinal `nrz_out`: cada bit `1` inverte o nível anterior, cada bit `0` mantém

> A simulação cobre apenas o encoder NRZ-I (`nrz_i.vhd`). O gerador VGA e a serialização temporizada do top-level não são simulados pelo testbench.

### Gravar na placa e ver o resultado no monitor

Com a placa e o monitor já conectados (veja acima):

1. No Vivado, com o projeto já aberto, clique em **Run Synthesis**
2. Após a síntese concluir, clique em **Run Implementation**
3. Após a implementação, clique em **Generate Bitstream** e aguarde
4. Clique em **Open Hardware Manager** (aparece automaticamente ou pelo menu **Tools**)
5. Clique em **Open Target** → **Auto Connect** — o Vivado detecta a Basys 3
6. Clique em **Program Device** → selecione o arquivo `top_nrz_i_basys3.bit` → clique em **Program**

Após a gravação, o monitor exibirá imediatamente a primeira cor correspondente ao bit SW15.

### O que observar na placa e no monitor

**No monitor:**

A tela exibe uma cor sólida para cada bit da sequência, alternando a cada 2 segundos:

| Bit (SW) | Nível NRZ-I | Cor da tela |
|:-:|:-:|:-:|
| Inverte o nível | Alto (`1`) | Azul inteiro |
| Mantém o nível | Baixo (`0`) | Vermelho inteiro |

A sequência percorre os 16 bits de SW15 a SW0, levando 32 segundos no total, e então reinicia do SW15.

**Nos LEDs da placa:**

Os LEDs LD15 a LD0 espelham diretamente os switches correspondentes (lógica combinacional), funcionando independentemente da saída VGA.

**Nos switches:**

Altere os switches antes ou durante a exibição para mudar a sequência. A mudança tem efeito na próxima vez que o ciclo reiniciar a partir do SW15.

## Recriar o projeto Vivado

O projeto não está versionado como `.xpr` para evitar dependências de caminho absoluto. O script Tcl reconstrói tudo a partir dos arquivos-fonte, com caminhos relativos, funcionando em qualquer máquina.

### Passo a passo no Tcl Console

**1. Abra o Vivado**

Inicie o Vivado normalmente. Não é necessário abrir nenhum projeto — o script cria tudo do zero.

**2. Abra o Tcl Console**

No menu superior, clique em **View → Tcl Console**. O painel abre na parte inferior da janela. Se o Vivado já tiver um projeto aberto, o console aparece automaticamente como aba na barra inferior.

**3. Navegue até a pasta `vivado_project/`**

Na linha de entrada do Tcl Console, digite o comando `cd` com o caminho completo da pasta `vivado_project/` deste subprojeto. Use **chaves** `{ }` para delimitar o caminho:

```tcl
cd {C:/caminho/para/nrz_i/extras/VGA/vivado_project}
```

> **Atenção:** use sempre barras para frente `/` no caminho, nunca barras invertidas `\`. O Tcl não reconhece `\` como separador de diretório e o comando falha silenciosamente ou com erro de parsing. Mesmo no Windows, o caminho deve ser escrito com `/`.

Exemplo correto:
```tcl
cd {C:/Users/aluno/projetos/nrz_i/extras/VGA/vivado_project}
```

Exemplo incorreto (não use):
```tcl
cd {C:\Users\aluno\projetos\nrz_i\extras\VGA\vivado_project}
```

**4. Confirme que está no diretório correto**

```tcl
pwd
```

O console deve retornar um caminho terminando em `.../VGA/vivado_project`. Se retornar outro caminho, repita o passo 3 com o caminho correto.

**5. Execute o script**

```tcl
source create_project.tcl
```

Aguarde até aparecer a confirmação:

```
======================================================================
 Projeto NRZ_I_VGA criado com sucesso!
======================================================================
```

O projeto abre automaticamente no Vivado. A partir daí, siga os passos da seção anterior para simular ou gravar na placa.

### Problemas comuns

| Erro | Causa | Solução |
|---|---|---|
| `couldn't open "create_project.tcl"` | O `cd` foi feito no diretório errado | Verifique com `pwd` e refaça o `cd` apontando para `VGA/vivado_project/` |
| Caminho não reconhecido ou erro de parsing | Barras invertidas `\` no caminho | Substitua todas as `\` por `/` no comando `cd` |
| `Part not found` | Device family Artix-7 não instalado | Reinstale o Vivado incluindo o suporte a **7 Series** |
| Monitor sem sinal após gravar | Cabo VGA solto ou monitor na entrada errada | Verifique a conexão física e a seleção de entrada no monitor |
| Tela preta após gravar | Monitor ligado depois da gravação | Grave novamente com o monitor já ligado e na entrada VGA |

## Ajuste de velocidade

A constante `CYCLES_PER_BIT` no `top_nrz_i_basys3.vhd` controla a duração de cada bit na tela. Para alterar, edite o valor no arquivo antes de recompilar:

| CYCLES_PER_BIT | Duração por bit | Sequência completa (16 bits) |
|:-:|:-:|:-:|
| 100.000.000 | 1 s | 16 s |
| 200.000.000 | 2 s | 32 s |
| 500.000.000 | 5 s | 80 s |

## Temporização VGA

O gerador de sincronismo segue o padrão VGA 640x480 @ ~60 Hz:

| Parâmetro | Horizontal | Vertical |
|:-:|:-:|:-:|
| Área visível | 640 px | 480 linhas |
| Front porch | 16 px | 10 linhas |
| Sync pulse | 96 px | 2 linhas |
| Back porch | 48 px | 33 linhas |
| Total | 800 px | 525 linhas |

O clock de pixel (~25 MHz) é obtido dividindo o clock da Basys 3 (100 MHz) por 4.

---

Dúvidas sobre os pinos VGA da Basys 3: consulte o [Basys 3 Reference Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual) na seção VGA Port.
