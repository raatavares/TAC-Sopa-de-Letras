STACK SEGMENT PARA STACK
	DB 64 DUP (' ')
STACK ENDS

dseg SEGMENT PARA 'DATA'
	
	POSy		db	2	; a linha pode ir de [1 .. 25]
	POSx		db	6	; POSx pode ir [1..80]
	STR12	 	DB 		"            "	; String para 12 digitos

				
				
	Bem_Vindo	db "Bem-vindo ao jogo",13,10
				db "Prima qualquer tecla para continuar...",13,10,'$'
				
				
				
;********************************************************************************
;Lista de nomes TOP10


	Construir_nome	db	"                            $"
		buffer	    db	'                             ',13,10
				    db 	'                             ',13,10
			    	db	'                             ',13,10
				    db 	'                             ',13,10
				    db	'                             ',13,10
				    db	'                             ',13,10
			    	db	'                             ',13,10
		    		db	'                             ',13,10
		    		db	'                             ',13,10
		    		db	'                             ',13,10	
			    	db	'                             $',13,10


;********************************************************************************


    ; Contador
	
	
	timer			dw 	    0				; Contador de tempo
	
	Minutos			dw		0				; Guarda os minutos actuais
	MinutosInicial			dw		0			
	SegundosInicial			dw		0					
	Segundos		dw		0				; Guarda os segundos actuais
	
	Old_seg			dw		0				; Guarda os ultimos segundos que foram lidos
	
	contaSeg 		dw 		0				;contador que regista a varia��o dos segundos/tempo
	
	minS			db 		2 dup(?)
	segS			db 		2 dup(?)
	Tempo_init		dw		0				; Guarda o tempo de inicio do jogo
	Tempo_j			dw		-1				; Guarda o tempo que decorre o jogo
	Tempo_limite	dw		100				; Tempo maximo de Jogo


	; Main


	String_TJ		db		"     / 100$"
	Pontuacao       dw      0             ; Guarda a pontuação do jogador
	Nome_Jogador	db		"          $"   ; Guarda o nome do jogador
	displacement    dw      ?
	pont_insuf      db      "Pontuacao insuficiente para TOP10"
	extrair_pont    dw      0
	POSyplayer      db      10              ; Posição da string para introduzir Nome de Utilizador
	POSxplayer      db      29              ; Posição da string para introduzir Nome de Utilizador
	POSpontosx      db      45              ; Posição dos pontos
	POSpontosy      db      20              ; Posição dos pontos
	introduzir_nome db      "Nome do utilizador:$"
	nomeplayerTEXT  db      "          $"
	tamanho_matriz  dw      0
	car				db		?
	cor				db		?
	mudaMenu	 	db 		0
	menuOP 			db	 	?
	bufferUser		db		255 dup (32)
	i 				db 		0
	

	; Ficheiros
	
	
	FichMenu		db		'menu.txt',0
	Erro_Open      	db      'Erro ao tentar iniciar o jogo$'
	FichJogo_A      db      'JogoA.txt',0
	FichJogo_B      db      'JogoB.txt',0
	FichTop10       db      'TOP10.txt',0
	Player_Won      db      'WINNER.txt',0
	Jogo_Acabou     db      'LOSER.txt',0
	FichMenu_Niveis db		'Menu2.txt',0
	
	handleFich 		dw      0
	carFich			db      ?
	
	
	; Mensagens de erro ficheiros
	
	
	msgErrorOpen       	db	"Erro ao tentar abrir o ficheiro$"
	msgErrorRead    	db	"Erro ao tentar ler o ficheiro$"
    msgErrorCloseRead	db	"Erro ao tentar fechar o ficheiro$"
	msgErrorCreate      db  "Erro na criacao do ficheiro$"
	msgErrorWrite       db  "Erro na escrita do ficheiro$"
	msgErrorClose       db  "Erro no fecho do ficheiro$"
	
	
	; Palavras
	;Nivel Básico
	
	String_Palavra1     db   "ASM$"
	String_Palavra2     db   "TECNOLOGIA$"
	String_Palavra3     db   "MOV$"
	String_Palavra4     db   "PROG$"
	String_Palavra5     db   "ISEC$"
	String_Palavra6     db   "TAC$"
	String_Palavra7     db   "TEXTO$"
	String_Palavra8     db   "ASSEMBLY$"
	
	
	;Nivel Avançado
	
	String_Palavra9     db   "INSTITUTO$"
	String_Palavra10    db   "LINGUAGEM$"
	String_Palavra11    db   "LETRA$"
	String_Palavra12    db   "NOTEPAD$"
	String_Palavra13    db   "DOSBOX$"
	String_Palavra14    db   "GITHUB$"
	String_Palavra15    db   "INFORMATICA$"
	String_Palavra16    db   "VISUAL$"
	String_Palavra17    db   "IMPOSSIVEL$"
	String_Palavra18    db   "TECNOLOGIAS$"
	String_Palavra19    db   "CADEIRA$"
	String_Palavra20    db   "MATEMATICA$"
	
	palavra		db		"          $"
	pos 				db 		0
	percorre	db	0
	jogo	db	0
	palavraCerta	db	0
	palavraIncorreta	db	0
	modoJogo	db	0
 	
	
