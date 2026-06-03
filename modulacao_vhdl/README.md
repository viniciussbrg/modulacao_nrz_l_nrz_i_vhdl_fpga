# Modulação Digital em VHDL — NRZ-L e NRZ-I

Trabalho da disciplina Comunicação de Dados — Sistemas Reconfiguráveis, ministrada pelo professor Vinicius S. Borges. Engenharia de Computação, FESA. 1º semestre de 2026.

## Integrantes

- Caio Alexandre Rossi — 081230013
- Caio S. A. de Araújo — 081230014

## Sobre o trabalho

A proposta foi implementar, em VHDL, dois esquemas clássicos de modulação digital: o Unipolar NRZ-L e o Unipolar NRZ-I. Cada um foi desenvolvido como um projeto separado no Vivado, com seu próprio source, testbench e arquivo de constraints.

O fluxo seguido foi: escrever o código, simular no Vivado Simulator para validar o comportamento e, depois, sintetizar e gravar na placa Basys 3 para ver o circuito funcionando de verdade. Os switches da placa servem como entrada de bits e o LED como saída modulada.

## Estrutura do repositório

```
modulacao_vhdl/
├── nrz_l/                projeto da modulação NRZ-L (auto-contido)
├── nrz_i/                projeto da modulação NRZ-I (auto-contido)
└── relatorio_final/      relatório técnico consolidado
```

Cada projeto é independente — tem seu próprio código, documentação e tutoriais dentro de uma pasta `docs/`. A ideia é que alguém consiga rodar um sem precisar do outro.

## Projetos

- [Modulação NRZ-L](./nrz_l/) — o bit é representado diretamente pelo nível do pulso (1 = nível alto, 0 = nível baixo).
- [Modulação NRZ-I](./nrz_i/) — o bit é representado pela transição (1 = inverte o nível anterior, 0 = mantém).

## Relatório

- [Relatório técnico final](./relatorio_final/relatorio.pdf)

## Ferramentas

- Vivado 2025.2
- Placa Digilent Basys 3 (Artix-7 xc7a35tcpg236-1)

## Por onde começar

A sugestão é abrir o projeto NRZ-L primeiro, porque ele é mais simples e dá uma base para entender o NRZ-I depois. Entre na pasta [nrz_l/](./nrz_l/) e siga o README de lá.

## Atividades extras

Os extras opcionais (saída pelo PMOD para osciloscópio e saída VGA) não foram implementados neste trabalho.
