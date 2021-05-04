;
; ENTRADA_MATRICIAL.asm
;
; Created: 03/05/2021 02:09:13 p. m.
; Author : pablo
//-------------------------------------------------------------
//              ZONA DE DEFINICIONES
//-------------------------------------------------------------

.def register = r16	
.def intento = r19
.def cons_sal = r18
.def cons_ent = r17

//-------------------------------------------------------------
//              ZONA DE VECTORES
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

			ldi register,$0f
			out portb,register
			out ddrb,register

			ldi register,$ff
			out ddrd,register
//-------------------------------------------------------------
//              SENTENCIA PARA SABER DONDE SALE EL CERO
//-------------------------------------------------------------

reset:
		ldi intento,$ff		//Limpiamos nuestra variable que nos indicara el numero que sacaremos, para que cuente desde cero			

INT_CONT_1:	
		ldi cons_sal,$0E				//Ahora cargamos el valor E, como no cambian solo se agrega una vez|0000 1110|
		rjmp COMP			//y nos vamos a comparar por primera vez

INT_CONT_2:		
		ldi cons_sal,$0D				//Ahora cargamos el valor D, como no cambian solo se agrega una vez|0000 11101|
		rjmp COMP			//y nos vamos a comparar por segunda vez

INT_CONT_3:		
		ldi cons_sal,$0B				//Ahora cargamos el valor B, como no cambian solo se agrega una vez|0000 1011|
		rjmp COMP			//y nos vamos a comparar por tercera vez

INT_CONT_4:		
		ldi cons_sal,$07				//Ahora cargamos el valor 7, como no cambian solo se agrega una vez|0000 0111|
		rjmp COMP			//y nos vamos a comparar por cuarta y ultima vez

//-------------------------------------------------------------
//      SENTENCIA PARA SABER POR QUE PUERTO ENTRA EL CERO
//-------------------------------------------------------------

COMP:
		ldi cons_ent,$E0				//Aqui podemos cargar el primer valor E de los pines en pull-up, solo porque el valor F, no es reconocido
		rcall comp_num			//Y sumamos el valor constante de r18 con r17 para hacer la primera comparacion con la entrada, Vamos a la funcion que compara
		;|1110 0000
		ldi cons_ent,$D0
		rcall comp_num
		;|1101 0000
		ldi cons_ent,$B0
		rcall comp_num
		;|1011 0000
		ldi cons_ent,$70
		rcall comp_num
		;|0111 0000

		cpi intento,$03				//Si de plano, no agarro ningun valor, nos vamos a cargar otro valor para r18
		breq INT_CONT_2				//Regresando a cargar, sumando en esta parte y asi hasta que agarre algo

		cpi intento,$07
		breq INT_CONT_3

		cpi intento,$0B
		breq INT_CONT_4

		cpi intento,$0F
		breq reset					//Si despues de 16 intentos, no agarro nada, el programa resetea para leer desde el principio
//-------------------------------------------------------------
//              SENTENCIA PARA SABER QUE VALOR SE COMPARA
//-------------------------------------------------------------

comp_num:
	add cons_ent,cons_sal
	inc intento	
	out portb,cons_ent
	rcall delay
	in register,pinb						//Aqui aumentamos el intento, para saber dos cosas: 1.- Que numero sacamos , 2.- Si pasamos a otra comparacion
	cp register,r17						//Comparamos lo que hay en la entrada con lo que sumamos
	breq sacar_num						//Y si es, pasaremos a expulsar el numero por el puerto D
	ret
										//Caso contrario, nos regresaremos a hacer mas comparaciones
//-------------------------------------------------------------
//              SENTENCIA PARA USAR EL TECLADO MATRICIAL(CHORIZERO)
//-------------------------------------------------------------
sacar_num:
	cpi intento,$00
	breq uno
	cpi intento,$01
	breq dos
	cpi intento,$02
	breq tres
	cpi intento,$03
	breq WA

	cpi intento,$04
	breq cuatro
	cpi intento,$05
	breq cinco
	cpi intento,$06
	breq seis
	cpi intento,$07
	breq WB

	cpi intento,$08
	breq siete
	cpi intento,$09
	breq ocho
	cpi intento,$0A
	breq nueve
	cpi intento,$0B
	breq WC

	cpi intento,$0C
	breq asterisco
	cpi intento,$0D
	breq cero
	cpi intento,$0E
	breq gato
	cpi intento,$0F
	breq WD

uno:
	ldi register,$01
	rcall out_portd
dos:
	ldi register,$02
	rcall out_portd
tres:
	ldi register,$03
	rcall out_portd
cuatro:
	ldi register,$04
	rcall out_portd
cinco:
	ldi register,$05
	rcall out_portd
seis:
	ldi register,$06
	rcall out_portd
siete:
	ldi register,$07
	rcall out_portd
ocho:
	ldi register,$08
	rcall out_portd
nueve:
	ldi register,$09
	rcall out_portd
cero:
	ldi register,$00
	rcall out_portd
WA:
	ldi register,$0A
	rcall out_portd
WB:
	ldi register,$0B
	rcall out_portd
WC:
	ldi register,$0C
	rcall out_portd
WD:
	ldi register,$0D
	rcall out_portd
asterisco:
	ldi register,$0E
	rcall out_portd
gato:
	ldi register,$0f
	rcall out_portd
//-------------------------------------------------------------
//              SENTENCIA PARA SACAR EL VALOR 
//-------------------------------------------------------------
out_portd:
	out portd,register					//Si logramos pasar, sacamos el numero por el puerto D, en formato binario
	rjmp reset							//Hecho esto, reseteamos para leer nuevamente los numeros, por lo que una vez dejamos de presionar
										//El programa limpia la salida automaticamente
//-------------------------------------------------------------
//              SENTENCIA DE RETARDO
//-------------------------------------------------------------
delay:
	; delaying 99990 cycles:
          ldi  R22, $20
WGLOOP0:  ldi  R21, $20
WGLOOP1:  dec  R21
          brne WGLOOP1
          dec  R22
          brne WGLOOP0
		  ret
//-------------------------------------------------------------
//              FIN DEL CODIGO
//-------------------------------------------------------------