.data
prompt_row:     .asciiz "Escolha a linha (1-3): "
prompt_col:     .asciiz "Escolha a coluna (1-3): "
invalid_pos:    .asciiz "Posicao invalida ou ocupada. Tente novamente.\n"
player_turn:    .asciiz "\nSua jogada (X)\n"
cpu_turn:       .asciiz "\nVez da CPU (O)...\n"
winner_player:  .asciiz "\nVOCE venceu! Parabens.\n"
winner_cpu:     .asciiz "\nCPU venceu. Boa sorte na proxima.\n"
draw_msg:       .asciiz "\nEmpate!\n"
board_header:   .asciiz "\nTabuleiro:\n"
newline:        .asciiz "\n"
X_char:         .asciiz " X "
O_char:         .asciiz " O "
dot_char:       .asciiz "   "
sep:            .asciiz " | "
line_sep:       .asciiz "-----------\n"

# Tabuleiro (inicialmente zeros) - 9 bytes (0 = vazio, 1 = X jogador, 2 = O CPU)
board:          .byte 0,0,0, 0,0,0, 0,0,0

# Linhas vencedoras (8 linhas * 3 indices)
winning_lines: .byte 0,1,2, 3,4,5, 6,7,8, 0,3,6, 1,4,7, 2,5,8, 0,4,8, 2,4,6

        .text
        .globl main

main:
    la $s0, board           # $s0 = endereço fixo do tabuleiro
    li $s1, 0               # $s1 = contador de turnos (0 = jogador começa)

game_loop:
    jal print_board

    # checa vencedor/empate -> retorna em $v0
    jal check_winner
    move $t0, $v0           # $t0: 0 nenhum, 1 jogador, 2 cpu, 3 empate
    beq $t0, $zero, continue_game

    # imprime resultado conforme $t0
    beq $t0, 1, print_player_winner
    beq $t0, 2, print_cpu_winner
    beq $t0, 3, print_draw

print_player_winner:
    la $a0, winner_player
    li $v0, 4
    syscall
    j end_program

print_cpu_winner:
    la $a0, winner_cpu
    li $v0, 4
    syscall
    j end_program

print_draw:
    la $a0, draw_msg
    li $v0, 4
    syscall
    j end_program

continue_game:
    # turno: 0 jogador, 1 CPU (alternando)
    andi $t1, $s1, 1
    beq $t1, $zero, player_turn_label

cpu_turn_label:
    la $a0, cpu_turn
    li $v0, 4
    syscall
    jal cpu_move
    addi $s1, $s1, 1
    j game_loop

player_turn_label:
    la $a0, player_turn
    li $v0, 4
    syscall
    jal player_move
    addi $s1, $s1, 1
    j game_loop

end_program:
    jal print_board
    li $v0, 10
    syscall

# ---------------------------
# print_board
# imprime o tabuleiro formatado
# ---------------------------
print_board:
    la $a0, board_header
    li $v0, 4
    syscall

    li $t0, 0               # índice base (0,3,6)
print_row_loop:
    # cell t0 (col 0)
    la $t1, board
    add $t1, $t1, $t0
    lb $t2, 0($t1)
    beq $t2, $zero, print_dot0
    li $t3, 1
    beq $t2, $t3, print_X0
    la $a0, O_char
    li $v0, 4
    syscall
    j after_cell0
print_X0:
    la $a0, X_char
    li $v0, 4
    syscall
    j after_cell0
print_dot0:
    la $a0, dot_char
    li $v0, 4
    syscall
after_cell0:
    la $a0, sep
    li $v0, 4
    syscall

    # cell t0+1 (col 1)
    la $t1, board
    addi $t1, $t1, 1
    add $t1, $t1, $t0
    lb $t2, 0($t1)
    beq $t2, $zero, print_dot1
    li $t3, 1
    beq $t2, $t3, print_X1
    la $a0, O_char
    li $v0, 4
    syscall
    j after_cell1
print_X1:
    la $a0, X_char
    li $v0, 4
    syscall
    j after_cell1
print_dot1:
    la $a0, dot_char
    li $v0, 4
    syscall
