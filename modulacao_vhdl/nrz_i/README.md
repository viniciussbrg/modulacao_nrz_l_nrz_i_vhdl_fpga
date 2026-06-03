# Modulação NRZ-I

Implementação em VHDL da modulação Unipolar NRZ-I (Non-Return-to-Zero Inverted). Diferente do NRZ-L, aqui o bit não é representado pelo nível do sinal e sim pela transição: cada bit 1 inverte o nível anterior e cada bit 0 mantém o nível. A informação está, portanto, na mudança — não no valor absoluto.

## Estrutura desta pasta

```
nrz_i/
├── src/                  código-fonte do circuito
├── sim/                  testbench para simulação
├── constraints/          mapeamento dos pinos da Basys 3
├── vivado_project/       projeto Vivado pronto para abrir
└── docs/                 tutoriais e documentação técnica
```

## Arquivos de código

- `src/nrz_i.vhd` — circuito principal da modulação NRZ-I
- `sim/tb_nrz_i.vhd` — testbench que aplica a sequência de bits e simula o circuito
- `constraints/basys3_nrz_i.xdc` — pinos da Basys 3 (switches, LEDs, botão, clock)

## Documentação

Tudo o que precisa para entender e reproduzir o projeto está em `docs/`:

- [Tutorial de simulação](./docs/tutorial_simulacao.pdf) — passo a passo para rodar a simulação no Vivado.
- [Tutorial de gravação na placa](./docs/tutorial_placa.pdf) — passo a passo para sintetizar, gerar o bitstream e gravar na FPGA.
- [Documentação técnica](./docs/documentacao_projeto.pdf) — descrição interna do circuito, portas, sinais e funcionamento.

## Por onde começar

Para abrir o projeto rapidamente no Vivado e só ver a simulação rodando:

1. Abra o Vivado e carregue `vivado_project/nrz_i_modulacao.xpr`.
2. No painel Flow Navigator, clique em `Run Simulation` → `Run Behavioral Simulation`.

Para entender o projeto de ponta a ponta e reproduzir do zero, a ordem recomendada é:

1. Ler a [documentação técnica](./docs/documentacao_projeto.pdf) para entender o que o circuito faz.
2. Comparar com o [projeto NRZ-L](../nrz_l/) — a estrutura é parecida, mas a lógica de saída muda completamente. Vale a pena olhar os dois códigos lado a lado.
3. Seguir o [tutorial de simulação](./docs/tutorial_simulacao.pdf) para rodar no Vivado Simulator.
4. Seguir o [tutorial de gravação](./docs/tutorial_placa.pdf) para colocar o circuito na placa.

## Extras

Os extras opcionais (saída pelo PMOD e saída VGA) não foram implementados neste projeto.

## Próximo passo

Você concluiu os dois projetos do trabalho. Agora vale a pena conferir o [Relatório técnico final](../relatorio_final/relatorio.pdf), onde estão a análise comparativa entre NRZ-L e NRZ-I, os resultados das simulações e as conclusões do grupo.
