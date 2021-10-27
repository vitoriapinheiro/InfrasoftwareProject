org 0x7e00
jmp 0x0000:start

data:
    ; dados da interface console
        texto_menu_console db 'SUPER ATARI', 0                  ; texto console
        texto_menu_pong db 'P - JOGAR PONG', 0                  ; texto jogar Pong console
        texto_menu_space db 'S - JOGAR SPACE INVADERS', 0       ; texto jogar Space Invaders console
        texto_menu_snake db 'T - JOGAR SNAKE', 0                ; texto jogar Snake console

    ; dados do Snake
        ; dados de game status
        game_status db 1                                        ; game_status = 1 - jogando | game_status = 0 - nao ta jogando
        winner_status db 0                                      ; status do vencedor | 1 -> jogador 1, 2 -> jogador 2
        tela_atual db 0                                         ; Status da tela atual | 0-> menu, 1 -> jogo

        ; dados da tela
        tela_largura dw 140h                                    ; janela feita com al = 13h (320x200)
        tela_altura dw 0c8h     
        margem_erro dw 6    
        condicao_da_tela db 20

        ; dados do tempo
        tempo_aux dw 0                                          ; variável usado para checar se o tempo passou
        TIMER db 300

        ; dados da interface 
        texto_jogador db '0'                                 ; texto da pontuação do jogador

        ; direcao
        CIMA db 0
        BAIXO db 1
        ESQUERDA db 2
        DIREITA db 3

        direcao db 4

        ; dados da cobra
        cobra_x dw 40
        cobra_y dw 12
        cor_da_cobra db 3
        comprimento_da_cobra dw 1

        array_x_cobra dw 1000h
        array_y_cobra dw 2000h

        ; dados do objeto
        objeto_x dw 0A0h
        objeto_y dw 064h
        tamanho_do_objeto dw 15
        cor_do_objeto db 15

        texto_game_over db 'GAME OVER', 0                       ; texto game over
        texto_vencedor db 'VOCE VENCEU', 0                      ; texto vencedor
        texto_restart db 'RESTART - pressione R', 0             ; texto restart
        texto_return_main_menu db 'MENU - pressione M', 0       ; texto retornar para o main menu
        
        texto_main_menu db 'MENU PRINCIPAL', 0                  ; texto main menu
        texto_jogar db 'JOGAR - pressione P', 0                 ; texto jogar
        texto_sair_jogo db 'Pressione E para sair de jogo', 0   ; texto sair do jogo

; printa um objeto passando os parrametros
; (coordX, coordY, largura, altura, cor)
%macro print_obj 5          
    .loop1:    
        .loop2:
            mov ah, 0Ch             ; escrevendo um pixel
            mov al, %5             ; escolhendo a cor (branca)
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

    jmp snake_laco

menu_console:
    call limpar_tela

    print_string 04h, 06h, texto_menu_console

    print_string 0Ah, 08h, texto_menu_pong

    print_string 0Ch, 08h, texto_menu_space

    print_string 0Eh, 08h, texto_menu_snake
    

    .espera_tecla:
        ; espera por um caracter
        mov ah, 00h
        int 16h          ; salva o caracter em al

		cmp al, 't'
        je jogar_snake
        cmp al, 'T'
        je jogar_snake

        jmp .espera_tecla


    jmp menu_console

reset_cor:
    mov al, 1
    mov [cor_do_objeto], al
    ret

mudar_cor:
    mov al, [cor_do_objeto]
    inc al
    mov [cor_do_objeto], al

    mov ah, 16
    cmp [cor_do_objeto], ah
    jge reset_cor

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

    print_string 0Eh, 06h, texto_jogador          ; print texto jogador

    ; print_string 10h, 08h, texto_inst_jogador     ; print texto inst jogador


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


snake_laco:                     	; gera a sensação de movimento
        xor al , al

        cmp [tela_atual], al        ; se a tela atual for a de menu
        je mostra_main_menu         ; mostra o menu

        cmp [game_status], al       ; se o jogo acabar
        je mostra_game_over         ; mostra a tela de game over
        
        mov ah, 00h                 ; get system time
        int 1ah                     ; cx:dx = numero de ticks de clock desde a meia noite

        cmp dx, [tempo_aux]         ; verifica se o tempo passou (provavelmente 1/100 s)
        je snake_laco

        ; o tempo passou

        mov [tempo_aux], dx         ; atualiza o tempo

        call limpar_tela            ; da update na tela para nao deixar "rastro"

        jmp snake_laco 
    
        mostra_game_over:
            call print_game_over_menu
            jmp snake_laco
            
        mostra_main_menu:
            call print_main_menu
            jmp snake_laco
            
        end:                        
            ; Menu do console
            call menu_console