dseg ENDS


cseg segment para public 'code'
     assume cs:cseg, ds:dseg
	
	ADICIONA_LETRA proc
		mov 	ah, 08h
		mov		bh,0		; numero da página
		int		10h
		mov		palavra[di], al
		call VERIFICA_PALAVRA
		ret
	
	ADICIONA_LETRA endp
	
	VERIFICA_PALAVRA proc
		cmp jogo, 2
		je VERIFICA_PALAVRA_A
		
		VERIFICA_PALAVRA_B:
			cmp String_Palavra1[di], al
			je PALAVRA_CERTA
			cmp String_Palavra2[di], al
			je PALAVRA_CERTA
			cmp String_Palavra3[di], al
			je PALAVRA_CERTA
			cmp String_Palavra4[di], al
			je PALAVRA_CERTA
			cmp String_Palavra5[di], al
			je PALAVRA_CERTA
			cmp String_Palavra6[di], al
			je PALAVRA_CERTA
			cmp String_Palavra7[di], al
			je PALAVRA_CERTA
			cmp String_Palavra8[di], al
			je PALAVRA_CERTA
			jmp PALAVRA_INCORRETA
		
		VERIFICA_PALAVRA_A:
			cmp String_Palavra9[di], al
			je PALAVRA_CERTA
			cmp String_Palavra10[di], al
			je PALAVRA_CERTA
			cmp String_Palavra11[di], al
			je PALAVRA_CERTA
			cmp String_Palavra12[di], al
			je PALAVRA_CERTA
			cmp String_Palavra13[di], al
			je PALAVRA_CERTA
			cmp String_Palavra14[di], al
			je PALAVRA_CERTA
			cmp String_Palavra15[di], al
			je PALAVRA_CERTA
			cmp String_Palavra16[di], al
			je PALAVRA_CERTA
			cmp String_Palavra17[di], al
			je PALAVRA_CERTA
			cmp String_Palavra18[di], al
			je PALAVRA_CERTA
			cmp String_Palavra19[di], al
			je PALAVRA_CERTA
			cmp String_Palavra20[di], al
			je PALAVRA_CERTA
			jmp PALAVRA_INCORRETA
			
		PALAVRA_CERTA:
			inc palavraCerta
			inc di
			mov		cor, 17
			mov bl, 17
			mov 	ah, 09h
			mov		al, car
			mov		bh, 0
			mov		cx, 1
			int		10h
			call ADICIONARPONTOS
			ret			
			
		PALAVRA_INCORRETA:
			xor di, di
			mov		bl, cor
			not		bl
			mov		cor, bl
			mov 	ah, 09h
			mov		al, car
			mov		bh, 0
			mov		cx, 1
			int		10h
			inc palavraIncorreta
			ret
		
	VERIFICA_PALAVRA endp

	
