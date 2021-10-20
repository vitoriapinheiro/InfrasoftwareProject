org 0x7e00
jmp 0x0000:start

data:
    ; dados de game status
    game_status db 1
    winner_status db 0              ; status do vencedor | 1 -> jogador 1, 2 -> jogador 2
    tela_atual db 0                 ; Status da tela atual | 0-> menu, 1 -> jogo
    
    ; dados da tela
    tela_largura dw 140h            ; janela feita com al = 13h (320x200)
    tela_altura dw 0c8h     
    margem_erro dw 6                ; margem de erro para a bola não atravessar a tela

    ; dados do tempo
    tempo_aux dw 0                  ; variável usado para checar se o tempo passou
    

    ; dados da interface
    texto_jogador_um db '0'         ; texto da pontuação do jogador 1
    texto_jogador_dois db '0'       ; texto da pontuação do jogador 2

    texto_game_over db 'GAME OVER', 0
    texto_vencedor_1 db 'PLAYER 1 VENCEU', 0
    texto_vencedor_2 db 'PLAYER 2 VENCEU', 0
    texto_restart db 'RESTART - pressione R', 0
    texto_return_main_menu db 'MENU - pressione M', 0
    
    texto_main_menu db 'MENU PRINCIPAL', 0
    texto_jogar db 'JOGAR - pressione P', 0
    texto_sair_jogo db 'Pressione E para sair de jogo', 0
    texto_jogador_1 db 'JOGADOR 1', 0
    texto_inst_jogador_1 db 'O/L move cima/baixo', 0
    texto_jogador_2 db 'JOGADOR 2', 0
    texto_inst_jogador_2 db 'W/S move cima/baixo', 0

    ; dados da bola
    bola_size dw 5                  ; tamanho da bola

    bola_origem_X dw 0A0h           ; posicao X original da bola (meio da tela)
    bola_origem_Y dw 064h           ; posição Y original da bola (meio da tela)
    bola_X dw 0A0h                  ; posição X da bola
    bola_Y dw 064h                  ; posição Y da bola
    bola_vel_X dw 06h               ; velocidade X da bola
    bola_vel_Y dw 03h               ; velocidade Y da bola


    ; dados das barras

    barra_esquerda_pontos db 0      ; pontuação do primeiro jogador (esquerda)
    barra_esquerda_X dw 0Ah         ; posição X da barra esquerda
    barra_esquerda_Y dw 0Ah         ; posição Y da barra esquerda

    barra_direita_pontos db 0       ; pontuação do segundo jogador (direita)
    barra_direita_X dw 132h         ; posição X da barra direita
    barra_direita_Y dw 0A0h         ; posição Y da barra direita

    barra_largura dw 5              ; largura da barra
    barra_altura dw 30              ; altura da barra
    barra_vel dw 06h                ; velocidade vertical da barra



; printa um objeto passando os parrametros
; (coordX, coordY, largura, altura)
%macro print_obj 4          
    .loop1:    
        .loop2:
            mov ah, 0Ch     ; escrevendo um pixel
            mov al, 0Fh     ; escolhendo a cor (branca)
            mov bh, 00h     ; escolhendo a pagina
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

print_UI:
    ; desenhar os pontos do jogador esquerdo

    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 04h                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov ah, 0Eh                     ; escrever caracter
    mov al, [texto_jogador_um]      ; escolher caracter
    mov bl, 15                      ; escolher cor (branco)
    int 10h

    ; desenhar os pontos do jogador direito

    mov ah, 02h                     ; escolher a posição do cursor
    mov dh, 04h                     ; escolher a linha
    mov dl, 21h                     ; escolher a coluna
    int 10h

    mov ah, 0Eh                     ; escrever caracter
    mov al, [texto_jogador_dois]    ; escolher caracter
    mov bl, 15                      ; escolher cor (branco)
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
    print_obj [barra_direita_X], [barra_direita_Y], [barra_largura], [barra_altura]

    ret

