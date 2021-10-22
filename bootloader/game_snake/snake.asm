;; SETUP ---------------
;org 07C00h		; Set bootsector to be at memory location hex 7C00h (UNCOMMENT IF USING AS BOOTSECTOR)
org 8000h		; Set memory offsets to start here

jmp setup_game 

;; CONSTANTS
memoria_do_video		equ 0B800h
tela_largura		equ 80;; SETUP ---------------
;org 07C00h		; Set bootsector to be at memory location hex 7C00h (UNCOMMENT IF USING AS BOOTSECTOR)
org 8000h		; Set memory offsets to start here

jmp setup_game 

;; CONSTANTS
memoria_do_video		equ 0B800h      
tela_largura	equ 80          ;;screen width
tela_altura		equ 25          ;;screen height
condicao_de_vitoria		equ 20          ;;win condition
cor_de_fundo		equ 1020h       ;;background color
cor_da_maca  equ 4020h
cor_da_cobra  equ 2020h
TIMER       equ 046Ch
array_x_da_cobra equ 1000h
array_y_da_cobra equ 2000h
UP			equ 0
DOWN		equ 1
LEFT		equ 2
RIGHT		equ 3

;; VARIABLES
jogador_x:	 dw 40 ; posicao onde o jogador vai iniciar no eixo x
jogador_y:	 dw 12 ; posicao onde o jogador vai iniciar no eixo y

;;Poderiamos colocar posicoes aleatorias para a maca aparecer
;;Poderia ser buscar a energia e na mesma vibe do jogo pong trocar a cor da cobra ao comer a maca
maca_x:		 dw 16 ; posicao onde a maca vai iniciar no eixo x
maca_y:		 dw 8  ; posicao onde a maca vai iniciar no eixo y
direcao:	 db 4
tamanho_da_cobra: dw 1

;; LOGIC --------------------
setup_game:
	;; Set video mode - VGA mode 03h (80x25 text mode, 16 colors)
	mov ax, 0003h
	int 10h

	;; Set up video memory
	mov ax, memoria_do_video
	mov es, ax		; ES:DI <- video memory (0B800:0000 or B8000)

	;; Set 1st snake segment "head"
	mov ax, [jogador_x]
	mov word [array_x_da_cobra], ax
	mov ax, [jogador_y]
	mov word [array_y_da_cobra], ax
	
	;; Hide cursor
	mov ah, 02h
	mov dx, 2600h	; DH = row, DL = col, cursor is off the visible screen
	int 10h

