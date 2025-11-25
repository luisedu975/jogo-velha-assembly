# 🎮 Jogo da Velha em Assembly (MIPS)

Este projeto implementa um **Jogo da Velha (Tic-Tac-Toe)** em **Assembly MIPS**, permitindo que o jogador enfrente uma CPU com lógica estratégica para tomada de decisões.

---

## 📌 Visão Geral

* O jogador utiliza o símbolo **X**.
* A CPU utiliza o símbolo **O**.
* O jogo ocorre em um tabuleiro 3x3.
* O jogador sempre inicia a partida.
* A CPU possui lógica inteligente, priorizando:

  1. Vitória imediata
  2. Bloqueio do jogador
  3. Centro do tabuleiro
  4. Cantos
  5. Laterais

---

## 🧠 Lógica da CPU

A função `cpu_move` segue a seguinte ordem de prioridade:

1. Verificar se há possibilidade de vitória (2 O's e 1 espaço vazio)
2. Bloquear jogadas do jogador (2 X's e 1 espaço vazio)
3. Jogar no centro (posição 4)
4. Jogar em um dos cantos (0, 2, 6, 8)
5. Jogar nas laterais (1, 3, 5, 7)

Essa lógica garante que a CPU jogue de forma competitiva.

---

## 🗂 Estrutura de Dados

### Tabuleiro

Representado por um vetor de 9 bytes:

```
board: .byte 0,0,0, 0,0,0, 0,0,0
```

* `0` = vazio
* `1` = jogador (X)
* `2` = CPU (O)

### Linhas Vencedoras

```
winning_lines: .byte
  0,1,2, 3,4,5, 6,7,8,
  0,3,6, 1,4,7, 2,5,8,
  0,4,8, 2,4,6
```

Representa todas as combinações possíveis de vitória.

---

## ▶️ Como Executar

Este jogo pode ser executado em simuladores MIPS como:

* **MARS (MIPS Assembler and Runtime Simulator)**
* **QtSPIM**

### Passos:

1. Abra o simulador (MARS ou QtSPIM)
2. Carregue o arquivo `.asm`
3. Execute o programa
4. Informe a linha e coluna quando solicitado (valores entre 1 e 3)

---

## 🕹️ Como Jogar

Durante sua vez, será exibido:

```
Sua jogada (X)
Escolha a linha (1-3):
Escolha a coluna (1-3):
```

Se a posição for inválida ou já estiver ocupada, o programa exibirá:

```
Posicao invalida ou ocupada. Tente novamente.
```

O tabuleiro será impresso a cada jogada.

---

## ✅ Condições de Término

O jogo finaliza quando:

* O jogador vence → "VOCE venceu! Parabens."
* A CPU vence → "CPU venceu. Boa sorte na proxima."
* Empate → "Empate!"

---

## 📄 Exemplo de Tabuleiro

```
Tabuleiro:
 X  | O  | X
-----------
    | X  |  
-----------
 O  |    | O
```

---

## 🛠️ Funções Principais

| Função       | Descrição                       |
| ------------ | ------------------------------- |
| main         | Loop principal do jogo          |
| print_board  | Imprime o tabuleiro formatado   |
| player_move  | Lê e valida a jogada do jogador |
| cpu_move     | Implementa a IA da CPU          |
| check_winner | Verifica vitória ou empate      |

---

## 🚀 Possíveis Melhorias Futuras

* Interface gráfica
* Níveis de dificuldade
* Contagem de partidas
* Multiplayer local

---

## 👨‍💻 Autor

Desenvolvido por João Victor Uchôa, Pablo José Pellegrino, Luís Eduardo Bérard e Yan Ribeiro Nunes. Para a disciplina de Infraestrutura de Hardware da CESAR School. Um exercício de lógica e programação em baixo nível utilizando **Assembly MIPS**.

---

Se quiser, posso gerar um README em inglês ou adaptar para GitHub com badges e estrutura mais formal 📘
