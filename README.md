# Modulação Digital NRZ-L e NRZ-I em VHDL

Trabalho prático da disciplina de **Comunicação de Dados e Sistemas Reconfiguráveis**, semestre 2025/1.

## Integrantes

- Alex Akio Nishimura Junior
- Ana Marta Souza
- Maria Eduarda Ferreira Bianchini 
- Pedro Henrique Rodrigues de Assis

## Descrição

Este repositório contém a implementação em VHDL de dois sistemas de modulação digital de linha: **Unipolar NRZ-L** (Non-Return-to-Zero Level) e **Unipolar NRZ-I** (Non-Return-to-Zero Inverted). Na NRZ-L, cada bit é representado diretamente pelo nível do sinal durante o intervalo (1 = alto, 0 = baixo). Na NRZ-I, o bit é representado pela presença ou ausência de uma transição no início do intervalo (1 = inverte o nível anterior, 0 = mantém).

Ambos os projetos foram simulados no Vivado Simulator (XSim), sintetizados e implementados na placa Basys 3 (Artix-7 XC7A35T-1CPG236C). Cada modulação possui um projeto principal com entrada via switches e saída via LEDs, além de duas atividades extras: saída serial pelo conector PMOD JA1 para visualização com o Analog Discovery 3 (WaveForms), e saída VGA 640x480 com representação por cores (azul para nível alto, vermelho para nível baixo).

## Estrutura do repositório

```
modulacao_nrz_l_nrz_i_vhdl_fpga/
├── nrz_l/                      Projeto da modulação NRZ-L (autocontido)
│   ├── src/                    Fontes VHDL (encoder + top-level)
│   ├── sim/                    Testbench e waveform config
│   ├── constraints/            Mapeamento de pinos (.xdc)
│   ├── vivado_project/         Script Tcl + bitstream
│   ├── extras/
│   │   ├── PMOD/               Saída serial pelo PMOD JA1
│   │   └── VGA/                Saída VGA com cores por nível
│   └── README.md
│
├── nrz_i/                      Projeto da modulação NRZ-I (autocontido)
│   ├── src/
│   ├── sim/
│   ├── constraints/
│   ├── vivado_project/
│   ├── extras/
│   │   ├── PMOD/
│   │   └── VGA/
│   └── README.md
│
├── relatorio_final/            Manuais e documentação técnica
│   ├── Manual Modulações.pdf
│   ├── Manual Analog Discovery.pdf
│   └── Manual Saida VGA.pdf
│
├── enunciado.pdf               Enunciado original do trabalho
├── guia_documentacao.pdf       Guia de organização da entrega
└── README.md
```

Cada projeto (NRZ-L e NRZ-I) é autocontido: possui seus próprios fontes, testbench, constraints, script Tcl para recriar o projeto no Vivado, e bitstream já compilado. Os extras PMOD e VGA dentro de cada projeto seguem a mesma estrutura e são igualmente independentes.

## Projetos

- [**Modulação NRZ-L**](./nrz_l/) — bit representado pelo nível do pulso (1 = alto, 0 = baixo)
- [**Modulação NRZ-I**](./nrz_i/) — bit representado pela transição do pulso (1 = inverte, 0 = mantém)

## Documentação

- [Manual das Modulações](./relatorio_final/Manual%20Modula%C3%A7%C3%B5es.pdf) — descrição técnica das codificações NRZ-L e NRZ-I, resultados de simulação e implementação
- [Manual do Analog Discovery](./relatorio_final/Manual%20Analog%20Discovery.pdf) — procedimento de conexão PMOD e captura de forma de onda com o WaveForms
- [Manual da Saída VGA](./relatorio_final/Manual%20Saida%20VGA.pdf) — detalhamento do gerador de sincronismo VGA e visualização por cores

## Ferramentas utilizadas

- **Vivado 2025.2** — síntese, implementação, simulação (XSim) e geração de bitstream
- **Basys 3** — placa FPGA com Artix-7 XC7A35T-1CPG236C
- **Analog Discovery 3 + WaveForms** — captura de forma de onda via PMOD (atividade extra)
- **Monitor VGA** — visualização da modulação por cores (atividade extra)

## Como começar

Recomenda-se iniciar pelo projeto NRZ-L, por ser a codificação mais direta. Acesse a pasta [nrz_l/](./nrz_l/) e siga o README local, que explica como recriar o projeto no Vivado, simular e gravar na placa. Em seguida, avance para o [nrz_i/](./nrz_i/) e compare as diferenças na lógica de codificação.

Para recriar qualquer projeto no Vivado, basta navegar até a pasta `vivado_project/` correspondente e executar `source create_project.tcl` no Tcl Console. Nenhum `.xpr` está versionado; os scripts Tcl geram o projeto com caminhos relativos, funcionando em qualquer máquina.
