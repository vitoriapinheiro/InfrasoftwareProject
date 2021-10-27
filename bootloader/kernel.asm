org 0x7e00
jmp 0x0000:start

data:
    ; dados da interface console
        texto_menu_console db 'SUPER ATARI', 0                  ; texto console
        texto_menu_pong db 'P - JOGAR PONG', 0                  ; texto jogar Pong console
        texto_menu_space db 'S - JOGAR SPACE INVADERS', 0       ; texto jogar Space Invaders console
        texto_menu_snake db 'T - JOGAR SNAKE', 0                ; texto jogar Snake console

    ; dados do Snake

    ; dados do Space Invaders =======================================================
        ; Variáveis de Vídeo -------- 320 * 200 = 64000 = 0FA00h

        space_sprites    equ 0FA00h
        alien1           equ 0FA00h
        alien2           equ 0FA04h  ; 4 bytes
        jogador          equ 0FA08h  ; 4 bytes
        barreiras_array  equ 0FA0Ch  ; 5 * 4 = 20 bytes
        aliens_array     equ 0FA20h  ; 4 bytes
        jogador_x        equ 0FA24h
        tiros_array      equ 0FA25h  ; 4 * 2(coordenadas) = 8 bytes. 2 Primeiros Byte = Tiro do jogador
        alien_y          equ 0FA2Dh+32
        alien_x          equ 0FA2Eh+32
        aliens_num       equ 0FA2Fh+32  ; Aliens vivos
        aliens_direcao   equ 0FA30h+32  ; Direção dos aliens
        move_timer       equ 0FA31h+32  ; Numero de Loops para que os aliens se movam
        muda_alien       equ 0FA33h+32  ; Muda o sprite do alien
        
        ; Outras variáveis ----------
        dist_barreiras   equ 0FA34h+32 
        num_barreiras    equ 0FA35h+32
        cur_moves        equ 0FA36h+32
        jogador_pt_tiro  equ 0FA37h+32
        ; Constantes ----------------
        TIMER            equ 046Ch ; Nº de ticks desde a meia-noite
        BARREIRA_X       equ 25
        BARREIRA_Y       equ 80
        JOGADOR_Y        equ 93
        LARGURA_TELA     equ 320
        ALTURA_TELA      equ 200
        ALTURA_SPRITE    equ 4
        LARGURA_SPRITE   equ 8       ; Largura em Bits
        LARGURA_SPRITE_P equ 16      ; Largura em Pixels
        DIST_BARREIRAS   equ 25
        
        ; Cores ---------------------
        COR_ALIEN       equ 02h
        COR_JOGADOR     equ 0Fh
        COR_TELA        equ 13h
        COR_BARREIRA    equ 06h
        COR_TIRO_ALIEN  equ 21h
        COR_TIRO_PLAYER equ 35h
        
        ; Textos -------------------
        space_texto_main_menu        db 'BEM-VINDO AO SPACE INVADERS' ,0
        space_instrucoes1            db 'DERROTE OS ALIENS', 0
        space_instrucoes2            db 'ANTES QUE ELES CHEGUEM ATE VOCE',0
        space_texto_jogar            db 'JOGAR - PRESSIONE S',0
        space_texto_sair_jogo        db 'SAIR - PRESSIONE N', 0
        space_texto_controle         db 'USE L_SHIFT/R_SHIFT PARA SE MOVER', 0
        space_texto_tiro             db 'ATIRE COM SPACE BAR', 0
        space_texto_reset            db 'RESET COM R', 0
        space_fases                  db 'BOA SORTE NAS 3 FASES!', 0
        space_fase1                  db 'FASE 1', 0
        space_fase2                  db 'FASE 2', 0 
        space_fase3                  db 'FASE 3', 0
        space_fim                    db 'GAME OVER',0
        space_parabens               db 'PARABENS!',0
    
    ; dados do Pong =================================================================
        ; dados de game status
        game_status db 1                                        ; game_status = 1 - jogando | game_status = 0 - nao ta jogando
        winner_status db 0                                      ; status do vencedor | 1 -> jogador 1, 2 -> jogador 2
        tela_atual db 0                                         ; Status da tela atual | 0-> menu, 1 -> jogo
        
        ; dados da tela
        tela_largura dw 140h                                    ; janela feita com al = 13h (320x200)
        tela_altura dw 0c8h     
        margem_erro dw 6                                        ; margem de erro para a bola não atravessar a tela

        ; dados do tempo
        tempo_aux dw 0                                          ; variável usado para checar se o tempo passou
        

        ; dados da interface 
        texto_jogador_um db '0'                                 ; texto da pontuação do jogador 1
        texto_jogador_dois db '0'                               ; texto da pontuação do jogador 2

        texto_game_over db 'GAME OVER', 0                       ; texto game over
        texto_vencedor_1 db 'PLAYER 1 VENCEU', 0                ; texto vencedor 1
        texto_vencedor_2 db 'PLAYER 2 VENCEU', 0                ; texto vencedor 2
        texto_restart db 'RESTART - pressione R', 0             ; texto restart
        texto_return_main_menu db 'MENU - pressione M', 0       ; texto retornar para o main menu
        
        texto_main_menu db 'MENU PRINCIPAL', 0                  ; texto main menu
        texto_jogar db 'JOGAR - pressione P', 0                 ; texto jogar
        texto_sair_jogo db 'Pressione E para sair de jogo', 0   ; texto sair do jogo
        texto_jogador_1 db 'JOGADOR 1', 0                       ; texto jogador 1
        texto_inst_jogador_1 db 'O/L move cima/baixo', 0        ; texto inst jogador 1
        texto_jogador_2 db 'JOGADOR 2', 0                       ; texto jogador 2
        texto_inst_jogador_2 db 'W/S move cima/baixo', 0        ; texto inst jogador 2
        
        ; dados da bola
        bola_size dw 5                                          ; tamanho da bola
        bola_cor db 15                                          ; cor da bola
    
        bola_origem_X dw 0A0h                                   ; posicao X original da bola (meio da tela)
        bola_origem_Y dw 064h                                   ; posição Y original da bola (meio da tela)
        bola_X dw 0A0h                                          ; posição X da bola
        bola_Y dw 064h                                          ; posição Y da bola
        bola_vel_X dw 06h                                       ; velocidade X da bola
        bola_vel_Y dw 03h                                       ; velocidade Y da bola


        ; dados das barras

        barra_esquerda_pontos db 0                              ; pontuação do primeiro jogador (esquerda)
        barra_esquerda_X dw 0Ah                                 ; posição X da barra esquerda
        barra_esquerda_Y dw 0Ah                                 ; posição Y da barra esquerda
        barra_esquerda_cor db 15

        barra_direita_pontos db 0                               ; pontuação do segundo jogador (direita)
        barra_direita_X dw 132h                                 ; posição X da barra direita
        barra_direita_Y dw 0A0h                                 ; posição Y da barra direita
        barra_direita_cor db 15

        barra_largura dw 5                                      ; largura da barra
        barra_altura dw 30                                      ; altura da barra
        barra_vel dw 06h                                        ; velocidade vertical da barra
    


