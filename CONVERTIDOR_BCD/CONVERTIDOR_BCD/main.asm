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

<<<<<<< HEAD
.org $00
 jmp SETUP	;Vamos a declarar una primera direccion a donde el programa vaya para la ejecuccion
=======
.org $00
 jmp SETUP	;Vamos a declarar una primera direccion a donde el programa vaya para la ejecuccion
>>>>>>> a1ec6f697a80f8ee32f159086fd026e865ad3949
						;Continua hasta la parte C(1).

//-------------------------------------------------------------
//               ZONA DE CODIGO(PREPARACION)
//-------------------------------------------------------------
; Replace with your application code
<<<<<<< HEAD
SETUP:      ldi register, high(RAMEND)	;INICIAMOS EL APUNTADOR DE STACK
            out SPH, register
            ldi register, low(RAMEND)
            out SPL, register    

			ldi register,$ff
			out ddrb,register

			ldi register,$00
			out ddrd,register

			ldi centenas,100	;Cargamos un 100
			ldi decenas,10		;Cargamos un 10
			;Esto nos servira para ir restando al numero introduccido
//-------------------------------------------------------------
//               ZONA DE CODIGO(DESENPAQUETADOR)
//-------------------------------------------------------------
Decod:
	in register,pinb
	cent:
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
		lsl Q_show
		out portc,Q_show
		rcall delay

		lds register,$101
		out portd,register
		lsl Q_show
		out portc,Q_show
		rcall delay

		lds register,$100
		out portd,register
		lsl Q_show
		out portc,Q_show
		rcall delay

		rjmp Decod
//-------------------------------------------------------------
//               ZONA DE DELAY
//-------------------------------------------------------------
delay:
	; delaying 19998 cycles:
          ldi  R27, $01;21
WGLOOP0:  ldi  R28, $01;C9
WGLOOP1:  dec  R28
          brne WGLOOP1
          dec  R27
          brne WGLOOP0
		  RET				;Retornamos a la funcion donde nos quedamos
=======
SETUP:      ldi register, high(RAMEND)	;INICIAMOS EL APUNTADOR DE STACK
            out SPH, register
            ldi register, low(RAMEND)
            out SPL, register    

			ldi register,$ff
			out ddrb,register

			ldi register,$00
			out ddrd,register

			ldi centenas,100	;Cargamos un 100
			ldi decenas,10		;Cargamos un 10
			;Esto nos servira para ir restando al numero introduccido
//-------------------------------------------------------------
//               ZONA DE CODIGO(DESENPAQUETADOR)
//-------------------------------------------------------------
Decod:
	in register,pinb
	cent:
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
		lsl Q_show
		out portc,Q_show
		rcall delay

		lds register,$101
		out portd,register
		lsl Q_show
		out portc,Q_show
		rcall delay

		lds register,$100
		out portd,register
		lsl Q_show
		out portc,Q_show
		rcall delay

		rjmp Decod
//-------------------------------------------------------------
//               ZONA DE DELAY
//-------------------------------------------------------------
delay:
	; delaying 19998 cycles:
          ldi  R27, $01;21
WGLOOP0:  ldi  R28, $01;C9
WGLOOP1:  dec  R28
          brne WGLOOP1
          dec  R27
          brne WGLOOP0
		  RET				;Retornamos a la funcion donde nos quedamos
>>>>>>> a1ec6f697a80f8ee32f159086fd026e865ad3949
//-------------------------------------------------------------
//              FIN DEL PROGRAMA
//-------------------------------------------------------------