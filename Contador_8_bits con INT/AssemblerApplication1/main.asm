;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
.def register = r16
.def num = r17
;-----------------------------------------------------------------------------
;PARTE B(1):
.org $00
 jmp SETUP	;Vamos a declarar una primera direccion a donde el programa vaya para la ejecuccion
						;Continua hasta la parte C(1).
;-----------------------------------------------------------------------------
;PARTE B(2):
.org $02	;Cuando presionamos la interrupciones, nos envia aqui, para leer el vector de direcciones y decidir hacia que instruccion irse
jmp COUNT	;Nos mandara aqui, y de aqui, saltamos al proceso count...Ve a PARTE C(3)

.org $04
jmp DECOUNT ; o nos vamos al proceso de decount
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
;PARTE C(1):
SETUP:      ldi register, high(RAMEND)	;INICIAMOS EL APUNTADOR DE STACK
            out SPH, register
            ldi register, low(RAMEND)
            out SPL, register    

			ldi register,$FF			;Vamos a configurar el puerto B como salida de datos, enviando 0XFF($FF)
			out ddrb,register

			ldi register,$0C			;Pero configuramos las resistencias internas de pull-up del puerto D
			out portd,register			;Esto hara que esten en ALTO para poder enviar un cero y que este sea leido

			ldi register,$0A			;Ahora activamos las interrupciones externas, configurandolas como cambio de nivel logico
			sts EICRA,register			;Y las enviamos al registro EICRA

			ldi register,$03			;Por ultimo activamos los pines de las interrupciones correspondientes al pin PD2(4) y PD3(5)
			out EIMSK,register		
			sei							;Por ultimo, activamos las interrupciones globales
				
//----------------------------------------------------------------------
;PARTE C(2):
main:
	out portb,num		;en este loop, siempre se muestra un cero ($00) pero...Ve a PARTE B(2)
	rjmp main			
;PARTE C(3):
COUNT:
	rcall retardo		;Nos manda aqui para activar una funcion de retardo				
	inc	num				;Y realiza un incremento
	reti				;Finalmente, descativa la interrupcion, regresando al main

DECOUNT:
	rcall retardo
	dec num			
	reti
						
retardo:
; -----------------------------	Aqui nos genera un retardo de 250uS para impedir interrupciones multiples
	; delaying 250,000 cycles:
			  ldi  R20, $A7
	WGLOOP0:  ldi  R21, $02
	WGLOOP1:  ldi  R22, $F8
	WGLOOP2:  dec  R22
			  brne WGLOOP2
			  dec  R21
			  brne WGLOOP1
			  dec  R20
			  brne WGLOOP0
			  nop
			  ret			;Al final, nos retorna a la instruccion donde fue llamada
; ----------------------------- 
