.8086
.model small
.stack 2048

; PILHA

PILHA	SEGMENT PARA STACK 'STACK'
		db 2048 dup(?)
PILHA	ENDS


dseg	segment para public 'data'

    MenuOptions db "                                                          ",13,10
				db "                    **************************************",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    *   1. Jogar                         *",13,10
				db "                    *   2. Top 10                        *",13,10
				db "                    *   3. Sair                          *",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    **************************************",13,10
				db "                                                          ",13,10
				db "                                                          ",13,10
				db "                                                          ",13,10,'$'
				

	FINALGANHO       db "                                                          ",13,10
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
	String_TJ		db		"     / 100$"
	
	
	; FICHEIROS
	
	Erro_Open       db      'Erro ao tentar iniciar o jogo$'
	FichTabela             db      'PAINEL.txt',0
	FichTop10           db      'TOP10.txt',0
	