;; Loop do jogo
game_loop:
	;; Limpar a tela
	mov ax, cor_de_fundo
	xor di, di
	mov cx, tela_largura*tela_altura
	rep stosw				; mov [ES:DI], AX & inc di

	;; Desenhar cobra
	xor bx, bx				; Index do array
	mov cx, [tamanho_da_cobra]	; Contador do loop
	mov ax, cor_da_cobra
	.snake_loop:
		imul di, [array_y_da_cobra+bx], tela_largura*2	; Y position of snake segment, 2 bytes per character
		imul dx, [array_x_da_cobra+bx], 2	; X position of snake segment, 2 bytes per character
		add di, dx
		stosw
		inc bx
		inc bx
	loop .snake_loop

	;; Desenhar maca
	imul di, [maca_y], tela_largura*2
	imul dx, [maca_x], 2
	add di, dx
	mov ax, cor_da_maca
	stosw

	;; Alterar a direcao da cobra
	mov al, [direcao]
	cmp al, UP
	je move_up
	cmp al, DOWN
	je move_down
	cmp al, LEFT
	je move_left
	cmp al, RIGHT
	je move_right

	jmp update_snake

	move_up:
		dec word [jogador_y]		; Move 1 linha para cima na tela
		jmp update_snake

	move_down:
		inc word [jogador_y]		; Move 1 linha para baixo na tela
		jmp update_snake

	move_left:
		dec word [jogador_x]		; Move 1 coluna para esquerda na tela
		jmp update_snake

	move_right:
		inc word [jogador_x]		; Move 1 coluna para direita na tela

	;; Update snake position from jogador_x/Y changes
	update_snake:
		;; Update all snake segments past the "head", iterate back to front
		imul bx, [tamanho_da_cobra], 2	; each array element = 2 bytes
		.snake_loop:
			mov ax, [array_x_da_cobra-2+bx]			; X value
			mov word [array_x_da_cobra+bx], ax
			mov ax, [array_y_da_cobra-2+bx]			; Y value
			mov word [array_y_da_cobra+bx], ax
			
			dec bx								; Get previous array elem
			dec bx
		jnz .snake_loop							; Stop at first element, "head"

	;; Store updated values to head of snake in arrays
	mov ax, [jogador_x]
	mov word [array_x_da_cobra], ax
	mov ax, [jogador_y]
	mov word [array_y_da_cobra], ax
	
	;; Casos para a cobra morrer
	;; 1)Sair da tela
	cmp word [jogador_y], -1		; Top of screen
	je game_over
	cmp word [jogador_y], tela_altura	; Bottom of screen
	je game_over
	cmp word [jogador_x], -1		; Left of screen
	je game_over
	cmp word [jogador_x], tela_largura ; Right of screen
	je game_over

	;; 2)Bater em si mesma
	cmp word [tamanho_da_cobra], 1	; Only have starting segment
	je pegar_input_jogador

	mov bx, 2					; Array indexes, start at 2nd array element
	mov cx, [tamanho_da_cobra]		; Loop counter
	check_hit_snake_loop:
		mov ax, [jogador_x]
		cmp ax, [array_x_da_cobra+bx]
		jne .increment

		mov ax, [jogador_y]
		cmp ax, [array_y_da_cobra+bx]
		je game_over				; Hit snake body, lose game :'(

		.increment:
			inc bx
			inc bx
	loop check_hit_snake_loop

	pegar_input_jogador:
		mov bl, [direcao]		; Save current direcao
		
		mov ah, 1
		int 16h					; Get keyboard status
		jz check_apple			; If no key was pressed, move on

		xor ah, ah
		int 16h					; Get keystroke, AH = scancode, AL = ascii char entered
		
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

		jmp check_apple

		w_pressed:
            ;; Move up
			mov bl, UP
			jmp check_apple

		s_pressed:
            ;; Move down
			mov bl, DOWN
			jmp check_apple

		a_pressed:
            ;; Move left
			mov bl, LEFT
			jmp check_apple

		d_pressed:
            ;; Move right
			mov bl, RIGHT
			jmp check_apple

		r_pressed:
            ;; Reset
			int 19h     ; Reload bootsector

	;; Verifica se o jogador comeu a maca
	check_apple:
		mov byte [direcao], bl		; Update direcao
		
		mov ax, [jogador_x]
		cmp ax, [maca_x]
		jne delay_loop

		mov ax, [jogador_y]
		cmp ax, [maca_y]
		jne delay_loop

		; Caso tenha comido a maca, aumenta o tamanho da cobra
		inc word [tamanho_da_cobra]
		cmp word [tamanho_da_cobra], condicao_de_vitoria
		je game_won

	;; Did not win yet, spawn next apple
	next_apple:
		;; Random X position
		xor ah, ah
		int 1Ah			; Timer ticks since midnight in CX:DX
		mov ax, dx		; Lower half of timer ticks
		xor dx, dx		; Clear out upper half of dividend
		mov cx, tela_largura
		div cx			; (DX/AX) / CX; AX = quotient, DX = remainder (0-79) 
		mov word [maca_x], dx
			
		;; Random Y position
		xor ah, ah
		int 1Ah			; Timer ticks since midnight in CX:DX
		mov ax, dx		; Lower half of timer ticks
		xor dx, dx		; Clear out upper half of dividend
		mov cx, tela_altura
		div cx			; (DX/AX) / CX; AX = quotient, DX = remainder (0-24) 
		mov word [maca_y], dx

	;; Checa se a maca apareceu dentro da cobra
	xor bx, bx				; array index
	mov cx, [tamanho_da_cobra]	; loop counter
	.check_loop:
		mov ax, [maca_x]
		cmp ax, [array_x_da_cobra+bx]
		jne .increment

		mov ax, [maca_y]
		cmp ax, [array_y_da_cobra+bx]
		je next_apple				; Apple did spawn in snake, make a new one!
		
		.increment:
			inc bx
			inc bx
	loop .check_loop
	
    ;; Reduzir o piscar dos elementos dispostos na tela
	delay_loop:
		mov bx, [TIMER]
		inc bx
		inc bx
		.delay:
			cmp [TIMER], bx
			jl .delay

jmp game_loop

;; End conditions
game_won:
	mov dword [ES:0000], 1F491F57h	; WI
	mov dword [ES:0004], 1F211F4Eh	; N!
	jmp reset
	
game_over:
	mov dword [ES:0000], 1F4F1F4Ch	; LO
	mov dword [ES:0004], 1F451F53h	; SE
	
;; Reset the game
reset:
	xor ah, ah
	int 16h
    int 19h     ; Reload bootsector

;; Bootsector padding
times 510 - ($-$$) db 0
dw 0AA55h