;
; ENTRADA_MATRICIAL.asm
;
; Created: 03/05/2021 02:09:13 p. m.
; Author : pablo

.def register = r16	
.def intento = r19

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

			ldi register,$0f
			out portb,register
			out ddrb,register

			ldi register,$ff
			out ddrd,register

reset:
		clr intento				//Limpiamos nuestra variable que nos indicara el numero que sacaremos

INT_CONT_1:	
		ldi r18,$0E				//Ahora cargamos el valor E, como no cambian solo se agrega una vez
		rjmp COMP			//y nos vamos a comparar por primera vez

INT_CONT_2:		
		ldi r18,$0D				//Ahora cargamos el valor D, como no cambian solo se agrega una vez
		rjmp COMP			//y nos vamos a comparar por segunda vez

INT_CONT_3:		
		ldi r18,$0B				//Ahora cargamos el valor B, como no cambian solo se agrega una vez
		rjmp COMP			//y nos vamos a comparar por tercera vez

INT_CONT_4:		
		ldi r18,$07				//Ahora cargamos el valor 7, como no cambian solo se agrega una vez
		rjmp COMP			//y nos vamos a comparar por cuarta y ultima vez

COMP:
		ldi r17,$E0				//Aqui podemos cargar el primer valor E de los pines en pull-up, solo porque el valor F, no es reconocido
		rcall comp_num			//Y sumamos el valor constante de r18 con r17 para hacer la primera comparacion con la entrada, Vamos a la funcion que compara

		ldi r17,$D0
		rcall comp_num

		ldi r17,$B0
		rcall comp_num

		ldi r17,$70
		rcall comp_num

		cpi intento,$04				//Si de plano, no agarro ningun valor, nos vamos a cargar otro valor para r18
		breq INT_CONT_2				//Regresando a cargar, sumando en esta parte y asi hasta que agarre algo

		cpi intento,$08
		breq INT_CONT_3

		cpi intento,$0C
		breq INT_CONT_4

		cpi intento,$10
		breq reset					//Si despues de 16 intentos, no agarro nada, el programa resetea para leer desde el principio

comp_num:
	add r17,r18
	inc intento	
	out portb,r17
	rcall delay
	in register,pinb						//Aqui aumentamos el intento, para saber dos cosas: 1.- Que numero sacamos , 2.- Si pasamos a otra comparacion
	cp register,r17						//Comparamos lo que hay en la entrada con lo que sumamos
	breq sacar_num						//Y si es, pasaremos a expulsar el numero por el puerto D
	ret
										//Caso contrario, nos regresaremos a hacer mas comparaciones
sacar_num:
	out portd,intento					//Si logramos pasar, sacamos el numero por el puerto D, en formato binario
	rjmp reset							//Hecho esto, reseteamos para leer nuevamente los numeros, por lo que una vez dejamos de presionar
										//El programa limpia la salida automaticamente
delay:
	; delaying 99990 cycles:
          ldi  R22, $cc
WGLOOP0:  ldi  R21, $cc
WGLOOP1:  dec  R21
          brne WGLOOP1
          dec  R22
          brne WGLOOP0
		  ret