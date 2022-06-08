STACK SEGMENT PARA STACK
	DB 64 DUP (' ')
STACK ENDS

dseg SEGMENT PARA 'DATA'
	
	POSy		db	2	; a linha pode ir de [1 .. 25]
	POSx		db	6	; POSx pode ir [1..80]
	STR12	 	DB 		"            "	; String para 12 digitos

	FINALGANHO  db "                                                          ",13,10
				db "                    **************************************",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    *          Acabou - Parabens!        *",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    **************************************",13,10
				db "                                                          ",13,10
				db "                                                          ",13,10,'$'
			

	FINALPERDEU db "                                                          ",13,10
				db "                    **************************************",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    *           Acabou o tempo!          *",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    **************************************",13,10
				db "                                                          ",13,10
				db "                                                          ",13,10,'$'
				
				
	Bem_Vindo	db "Bem-vindo ao jogo",13,10
				db "Prima qualquer tecla para continuar...",13,10,'$'
				
				
				
				


    ; CONTADOR
	
	timer			dw 	    0				; Contador de tempo
	Horas			dw		0				; Guarda a hora atual
	Minutos			dw		0				; Guarda os minutos actuais
	Segundos		dw		0				; Guarda os segundos actuais
	Old_seg			dw		0				; Guarda os ultimos segundos que foram lidos
	Tempo_init		dw		0				; Guarda o tempo de inicio do jogo
	Tempo_j			dw		-1				; Guarda o tempo que decorre o jogo
	Tempo_limite	dw		100				; Tempo maximo de Jogo
	String_TJ		db		"     / 100$"
	
	
	; FICHEIROS
	
	FichMenu		db		'menu.txt',0
	Erro_Open      	db      'Erro ao tentar iniciar o jogo$'
	FichTabela      db      'PAINEL.txt',0
	FichTop10       db      'TOP10.txt',0
	Player_Won      db      'WINNER.txt',0
	Jogo_Acabou     db      'LOSER.txt'
	
	handleFich 		dw      0
	carFich			db      ?
	
	
	; mensagens de erro ler ficheiros
	msgErrorOpen       	db	"Erro ao tentar abrir o ficheiro$"
	msgErrorRead    	db	"Erro ao tentar ler o ficheiro$"
    msgErrorCloseRead	db	"Erro ao tentar fechar o ficheiro$"
	
	
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
	
	
	;########################################################################
	; GOTO_XY - MOVE A POSICAO DO CURSOR

	goto_xy	macro	POSy, POSx
		mov		ah,02h
		mov		bh,0		; nomeJogador da p�gina
		mov		dh,POSy
		mov		dl,POSx
		int		10h
	endm


	;########################################################################
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
		jc      ERRO_ABRIR				; pode aconter erro a abrir o ficheiro 
		mov     handleFich,ax			; ax devolve o Handle para o ficheiro 
		jmp     LER_CICLO				; depois de abero vamos ler o ficheiro 

	ERRO_ABRIR:
		mov     ah,09h
		lea     dx,msgErrorOpen
		int     21h
		jmp     SAI

	LER_CICLO:
		mov     ah,3fh				; indica que vai ser lido um ficheiro 
		mov     bx,handleFich		; bx deve conter o Handle do ficheiro previamente aberto 
		mov     cx,1				; nomeJogador de bytes a ler 
		lea     dx,carFich			; vai ler para o local de memoria apontado por dx (carFich)
		int     21h					; faz efectivamente a leitura
		jc	    ERRO_LER			; se carry � porque aconteceu um erro
		cmp	    ax,0				;EOF?	verifica se j� estamos no fim do ficheiro 
		je	    FECHA_FICHEIRO		; se EOF fecha o ficheiro 
		mov     ah,02h				; coloca o caracter no ecran
		mov	    dl,carFich			; este � o caracter a enviar para o ecran
		int	    21h					; imprime no ecran
		jmp	    LER_CICLO			; continua a ler o ficheiro

	ERRO_LER:
		mov     ah,09h
		lea     dx,msgErrorRead
		int     21h

		FECHA_FICHEIRO:					; vamos fechar o ficheiro 
		mov     ah,3eh
		mov     bx,handleFich
		int     21h
		jnc     SAI

		mov     ah,09h			; o ficheiro pode não fechar correctamente
		lea     dx,msgErrorCloseRead
		Int     21h
	SAI:
		mov 	STR12[0], 190
		mov 	STR12[1], '$'
		GOTO_XY 10,56
		MOSTRA STR12
		mov 	STR12[0], 195
		mov 	STR12[1], '$'
		GOTO_XY 10,59
		MOSTRA STR12
		mov 	STR12[0], 197
		mov 	STR12[1], '$'
		GOTO_XY 10,62
		MOSTRA STR12
		mov 	STR12[0], 189
		mov 	STR12[1], '$'
		GOTO_XY 10,65
		MOSTRA STR12
		
		GOTO_XY POSy,POSx
		ret
	LE_MENU	endp
		
	
	main  proc
		mov     ax, dseg
		mov     ds, ax
		mov		ax,0B800h
		mov		es,ax

		;**** Inserir codigo
		CALL LE_MENU
		
		
;********************************************************************************		
		
		
	TOP10:
	    call apaga_ecran
	    goto_xy 0,0
        lea dx, FichTop10  ; Colocar em dx o ficheiro com a lista do TOP10
		call IMP_FICH      ; Imprimir ficheiro
		
		mov ah,07h
		int 21h
		call main
		
	sair: 
	
	    call END_GAME
		
	main endp
	
	
;********************************************************************************

		
	IMP_FICH proc:
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
        jnc     SAI

        mov     ah,09h
        lea     dx,msgErrorCloseRead
        Int     21h
		
		
	SAI_F:
	    RET
		
		
	IMP_FICH endp


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
        	
		
	APAGA_ECRAN	proc
		mov		ax,0B800h
		mov		es,ax
		xor		bx,bx
		mov		cx,25*80
		
    APAGA:	
	    mov		byte ptr es:[bx],' '
		mov		byte ptr es:[bx+1],7
		inc		bx
		inc 	bx
		loop	APAGA
		ret
    APAGA_ECRAN	endp


;********************************************************************************
	
	
	END_GAME proc
		call		apaga_ecran
        goto_xy 	0,0
		mov			ah,4CH   	
		INT			21H   		; Interruptor para sair
    END_GAME endp
	
	
;********************************************************************************


Fim:
	mov		ah,4CH
	INT		21H
Main	endp
cseg ends
end  main