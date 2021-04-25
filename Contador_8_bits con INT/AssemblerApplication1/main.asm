.include "m328pdef.inc"

;-----------------------------------------------------------------------------
;PARTE A(1):
.def temp0 = R16	;Definimos una variable para almacenar nuestra informacion global

;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
;PARTE B(1):
.org $00
            jmp SETUP	;Vamos a declarar una primera direccion a donde el programa vaya para la ejecuccion
			;Continua hasta la parte C(1).
;-----------------------------------------------------------------------------
;PARTE B(2):
.org $02
            jmp COUNT	;Nos mandara aqui, y de aqui, saltamos al proceso count
.org $04
            jmp DECOUNT ; o nos vamos al proceso de decount
.org $34	;ignora esto y regresa a C(2)
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
;PARTE C(1):
SETUP:      ldi temp0, low(RAMEND)	;INICIAMOS EL APUNTADOR DE STACK
            out SPL, temp0
            ldi temp0, high(RAMEND)
            out SPH, temp0      

			out ddrb,temp0	;En esta parte configuramos los puertos, aqui declaramos como entrada el puerto B
			ldi temp0,$0C	;Pero cargamos un 12($0c) para los botones de interrupticones
			out ddrb,temp0	;le enviamos esta informacion al puerto D
			out portd,temp0	;y configuramos en alto los mismos

			ldi temp0,$0A	;una vez hecho esto, cargamos un 10($0a) para indicar que estos se activaran por transicion negativa
			sts EICRA,temp0	;y los seteamos en el registro de interrupciones externas (eicra)

			ldi temp0,$03	;por ultimo configuramos la mascara para detectar las interrupciones
			sts EIMSK,temp0	;y lo seteamos en el registro 

			sei				;activamos las interrupciones
			clr temp0	;y limpiamos el registro 
;PARTE C(2):
ciclo:
	out portb,temp0		;en este loop, siempre se muestra un cero ($00) pero...
	rjmp ciclo

COUNT:					;hasta que no se active la direccion del vector count, podemos aumentar este registro en 1 (ve a la parte B(2))
	inc temp0
	reti

DECOUNT:
	dec temp0			;o podemos decrementar este registro
	reti				;En cualquier caso, reti sirve para deshabilitar interrupciones para regresar al codigo principal (direccion 0x00)
	;Para reactivarlas y que el codigo funcione siempre asi.

			
