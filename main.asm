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



    ; CONTADOR
	
	
	timer			dw 	    0				; Contador de tempo
	Horas			dw		0				; Guarda a hora atual
	Minutos			dw		0				; Guarda os minutos actuais
	Segundos		dw		0				; Guarda os segundos actuais
	Dia_Mes_Ano     db      "              "
	Old_seg			dw		0				; Guarda os ultimos segundos que foram lidos
	Tempo_init		dw		0				; Guarda o tempo de inicio do jogo
	Tempo_j			dw		-1				; Guarda o tempo que decorre o jogo
	Tempo_limite	dw		100				; Tempo maximo de Jogo
	String_TJ		db		"     / 100$"
	Pontuacao       dw      500             ; Guarda a pontuação do jogador
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
	; FICHEIROS
	
	FichMenu		db		'menu.txt',0
	Erro_Open      	db      'Erro ao tentar iniciar o jogo$'
	FichJogo_A      db      'JogoA.txt',0
	FichJogo_B      db      'JogoB.txt',0
	FichTop10       db      'TOP10.txt',0
	Player_Won      db      'WINNER.txt',0
	Jogo_Acabou     db      'LOSER.txt',0
	
	handleFich 		dw      0
	carFich			db      ?
	
	
	; mensagens de erro ficheiros
	msgErrorOpen       	db	"Erro ao tentar abrir o ficheiro$"
	msgErrorRead    	db	"Erro ao tentar ler o ficheiro$"
    msgErrorCloseRead	db	"Erro ao tentar fechar o ficheiro$"
	msgErrorCreate      db  "Erro na criacao do ficheiro$"
	msgErrorWrite       db  "Erro na escrita do ficheiro$"
	msgErrorClose       db  "Erro no fecho do ficheiro$"
	

	
dseg ENDS