; printa um objeto passando os parametros
; (coordX, coordY, largura, altura, cor)
%macro print_obj 5          
    .loop1:    
        .loop2:
            mov ah, 0Ch             ; escrevendo um pixel
            mov al, %5              ; escolhendo a cor (branca)
            mov bh, 00h             ; escolhendo a pagina
            int 10h

            inc cx
            mov ax, cx     
            sub ax, %1
            cmp ax, %3
            jne .loop2
        
        mov cx, %1
        inc dx
        mov ax, dx
        sub ax, %2
        cmp ax, %4
        jne .loop1

%endmacro

; printa uma string passando os parametros
; (linha, coluna, * string)
%macro print_string 3 
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, %1                      ; escolher a linha
    mov dl, %2                      ; escolher a coluna
    int 10h

    mov si, %3                      ; pega o texto 

    call prints                     ; print o texto
%endmacro
jogar_snake:
    mov al, 1
    mov [game_status], al
    xor al, al
    mov [tela_atual], al

    ; jmp snake_loop

jogar_pong:
    mov al, 1
    mov [game_status], al
    xor al, al
    mov [tela_atual], al

    jmp pong_loop

menu_console:
    call limpar_tela

    print_string 04h, 06h, texto_menu_console

    print_string 0Ah, 06h, texto_menu_pong

    print_string 0Ch, 06h, texto_menu_space

    print_string 0Eh, 06h, texto_menu_snake

    .espera_tecla:
        ; espera por um caracter
        mov ah, 00h
        int 16h          ; salva o caracter em al

        cmp al, 'p'
        je jogar_pong
        cmp al, 'P'
        je jogar_pong
        cmp al, 's'
        je prep_jogar_space
        cmp al, 'S'
        je prep_jogar_space

        jmp .espera_tecla


    jmp menu_console

reset_cor:
    mov al, 1
    mov [bola_cor], al
    ret

mudar_cor:
    mov al, [bola_cor]
    inc al
    mov [bola_cor], al

    mov ah, 16
    cmp [bola_cor], ah
    jge reset_cor

    ret

print_UI:
    ; desenhar os pontos do jogador esquerdo

    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 04h                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov ah, 0Eh                     ; escrever caracter
    mov al, [texto_jogador_um]      ; escolher caracter
    mov bl, [barra_esquerda_cor]    ; escolher cor (branco)
    int 10h

    ; desenhar os pontos do jogador direito

    mov ah, 02h                     ; escolher a posição do cursor
    mov dh, 04h                     ; escolher a linha
    mov dl, 21h                     ; escolher a coluna
    int 10h

    mov ah, 0Eh                     ; escrever caracter
    mov al, [texto_jogador_dois]    ; escolher caracter
    mov bl, [barra_direita_cor]     ; escolher cor (branco)
    int 10h

    ret

atualiza_texto_jogador_um:
    xor ax, ax
    mov al, [barra_esquerda_pontos]

    add al, 48
    mov [texto_jogador_um], al


    ret

atualiza_texto_jogador_dois:
    xor ax, ax
    mov al, [barra_direita_pontos]

    add al, 48
    mov [texto_jogador_dois], al

    ret


print_barra_direita:

    ; define as coordenadas iniciais da barra direita
    mov cx, [barra_direita_X]
    mov dx, [barra_direita_Y]

    ; desenha a barra direita
    print_obj [barra_direita_X], [barra_direita_Y], [barra_largura], [barra_altura], [barra_direita_cor]

    ret

print_barra_esquerda:

    ; define as coordenadas iniciais da barra esquerda
    mov cx, [barra_esquerda_X]
    mov dx, [barra_esquerda_Y]

    ; desenha a barra esquerda
    print_obj [barra_esquerda_X], [barra_esquerda_Y], [barra_largura], [barra_altura], [barra_esquerda_cor]

    ret

print_bola:
    ; define as coordenadas iniciais da bola
    mov cx, [bola_X]
    mov dx, [bola_Y]

    ; desenha a bola
    print_obj [bola_X], [bola_Y], [bola_size], [bola_size], [bola_cor]

    ret

prints:                ; print o texto de game over
        .loop:
            lodsb ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:
            ret