;********************************************************************************
; GOTO_XY - MOVE A POSICAO DO CURSOR

	goto_xy	macro	POSy, POSx
		mov		ah,02h
		mov		bh,0		; nomeJogador da página
		mov		dh,POSy
		mov		dl,POSx
		int		10h
	endm


 ;********************************************************************************
   	
		
	APAGA_ECRAN	proc
		PUSH  BX
		PUSH  AX
		PUSH  CX
		PUSH  SI
		XOR	  BX,BX
		MOV	  CX,24*80
		mov   bx,160
		MOV   SI,BX
		
		
	APAGA:	
		MOV	 AL,' '
		MOV	 BYTE PTR ES:[BX],AL
		MOV	 BYTE PTR ES:[BX+1],7
		INC	 BX
		INC  BX
		INC  SI
		LOOP APAGA
		POP  SI
		POP  CX
		POP  AX
		POP  BX
		RET
		
		
    APAGA_ECRAN	endp


;********************************************************************************
; MOSTRA - Faz o display de uma string terminada em $


	MOSTRA MACRO STR 
		MOV AH,09H
		LEA DX,STR 
		INT 21H
	ENDM
	

	; FIM DAS MACROS
	

;********************************************************************************


    ADICIONAR_TOP10 proc
	      goto_xy    0,0
		  call       APAGA_ECRAN
		  call       RESETARJOGADOR
		  mov        si,0
		  mov        displacement,0
		  jmp        preencher
		  
		  
	PEQUENA_PONTUACAO:
	      call       APAGA_ECRAN
		  goto_xy    10,10
		  MOSTRA     pont_insuf
		  mov        ah,07h
		  int        21h
		  call       MAIN
		  
		  
	PEQUENA_PONTUACAO2:
	      cmp        si,270
		  jae        PEQUENA_PONTUACAO
		  add        si,30
		  add        displacement,30
		  
		  
	preencher:
	      call     EXTRAIR_NUMERO
		  mov      ax,extrair_pont
		  cmp      Pontuacao,ax
		  ;jbe      PEQUENA_PONTUACAO2
		  call     NPLAYER
		  lea      bx,buffer
		  mov      ax,Pontuacao
		  add      displacement,20
		  call     PRINTDIGITPLUS
		  lea      dx,FichTop10
		  lea      si,buffer
		  mov      tamanho_matriz,290
		  call     EXPORTARMATRIX
		  
	
	ADICIONAR_TOP10 endp

;********************************************************************************


	TOP10 proc
	    call APAGA_ECRAN
	    goto_xy 0,0
        lea dx, FichTop10  ; Colocar em dx o ficheiro com a lista do TOP10
		call IMP_FICH     ; Imprimir ficheiro
		
		mov ah,07h
		int 21h
		goto_xy 0,0
		call APAGA_ECRAN
		call Menu_Inicial
		
	SAIR:
	    call END_GAME


	TOP10 endp

	
;********************************************************************************	
		
		
    Menu_Inicial:
		mov Pontuacao, 0
		mov modoJogo, 0
	    call APAGA_ECRAN
		goto_xy		0,0
		xor	di, di
		lea			dx,FichMenu      	; Carregar para dx o ficheiro que queremos imprimir
		call		IMP_FICH  			; Imprimir o ficheiro

		mov  ah, 07h 					; Espera para que o utilizador insira um caracter
  		int  21h
  		cmp  al, '1' 					; Se inserir o numero 1
  		je   Menu_Niveis              	; Vai para o jogo
  		cmp  al, '2' 					; Se inserir o numero 2
  		je   TOP10 						; Vai para a lista do top10
		cmp  al, '3' 					; Se inserir o numero 3

		je   SAIR 						; Sai do programa
		call APAGA_ECRAN
		jmp  Menu_Inicial 	

;********************************************************************************
; Jogo - MENU NIVEIS

	Menu_Niveis:
		call APAGA_ECRAN
		goto_xy		0,0
		lea			dx,FichMenu_Niveis      	; Carregar para dx o ficheiro que queremos imprimir
		call		IMP_FICH  			; Imprimir o ficheiro

		mov  ah, 07h 					; Espera para que o utilizador insira um caracter
  		int  21h
  		cmp  al, '1' 					; Se inserir o numero 1
  		je   nivel_basico              	; Vai para o jogo
  		cmp  al, '2' 					; Se inserir o numero 2
  		je   nivel_avancado 						; Vai para o nivel avançado
		cmp  al, '3' 					; Se inserir o numero 3
		je   SAIR 						; Sai do programa
		call APAGA_ECRAN
		jmp  Menu_Niveis 	

	