print_barra_esquerda:

    ; define as coordenadas iniciais da barra esquerda
    mov cx, [barra_esquerda_X]
    mov dx, [barra_esquerda_Y]

    ; desenha a barra esquerda
    print_obj [barra_esquerda_X], [barra_esquerda_Y], [barra_largura], [barra_altura]

    ret

print_bola:
    ; define as coordenadas iniciais da bola
    mov cx, [bola_X]
    mov dx, [bola_Y]

    ; desenha a bola
    print_obj [bola_X], [bola_Y], [bola_size], [bola_size]

    ret

putchar:
    mov ah, 0x0e
    mov bh, 00h
    mov bl, 15
    int 10h
    ret

print_game_over_menu:
    call limpar_tela


    ; mostra o texto de gameover
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 04h                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov si, texto_game_over         ; pega o texto de game over

    print_game_over:                ; print o texto de game over
        .loop:
            lodsb ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:
        
    ; mostra o vencedor
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 06h                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov al, 01h                     ; compara o status de vencedor
    cmp [winner_status], al
    je vencedor_um                  ; se for 1 o jogador 1 venceu
    jne vencedor_dois               ; se não, o jogador 2 venceu

    vencedor_um:
        mov si, texto_vencedor_1    ; pega o texto de vencedor 1
        jmp print_vencedor
    vencedor_dois:
        mov si, texto_vencedor_2    ; pega o texto de vencedor 2
        jmp print_vencedor

    print_vencedor:                 ; print o texto de vencedor
        .loop:
            lodsb           ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:
    
    ;mostrar restart
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 08h                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov si, texto_restart

    print_restart:                   ; print o texto de restart
        .loop:
            lodsb           ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:
    
    ;mostrar sair para o menu
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 0Ah                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov si, texto_return_main_menu

    print_return_menu:              ; print o texto de retornar ao menu
        .loop:
            lodsb           ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:
    


    ; espera por um caracter
    mov ah, 00h
    int 16h                          ; salva o caracter em al

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
        mov [game_status], al
        ret

    sair_para_menu:
        mov al, 00h
        mov [game_status], al
        mov [tela_atual], al 

    
print_main_menu:
    call limpar_tela

    ; mostra o texto de main menu
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 04h                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov si, texto_main_menu         ; pega o texto de game over

    print_texto_main:                ; print o texto de game over
        .loop:
            lodsb ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:

    ; mostra o texto de jogar
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 06h                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov si, texto_jogar         ; pega o texto de game over

    print_texto_jogar:                ; print o texto de game over
        .loop:
            lodsb ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:

    ; mostra o texto de sair do jogo
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 08h                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov si, texto_sair_jogo         ; pega o texto de game over

    print_texto_sair_jogo:                ; print o texto de game over
        .loop:
            lodsb ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:


    ; mostra o texto jogador 1
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 0Eh                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov si, texto_jogador_1         ; pega o texto de game over

    print_texto_jogador_1:                ; print o texto de game over
        .loop:
            lodsb ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:

    ; mostra o texto instrucao 1
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 10h                     ; escolher a linha
    mov dl, 08h                     ; escolher a coluna
    int 10h

    mov si, texto_inst_jogador_1         ; pega o texto de game over

    print_texto_inst_1:                ; print o texto de game over
        .loop:
            lodsb ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:

    ; mostra o texto jogador 2
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 12h                     ; escolher a linha
    mov dl, 06h                     ; escolher a coluna
    int 10h

    mov si, texto_jogador_2        ; pega o texto de game over

    print_texto_jogador_2:                ; print o texto de game over
        .loop:
            lodsb ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:
    
    ; mostra o texto instrucao 2
    mov ah, 02h                     ; escolher a posição do cursor
    mov bh, 00h                     ; escolher a pagina
    mov dh, 14h                     ; escolher a linha
    mov dl, 08h                     ; escolher a coluna
    int 10h

    mov si, texto_inst_jogador_2         ; pega o texto de game over

    print_texto_inst_2:                ; print o texto de game over
        .loop:
            lodsb ; bota character em al 
            cmp al, 0
            je .endloop
            call putchar
            jmp .loop
        .endloop:

    espera_tecla:
        ; espera por um caracter
        mov ah, 00h
        int 16h                          ; salva o caracter em al

        cmp al, 'p'
        je jogar
        cmp al, 'P'
        je jogar

        cmp al, 'e'
        je end
        cmp al, 'E'
        je end

        jmp espera_tecla


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

    ret