putchar:
    mov ah, 0x0e
    mov bh, 00h
    mov bl, 15
    int 10h
    ret

print_game_over_menu:
    call limpar_tela

    print_string 04h, 06h, texto_game_over          ; print texto game over


    ; mostra o vencedor     
    mov ah, 02h                                     ; escolher a posição do cursor
    mov bh, 00h                                     ; escolher a pagina
    mov dh, 06h                                     ; escolher a linha
    mov dl, 06h                                     ; escolher a coluna
    int 10h

    mov al, 01h                                     ; compara o status de vencedor
    cmp [winner_status], al
    je vencedor_um                                  ; se for 1 o jogador 1 venceu
    jne vencedor_dois                               ; se não, o jogador 2 venceu

    vencedor_um:
        mov si, texto_vencedor_1                    ; pega o texto de vencedor 1
        jmp print_vencedor
    vencedor_dois:
        mov si, texto_vencedor_2                    ; pega o texto de vencedor 2
        jmp print_vencedor

    print_vencedor:                                 ; print o texto de vencedor
        call prints
    
    print_string 08h, 06h, texto_restart            ; print texto restart

    print_string 0Ah, 06h, texto_return_main_menu   ; print texto return main menu  


    ; espera por um caracter
    mov ah, 00h
    int 16h             ; salva o caracter em al

    cmp al, 'r'
    je restart_game
    cmp al, 'R'
    je restart_game

    cmp al, 'm'
    je sair_para_menu
    cmp al, 'M'
    je sair_para_menu

    ret

    restart_game:
        mov al, 01h                                 
        mov [game_status], al                       ; game_status = 1 | retorna o jogo
        ret     

    sair_para_menu:
        mov al, 00h
        mov [game_status], al                       ; game_status = 0 | o jogo para
        mov [tela_atual], al 

    
print_main_menu:
    call limpar_tela

    print_string 04h, 06h, texto_main_menu          ; print texto main menu

    print_string 06h, 06h, texto_jogar              ; print texto jogar

    print_string 08h, 06h, texto_sair_jogo          ; print texto sair do jogo

    print_string 0Eh, 06h, texto_jogador_1          ; print texto jogador 1

    print_string 10h, 08h, texto_inst_jogador_1     ; print texto inst jogador 1
   
    print_string 12h, 06h, texto_jogador_2          ; print texto jogador 2

    print_string 14h, 08h, texto_inst_jogador_2     ; print texto int jogador 2


    .espera_tecla:
        ; espera por um caracter
        mov ah, 00h
        int 16h          ; salva o caracter em al

        cmp al, 'p'
        je jogar
        cmp al, 'P'
        je jogar

        cmp al, 'e'
        je end
        cmp al, 'E'
        je end

        jmp .espera_tecla


    jogar:
        mov al, 1
        mov [game_status], al
        mov [tela_atual], al
        ret

limpar_tela:
    ; chama o modo vídeo
    mov ah, 00h             ; set video mode
    mov al, 13h             ; escolhe o video mode
    int 10h                 ; executa

    ; chama o fundo preto
    mov ah, 0Bh             ; setando a configuracao
    mov bh, 00h             ; para a cor de fundo
    mov bl, 00h             ; escholhendo preto
    int 10h

    ret

inv_vel_X:
    ; inverte a velocidade em X
    mov ax, [bola_vel_X]
    neg ax
    mov [bola_vel_X], ax

    call mudar_cor

    ret


inv_vel_Y:
    ; inverte a velocidade em Y caso bata na parede
    mov ax, [bola_vel_Y]
    neg ax
    mov [bola_vel_Y], ax
    
    call mudar_cor

    ret

inv_vel_Y_gol:
    ; inverte a velocidade em Y caso haja gol
    mov ax, [bola_vel_Y]
    neg ax
    mov [bola_vel_Y], ax
    
    jmp pass

reset_bola:
    ; a bola volta para a posição X de origem
    mov ax, [bola_origem_X]
    mov [bola_X], ax

    ; a bola volta para a posicao Y de origem
    mov ax, [bola_origem_Y]
    mov [bola_Y], ax

    ; a barra esquerda volta para a posicao inicial
    mov ax, 0Ah
    mov [barra_esquerda_X], ax
    mov [barra_esquerda_Y], ax

    ; a barra direita volta para a posicao inicial
    mov ax, 132h
    mov [barra_direita_X], ax
    mov ax, 0A0h
    mov [barra_direita_Y], ax

    xor ax, ax
    cmp [bola_vel_X], ax    
    jl teste_inv_1  
    jg teste_inv_2          

; serve para o jogo reiniciar de modo que os jogadores sempre consigam pegar a primeira bola

; se V_X < 0 && V_Y < 0, inverte

    teste_inv_1:
        xor ax, ax 
        cmp [bola_vel_Y], ax
        jl inv_vel_Y_gol 
          
        jmp pass

; se V_X > 0 && V_Y > 0, inverte 
    teste_inv_2:
        xor ax, ax
        cmp [bola_vel_Y], ax
        jg inv_vel_Y_gol

        jmp pass

    pass:

    call inv_vel_X

    

    ret

pontuar_jogador_um:
    mov al, [barra_esquerda_pontos]                 ; pontua o jogador um 
    inc al
    mov [barra_esquerda_pontos], al

    call reset_bola                                 ; bola volta para o início

    call atualiza_texto_jogador_um                  ; Atualiza a pontuação na tela do jogador 1

    ; checa se o jogador dois fez 5 pontos
    mov al, [barra_esquerda_pontos]
    cmp al, 05h
    je game_over

    ret