;********************************************************************************
; Jogo - Nivel Básico


    nivel_basico:
		call APAGA_ECRAN
		goto_xy		0,0
	    lea  dx,FichJogo_B      	; Carregar para dx o ficheiro que queremos imprimir
		call IMP_FICH  
		mov minS[0], 0	
		mov minS[1], 0
		mov segS[0], 0	
		mov segS[1], 0
		mov Minutos, 0 ; iniciou o jogo
		mov Segundos, 0 ; iniciou o jogo
		mov modoJogo, 1
		call LER_TEMPO
		mov AX, Minutos
		mov MinutosInicial, AX
		mov AX, Segundos
		mov SegundosInicial, AX
		call LER_SETA
		call APAGA_ECRAN
		call WINNER
		call Menu_Inicial
	



;********************************************************************************
; Jogo - Nivel Avançado


    nivel_avancado:
		call APAGA_ECRAN
		goto_xy		0,0
	    lea  dx,FichJogo_A      	; Carregar para dx o ficheiro que queremos imprimir
		call IMP_FICH  
		mov minS[0], 0	
		mov minS[1], 0
		mov segS[0], 0	
		mov segS[1], 0
		mov Minutos, 0 ; iniciou o jogo
		mov Segundos, 0 ; iniciou o jogo
		mov modoJogo, 2
		call LER_TEMPO
		mov AX, Minutos
		mov MinutosInicial, AX
		mov AX, Segundos
		mov SegundosInicial, AX
		call LER_SETA
		call APAGA_ECRAN
		call WINNER
		call Menu_Inicial

	
;********************************************************************************

		
	IMP_FICH proc
        mov ah,3dh
		mov al,0
		int 21h
		jc ERRO_ABRIR
		mov handleFich,ax
		jmp LER_CICLO
		
		
	ERRO_ABRIR:
	    mov ah,09h
		lea dx,msgErrorOpen  
		int 21h
		jmp sai_f
		
	
	LER_CICLO:
        mov ah,3fh
        mov     bx,handleFich
        mov     cx,1
        lea     dx,carFich
        int     21h
		jc		erro_ler
		cmp		ax,0		
		je		FECHA_FICHEIRO
        mov     ah,02h
		mov		dl,carFich
		int		21h
		jmp		ler_ciclo		
		
		
	ERRO_LER:
	    mov     ah,09h
        lea     dx,msgErrorRead
        int     21h
		
		
	FECHA_FICHEIRO:
        mov     ah,3eh
        mov     bx,handleFich
        int     21h
        jnc     SAI_F
        mov     ah,09h
        lea     dx,msgErrorCloseRead
        Int     21h
		
		
	SAI_F:
	    RET
		
		
	IMP_FICH endp


;********************************************************************************


    ADICIONARPONTOS proc
	    goto_xy     3,66
		add         pontuacao, 10
		mov         ax, pontuacao
		call        PRINTDIGIT
		ret
		
		
	ADICIONARPONTOS endp


;********************************************************************************

    LER_TEMPO proc
	    PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		PUSHF
		MOV AH, 2CH             ; Ver Horas
		INT 21H                 
		XOR AX,AX
		MOV AL, DH              ; Mover os segundos para AL
		mov Segundos,AX
		XOR AX,AX
		MOV AL, CL              ; Mover os minutos para AL
		mov Minutos, AX         ; Guardar os minutos na respetiva variavel
		XOR AX,AX
		MOV AL, CH              ; Mover as horas para AL
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
 		RET 
    LER_TEMPO   endp
	
	
;********************************************************************************
     
    WINNER proc
	 
    FIM_JOGO_GANHO	:	 
		call APAGA_ECRAN
	    goto_xy	0,0   				;apaga o ecra a partir do 0 0
        lea  	dx,Player_Won   	;carregar para dx o ficheiro que queremos imprimir
        call 	IMP_FICH   			;imprimir o ficheiro
		goto_xy 23,68				; print da pontuacao
	    mov		ax,Pontuacao
	    call 	PRINTDIGIT
	    mov 	ah, 07h 			; Espera para que o utilizador insira um caracter
  	    int 	21h					
	    cmp     al,'1'
	    je      PLAY_AGAIN2
	    cmp     al,'2'
	    je      TOP10xx
	    cmp     al,'3'
	    je      LEAVE2
	    jmp     FIM_JOGO_GANHO
		
		
    TOP10xx:
	    call ADICIONAR_TOP10
		
		
    PLAY_AGAIN2:
	    call MAIN
		
		
    LEAVE2:
	    call END_GAME
		
		
    WINNER endp


