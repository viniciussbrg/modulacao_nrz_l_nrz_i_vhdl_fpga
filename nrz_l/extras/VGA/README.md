# VGA — Saída NRZ-L com visualização em monitor

Variante do projeto NRZ-L principal que adiciona saída **VGA 640x480 @ 60 Hz** pela Basys 3, exibindo o nível modulado atual como cor de tela inteira: **azul para nível alto (bit '1')**, **vermelho para nível baixo (bit '0')**. Cada bit permanece na tela por 2 segundos, percorrendo a sequência completa de 16 bits em 32 segundos antes de reiniciar.

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

Este subprojeto modifica dois arquivos do projeto base (`nrz_l/`):

- **`src/top_nrz_l_basys3.vhd`** — Inclui entrada de clock (`clk` a 100 MHz), portas VGA (`vgaRed`, `vgaGreen`, `vgaBlue`, `Hsync`, `Vsync`), gerador de sincronismo VGA com divisor de clock por 4 (100 MHz para ~25 MHz), e serialização temporizada dos 16 bits com `CYCLES_PER_BIT` = 200.000.000 (2 segundos por bit). Na NRZ-L a saída é direta: `nrz_out_reg <= sw(bit_index)`
- **`constraints/basys3_nrz_l.xdc`** — Adiciona ao constraint base o mapeamento do clock (W5), dos 12 pinos de cor VGA (4 bits por canal: R, G, B), e dos sinais de sincronismo Hsync (P19) e Vsync (R19)

O arquivo `src/nrz_l.vhd` e o testbench `sim/tb_nrz_l.vhd` são idênticos aos do projeto principal.

## Arquivos de código

- **`src/nrz_l.vhd`** — Encoder NRZ-L com FSM (idêntico ao projeto principal)
- **`src/top_nrz_l_basys3.vhd`** — Top-level com LEDs espelhando switches, gerador VGA e serialização temporizada com troca de cor a cada 2 segundos
- **`sim/tb_nrz_l.vhd`** — Testbench do encoder (idêntico ao projeto principal)
- **`constraints/basys3_nrz_l.xdc`** — Mapeamento de `sw[15:0]`, `led[15:0]`, `clk`, pinos VGA e sincronismo

## Como usar

### Recriar o projeto no Vivado

```tcl
cd {C:/caminho/para/nrz_l/extras/VGA/vivado_project}
source create_project.tcl
```

### Conexão VGA

1. Conecte um monitor ao conector VGA da Basys 3 com um cabo VGA
2. Grave o bitstream na placa (`Program Device`)
3. Ajuste os switches SW15 a SW0 para definir a sequência de entrada
4. Observe a tela alternar entre azul (bit '1', nível alto) e vermelho (bit '0', nível baixo) a cada 2 segundos, percorrendo os 16 bits do MSB ao LSB

### Mapa de cores

| Bit | Nível modulado | Cor da tela | Componentes RGB |
|:-:|:-:|:-:|:-:|
| 1 | Alto | Azul | R=0000 G=0000 B=1111 |
| 0 | Baixo | Vermelho | R=1111 G=0000 B=0000 |

### Ajuste de velocidade

A constante `CYCLES_PER_BIT` no `top_nrz_l_basys3.vhd` controla a duração de cada bit na tela:

| CYCLES_PER_BIT | Duração por bit | Sequência completa (16 bits) |
|:-:|:-:|:-:|
| 100.000.000 | 1 s | 16 s |
| 200.000.000 | 2 s | 32 s |
| 500.000.000 | 5 s | 80 s |

---

Dúvidas sobre os pinos VGA da Basys 3: consulte o [Basys 3 Reference Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual) na seção VGA Port.