pontuar_jogador_dois:
    mov al, [barra_direita_pontos]                  ; pontua jogador dois
    inc al
    mov [barra_direita_pontos], al
   
    call reset_bola                                 ; bola volta para o início

    call atualiza_texto_jogador_dois                ; Atualiza a pontuação na tela do jogador 2

    ; checa se o jogador dois fez 5 pontos
    mov al, [barra_direita_pontos]
    cmp al, 05h
    je game_over

    ret

game_over:                                          ; quando um jogador fizer 5 pontos
    mov al, 05h
    cmp [barra_esquerda_pontos], al                 ; se o jogador 1 fez 5 pontos
    je jogador_um_venceu                            ; o jogador 1 ganhou
    jne jogador_dois_venceu                         ; se não, o jogador 2 ganhou

    jogador_um_venceu:
        mov byte[winner_status], 01h                ; winner_status = 1
        jmp continua_game_over                      ; pula para o resto do game over
    jogador_dois_venceu:
        mov byte[winner_status], 02h                ; winner status = 2
        jmp continua_game_over                      ; pula para o resto do game over

    continua_game_over:    
        mov byte [barra_esquerda_pontos], 00h       ; zera os pontos do primeiro jogador
        mov byte [barra_direita_pontos], 00h        ; zera os pontos do segundo jogador

        call atualiza_texto_jogador_um              ; atualiza o texto do jogador 1
        call atualiza_texto_jogador_dois            ; atualiza o texto do jogador 2

        xor al, al
        mov [game_status], al                       ; game status = 0 -> o jogo acabou

    ret

mover_bola:
    ; movendo a bola em X
    mov ax, [bola_vel_X]    
    add [bola_X], ax

    ; se bola_X < margem_erro(6)
    ; entao, a bola volta para o inicio
    mov ax, [margem_erro]   
    cmp [bola_X], ax        
    jl pontuar_jogador_dois          


    ; se bola_X > (tela_largura - bola_size - margem de erro)
    ; entao, a bola volta para o inicio
    mov ax, [tela_largura]
    sub ax, [bola_size]
    sub ax, [margem_erro]
    cmp [bola_X], ax        
    jg pontuar_jogador_um      

    ; movendo a bola em Y                      
    mov ax, [bola_vel_Y]    
    add [bola_Y], ax

    ; se bola_Y < margem_erro 
    ; entao, inverte a velocidade Y
    mov ax, [margem_erro]
    cmp [bola_Y], ax        
    jl inv_vel_Y            

    ; se bola_Y > tela_largura - bola_size - margem_erro
    ; entao, inverte vel Y
    mov ax, [tela_altura]
    sub ax, [bola_size]
    sub ax, [margem_erro]
    cmp [bola_Y], ax
    jg inv_vel_Y       


    ; checa se a bola colide com a barra direita
    
    ; bola_x + bola_size > barra_direita_X
    mov ax, [bola_X]
    add ax, [bola_size]
    cmp ax, [barra_direita_X]
    jng check_colisao_barra_esquerda    ; se não tem colidao com a barra direta, checamos a barra esquerda

    ; bola_x < barra_direita_X + barra_largura 
    mov ax, [barra_direita_X]
    add ax, [barra_largura]
    cmp [bola_X], ax
    jnl check_colisao_barra_esquerda    ; se não tem colidao com a barra direta, checamos a barra esquerda

    ; bola_Y + bola_size > barra_direita_Y
    mov ax, [bola_Y]
    add ax, [bola_size]
    cmp ax, [barra_direita_Y]
    jng check_colisao_barra_esquerda    ; se não tem colidao com a barra direta, checamos a barra esquerda

    ; bola_Y < barra_direita_Y + barra_altura
    mov ax, [barra_direita_Y]
    add ax, [barra_altura]
    cmp [bola_Y], ax
    jnl check_colisao_barra_esquerda    ; se não tem colidao com a barra direta, checamos a barra esquerda

    ; se chegar até aqui, houve colisão com a barra direita
    ; inverte a velocidade da bola na direção X

    mov al, [bola_cor]                  ; muda a cor da barra direita
    mov [barra_direita_cor], al

    mov ax, [bola_vel_X]
    neg ax
    mov [bola_vel_X], ax

    ret

    check_colisao_barra_esquerda:
    ; checa se a bola colide com a barra esquerda   
    mov ax, [bola_X]
    add ax, [bola_size]
    cmp ax, [barra_esquerda_X]
    jng exit_check_colisao_barra        ; se não tem colidao com a barra direta, checamos a barra esquerda

    ; bola_x < barra_esquerda_X + barra_largura 
    mov ax, [barra_esquerda_X]
    add ax, [barra_largura]
    cmp [bola_X], ax
    jnl exit_check_colisao_barra        ; se não tem colidao com a barra direta, checamos a barra esquerda

    ; bola_Y + bola_size > barra_esquerda_Y
    mov ax, [bola_Y]
    add ax, [bola_size]
    cmp ax, [barra_esquerda_Y]
    jng exit_check_colisao_barra        ; se não tem colidao com a barra direta, checamos a barra esquerda

    ; bola_Y < barra_esquerda_Y + barra_altura
    mov ax, [barra_esquerda_Y]
    add ax, [barra_altura]
    cmp [bola_Y], ax
    jnl exit_check_colisao_barra        ; se não tem colidao com a barra direta, checamos a barra esquerda

    ; se chegar até aqui, houve colisão com a barra esquerda
    ; inverte a velocidade da bola na direção X

    mov al, [bola_cor]                  ; muda a cor da barra esquerda
    mov [barra_esquerda_cor], al

    mov ax, [bola_vel_X]
    neg ax
    mov [bola_vel_X], ax    

    ret     

    exit_check_colisao_barra:
                    
    ret   