;########################################################################
; IMPRIME O TEMPO E A DATA NO MONITOR

TRATA_HORAS_JOGO PROC

	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX		

	cmp 	modoJogo, 0
	je 		FIM_HORAS
	CALL 	LER_TEMPO				; Horas MINUTOS e segundos do Sistema
	
	MOV		AX, contaSeg
	;cmp		AX, Old_seg			; VErifica se os segundos mudaram desde a ultima leitura
	;je		FIM_HORAS			; Se a hora não mudou desde a última leitura sai.
	mov		Old_seg, AX			; Se segundos são diferentes actualiza informação do tempo

	mov      ax, Minutos          ; Load number1 in al  
      mov      bx, MinutosInicial          ; Load number2 in bl  
      sub      ax, bx  
	  mov		Minutos, ax
	  mov      ax, Segundos          ; Load number1 in al  
      mov      bx, SegundosInicial          ; Load number2 in bl
	  cmp		ax, bx
	  jb		segundos2  
      sub      ax, bx  
	  mov		Segundos, ax
	  jmp NEXT
	  
	segundos2:
	   mov	ax, 60
	   sub ax, bx
	   mov      ax, Segundos
	   add	bx, ax
	  mov		Segundos, bx
	  mov      ax, Minutos
	  sub	ax, 1
	  mov Minutos, ax
	  jmp NEXT
	
	NEXT:
		inc Segundos
	cmp Segundos, 60
	jb CONTINUA
	mov Segundos, 0
	inc Minutos
	cmp Minutos, 02
	jne CONTINUA
	mov Minutos, 0
	JMP ACABA_JOGO
	
	ACABA_JOGO:
		call Winner
		ret
	
	FIM_HORAS:		
		POPF
		POP DX		
		POP CX
		POP BX
		POP AX
		RET	
	
	CONTINUA:		
		mov 	ax,Minutos
		MOV 	bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
		MOV 	STR12[0],al			; 
		MOV 	STR12[1],ah
		MOV 	STR12[2],':'		
		MOV 	STR12[3],'$'
		goto_xy	2,66
		MOSTRA	STR12 		
		
		mov 	ax,Segundos
		MOV 	bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
		MOV 	STR12[0],al			; 
		MOV 	STR12[1],ah
		MOV 	STR12[2],'$'	
		goto_xy	2, 70
		MOSTRA	STR12 			
			
		goto_xy	POSy,POSx			; Volta a colocar o cursor onde estava antes de actualizar as horas
		jmp FIM_HORAS
		
TRATA_HORAS_JOGO ENDP


;********************************************************************************


; LE UMA TECLA	

    LE_TECLA	PROC
	sem_tecla:
		call 	TRATA_HORAS_JOGO
		mov ah, 0bh
		int 21h
		cmp al, 0
		je sem_tecla
		
		goto_xy POSy, POSx
		
		mov		ah,08h
		int		21h
		mov		ah,0
		cmp		al,0
		jne		SAI_TECLA
		mov		ah, 08h
		int		21h
		mov		ah,1
    
	SAI_TECLA:		RET
    
	LE_TECLA	endp

				