game_loop:
	;;limpar a tela em toda iteracao
	call limpar_tela

	xor di, di
    mov ax, tela_altura
    mul ax
    mov ax, tela_largura
    mul ax
	mov cx, ax
	rep stosw

	; Desenhar a cobra
	xor bx, bx
	mov cx, [comprimento_da_cobra]
	mov ax, cor_da_cobra

	.snake_laco:
		imul di, [array_y_cobra + bx], tela_largura*2
		imul dx, [array_x_cobra + bx], 2
		add di, dx
		stosw
		inc bx
		inc bx
	loop .snake_laco

	; Desenhar objeto
	imul di, [objeto_y], tela_largura*2
	imul dx, 2
	add di, dx
    mov ax, [cor_do_objeto]
	stosw

	; Mover cobra para direcao atual
	mov al, [direcao]

	cmp al, CIMA
	je mover_cima

	cmp al, BAIXO
	je mover_baixo

	cmp al, ESQUERDA
	je mover_esquerda

	cmp al, DIREITA
	je mover_direita

	jmp atualizar_cobra

	mover_cima:
		dec word [cobra_y]			;; Move uma linha para cima na tela
		jmp atualizar_cobra
	
	mover_baixo:
		inc word [cobra_y]			;; Move uma linha para baixo na tela
		jmp atualizar_cobra

	mover_esquerda:
		dec word [cobra_x]          ;; Move uma coluna para a esquerda na tela
        jmp atualizar_cobra
    
    mover_direita:
        inc word [cobra_x]          ;; Move uma coluna para a direita na tela

    atualizar_cobra:
        ;; Atualiza todos os segmentos da cobra depois da cabeca, itera de tras pra frente 
        imul bx, [comprimento_da_cobra], 2
        .snake_laco:
            mov ax, [array_x_cobra - 2 + bx]
            mov word [array_x_cobra + bx], ax
            mov ax, [array_y_cobra - 2 + bx]
            mov word [array_y_cobra + bx], ax

            dec bx
            dec bx
        jnz .snake_laco

    ;; Armazena os valores atualizados da cabeca da cobra nos arrays
    mov ax, [cobra_x]
    mov word [array_x_cobra], ax
    mov ax, [cobra_y]
    mov word [array_y_cobra], ax

    ;; Condicoes de derrota
    ;; 1) Bater em alguma das bordas da tela
    cmp word [cobra_y], -1                      ;; Topo da tela
    je game_over

    cmp word [cobra_y], tela_altura             ;; Baixo da tela
    je game_over

    cmp word [cobra_x], -1                      ;; Esquerda da tela
    je game_over

    cmp word [cobra_x], tela_largura            ;; Direita da tela
    je game_over

    ;; 2) Bateu em alguma parte da cobra
    cmp word [comprimento_da_cobra], 1          ;; So tem o tamanho inicial de 1
    je pegar_input_cobra

    mov bx, 2
    mov cx, [comprimento_da_cobra]
    checar_colisao__cobra_loop:
        mov ax, [cobra_x]
        cmp ax, [array_x_cobra + bx]
        jne .incremento

        mov ax, [cobra_y]
        cmp ax, [array_y_cobra + bx]
        je game_over
        
        .incremento: 
            inc bx
            inc bx
    loop checar_colisao__cobra_loop

    pegar_input_cobra:
        mov bl, [direcao]

        mov ah, 1
        int 16h
        jz checar_objeto

        xor ah, ah
        int 16h

        cmp al, 'w'
        je w_pressed

        cmp al, 's'
        je s_pressed

        cmp al, 'a'
        je a_pressed
        
        cmp al, 'd'
        je d_pressed
        
    cmp al, 'r'
    je r_pressed

        jmp checar_objeto
        
        w_pressed:              ;; Mover para cima
            mov bl, CIMA
            jmp checar_objeto
        
        s_pressed:              ;; Mover para baixo
            mov bl, BAIXO
            jmp checar_objeto

        a_pressed:              ;; Mover para esquerda
            mov bl, ESQUERDA
            jmp checar_objeto
            
        d_pressed:              ;; Mover para direita
            mov bl, DIREITA
            jmp checar_objeto

        r_pressed:              ;; Resetar
            int 19h             ;; Reload bootsector
        
    checar_objeto:
        mov byte [direcao], bl
        
        mov ax, [cobra_x]
        cmp ax, [objeto_x]
        jne delay_loop

        mov ax, [cobra_y]
        cmp ax, [objeto_y]
        jne delay_loop

        ;; Se bateu no objeto, aumenta o tamanho da cobra
        inc word [comprimento_da_cobra]
        cmp word [comprimento_da_cobra], condicao_da_tela
        je game_won
        
    posicao_aleatoria:
        xor ah, ah
        int 1Ah
        mov ax, dx
        xor dx, dx
        mov cx, tela_largura
        div cx
        mov word [objeto_x], dx
    
        xor ah, ah
        int 1Ah
        mov ax, dx
        xor dx, dx
        mov cx, tela_altura
        div cx
        mov word [objeto_y], dx

    xor bx, bx
    mov cx, [comprimento_da_cobra]
    .check_loop:
        mov ax, [objeto_x]
        cmp ax, [comprimento_da_cobra + bx]
        jne .incremento

        mov ax, [objeto_y]
        cmp ax, [comprimento_da_cobra + bx]
        je posicao_aleatoria

        .incremento:
            inc bx
            inc bx
    loop .check_loop

    delay_loop:
        mov bx, [TIMER]
        inc bx
        inc bx
        .delay:
            cmp [TIMER], bx
            jl .delay

jmp game_loop

game_won:
	mov dword [ES:0000], 1F491F57h	; WI
	mov dword [ES:0004], 1F211F4Eh	; N!
	jmp reset

game_over:
	mov dword [ES:0000], 1F4F1F4Ch	; LO
	mov dword [ES:0004], 1F451F53h	; SE

start:
    xor ax, ax
    mov ds, ax
 
    call limpar_tela                ; executa a configuração de video inicial

    jmp menu_console


;; Resetar o jogo
reset:
	xor ah, ah
	int 16h
    int 19h     ; Reload bootsector
    

times 63*512-($-$$) db 0


jmp $
dw 0xaa55