mover_barras:               ; move as barras verticalmente
; barra esquerda

    ; checar de alguma tecla foi pressionada(se nao, checa a outra barra)
    mov ah, 01h
    int 16h
    jz check_mov_barra_direita      ; zf = 1 -> jz pula se for 1

    ; checar qual tecla foi pressionada (AL = ASCII character)
    mov ah, 00h
    int 16h

    ; se foi 'w' ou 'W' move para cima
    cmp al, 77h                     ; 'w'
    je mover_barra_esquerda_cima
    cmp al, 57h                     ; 'W'
    je mover_barra_esquerda_cima

    ; se foi 's' ou 'S' move para baixo  
    cmp al, 73h                     ; 's'
    je mover_barra_esquerda_baixo
    cmp al, 53h                     ; 'S'
    je mover_barra_esquerda_baixo

    jmp check_mov_barra_direita

    ret
    mover_barra_esquerda_cima:
        ; move a barra esquerda para cima
        mov ax, [barra_vel]
        sub [barra_esquerda_Y], ax

        ; checa se o movimento é valido
        mov ax, [margem_erro]
        cmp [barra_esquerda_Y], ax
        jl fix_barra_esquerda_cima
        jmp check_mov_barra_direita

        ret

        fix_barra_esquerda_cima:
            ; conserta o movimento caso não seja válido
            mov ax, [margem_erro]
            mov [barra_esquerda_Y], ax
            jmp check_mov_barra_direita

    mover_barra_esquerda_baixo:
        ; move a barra esquerda para baixo
        mov ax, [barra_vel]
        add [barra_esquerda_Y], ax

        ; checa se o movimento é valido
        mov ax, [tela_altura]
        sub ax, [margem_erro]
        sub ax, [barra_altura]
        cmp [barra_esquerda_Y], ax
        jg fix_barra_esquerda_baixo
        jmp check_mov_barra_direita


        ret
        fix_barra_esquerda_baixo:
            ; conserta o movimento caso não seja válido
            mov ax, [tela_altura]
            sub ax, [margem_erro]
            sub ax, [barra_altura]
            mov [barra_esquerda_Y], ax
            jmp check_mov_barra_direita

    
; barra direita
    check_mov_barra_direita:
        
        ; se foi 'o' ou 'O' move para cima
        cmp al, 6Fh                 ; 'o'
        je mover_barra_direita_cima
        cmp al, 4Fh                 ; 'O'
        je mover_barra_direita_cima

        ; se foi 'l' or 'L' move para baixo    
        cmp al, 6Ch                 ; 'l'
        je mover_barra_direita_baixo
        cmp al, 4Ch                 ; 'L'
        je mover_barra_direita_baixo


        jmp exit_mov_barra

        mover_barra_direita_cima:   
            ; move a barra direita para cima
            mov ax, [barra_vel]
            sub [barra_direita_Y], ax

            ; checa se o movimento é válido
            mov ax, [margem_erro]
            cmp [barra_direita_Y], ax
            jl fix_barra_direita_cima

            ret

        fix_barra_direita_cima:
            mov ax, [margem_erro]
            mov [barra_direita_Y], ax
             
            ret


        mover_barra_direita_baixo:  
            ; move a barra direita para baixo   
            mov ax, [barra_vel]
            add [barra_direita_Y], ax

            ; checa se o movimento é válido
            mov ax, [tela_altura]
            sub ax, [margem_erro]
            sub ax, [barra_altura]
            cmp [barra_direita_Y], ax
            jg fix_barra_direita_baixo

            ret

        fix_barra_direita_baixo:
            ; conserta o movimento caso não seja válido
            mov ax, [tela_altura]
            sub ax, [margem_erro]
            sub ax, [barra_altura]
            mov [barra_direita_Y], ax
            
            ret

    exit_mov_barra:
        ret

pong_loop:                     ; gera a sensação de movimento
        xor al , al

        cmp [tela_atual], al        ; se a tela atual for a de menu
        je mostra_main_menu         ; mostra o menu

        cmp [game_status], al       ; se o jogo acabar
        je mostra_game_over         ; mostra a tela de game over
        
        mov ah, 00h                 ; get system time
        int 1ah                     ; cx:dx = numero de ticks de clock desde a meia noite

        cmp dx, [tempo_aux]         ; verifica se o tempo passou (provavelmente 1/100 s)
        je pong_loop

        ; o tempo passou

        mov [tempo_aux], dx         ; atualiza o tempo

        call limpar_tela            ; da update na tela para nao deixar "rastro"
         
        call mover_bola             ; muda as coordenadas da bola      

        call print_bola             ; desenha a bola 

        call mover_barras           ; move e checa os movimentos validos das barras

        call print_barra_esquerda   ; desenha a barra direita

        call print_barra_direita    ; desenha a barra esquerda

        call print_UI

        jmp pong_loop 
    
        mostra_game_over:
            call print_game_over_menu
            jmp pong_loop
            
        mostra_main_menu:
            call print_main_menu
            jmp pong_loop
            
        end:                        
            ; Menu do console
            call menu_console

; Space Invaders ====================================================
; Talvez dê bug com o sp e o bp

%macro space_limpa_tela 0
    xor ax, ax
    mov al, COR_TELA
    xor di, di
    mov cx, LARGURA_TELA*ALTURA_TELA    ; Tamanho da tela
    rep stosb
%endmacro

%macro temporizador_delay 1
    mov ax, [CS:TIMER]  
    add ax, %1; Incremento em um segundo
    .wait:
        cmp [CS:TIMER], ax ; Checo se já se passou um segundo
        jl .wait
%endmacro

prep_jogar_space:
    push 1