;********************************************************************************
; Assinala caracter no ecran	


    assinala_P	PROC

    CICLO_assinala:	
		; goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		; mov		ah, 02h
		; mov		dl, Car	; Repoe Caracter guardado 
		; int		21H		
		
		goto_xy	POSx,POSy	; Vai para nova posição
		mov 	ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al		; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah		; Guarda a cor que está na posição do Cursor
		goto_xy	POSx,POSy	; Vai para posição do cursor
		
		
    LER_SETA:		
		xor si, si
		call 	LE_TECLA
		cmp		ah, 1
		je		ESTEND
		CMP 	AL, 27	; ESCAPE
		JE		GAME_OVER
		CMP		AL, 13
		je		ASSINALA
		jmp		LER_SETA
		
    ESTEND:	
	    cmp 	al,48h
		jne		BAIXO
		dec		POSy		;cima
		jmp		CICLO_assinala

    BAIXO:	 
	    cmp		al,50h
		jne		ESQUERDA
		inc 	POSy		;Baixo
		jmp		CICLO_assinala

    ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		dec		POSx
		dec		POSx		;Esquerda
		jmp		CICLO_assinala
		
    DIREITA:
		cmp		al,4Dh
		jne		LER_SETA 
		inc		POSx
		inc		POSx		;Direita
		jmp		CICLO_assinala

				; INT 10,9 - Write Character and Attribute at Cursor Position
				; AH = 09
				; AL = ASCII character to write
				; BH = display page  (or mode 13h, background pixel value)
				; BL = character attribute (text) foreground color (graphics)
				; CX = count of characters to write (CX >= 1)		
				
    ASSINALA:
		call ADICIONA_LETRA
		goto_xy POSy, POSx
		jmp		CICLO_assinala
	
	assinala_P	endp
	
;****************************************************************************s****


    GAME_OVER proc
	
	FIM_JOGO_PERDIDO:
	    call	APAGA_ECRAN
	    goto_xy	0,0   				;apaga o ecra a partir do 0 0
        lea  	dx,Jogo_Acabou		;carregar para dx o ficheiro que queremos imprimir
        call 	IMP_FICH  			;imprimir o ficheiro
	    goto_xy 23,68				; print da pontuacao
	    mov		ax,Pontuacao
	    call 	PRINTDIGIT
	    mov  	ah, 07h 			; Espera para que o utilizador insira um caracter
  	    int  	21h
	    cmp     al,'1'
	    je      PLAY_AGAIN
	    cmp     al,'2'	
	    je      TOP10x
	    cmp     al,'3'
	    je      LEAVE1
	    jmp     FIM_JOGO_PERDIDO

    TOP10x:
	call ADICIONAR_TOP10
    
	PLAY_AGAIN:
	call MAIN

    LEAVE1:
	call END_GAME
 
    GAME_OVER endp
        
	
;********************************************************************************


    RESETARJOGADOR proc
	       mov    bx,0
		   mov    cx,10
	
	RESET_PLAYER:
	       mov     Nome_Jogador[bx],' '
		   inc     bx
		   loop    RESET_PLAYER
		   ret
		  	  
	RESETARJOGADOR endp


;********************************************************************************

    EXPORTARMATRIX proc
		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro 	
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escrever			; Se não existir erro escreve no ficheiro				; handle é tipo, apontar para o sitio onde está a memória	
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
		jmp		fim_EXPORTARMATRIX
	
    escrever:
		mov		bx, ax				; Coloca em BX o Handle
    	mov		ah, 40h				; indica que é para escrever
		mov		dx, si				; DX aponta para a infromação a escrever
    	mov		cx, tamanho_matriz	; CX fica com o numero de bytes a escrever
		int		21h					; Chama a rotina de escrita
		jnc		fechar				; Se não existir erro na escrita fecha o ficheiro
		mov		ah, 09h
		lea		dx, msgErrorWrite
		int		21h
		
    fechar:
		mov		ah,3eh				; fecha o ficheiro
		int		21h
		jnc		fim_EXPORTARMATRIX
		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h
		
    fim_EXPORTARMATRIX:
		ret

    EXPORTARMATRIX endp


;********************************************************************************


    EXTRAIR_NUMERO proc
	      push  si
	      xor   si,si
	      mov	di,1
	      xor   ax,ax
	      xor   dx,dx
	      mov   extrair_pont,0
	      add   displacement,19			
	      mov   si,displacement

    BOM:
	      goto_xy 0,0
 	      lea     bx,buffer
       	  mov     dl, [bx+si]			
	      mov     ah, 02h 			
	      int     21h				
          sub	  al,'0'		    
	      mov	  ah,0 				
	      mul	  di				
      	  add	  extrair_pont,ax
	      sub	  si,1
	      cmp     buffer[si],' '
	      je	  EM
	      mov     ax,10				
	      mul	  di
	      mov	  di,ax
	      jmp	  BOM

    EM:
	     sub   displacement,19		
     	 pop   si
	     ret
    
	EXTRAIR_NUMERO endp
	