after_cell1:
    la $a0, sep
    li $v0, 4
    syscall

    # cell t0+2 (col 2)
    la $t1, board
    addi $t1, $t1, 2
    add $t1, $t1, $t0
    lb $t2, 0($t1)
    beq $t2, $zero, print_dot2
    li $t3, 1
    beq $t2, $t3, print_X2
    la $a0, O_char
    li $v0, 4
    syscall
    j after_cell2
print_X2:
    la $a0, X_char
    li $v0, 4
    syscall
    j after_cell2
print_dot2:
    la $a0, dot_char
    li $v0, 4
    syscall
after_cell2:

    # newline
    la $a0, newline
    li $v0, 4
    syscall

    # incrementa para próxima linha (3 células)
    addi $t0, $t0, 3
    li $t4, 9
    blt $t0, $t4, print_linesep_done
    j print_board_done

print_linesep_done:
    la $a0, line_sep
    li $v0, 4
    syscall
    li $t5, 9
    blt $t0, $t5, print_row_loop

print_board_done:
    jr $ra

# ---------------------------
# player_move
# lê entrada do jogador e valida
# ---------------------------
player_move:
read_row:
    la $a0, prompt_row
    li $v0, 4
    syscall
    li $v0, 5        # read int
    syscall
    move $t0, $v0    # t0 = row (1..3)
    blt $t0, 1, read_row
    bgt $t0, 3, read_row

read_col:
    la $a0, prompt_col
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t1, $v0    # t1 = col (1..3)
    blt $t1, 1, read_col
    bgt $t1, 3, read_col

    # convert to 0-based index
    addi $t0, $t0, -1    # row in $t0
    addi $t1, $t1, -1    # col in $t1
    # index = row*3 + col -> use sll to multiply by 3
    sll $t3, $t0, 1      # t3 = row * 2
    add $t3, $t3, $t0    # t3 = row * 3
    add $t3, $t3, $t1    # t3 = row*3 + col

    la $t4, board
    add $t4, $t4, $t3
    lb $t5, 0($t4)
    bne $t5, $zero, player_invalid
    # place player mark (1)
    li $t6, 1
    sb $t6, 0($t4)
    jr $ra

player_invalid:
    la $a0, invalid_pos
    li $v0, 4
    syscall
    j player_move

# ---------------------------
# cpu_move (CORRIGIDA: usa $s5, $s6, $s7, $t8, $t9)
# implementa a logica da CPU (ganhar, bloquear, centro, canto, lado)
# ---------------------------
cpu_move:
    # prólogo: salva $ra e $s2..$s7
    addi $sp, $sp, -32
    sw $ra, 28($sp)
    sw $s2, 0($sp)
    sw $s3, 4($sp)
    sw $s4, 8($sp)
    sw $s5, 12($sp) # $s5, $s6, $s7 são usados para lógica da CPU
    sw $s6, 16($sp)
    sw $s7, 20($sp)

    la $t0, winning_lines    # ponteiro para winning_lines
    li $t1, 8                # número de linhas
    li $t2, 0                # contador linhas
cpu_search_win:
    beq $t2, $t1, cpu_block_search
    # pega 3 indices da linha
    lb $t3, 0($t0)           # idx a
    lb $t4, 1($t0)           # idx b
    lb $t5, 2($t0)           # idx c

    # carrega valores do tabuleiro (valores 0/1/2)
    la $t6, board
    add $s2, $t6, $t3
    lb $s2, 0($s2)           # val a -> s2
    la $t7, board
    add $s3, $t7, $t4
    lb $s3, 0($s3)           # val b -> s3
    la $t8, board
    add $s4, $t8, $t5
    lb $s4, 0($s4)           # val c -> s4

    # contar quantos val == 2 (CPU)
    li $s5, 0               # $s5 = Contador de marcas 'O' (2)
    li $t9, 2               # $t9 = Valor 'O' (2)
    beq $s2, $t9, inc_w1
    j chk_w_b
inc_w1:
    addi $s5, $s5, 1
chk_w_b:
    beq $s3, $t9, inc_w2
    j chk_w_c
inc_w2:
    addi $s5, $s5, 1
chk_w_c:
    beq $s4, $t9, inc_w3
    j eval_win_cnt
inc_w3:
    addi $s5, $s5, 1

