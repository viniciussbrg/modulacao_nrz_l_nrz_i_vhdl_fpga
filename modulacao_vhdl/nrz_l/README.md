# Modulação NRZ-L

Implementação em VHDL da modulação Unipolar NRZ-L (Non-Return-to-Zero Level). É a forma mais direta de modulação: o nível do sinal de saída espelha o bit atual — bit 1 vira nível alto e bit 0 vira nível baixo. Cada bit ocupa um intervalo fixo de tempo, definido pelo número de ciclos de clock.

## Estrutura desta pasta

```
nrz_l/
├── src/                  código-fonte do circuito
├── sim/                  testbench para simulação
├── constraints/          mapeamento dos pinos da Basys 3
├── vivado_project/       projeto Vivado pronto para abrir
└── docs/                 tutoriais e documentação técnica
```

## Arquivos de código

- `src/nrz_l.vhd` — circuito principal da modulação NRZ-L
- `sim/tb_nrz_l.vhd` — testbench que aplica a sequência de bits e simula o circuito
- `constraints/basys3_nrz_l.xdc` — pinos da Basys 3 (switches, LEDs, botão, clock)

## Documentação

Tudo o que precisa para entender e reproduzir o projeto está em `docs/`:

- [Tutorial de simulação](./docs/tutorial_simulacao.pdf) — passo a passo para rodar a simulação no Vivado.
- [Tutorial de gravação na placa](./docs/tutorial_placa.pdf) — passo a passo para sintetizar, gerar o bitstream e gravar na FPGA.
- [Documentação técnica](./docs/documentacao_projeto.pdf) — descrição interna do circuito, portas, sinais e funcionamento.

## Por onde começar

Para abrir o projeto rapidamente no Vivado e só ver a simulação rodando:

1. Abra o Vivado e carregue `vivado_project/nrz_l_modulacao.xpr`.
2. No painel Flow Navigator, clique em `Run Simulation` → `Run Behavioral Simulation`.

Para entender o projeto de ponta a ponta e reproduzir do zero, a ordem recomendada é:

1. Ler a [documentação técnica](./docs/documentacao_projeto.pdf) para entender o que o circuito faz.
2. Seguir o [tutorial de simulação](./docs/tutorial_simulacao.pdf) para rodar no Vivado Simulator.
3. Seguir o [tutorial de gravação](./docs/tutorial_placa.pdf) para colocar o circuito na placa.

## Extras

Os extras opcionais (saída pelo PMOD e saída VGA) não foram implementados neste projeto.

## Próximo passo

Quando terminar com o NRZ-L, vá para a [Modulação NRZ-I](../nrz_i/). É o segundo projeto do trabalho e implementa a outra versão estudada — a comparação entre as duas modulações fica mais clara depois de ver os dois funcionando.
