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

		lds register,$102
		out portd,register
		ldi Q_show,$01
		out portc,Q_show
		rcall delay

		lds register,$101
		out portd,register
		ldi Q_show,$02
		out portc,Q_show
		rcall delay

		lds register,$100
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
          ldi  R17, $01;06
WGLOOP0:  ldi  R18, $01;37
WGLOOP1:  ldi  R19, $01;c9
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
		  RET				;Retornamos a la funcion donde nos quedamos
//-------------------------------------------------------------
//              FIN DEL PROGRAMA
//-------------------------------------------------------------