cseg segment para public 'code'
     assume cs:cseg, ds:dseg
	 
	;MAIN PROC FAR
	;
	;	MOV AH,00h	;set the configuration to video mode		
	;	MOV AL,13h	;choose the video mode
	;	INT 10h		;execute the configuration
	;	
	;	MOV AH,0Bh	;set the configuration
	;	MOV BH,00h	;to the background color
	;	MOV BL,00h	;choose the backgroung color
	;	INT 10h		;execute the configuration
	;	
	;	
	;	RET
	;MAIN ENDP
	
	
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
			PUSH BX
		PUSH AX
		PUSH CX
		PUSH SI
		XOR	BX,BX
		MOV	CX,24*80
		mov bx,160
		MOV SI,BX
	APAGA:	
		MOV	AL,' '
		MOV	BYTE PTR ES:[BX],AL
		MOV	BYTE PTR ES:[BX+1],7
		INC	BX
		INC BX
		INC SI
		LOOP	APAGA
		POP SI
		POP CX
		POP AX
		POP BX
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
	
		
	LE_MENU	proc
		mov     ah,3dh					; vamos abrir ficheiro para leitura 
		mov     al,0					; tipo de ficheiro	
		lea     dx,FichMenu				; nome do ficheiro
		int     21h						; abre para leitura 
		jc      ERRO_ABRIR_MENU				; pode aconter erro a abrir o ficheiro 
		mov     handleFich,ax			; ax devolve o Handle para o ficheiro 
		jmp     LER_CICLO_MENU				; depois de abero vamos ler o ficheiro 

	ERRO_ABRIR_MENU:
		mov     ah,09h
		lea     dx,msgErrorOpen
		int     21h
		jmp     SAI

	LER_CICLO_MENU:
		mov     ah,3fh				; indica que vai ser lido um ficheiro 
		mov     bx,handleFich		; bx deve conter o Handle do ficheiro previamente aberto 
		mov     cx,1				; nomeJogador de bytes a ler 
		lea     dx,carFich			; vai ler para o local de memoria apontado por dx (carFich)
		int     21h					; faz efectivamente a leitura
		jc	    ERRO_LER_MENU			; se carry � porque aconteceu um erro
		cmp	    ax,0				;EOF?	verifica se j� estamos no fim do ficheiro 
		je	    FECHA_FICHEIRO_MENU		; se EOF fecha o ficheiro 
		mov     ah,02h				; coloca o caracter no ecran
		mov	    dl,carFich			; este � o caracter a enviar para o ecran
		int	    21h					; imprime no ecran
		jmp	    LER_CICLO_MENU			; continua a ler o ficheiro

	ERRO_LER_MENU:
		mov     ah,09h
		lea     dx,msgErrorRead
		int     21h

		FECHA_FICHEIRO_MENU:					; vamos fechar o ficheiro 
		mov     ah,3eh
		mov     bx,handleFich
		int     21h
		jnc     SAI

		mov     ah,09h			; o ficheiro pode não fechar correctamente
		lea     dx,msgErrorCloseRead
		Int     21h
	SAI:
	;	mov 	STR12[0], 190
	;	mov 	STR12[1], '$'
	;	GOTO_XY 10,56
	;	MOSTRA STR12
	;	mov 	STR12[0], 195
	;	mov 	STR12[1], '$'
	;	GOTO_XY 10,59
	;	MOSTRA STR12
	;	mov 	STR12[0], 197
	;	mov 	STR12[1], '$'
	;	GOTO_XY 10,62
	;	MOSTRA STR12
	;	mov 	STR12[0], 189
	;	mov 	STR12[1], '$'
	;	GOTO_XY 10,65
	;	MOSTRA STR12
		
		GOTO_XY POSy,POSx
		ret
	LE_MENU	endp
		
				
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
		goto_xy	78,0		; Mostra o caractereque estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		goto_xy	POSx,POSy	; Vai para posição do cursor
		
		
    IMPRIME:	
		; mov		ah, 02h
		; mov		dl, 190		; Coloca AVATAR
		; int		21H	
		; goto_xy	POSx,POSy	; Vai para posição do cursor
		
		; mov		al, POSx	; Guarda a posição do cursor	
		; mov		POSxa, al
		; mov		al, POSy	; Guarda a posição do cursor
		; mov 	POSya, al
		
		
    LER_SETA:	
		call 	LE_TECLA
		cmp		ah, 1
		je		ESTEND
		CMP 	AL, 27	; ESCAPE
		JE		fim_assinala
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
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda
		jmp		CICLO_assinala
		

    DIREITA:
		cmp		al,4Dh
		jne		LER_SETA 
		inc		POSx		;Direita
		inc		POSx		;Direita
		jmp		CICLO_assinala

				; INT 10,9 - Write Character and Attribute at Cursor Position
				; AH = 09
				; AL = ASCII character to write
				; BH = display page  (or mode 13h, background pixel value)
				; BL = character attribute (text) foreground color (graphics)
				; CX = count of characters to write (CX >= 1)
				
				
    ASSINALA:
		mov		bl, cor
		not		bl
		mov		cor, bl
		mov 	ah, 09h
		mov		al, car
		mov		bh, 0
		mov		cx, 1
		int		10h
		jmp		CICLO_assinala
    
	
	fim_assinala:	
		RET
    
	
	assinala_P	endp




	
;********************************************************************************	
		
		
    Menu_Inicial:
	    call APAGA_ECRAN
		goto_xy		0,0
		lea			dx,FichMenu      	; Carregar para dx o ficheiro que queremos imprimir
		call		IMP_FICH  			; Imprimir o ficheiro

		mov  ah, 07h 					; Espera para que o utilizador insira um caracter
  		int  21h
  		cmp  al, '1' 					; Se inserir o numero 1
  		je   nivel_basico              	; Vai para o jogo
  		cmp  al, '2' 					; Se inserir o numero 2
  		je   TOP10 						; Vai para a lista do top10
		cmp  al, '3' 					; Se inserir o numero 3
		je   SAIR 						; Sai do programa
		call APAGA_ECRAN
		jmp  Menu_Inicial 	


;********************************************************************************
; Jogo - Nivel Básico


    nivel_basico:
		call APAGA_ECRAN
		goto_xy		0,0
	    lea  dx,FichJogo_B      	; Carregar para dx o ficheiro que queremos imprimir
		call IMP_FICH  
		call LER_SETA





;********************************************************************************
; Jogo - Nivel Avançado


    ;nivel_avancado:






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
	    goto_xy     POSpontosx,POSpontosy
		add         pontuacao, 750
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
		mov Horas,AX			; Guardar as horas na respetiva variavel
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
 		RET 
    LER_TEMPO   endp
	
	
