//----------------------------------------------------------------------------
//                            (PRACTICA 2) CALCULADORA ASSEMBLER V1
//----------------------------------------------------------------------------
 
; Created: 12/04/2021 5:00:00 PM
; Author : Pablo Gonzalez 

//----------------------------------------------------------------------------
//                              CARGA DE REGISTROS
//----------------------------------------------------------------------------

   .include "m328pdef.inc"
   .org $00
   rjmp inicio 
   .org 0x36

//----------------------------------------------------------------------------
//             Segmento de codigo que inicializa el apuntador de stack
//----------------------------------------------------------------------------

inicio:
	ldi r16,$FF
	ldi r17,$08
	out spl,r16
	out sph,r17

//----------------------------------------------------------------------------
//                   Configuracion de puertos como entrada y salida
//----------------------------------------------------------------------------

	ldi r16,$F0
	out DDRB,r16 ; cargando ceros al registro B para configurarlo como entrada
;NOTA:
;	PINES 0-3 : NUMEROS A SUMAR
;	PINES 4-7 : NUMERO RESULTANTE

//----------------------------------------------------------------------------
//                   Configuracion de puertos como entrada y salida(basico)
//----------------------------------------------------------------------------
	ldi r16,$02
	out DDRD,r16 ; cargamos "00000011" para configurar dos botones de control
;NOTA:
;	PIN_0: SUMAR
;	PIN_1: RESULTADO

//----------------------------------------------------------------------------
//                   Configuracion de puertos como entrada y salida(avanzado)
//----------------------------------------------------------------------------
	ldi r16,$07
	out DDRD,r16 ; cargamos "00000011" para configurar dos botones de control
;NOTA:
;	PIN_0: SUMAR
;	PIN_1: RESULTADO
;	PIN_2: BORRAR
//----------------------------------------------------------------------------
//                              Zona de condicionales (basica)
//----------------------------------------------------------------------------

ciclo_1:
	in r16,PINB  ;leemos el numero en la entrada de los interruptores
	andi r16,$0f
	mov r17,r16
	ldi r16,$01
	in r18,PIND
	cp r16,r18
	brne ciclo_1 ;sentencia (if): si no se presiona el primer boton, no avanza

ciclo_2:
	in r16,PINB  ;leemos el numero en la entrada de los interruptores
	andi r16,$0f
	mov r19,r16
	ldi r16,$01
	in r18,PIND
	cp r16,r18
	brne ciclo_2 ;sentencia (if): si no se presiona el primer boton, no avanza

sum_n_ans:
	ldi r16,$02
	in r18,PIND
	cp r16,r18
	brne sum_n_ans ;sentencia (if): si no se presiona el primer boton, no avanza
	add r19,r17
	swap r19
	out PORTB,r19
	; regresa a la primera instancia del codigo
//----------------------------------------------------------------------------
//                               FIN DEL PROGRAMA
//----------------------------------------------------------------------------	

//----------------------------------------------------------------------------
//                              Zona de condicionales (avanzado)
//----------------------------------------------------------------------------

ersr: 
	ldi r16,$00		;inicialmente los leds estan apagados
	out PORTB,r16
	nop

ciclo_1_a: ;CICLO DE LECTURA DEL PRIMER NUMERO
	in r16,PINB  ;leemos el numero en la entrada de los interruptores
	mov r17,r16
	nop

add_n_show_1:		;sentencia (if): si no se presiona el primer boton, no avanza
	ldi r16,$01
	in r18,PIND
	cp r16,r18
	brne ciclo_1_a

then_sen_1:		;le muestra el primer numero introduccido al usuario
	swap r17
	out PORTB,r17
	nop

ciclo_2_a:
	in r16,PINB  ;leemos el numero en la entrada de los interruptores
	andi r16,$0f ;no toma en cuenta los resultados mostrados, solo los ingresados
	mov r19,r16
	nop

add_n_show_2:		;sentencia (if): si no se presiona el segundo boton, no avanza
	ldi r16,$01
	in r18,PIND
	cp r16,r18
	brne ciclo_2_a

then_sen_2:			;le muestra el primer numero introduccido al usuario
	swap r19
	out PORTB,r19
	nop

op_n_go:			;Hasta que no se pulse el segundo boton, no avanza quedando en la ultima "pantalla"
	ldi r16,$02
	in r18,PIND
	cp r16,r18
	brne op_n_go

then_sen_3:			;cuando se presiona, realiza el calculo y lo envia al puerto
	add r19,r17
	out PORTB,r19
	nop

inf_show_rst:		;si no se presiona el tercer boton, nos quedamos viendo el resultado un tiempo indefinido
	ldi r16,$04
	in r18,PIND
	cp r16,r18
	brne inf_show_rst

	rjmp ersr		;una vez presionado, regresamos al inicio del codigo, limpiando la "pantalla"

//----------------------------------------------------------------------------
//                               FIN DEL PROGRAMA
//----------------------------------------------------------------------------	