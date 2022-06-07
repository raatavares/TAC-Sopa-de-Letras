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