eval_win_cnt:
    li $t8, 2               # $t8 = Dois em linha (critério)
    bne $s5, $t8, next_line_win
    # se existem 2 O's e 1 vazio -> joga para vencer
    li $s6, 0               # $s6 = Valor 'Vazio' (0)
    beq $s2, $s6, put_move_a_win
    beq $s3, $s6, put_move_b_win
    beq $s4, $s6, put_move_c_win
    j next_line_win

put_move_a_win:
    la $s7, board           # $s7 é o novo $t16
    add $s7, $s7, $t3
    li $t9, 2
    sb $t9, 0($s7)
    j cpu_move_epilogue
put_move_b_win:
    la $s7, board
    add $s7, $s7, $t4
    li $t9, 2
    sb $t9, 0($s7)
    j cpu_move_epilogue
put_move_c_win:
    la $s7, board
    add $s7, $s7, $t5
    li $t9, 2
    sb $t9, 0($s7)
    j cpu_move_epilogue

next_line_win:
    addi $t0, $t0, 3
    addi $t2, $t2, 1
    j cpu_search_win

# ---------------------------
# cpu_block_search: procura bloquear jogador (1) (CORRIGIDA)
# ---------------------------
cpu_block_search:
    la $t0, winning_lines
    li $t1, 8
    li $t2, 0
cpu_search_block:
    beq $t2, $t1, cpu_center
    lb $t3, 0($t0)
    lb $t4, 1($t0)
    lb $t5, 2($t0)

    la $t6, board
    add $s2, $t6, $t3
    lb $s2, 0($s2)
    la $t7, board
    add $s3, $t7, $t4
    lb $s3, 0($s3)
    la $t8, board
    add $s4, $t8, $t5
    lb $s4, 0($s4)

    # contar quantos val == 1 (player)
    li $s5, 0               # $s5 = Contador de marcas 'X' (1)
    li $t9, 1               # $t9 = Valor 'X' (1)
    beq $s2, $t9, inc_b1
    j chk_b_b
inc_b1:
    addi $s5, $s5, 1
chk_b_b:
    beq $s3, $t9, inc_b2
    j chk_b_c
inc_b2:
    addi $s5, $s5, 1
chk_b_c:
    beq $s4, $t9, inc_b3
    j eval_blk_cnt
inc_b3:
    addi $s5, $s5, 1

eval_blk_cnt:
    li $t8, 2
    bne $s5, $t8, next_line_block
    # se existem 2 X e 1 vazio -> bloqueia
    li $s6, 0               # $s6 = Valor 'Vazio' (0)
    beq $s2, $s6, put_move_a_blk
    beq $s3, $s6, put_move_b_blk
    beq $s4, $s6, put_move_c_blk
    j next_line_block

put_move_a_blk:
    la $s7, board
    add $s7, $s7, $t3
    li $t9, 2
    sb $t9, 0($s7)
    j cpu_move_epilogue
put_move_b_blk:
    la $s7, board
    add $s7, $s7, $t4
    li $t9, 2
    sb $t9, 0($s7)
    j cpu_move_epilogue
put_move_c_blk:
    la $s7, board
    add $s7, $s7, $t5
    li $t9, 2
    sb $t9, 0($s7)
    j cpu_move_epilogue

next_line_block:
    addi $t0, $t0, 3
    addi $t2, $t2, 1
    j cpu_search_block

# ---------------------------
# cpu_center: tenta centro (índice 4)
# ---------------------------
cpu_center:
    la $t0, board
    addi $t0, $t0, 4
    lb $t1, 0($t0)
    beq $t1, $zero, cpu_take_center
    j cpu_take_corner

cpu_take_center:
    li $t2, 2
    sb $t2, 0($t0)
    j cpu_move_epilogue

# ---------------------------
# cpu_take_corner: tenta cantos (0,2,6,8)
# ---------------------------
cpu_take_corner:
    la $t0, board
    lb $t1, 0($t0)         # idx 0
    beq $t1, $zero, cpu_put_corner0
    lb $t2, 2($t0)         # idx 2
    beq $t2, $zero, cpu_put_corner2
    lb $t3, 6($t0)         # idx 6
    beq $t3, $zero, cpu_put_corner6
    lb $t4, 8($t0)         # idx 8
    beq $t4, $zero, cpu_put_corner8
    j cpu_take_side

