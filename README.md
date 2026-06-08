# Modulação NRZ-L e NRZ-I em VHDL/FPGA

Trabalho prático da disciplina de **Comunicação de Dados - Sistemas Reconfiguráveis**.

O trabalho consiste em desenvolver, simular e implementar em FPGA, utilizando VHDL e o Vivado, dois sistemas de modulação digital:

- **Unipolar NRZ-L** — bit representado pelo nível do pulso
- **Unipolar NRZ-I** — bit representado pela transição do pulso

## Organização deste repositório

A branch `main` contém apenas o enunciado e o guia. Cada grupo terá uma **branch dedicada** com a entrega aprovada. A estrutura evolui ao longo do semestre:

### Estado inicial (semestre começando)

```
modulacao_nrz_l_nrz_i_vhdl_fpga/
└── main
    ├── README.md
    ├── enunciado.pdf
    └── guia_documentacao.pdf
```

### Durante o semestre (grupos entregando)

```
modulacao_nrz_l_nrz_i_vhdl_fpga/
├── main                  Enunciado e guia (não muda)
├── grupo1                Entrega do grupo 1
├── grupo2                Entrega do grupo 2
└── grupo3                Entrega do grupo 3
```

### Fim do semestre (todas as entregas consolidadas)

```
modulacao_nrz_l_nrz_i_vhdl_fpga/
├── main                  Enunciado e guia (sempre intocada)
├── grupo1                Entrega do grupo 1
├── grupo2                Entrega do grupo 2
├── grupo3                Entrega do grupo 3
├── ...
└── grupoN                Entrega do grupo N
```

**Como navegar entre as entregas:** clicar no seletor de branches (canto superior esquerdo, onde aparece `main`) e escolher a branch do grupo desejado.

## Documentos do trabalho

- [📄 Enunciado completo](./enunciado.pdf) — descrição do trabalho, requisitos e atividades extras
- [📘 Guia de documentação](./guia_documentacao.pdf) — orientação sobre READMEs, tutoriais, documentação técnica e relatório

**Leia os dois antes de começar.** O enunciado descreve *o que fazer*; o guia descreve *como organizar a entrega*.

## Como entregar (fluxo de fork)

A entrega é feita via **fork + Pull Request**. Resumidamente:

1. **Fazer fork** deste repositório (botão `Fork` no canto superior direito)
2. **Clonar o fork** na máquina de um dos integrantes
3. **Desenvolver o trabalho** no fork seguindo a estrutura sugerida
4. **Abrir um Pull Request** com o título no formato:
```
   Entrega - Grupo X - Nome dos integrantes
```
5. **Aguardar a revisão**. Após aprovado, o trabalho será incorporado como branch dedicada do grupo neste repositório

Os passos detalhados, com todos os comandos Git, estão no [enunciado](./enunciado.pdf).

## Estrutura esperada dentro do fork de cada grupo

```
modulacao_vhdl/
├── README.md
├── nrz_l/
│   ├── src/, sim/, constraints/, vivado_project/
│   ├── docs/      (tutoriais e documentação técnica)
│   └── extras/    (PMOD e VGA, opcionais)
├── nrz_i/         (mesma estrutura)
└── relatorio_final/
```

Detalhes completos no [guia de documentação](./guia_documentacao.pdf).

## Entregas dos grupos

Entregas aprovadas e incorporadas no repositório:

- [Grupo 1](../../tree/grupo1) — Edgar Camacho, Henrico Birochi, Nicholas Birochi, Vitor Braghttoni
- [Grupo 2](../../tree/grupo2) — Matheus Mitsuo, Nicolas Gomes Lima, Júlio César Caberlino, Alex Saifi, Felipe Medeiros
- [Grupo 3](../../tree/grupo3) — André Mendes, Felipe Lira, Pedro Henrique Simões, Vinicius Yamaguti
- [Grupo 4](../../tree/grupo4) — Alex Akio Nishimura Junior, Ana Marta Souza, Maria Eduarda Ferreira Bianchini, Pedro Henrique Rodrigues de Assis
- [Grupo 5](../../tree/grupo5) — Aline Cristina Ribeiro de Barros, Luis Gustavo de Oliveira Carneiro, Roger Rocha da Silva, João Victor Pereira Andrade, Samar Victor Vieira Souza
- [Grupo 6](../../tree/grupo6) — Gustavo Trindade Rodrigues, Lucas Barboza Silva, Victor Oliveira Malvão, Matheus Gonçalves Nunes
- [Grupo 7](../../tree/grupo7) — Arthur Destro, Gustavo Zaccheu, Gustavo Mauriz, Vinicius Strazzza, Vitor Barbosa
- [Grupo 8](../../tree/grupo8) — Henrique Alves Ferreira, Gabriel Melo Santos, Matheus da Silva Souza, Rafael Ruppert Barrocal
- [Grupo 9](../../tree/grupo9) — Caio Alexandre Rossi, Caio S. A. de Araújo

## Observações

- A implementação na placa é **obrigatória**
- As atividades extras (PMOD e VGA) são **opcionais** e somam pontuação adicional
- Dúvidas: abrir uma **Issue** neste repositório