jmp jogar_space

jogar_space: ; Prepara a tela para o jogo ---------------------------
    xor ax, ax
    xor bx, bx
    xor cx, cx
    mov ax, 0013h ; Modo de vídeo
    int 10h
    push 0A000h 
    pop es ; Movendo o ponteiro es para o primeiro pixel da tela

    pop ax
    push ax
    cmp ax, 1
    jle print_fase_1

    cmp ax, 2
    je print_fase_2

    cmp ax, 3
    je print_fase_3

    cmp ax, 4
    jge space_ganhou


    
    print_fase_1:

        call space_printa_menu
        cmp al, 1
        je start
        jmp continua_inic_space

    print_fase_2:
        space_limpa_tela
        print_string 0Ah, 11h, space_fase2
        temporizador_delay 30
        jmp continua_inic_space
    
    print_fase_3:
        space_limpa_tela
        print_string 0Ah, 11h, space_fase3
        temporizador_delay 30
        jmp continua_inic_space

    continua_inic_space:

    ; Movendo os sprites iniciais para a memória
    mov di, space_sprites
    mov si, space_sprites_bitmaps
    mov cl, 6
    rep movsw
    
    lodsd           ; Salva 5 barreiras na memoria 
    mov cl, 5
    rep stosd

    ;; Variáveis Iniciais
    mov cl, 5       ; Array de Aliens e X do Jogador
    rep movsb

    xor ax, ax      ; Array de Tiros
    mov cl, 20
    rep stosw

    mov cl, 10       ; Outras variaveis apos o array de tiros
    rep movsb

    push es
    pop ds          ; DS = ES

    pop ax

    cmp ax, 2
    je fase_2
    cmp ax, 3
    je fase_3

    volta_fases:
    push ax
    
    
jmp space_loop
space_passa_de_fase:
    pop cx
    jmp space_prox_fase

space_prox_fase:
    pop ax
    inc ax
    push ax
    xor ax,ax
    mov ds,ax
    jmp jogar_space

fase_2:
    mov byte [num_barreiras], 3
    mov byte [dist_barreiras], 50
    mov byte [move_timer], 15
jmp volta_fases

fase_3:
    mov byte [num_barreiras], 2
    mov byte [dist_barreiras], 100
    mov byte [move_timer], 12
jmp volta_fases

space_printa_menu:
    pusha
    space_limpa_tela                          

    print_string 02h, 07h, space_texto_main_menu
    print_string 07h, 0Ch, space_instrucoes1
    print_string 09h, 05h, space_instrucoes2
    print_string 0Bh, 09h, space_fases
    print_string 0Fh, 05h, space_texto_jogar              
    print_string 11h, 05h, space_texto_sair_jogo          
    print_string 13h, 05h, space_texto_controle
    print_string 15h, 05h, space_texto_tiro
    print_string 17h, 05h, space_texto_reset

    .espera_tecla:
        mov ah, 00h
        int 16h         
        cmp al, 's'
        je .jogar
        cmp al, 'S'
        je .jogar
        cmp al, 'n'
        je .end
        cmp al, 'N'
        je .end
        jmp .espera_tecla
    .jogar:
        popa
        space_limpa_tela
        print_string 0Ah, 11h, space_fase1
        temporizador_delay 30
        mov al,0
        ret
    .end:
        popa
        mov al,1
        ret

