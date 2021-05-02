;
; CONVERTIDOR_BCD.asm
;
; Created: 29/04/2021 04:27:33 p. m.
; Author : pablo
//-------------------------------------------------------------
//               ZONA DE DEFINICIONES
//-------------------------------------------------------------
.def register = r16		;Variable para guardar cosas en general

.def centenas = r17		;Constante de valor 100
.def decenas = r18		;Constante de valor 10

.def cont_cen = r20		;Variable que almacena las veces en que fue restado el numero 100
.def cont_dec = r21		;Variable que almacena las veces en que fue restado el numero 100

.def Q_show = r23		;Variable para encender los displays

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

			ldi register,$00
			out ddrb,register

			
			;Esto nos servira para ir restando al numero introduccido
//-------------------------------------------------------------
//               ZONA DE CODIGO(DESENPAQUETADOR)
//-------------------------------------------------------------
Decod:
	clr cont_cen
	clr cont_dec
	clr register
	ldi centenas,100	;Cargamos un 100
	ldi decenas,10		;Cargamos un 10
	cent:	in register,pinb
		dec_cent:
			sub register,centenas
			brlo decen
			inc cont_cen
			jmp dec_cent
   decen:
		add register,centenas
		dec_dec:
			sub register,decenas
			brlo unis
			inc cont_dec
			jmp dec_dec 
//-------------------------------------------------------------
//               ZONA DE CODIGO(MUESTRA DE RESULTADOS)
//-------------------------------------------------------------

  unis:
  		
		add register,decenas

		sts $100,register
		sts $101,cont_dec
		sts $102,cont_cen

Output:
		lds register,$102
		rcall binBCD
		out portd,register
		ldi Q_show,$01
		out portc,Q_show
		rcall delay

		lds register,$101
		rcall binBCD
		out portd,register
		ldi Q_show,$02
		out portc,Q_show
		rcall delay

		lds register,$100
		rcall binBCD
		out portd,register
		ldi Q_show,$04
		out portc,Q_show
		rcall delay


		rjmp Decod
//-------------------------------------------------------------
//               ZONA DE DELAY
//-------------------------------------------------------------
delay:
; delaying 199998 cycles:
          ldi  R17, $06;06
WGLOOP0:  ldi  R18, $17;37
WGLOOP1:  ldi  R19, $19;c9
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
		  RET				;Retornamos a la funcion donde nos quedamos


binBCD:
cero:
	cpi register,$00
	breq convcero
	rjmp uno
convcero:			;CATODO			ANODO 
	ldi register,$01;01              ; 7E
	ret

uno:
	cpi register,$01				
	breq convuno
	rjmp dos
convuno:		
	ldi register,$4F;4F				;30
	ret

dos:
	cpi register,$02
	breq convdos
	rjmp tres
convdos:		
	ldi register,$12;12				;6D
	ret

tres:
	cpi register,$03
	breq convtres
	rjmp cuatro
convtres:
	ldi register,$06;06				;79
	ret

cuatro:
	cpi register,$04
	breq convcuatro
	rjmp cinco
convcuatro:
	ldi register,$4C;4C				;33
	ret

cinco:
	cpi register,$05
	breq convcinco
	rjmp seis
convcinco:
	ldi register,$24;24				;5B
	ret

seis:
	cpi register,$06
	breq convseis
	rjmp siete
convseis:
	ldi register,$60;1F				;1F
	ret

siete:
	cpi register,$07
	breq convsiete
	rjmp ocho
convsiete:
	ldi register,$0F;0F				;70
	ret

ocho:
	cpi register,$08
	breq convocho
	rjmp nueve
convocho:
	ldi register,$00;00				;7F
	ret

nueve:
	cpi register,$09
	breq convnueve
	rjmp salir
convnueve:
	ldi register,$0C;0C				;73
	ret

salir:
	ret
	
//-------------------------------------------------------------
//              FIN DEL PROGRAMA
//-------------------------------------------------------------