inv_vel_Y:
    ; inverte a velocidade em Y caso bata na parede
    mov ax, [bola_vel_Y]
    neg ax
    mov [bola_vel_Y], ax
    
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
    mov al, [barra_esquerda_pontos]             ; pontua o jogador um 
    inc al
    mov [barra_esquerda_pontos], al

    call reset_bola                             ; bola volta para o início

    call atualiza_texto_jogador_um              ; Atualiza a pontuação na tela do jogador 1

    ; checa se o jogador dois fez 5 pontos
    mov al, [barra_esquerda_pontos]
    cmp al, 05h
    je game_over

    ret

pontuar_jogador_dois:
    mov al, [barra_direita_pontos]              ; pontua jogador dois
    inc al
    mov [barra_direita_pontos], al
   
    call reset_bola                             ; bola volta para o início

    call atualiza_texto_jogador_dois            ; Atualiza a pontuação na tela do jogador 2

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
    mov ax, [bola_vel_X]
    neg ax
    mov [bola_vel_X], ax

    ret

    check_colisao_barra_esquerda:
    ; checa se a bola colide com a barra esquerda   
    mov ax, [bola_X]
    add ax, [bola_size]
    cmp ax, [barra_esquerda_X]
    jng exit_check_colisao_barra    ; se não tem colidao com a barra direta, checamos a barra esquerda

                                        ; bola_x < barra_esquerda_X + barra_largura 
    mov ax, [barra_esquerda_X]
    add ax, [barra_largura]
    cmp [bola_X], ax
    jnl exit_check_colisao_barra    ; se não tem colidao com a barra direta, checamos a barra esquerda

                                        ; bola_Y + bola_size > barra_esquerda_Y
    mov ax, [bola_Y]
    add ax, [bola_size]
    cmp ax, [barra_esquerda_Y]
    jng exit_check_colisao_barra    ; se não tem colidao com a barra direta, checamos a barra esquerda

                                        ; bola_Y < barra_esquerda_Y + barra_altura
    mov ax, [barra_esquerda_Y]
    add ax, [barra_altura]
    cmp [bola_Y], ax
    jnl exit_check_colisao_barra    ; se não tem colidao com a barra direta, checamos a barra esquerda

    ; se chegar até aqui, houve colisão com a barra esquerda
    ; inverte a velocidade da bola na direção X
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
        
start:
    xor ax, ax
    mov ds, ax


    call limpar_tela                ; executa a configuração de video inicial

    
    check_time:                     ; gera a sensação de movimento
        xor al , al

        cmp [tela_atual], al
        je mostra_main_menu
        cmp [game_status], al          ; se o jogo acabar
        je mostra_game_over         ; mostra a tela de game over
        
        mov ah, 00h                 ; get system time
        int 1ah                     ; cx:dx = numero de ticks de clock desde a meia noite

        cmp dx, [tempo_aux]         ; verifica se o tempo passou (provavelmente 1/100 s)
        je check_time

        ; o tempo passou

        mov [tempo_aux], dx         ; atualiza o tempo

        call limpar_tela            ; da update na tela para nao deixar "rastro"
         
        call mover_bola             ; muda as coordenadas da bola      

        call print_bola             ; desenha a bola 

        call mover_barras           ; move e checa os movimentos validos das barras

 
        call print_barra_esquerda   ; desenha a barra direita

        call print_barra_direita    ; desenha a barra esquerda

        call print_UI

        jmp check_time 
    
        mostra_game_over:
            call print_game_over_menu
            jmp check_time
            
        mostra_main_menu:
            call print_main_menu
            jmp check_time
            

    
        end:                        
            ; chama o modo texto
            mov ah, 00h             ; set video mode
            mov al, 00h             ; escolhe o modo texto
            int 10h                 ; executa


times 63*512-($-$$) db 0


jmp $
dw 0xaa55