space_loop: ; Loop principal do jogo --------------------------------
    space_limpa_tela           ; Pinta a tela com a cor em al

    ; Desenhar Aliens ------------------------------
    mov si, aliens_array
    mov bl, COR_ALIEN
    mov al, [alien_y]           ; AL = alien_y, AH = alien_x
    mov ah, [alien_x]
    mov cl, 4                   ; Numero de linhas
    cmp byte [muda_alien], 0    ; Booleano para mudar o sprite do alien
    jg desenha_linha_aliens     ; Se não, use o sprite normal
    add di, 4                   ; Se sim, use o sprite alternativo
    desenha_linha_aliens:
        pusha                   ; Salvando os registradores
        mov cl, 8               ; 8 linhas

        .checa_alien:
            pusha
            dec cx
            bt [si],cx                      ; Verifica se o bit está "ligado" (resultado no registrador de carry)
            jnc .prox_alien                 ; Se não (alien morreu), não desenhe
            mov si,di                       ; Sprite atual do alien em SI
            call space_desenha_sprite
            
            .prox_alien:
                popa                        ; Retorna os registradores para suas posições iniciais
                add ah, LARGURA_SPRITE + 4  ; 4 Pixels de distância, ah guarda o x
                .muda_cor:
                    inc bl
                    cmp bl, 8
                    je .muda_cor
                    cmp bl, COR_TELA
                    je .muda_cor
                    cmp bl, COR_BARREIRA
                    je .muda_cor
                    cmp bl, COR_JOGADOR
                    je .muda_cor
                     cmp bl, COR_TIRO_ALIEN
                    je .muda_cor
                     cmp bl, COR_TIRO_PLAYER
                    je .muda_cor
                
        loop .checa_alien                   ; Loop roda "CL" vezes

        popa
        add al, ALTURA_SPRITE + 2
        inc si
    loop desenha_linha_aliens               ; Loop roda "CL" vezes (por isso o popa)
    
    ; Desenhar Jogador -----------------------------

    mov ah, [jogador_x]
    mov al, JOGADOR_Y
    mov si, jogador
    mov bl, COR_JOGADOR
    call space_desenha_sprite

    ; Desenhar Barreiras ---------------------------

    mov ah, BARREIRA_X
    mov al, BARREIRA_Y
    mov si, barreiras_array
    mov bl, COR_BARREIRA
    mov cl, [num_barreiras]
    desenha_barreiras:
        pusha
        call space_desenha_sprite
        popa
        add ah, [dist_barreiras]
        add si, ALTURA_SPRITE
    loop desenha_barreiras
    
    ; Checar se o tiro acertou algo ----------------

    mov si, tiros_array
    mov cl,20
    get_prox_tiro:
        push cx
        lodsw       ; Y/X em AL e AH
        cmp al, 0
        jnz check_tiro
        
        prox_tiro:
            pop cx
    loop get_prox_tiro

    jmp cria_tiro_aliens

    check_tiro:
        call space_posicao_na_tela
        mov al, [di]
        ; Acertou Jogador
        cmp al, COR_JOGADOR
        je space_game_over

        xor bx,bx

        ; Acertou Barreira 
        cmp al, COR_BARREIRA
        jne .check_acertou_alien
        mov bx, barreiras_array
        mov ah, BARREIRA_X + LARGURA_SPRITE
        .check_barreira_loop:
            cmp  dh, ah                     ; DX salva a posição x e y do tiro
            ja .prox_barreira

            sub ah, LARGURA_SPRITE          ; Valor X inicial da barreira 
            sub dh, ah                      ; Subtract from shot X

            pusha
            sub dl, BARREIRA_Y              ; Tira a diferença para o primeiro pixel da barreira
            add bl, dl                      ; BX agora aponta para a linha do pixel atingido
            mov al, 7
            sub al, dh                      ; 
            cbw                             ; AH = 0
            btr [bx], ax                    ; BIT TESTE e RESETA o pixel
            mov byte [si-2], 0              ; Reseta o valor de Y do tiro para 0
            popa
            jmp prox_tiro
            .prox_barreira:
                add ah, [dist_barreiras]
                add bl, ALTURA_SPRITE       ; Proxima barreira no array

        jmp .check_barreira_loop
        ; Acertou Alien
        .check_acertou_alien:
            cmp cl,17                        ; É o tiro do player?
            jl desenha_tiro

            cmp al, COR_TIRO_ALIEN         
            je desenha_tiro
            
            cmp al, COR_TELA
            je desenha_tiro



            mov bx, aliens_array
            mov al, [alien_y]
            mov ah, [alien_x]
            add al, ALTURA_SPRITE           ; Fundo do sprite
            .get_linha_alien:
                cmp dl, al                  ; Compara y_tiro com o y da linha atual
                jg .prox_linha
                mov cl, 8                   ; Numero de aliens/linha
                add ah, LARGURA_SPRITE      ; Lado direito do sprite atual
                .get_alien:
                    dec cx
                    cmp dh, ah
                    ja .prox_alien
                    ; Alien certo

                    btr [bx], cx                ; Reseta o bit no array de aliens
                    mov byte [si-2], 0          ; Reseta o valor Y do tiro
                    dec byte [aliens_num]       ; aliens_num - 1
                    jz space_passa_de_fase      ; Ultimo alien morreu, você passou de fase!
                    jmp prox_tiro

                    .prox_alien:
                        add ah, LARGURA_SPRITE+4
                jmp .get_alien
                .prox_linha:
                    add al, ALTURA_SPRITE + 2
                    inc bx
            jmp .get_linha_alien

    ; Desenhar Tiros ------------------------------
    desenha_tiro:  
        mov bh, COR_TIRO_PLAYER
        mov al,[si-2]           ; Shaenanigans, acontece que por conta de um lodsw [...]
                                ; [..] si é movido 2 bytes (word)
        dec ax                  ; Mover para cima (tiro do player)
        cmp cl,17                ; Se cl == 4, significa que o loop de checar os tiros está na posição 4 (player)
        jge .desenha             ; Se sim, desenhe

        mov bh, COR_TIRO_ALIEN  ; Se não, tiro do alien
        add ax,2                  ; ax = ax - 1 ali em cima, adiciona 2 pra virar ax + 2 (move pra baixo)
        cmp al, ALTURA_TELA/2   ; Escala, comparando se atingiu a tela
        cmovge ax, bx           ; Se sim, zera AX

        .desenha:
            mov byte [si-2],al
            mov bl, bh
            xchg ax, bx                 ; Cor em AX
            mov [di+LARGURA_TELA], ax   ; Desenha 2 pixels 1 linha abaixo (mvoe)
            stosw                       ; desenha 2 pixels na linha atual

        jmp prox_tiro

    ; Criar Tiros dos Aliens ----------------------
    cria_tiro_aliens:
        mov si, tiros_array
        add si, 8           ; Primeiro tiro alien
        mov cl, 16
        .checa_tiro:
            mov di, si      ; Carregar os valores de X e Y
            lodsw           ; AX = Y/X
            cmp al, 0       ; Y = 0? Já foi atirado
            jg .prox_tiro

            ; PSEUDO - RANDOM
            mov ax, [CS:TIMER]
            imul ax, ax, 57667
            add ax, 27337
            and ax, 7h                      ; 0 - 7
            imul ax, ax,LARGURA_SPRITE + 4  ; X que o tiro vai sair
            xchg ah,al                      ; AL = Y
            add ax, [alien_y]

            pusha
            call space_posicao_na_tela
            cmp byte [di], COR_TELA
            je .reset
            popa
            stosw                           ; Move pra o array de tiros
            jmp move_alien
            .reset:
                popa
            .prox_tiro:
        loop .checa_tiro

    ; Mover Aliens --------------------------------
    move_alien:
        mov di, alien_x
        inc byte [cur_moves]
        mov al, [cur_moves]
        cmp al, [move_timer]
        jl space_get_input

        neg byte [muda_alien]
        mov byte [cur_moves], 0
        mov al, [aliens_direcao]

        add byte [di],al
        jg .checa_direita 

        mov byte [di],0
        jmp .move_baixo

        .checa_direita:
            mov al, 68
            cmp [di], al        ; Bateu no lado direito?
            jle space_get_input ; Não
            stosb               ; Sim
            dec di

        .move_baixo:
            neg byte [aliens_direcao]   ; Move in opposite X direction
            dec di
            add byte [di], 5            ; Add to alienY value to move down
            cmp byte [di], BARREIRA_Y+1     ; Did aliens breach the barriers?
            jg space_game_over                ; Yes, lost game :'(
            dec byte [move_timer]       ; Aliens will get slightly faster
            cmp byte [move_timer], 2
            jne space_get_input
            add byte [move_timer], 1

    ; Pegar Input do Jogador ----------------------
    space_get_input:
        mov si, jogador_x
        mov ah, 02h
        int 16h
        cmp al,1
        je .move_right
        cmp al,2
        je .move_left

        .resto:
        mov ah, 01h
        int 16h
        jz .fim

        mov ah, 00h
        int 16h

        cmp al,'r'
        je .reset
        cmp al,'R'
        je .reset
        cmp al, ' ' ; Barra de espaço
        je .shoot

        jmp .fim
        .move_left:
            sub byte[si], 1
            jmp .resto
        .move_right:
            add byte[si], 1
            jmp .resto
        .shoot:
            lodsb                   ; X do jogador -> AL
            mov ah, al
            add ah, 3               ; Mais ou menos no meio da nave          
            mov al, JOGADOR_Y - 1   ; Logo acima do jogador
            mov si, tiros_array
            add si, [jogador_pt_tiro]
            mov [si], ax
            add byte [jogador_pt_tiro],2
            cmp byte [jogador_pt_tiro],8
            jne .fim
            mov byte [jogador_pt_tiro],0
            jmp .fim
        .reset:
            xor ax,ax
            mov ds, ax
            push 1
            jmp jogar_space

    .fim:
    temporizador_delay 1

