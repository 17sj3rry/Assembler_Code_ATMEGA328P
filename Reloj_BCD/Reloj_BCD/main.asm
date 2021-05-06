;
; Reloj_BCD.asm
;
; Created: 04/05/2021 10:15:52 p. m.
; Author : pablo
;

.def register = r16
.def Q_show = r23

.def minsx1 = r20
.def minsx10 = r21  ;Variable para contar minutos x 10
.def hrsx1 = r22	;Variable para contar horas x 1
.def hrsx10 = r24	;Variable para contar horas x 10
//-------------------------------------------------------------
//               ZONA DE VECTORES DE DIRECCION
//-------------------------------------------------------------

.org $00
 jmp SETUP	;Vamos a declarar una primera direccion a donde el programa vaya para la ejecuccion
						;Continua hasta la parte C(1).

//-------------------------------------------------------------
//               ZONA DE CODIGO(PREPARACION)
//-------------------------------------------------------------
; Replace with your application code
SETUP:      ldi register, high(RAMEND)	;INICIAMOS EL APUNTADOR DE STACK
            out SPH, register
            ldi register, low(RAMEND)
            out SPL, register    

			ldi register,$ff
			out ddrd,register

			ldi register,$7f
			out ddrc,register

Clock_loop:

	clr minsx1
	clr minsx10
	clr hrsx1
	clr hrsx10
		
		mins1:
			rcall Delay_min
			inc minsx1
			cpi minsx1,$0A
			breq mins10
			brne mins1
	
		mins10:
			clr minsx1
			inc minsx10
			cpi minsx10,$06
			breq hrs1
			brne mins1

		hrs1:
			inc hrsx1
			cpi hrsx1,$0A
			breq hrs10
			brne mins1

		hrs10:
			inc hrsx10
			cpi hrsx10,$02
			breq Clock_loop
			brne mins1
Delay_min:
			ldi r26,$2F
	LOOP1:	ldi r25,$1F
	LOOP3:  ldi r27,$1F

		mov register,minsx1
		rcall binBCD
		out portd,register
		ldi Q_show,$08
		out portc,Q_show
		rcall Delay_Dis

		mov register,minsx10
		rcall binBCD
		out portd,register
		ldi Q_show,$04
		out portc,Q_show
		rcall Delay_Dis

		mov register,hrsx1
		rcall binBCD
		out portd,register
		ldi Q_show,$02
		out portc,Q_show
		rcall Delay_Dis

		mov register,hrsx1
		rcall binBCD
		out portd,register
		ldi Q_show,$01
		out portc,Q_show
		rcall Delay_Dis
		
	LOOP2:	dec r27
		brne LOOP2
		dec r25
		brne LOOP3
		dec r26
		brne LOOP1

		 ret

Delay_Dis:
	; delaying 199998 cycles:
          ldi  R17, $06;06
WGLOOP0:  ldi  R18, $c7;17
WGLOOP1:  ldi  R19, $c9;19
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
		  RET	

binBCD:
cero:
	cpi register,$00
	breq convcero
	rjmp uno
convcero:			;ANODO		CATODO
	ldi register,$7E;01              ; 7E
	ret

uno:
	cpi register,$01				
	breq convuno
	rjmp dos
convuno:		
	ldi register,$30;4F				;30
	ret

dos:
	cpi register,$02
	breq convdos
	rjmp tres
convdos:		
	ldi register,$6D;12				;6D
	ret

tres:
	cpi register,$03
	breq convtres
	rjmp cuatro
convtres:
	ldi register,$79;06				;79
	ret

cuatro:
	cpi register,$04
	breq convcuatro
	rjmp cinco
convcuatro:
	ldi register,$33;4C				;33
	ret

cinco:
	cpi register,$05
	breq convcinco
	rjmp seis
convcinco:
	ldi register,$5B;24				;5B
	ret

seis:
	cpi register,$06
	breq convseis
	rjmp siete
convseis:
	ldi register,$1F;60			;1F
	ret

siete:
	cpi register,$07
	breq convsiete
	rjmp ocho
convsiete:
	ldi register,$70;0F				;70
	ret

ocho:
	cpi register,$08
	breq convocho
	rjmp nueve
convocho:
	ldi register,$7F;00				;7F
	ret

nueve:
	cpi register,$09
	breq convnueve
	rjmp salir
convnueve:
	ldi register,$73;0C				;73
	ret

salir:
	ret