;********************************************************************************
     
    WINNER proc
	 
    FIM_JOGO_GANHO:	 
		call APAGA_ECRAN
	    goto_xy	0,0   				;apaga o ecra a partir do 0 0
        lea  	dx,Player_Won   	;carregar para dx o ficheiro que queremos imprimir
        call 	IMP_FICH   			;imprimir o ficheiro
        goto_xy 45,22				; print da pontuacao
	    mov		ax,Pontuacao
	    call 	PRINTDIGIT
	    goto_xy 70,22				; print do nivel
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


;********************************************************************************
; TEMPO - Analisa a data do sistema e coloca numa string com a forma DD/MM/AAAA
; CX - Ano | DH - Mês | DL - Dia


   TEMPO proc
        push      ax
		push      bx
		push      cx
		push      dx
		push      si
		pushf
		mov       ah, 2ah   ; Procurar a data
		int       21h
		push      cx        ; Ano -> Pilha
		xor       cx, cx    ; Limpar CX
		mov       cl, dl    ; Mês = CL
		push      cx        ; Mês -> Pilha
		mov       cl, dl    ; Dia = CL
		push      cx        ; Dia -> Pilha
		xor       dh, dh
		xor       si, si
		
		
; Tratamento do DIA:


        xor       dx, dx    ; Limpa DX
		pop       ax        ; Tirar dia da pilha
		mov       cx, 0
		mov       bx, 10
		mov       cx, 2
		
		
	DIVISOR_DIA:
	    div       bx        ; Divide por 10
		push      dx
		mov       dx, 0
		loop      DIVISOR_DIA
		mov       cx, 2
		
		
	RESTO_DIA: 
	    pop       dx                         ; Resto da divisão
		add       dl, 30h
		mov       Dia_Mes_Ano[si], dl
		inc       si
		loop      RESTO_DIA
		mov       dl, '/'                    ; Separador
		mov       Dia_Mes_Ano[si], dl
		inc       si
		
		
; Tratamento do MÊS


        mov       dx, 0
		pop       ax
		xor       cx, cx
		mov       bx, 10
		mov       cx, 2
		
		
	DIVISOR_MES:
	    div       bx
		push      dx
		mov       dx, 0
		loop      DIVISOR_MES
		mov       cx, 2
		
		
	RESTO_MES:
	    pop       dx
		add       dl, 30h
		mov       Dia_Mes_Ano[si], dl
		inc       si
		loop      RESTO_MES
		mov       dl, '/'
		mov       Dia_Mes_Ano[si], dl
		inc       si
		
		
; Tratamento do ANO


        mov       dx, 0
		pop       ax
		mov       cx, 0
		mov       bx, 10
		
		
	DIVISOR_ANO:
	    div       bx
		push      dx
		add       cx, 1
		mov       dx, 0
		cmp       ax, 0
		jne       DIVISOR_ANO
		
		
	RESTO_ANO:
	    pop       dx
		add       dl, 30h
		mov       Dia_Mes_Ano[si], dl
		inc       si
		loop      RESTO_ANO
		popf
		pop       si
		pop       dx
		pop       cx
		pop       bx
		pop       ax
		ret
		
		
	TEMPO endp


;********************************************************************************
; MOVER_PONTOS - Substituir pontos no jogo


    MOVER_PONTOS proc 
	    cmp  pontuacao, 15
		jbe  MINIMO_PONTOS
		sub  pontuacao, 1
		
	
	MINIMO_PONTOS:
	    goto_xy  POSpontosx, POSpontosy
		mov      ax, pontuacao
		call     PRINTDIGIT
		ret
		
		
	MOVER_PONTOS endp


;********************************************************************************


; LE UMA TECLA	

    LE_TECLA	PROC

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


    GAME_OVER proc
	
	FIM_JOGO_PERDIDO:
	    call	APAGA_ECRAN
	    goto_xy	0,0   				;apaga o ecra a partir do 0 0
        lea  	dx,Jogo_Acabou		;carregar para dx o ficheiro que queremos imprimir
        call 	IMP_FICH  			;imprimir o ficheiro
	    goto_xy 45,22				; print da pontuacao
	    mov		ax,Pontuacao
	    call 	PRINTDIGIT
	    goto_xy 70,22				; print do nivel
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
		  jbe      PEQUENA_PONTUACAO2
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