cpu_put_corner0:
    li $t5, 2
    sb $t5, 0($t0)
    j cpu_move_epilogue
cpu_put_corner2:
    li $t5, 2
    sb $t5, 2($t0)
    j cpu_move_epilogue
cpu_put_corner6:
    li $t5, 2
    sb $t5, 6($t0)
    j cpu_move_epilogue
cpu_put_corner8:
    li $t5, 2
    sb $t5, 8($t0)
    j cpu_move_epilogue

# ---------------------------
# cpu_take_side: tenta laterais (1,3,5,7)
# ---------------------------
cpu_take_side:
    la $t0, board
    lb $t1, 1($t0)
    beq $t1, $zero, cpu_put_side1
    lb $t2, 3($t0)
    beq $t2, $zero, cpu_put_side3
    lb $t3, 5($t0)
    beq $t3, $zero, cpu_put_side5
    lb $t4, 7($t0)
    beq $t4, $zero, cpu_put_side7
    # se nada (teoricamente impossível), volta
    j cpu_move_epilogue

cpu_put_side1:
    li $t5, 2
    sb $t5, 1($t0)
    j cpu_move_epilogue
cpu_put_side3:
    li $t5, 2
    sb $t5, 3($t0)
    j cpu_move_epilogue
cpu_put_side5:
    li $t5, 2
    sb $t5, 5($t0)
    j cpu_move_epilogue
cpu_put_side7:
    li $t5, 2
    sb $t5, 7($t0)
    j cpu_move_epilogue

# epílogo da cpu_move: restaura regs e retorna
cpu_move_epilogue:
    lw $ra, 28($sp)
    lw $s2, 0($sp)
    lw $s3, 4($sp)
    lw $s4, 8($sp)
    lw $s5, 12($sp)
    lw $s6, 16($sp)
    lw $s7, 20($sp)
    addi $sp, $sp, 32
    jr $ra

# ---------------------------
# check_winner (REORGANIZADA para um epílogo único)
# Retorna em $v0: 0 = nenhum, 1 = jogador, 2 = cpu, 3 = empate
# ---------------------------
check_winner:
    # prólogo: salva $ra e $s2..$s7
    addi $sp, $sp, -32
    sw $ra, 28($sp)
    sw $s2, 0($sp)
    sw $s3, 4($sp)
    sw $s4, 8($sp)
    sw $s5, 12($sp)
    sw $s6, 16($sp)
    sw $s7, 20($sp)

    la $t0, winning_lines
    li $t1, 8
    li $t2, 0
check_winner_loop:
    beq $t2, $t1, check_draw
    lb $t3, 0($t0)
    lb $t4, 1($t0)
    lb $t5, 2($t0)
    la $t6, board
    add $s2, $t6, $t3
    lb $s2, 0($s2)
    la $t7, board
    add $s3, $t7, $t4
    lb $s3, 0($s3)
    la $t8, board
    add $s4, $t8, $t5
    lb $s4, 0($s4)

    # if s2 == s3 == s4 and not zero -> winner
    bne $s2, $s3, next_check_line
    bne $s2, $s4, next_check_line
    beq $s2, $zero, next_check_line
    # vencedor
    li $v0, 1
    li $t9, 2
    beq $s2, $t9, cpu_is_winner
    j winner_epilogue

cpu_is_winner:
    li $v0, 2
    j winner_epilogue

next_check_line:
    addi $t0, $t0, 3
    addi $t2, $t2, 1
    j check_winner_loop

check_draw:
    la $t0, board
    li $t1, 9
    li $t2, 0
check_draw_loop:
    beq $t2, $t1, is_draw
    lb $t3, 0($t0)
    beq $t3, $zero, no_winner_yet
    addi $t0, $t0, 1
    addi $t2, $t2, 1
    j check_draw_loop

no_winner_yet:
    li $v0, 0
    j winner_epilogue

is_draw:
    li $v0, 3
    j winner_epilogue

# Epílogo de check_winner: restaura regs e retorna
winner_epilogue:
    lw $ra, 28($sp)
    lw $s2, 0($sp)
    lw $s3, 4($sp)
    lw $s4, 8($sp)
    lw $s5, 12($sp)
    lw $s6, 16($sp)
    lw $s7, 20($sp)
    addi $sp, $sp, 32
    jr $ra