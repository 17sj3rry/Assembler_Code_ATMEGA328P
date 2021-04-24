;
; ReloJ_Binario.asm
;
; Created: 17/04/2021 02:34:42 a. m.
; Author : pablo
;
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

;---------------------------------------------------------------------
;                 DECLARANDO ENTRADAS Y SALIDAS
;---------------------------------------------------------------------
	cli

	ldi r16,$ff
	out ddrb,r16
	out ddrd,r16

	sei

	sbi EIMSK,2
	
;---------------------------------------------------------------------
;                        ZONA DE CODIGO
;---------------------------------------------------------------------

borrar:
;------------------------------
; REGISTROS DE TIEMPO(CONTENO)
;------------------------------

	clr r16
	clr r21
	clr r22
	clr r23

;------------------------------
; REGISTROS DE TIEMPO(MODIFICACION)
;------------------------------

	ldi r24,$10
	ldi r25,$0C ;$0C
	out portb,r16
	out portd,r16

count_12:

	cpi r25,$00
	breq borrar

DELAYER:
;---------------------------------------------------------------------
	; ============================= 
	; delaying 49939965 cycles:
	; ============================= 
			  ldi  R17, $FF
	WGLOOP0:  ldi  R18, $FF
	WGLOOP1:  ldi  R19, $FF
	WGLOOP2:  dec  R19
			  brne WGLOOP2
			  dec  R18
			  brne WGLOOP1
			  dec  R17
			  brne WGLOOP0
	; ============================= 
	; delaying 10060014 cycles:
	; ============================= 
			  ldi  R17, $83
	WGLOOP3:  ldi  R18, $8F
	WGLOOP4:  ldi  R19, $B2
	WGLOOP5:  dec  R19
			  brne WGLOOP5
			  dec  R18
			  brne WGLOOP4
			  dec  R17
			  brne WGLOOP3
;---------------------------------------------------------------------

	cont_1_min:			//Contamos hasta 10 para indicar un paso de 10 minutos

		in r16,portb	//Lee lo que hay en el puerto (inicialmente es cero)
		inc r16			//Lo que hay, lo incremente en 1
		out portb,r16	//Y lo expulsa fuera en el puerto b
		andi r16,$0f	//Pero elimina la parte de los ultimos 4 bits 
		cpi r16,$0A;0A	//Para checar si la primera parte suman 10
		brne count_12	//Si es, pasa; si no, regresa hasta que sean

		clr r16			//Una vez pasa, limpia el registro

	cont_10_min:
		
		add r21,r24		//Al registro 21, le suman $10 para incrementar los ultimos 4 bits hasta 6 ($60)
		out portb,r21	//Expulsa el resultado por el puerto
		cpi r21,$60;60	//Revisa si son 6 ($60)
		brne count_12	//Pasa 

		clr r21			//Limpia el registro
		out portb,r21	//Limpia el display, ahora queda en cero para mostrar el siguiente display

	cont_1_hr:

		dec r25			//Decrementamos el registro 25, 12 veces
		inc r22			//Incrementamos el registro 22 en 1
		out portd,r22	//Sacamos el resultado por el puerto D
		andi r22,$0f	//Pero solo leemos la parte inicial de 4 bits para checar
		cpi r22,$0A;0A	//Comparamos si son 10($0A)
		brne count_12

		andi r22,$00

	cont_10_hr:

		add r23,r24
		out portd,r23
		cpi r23,$01;01
		brne count_12

		andi r23,$00
		out portd,r23

		rjmp borrar

;---------------------------------------------------------------------
;                        BLOQUE DE INTERRUPCIONES
;---------------------------------------------------------------------
	ext_int0:

		int_strt:
			in r26,portc

			cpi r26,$01
			breq add_min

			cpi r26,$02
			breq add_hrs

			cpi r26,$03
			breq salir

			rjmp int_strt

		add_min:
			inc r16
			rjmp int_strt

		add_hrs:
			inc r22
			rjmp int_strt

		salir:
			reti