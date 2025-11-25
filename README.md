⭕❌ Jogo da Velha (Tic-Tac-Toe) em Assembly MIPS
Este repositório contém uma implementação completa do clássico Jogo da Velha desenvolvido em Assembly MIPS. O projeto foi criado como parte da avaliação da disciplina de Infraestrutura de Hardware e roda no simulador MARS.

O destaque deste projeto é a implementação de uma CPU Inteligente, que não joga aleatoriamente, mas segue uma heurística de prioridades para tentar vencer ou bloquear o jogador.

👥 Autores
Projeto desenvolvido pelos alunos da turma CC-A:

Luis Eduardo Bérard

Pablo José Cintra

João Victor Uchoa

Yan Nunes

🚀 Funcionalidades
Interface via Console: Tabuleiro desenhado em ASCII atualizado a cada jogada.

Validação de Entrada: O sistema impede jogadas em casas ocupadas ou coordenadas inválidas (fora do intervalo 1-3).

Detecção de Fim de Jogo: Verifica automaticamente vitórias (linhas, colunas, diagonais) ou empates (velha).

Inteligência Artificial (CPU): A CPU joga com base em uma lógica de prioridade:

Vencer: Se tiver 2 peças numa linha, completa a terceira.

Bloquear: Se o jogador tiver 2 peças numa linha, bloqueia a terceira.

Estratégia: Prioriza o centro, depois os cantos e por último as laterais.

🛠️ Tecnologias Utilizadas
Linguagem: Assembly MIPS (32-bit)

Simulador: MARS (MIPS Assembler and Runtime Simulator)

Arquitetura: Lógica baseada em registradores, chamadas de sistema (syscalls) e manipulação direta de memória (.data).

🎮 Como Executar
Para rodar este jogo, você precisará do simulador MARS instalado em sua máquina (requer Java).

Baixe o arquivo .asm deste repositório.

Abra o MARS.

Vá em File > Open e selecione o código.

Monte o código pressionando F3 (ou no menu Run > Assemble).

Execute o programa pressionando F5 (ou no menu Run > Go).

Controles
O jogo pedirá coordenadas para sua jogada. O tabuleiro é organizado em Linhas (1-3) e Colunas (1-3).

Exemplo de input:

Plaintext

Escolha a linha (1-3): 2
Escolha a coluna (1-3): 2
Isso marcará um X no centro do tabuleiro.

🧠 Detalhes da Implementação Técnica
Para fins de avaliação acadêmica, destacam-se os seguintes pontos do código:

Mapeamento de Memória: O tabuleiro é tratado como um array linear de 9 bytes (board), onde 0 é vazio, 1 é Jogador e 2 é CPU.

Lógica de Busca: A CPU utiliza um array de winning_lines (contendo os índices das 8 combinações de vitória possíveis) para iterar e calcular sua melhor jogada.

Gerenciamento de Pilha: As funções cpu_move e check_winner utilizam corretamente o ponteiro de pilha ($sp) para salvar registradores ($s0-$s7 e $ra), garantindo que o fluxo do programa não seja corrompido durante chamadas de sub-rotinas aninhadas.

📝 Licença
Este projeto é de uso educacional. Sinta-se à vontade para estudar o código e propor melhorias.
