;
; Blinky.asm
;
; Created: 06/05/2021 12:01:14 p. m.
; Author : pablo
;
//-------------------------------------------------------------
//               ZONA DE VECTORES DE DIRECCION
//-------------------------------------------------------------
.def register = r16
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
			out ddrb,register

loop:
	ldi register,$01
	out portb,register
	rcall delay
	ldi register,$00
	out portb,register
	rcall delay
	rjmp loop

delay:
; delaying 199998 cycles:
          ldi  R17, $06;06
WGLOOP0:  ldi  R18, $37;37
WGLOOP1:  ldi  R19, $c9;c9
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
		  RET	