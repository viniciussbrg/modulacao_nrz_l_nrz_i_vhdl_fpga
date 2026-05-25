# PMOD — Saída NRZ-L para Analog Discovery

Variante do projeto NRZ-L principal que adiciona saída serial pelo conector **PMOD JA1** da Basys 3, permitindo visualizar a forma de onda modulada em tempo real com o **Analog Discovery 3** (ou qualquer osciloscópio conectado ao pino).

## Estrutura desta pasta

```
PMOD/
├── src/                Código-fonte VHDL
├── sim/                Testbench e configuração de waveform
├── constraints/        Mapeamento de pinos (.xdc) com PMOD JA1
├── vivado_project/     Script Tcl para recriar o projeto e bitstream
└── docs/               Documentação adicional (esquemáticos, capturas)
```

## Diferenças em relação ao projeto principal

Este subprojeto modifica dois arquivos do projeto base (`nrz_l/`):

- **`src/top_nrz_l_basys3.vhd`** — Agora inclui entrada de clock (`clk` a 100 MHz), porta de saída `pmod_ja1`, e um processo síncrono que serializa os valores dos 16 switches um por vez pelo PMOD, emitindo diretamente `sw(bit_index)` como nível de saída (NRZ-L puro). Temporização configurável via `CYCLES_PER_BIT` (padrão: 2.000.000 ciclos = 20 ms por bit, 320 ms por sequência completa)
- **`constraints/basys3_nrz_l.xdc`** — Adiciona o mapeamento do clock da Basys 3 (W5, 100 MHz) e do pino PMOD JA1 (J1) ao constraint original de switches e LEDs

O arquivo `src/nrz_l.vhd` e o testbench `sim/tb_nrz_l.vhd` são idênticos aos do projeto principal.

## Arquivos de código

- **`src/nrz_l.vhd`** — Encoder NRZ-L com FSM (idêntico ao projeto principal)
- **`src/top_nrz_l_basys3.vhd`** — Top-level com `led <= sw` para os LEDs e serialização síncrona para o PMOD JA1
- **`sim/tb_nrz_l.vhd`** — Testbench do encoder (idêntico ao projeto principal)
- **`constraints/basys3_nrz_l.xdc`** — Mapeamento de `sw[15:0]`, `led[15:0]`, `clk` e `pmod_ja1`

## Como usar

### Recriar o projeto no Vivado

```tcl
cd {C:/caminho/para/nrz_l/extras/PMOD/vivado_project}
source create_project.tcl
```

### Conexão com o Analog Discovery 3

1. Conecte o canal 1+ (fio laranja) do Analog Discovery ao pino **JA1** do conector PMOD da Basys 3
2. Conecte o GND (fio preto) ao GND do PMOD
3. No **WaveForms**, abra o **Scope** e configure:
   - Time base: ~50 ms/div para visualizar a sequência completa
   - Trigger: borda de subida no canal 1
4. Grave o bitstream na placa e ajuste os switches para definir a entrada

### Ajuste de velocidade

A constante `CYCLES_PER_BIT` no `top_nrz_l_basys3.vhd` controla a duração de cada bit na saída serial:

| CYCLES_PER_BIT | Duração por bit | Sequência completa (16 bits) |
|:-:|:-:|:-:|
| 1.000.000 | 10 ms | 160 ms |
| 2.000.000 | 20 ms | 320 ms |
| 5.000.000 | 50 ms | 800 ms |

---

Dúvidas sobre o mapeamento de pinos PMOD: consulte o [Basys 3 Reference Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual) na seção Pmod Connectors.