jmp space_loop

space_game_over: ; Fim de Jogo e Reset
    space_limpa_tela
    xor ax,ax
    mov ds,ax
    print_string 0Ah,0Fh, space_fim
    temporizador_delay 30
    push 1
    jmp jogar_space

space_ganhou:
    space_limpa_tela
    xor ax,ax
    mov ds,ax
    print_string 0Ah,0Fh, space_parabens
    temporizador_delay 30
    push 1
    jmp jogar_space

; Desenha um sprite na tela
; Registradores:
;   SI -> Endereço do sprite
;   AL -> Posição Y
;   AH -> Posição X
;   BL -> Cor

space_desenha_sprite:           ; Desenha um bloco de 4 pixels, por pixel
    call space_posicao_na_tela  ; Recebe a posição em DI
    mov cl, ALTURA_SPRITE       ; Loop para desenhar
    .prox_linha:
        push cx
        lodsb                   ; AL = Prox Byte a ser desenhado (Já incrementa SI)
        mov dx,ax               ; DX recebe AX
        mov cl, LARGURA_SPRITE  ; Segundo loop para desenhar
        .prox_pixel:
            mov ax, [COR_TELA]          ; Se o bit for setado, printe a cor da tela
            dec cx          
            bt dx, cx                   ; Compara bitwise na posição cx
            cmovc ax, bx                ; Se o bit for 1, pinte o pixel com a cor em BL
            mov ah, al                  ; Copia a cor 
            mov [di + LARGURA_TELA], ax ; Colore o pixel
            stosw                       ; Move o ponteiro
        jnz .prox_pixel                 ; Se ainda houverem pixels para pintar na linha, loop
        add di, LARGURA_TELA * 2 - LARGURA_SPRITE_P ; Move o ponteiro pra pra proxima linha
        pop cx
    loop .prox_linha
    ret

; Devolve a posição X/Y em DI
; Registradores:
;   AL -> Posição Y
;   AH -> Posição X
space_posicao_na_tela:
    mov dx, ax                      ; Salva os valores de posição em DX
    cbw  
    imul di, ax, LARGURA_TELA * 2   ; A tela é um vetor que cresce na direção x, então para cada "Y" temos LARGURA TELA_PIXELS
    mov al, dh                      ; AX = Y (Antigo AH que agora é 0)
    shl ax, 1                       ; AX = AX * 2 (Escala)
    add di, ax                      ; DI agora terá exatamente o pixel onde o sprite deve ser desenhado
    ret


space_sprites_bitmaps:
    db 10011001b    ; Alien 1 bitmap
    db 01011010b
    db 00111100b
    db 01000010b

    db 00011000b    ; Alien 2 bitmap
    db 01011010b
    db 10111101b
    db 00100100b

    db 00011000b    ; Jogador bitmap
    db 00111100b
    db 00100100b
    db 01100110b

    db 00111100b    ; Barreira bitmap
    db 01111110b
    db 11100111b
    db 11100111b

    dw 0FFFFh       ; Alien array
    dw 0FFFFh
    db 75           ; player_x
    dw 230Ah        ; alien_y e alien x | 10 = Y, 35 = X
    db 20h          ; num de aliens = 32 
    db 0FBh         ; Direção =  -5
    dw 18           ; 18 Ticks para mover os aliens
    db 1            ; Muda o alien - entre 1 e -1
    db 25           ; Distancia barreiars
    db 5            ; Num Barreiras
    db 0
    db 0

start:
    xor ax, ax
    mov ds, ax

    call limpar_tela                ; executa a configuração de video inicial

    jmp menu_console

times 63*512-($-$$) db 0
jmp $
dw 0xaa55