;********************************************************************************


    PRINTDIGIT proc
	    mov cx,0
        mov dx,0
	    cmp ax,0			; Verifica se tem 0
	    je	SAIDA1_PRINTDIGIT
		
    PART1_PRINTDIGIT:
    	cmp ax,0		; Verifica se ax = 0
        je PRINT1_PRINTDIGIT
        mov bx,10       ; bx inicializa a 10
        div bx 			; Extrair último digito
        push dx 		; Guarda o mesmo na stack
        inc cx 			; Incrementar o contador 
        xor dx,dx		; Colocar dx a zeros
        jmp PART1_PRINTDIGIT
		
    PRINT1_PRINTDIGIT:
        cmp cx,0		; Verificar se cx = 0
        je SAIDA1_PRINTDIGIT
        pop dx 			 
        add dx,48		 
        mov ah,02h		
        int 21h
        dec cx			
        jmp PRINT1_PRINTDIGIT

    SAIDA1_PRINTDIGIT:
		mov dx,'0'
		mov ah,02h
        int 21h

    SAIDA_PRINTDIGIT:
		mov dx,' '
		mov ah,02h		; para dar print de um espaço no fim caso fique com menos um digito
        int 21h
		RET

    PRINTDIGIT ENDP


;********************************************************************************


    PRINTDIGITPLUS proc
	    mov   cx,0
        mov   dx,0
	    cmp   ax,0			
	    je	  SAIDA1
			
    PART1:
    	cmp   ax,0		
        je    PRINT1
        mov   bx,10      
        div   bx 			
		pop   bx
        push  dx 		
        inc   cx 			
        xor   dx,dx		
        jmp   PART1
		
    PRINT1:
        cmp    cx,0		
        je     SAIDA
        pop    dx 			 
        add    dx,48		 
        mov    si,displacement
        sub    si,cx
        mov    [bx+si],dl		
        int    21h
        dec    cx			
        jmp    PRINT1

    SAIDA1:
		mov dx,'0'
		mov ah,02h
        int 21h

    SAIDA:
		mov dx,' '
		mov ah,02h		
        int 21h
		RET

    PRINTDIGITPLUS ENDP
	

;********************************************************************************
	
	
	END_GAME proc
		call		APAGA_ECRAN
        goto_xy 	0,0
		mov			ah,4CH   	
		INT			21H   		; Interruptor para sair
    END_GAME endp
	
	
;********************************************************************************




    NPLAYER proc                                     ; Introduzir nome de utilizador
	      xor si,si
	      mov cx,10					
	      mov bx,displacement			

    res_player:						
	      mov       buffer[bx+si],' '		
	      inc       si						
	      loop      res_player				
	      xor       si,si
	      goto_xy   10,10
	      mostra    introduzir_nome
	      mov       POSxplayer,29
	      mov       POSyplayer,10

    jogador:
	     goto_xy   POSxplayer ,POSyplayer 
	     mov       ah,07h
  	     int       21h

    ciclo_NPLAYER:	
		 CMP 	AL, 27	; ESCAPE
		 call	Menu_Inicial
	     cmp    al ,0DH
	     je     sos
	     cmp    al,'A'
	     jb     jogador
	     cmp    al,'Z'
	     ja     jogador
	     jmp    letra

    letra:
	     mov    nomeplayerText[si],al
	     mov    bx,displacement
	     mov    buffer[si+bx],al		; salva o input na matriz buffer
      	 inc    si
	     cmp    si, 10
	     je     sos
	     jmp    nic

    nic:
	     goto_xy    29 ,10
	     mostra     nomeplayerTEXT
	     inc        POSxplayer
	     jmp        NPLAYER

    sos:
	     RET
		 
    NPLAYER endp
	
			  
;********************************************************************************
main  proc
		mov     ax, dseg
		mov     ds, ax
		mov		ax,0B800h
		mov		es,ax

		call APAGA_ECRAN
		call Menu_Inicial

					
Fim:
	mov		ah,4CH
	INT		21H
Main	endp
cseg ends
end  main