;
; ReloJ_Binario.asm
;
; Created: 17/04/2021 02:34:42 a. m.
; Author : Pablo Gonzalez
;
//----------------------------------------------------------------------------
//                              DEFINICION DE VARIABLES
//----------------------------------------------------------------------------

.def minsx1 = r16	;Variable para contar minutos x 1
.def temp0 = r17	;Variable para retardo num1
.def temp1 = r18	;Variable para retardo num2
.def temp2 = r19	;Variable para retardo num3
.def regis_ldr = r20;Variable para cargar y modificar registros
.def minsx10 = r21  ;Variable para contar minutos x 10
.def hrsx1 = r22	;Variable para contar horas x 1
.def hrsx10 = r23	;Variable para contar horas x 10
.def m10_addr = r24 ;Variable para sumar un $10(0001 0000)
.def m12_cont = r25 ;Variable para contar hasta 12 horas

//----------------------------------------------------------------------------
//                              CARGA DE VECTORES
//----------------------------------------------------------------------------

   .org $00
   jmp inicio 

//----------------------------------------------------------------------------
//             Segmento de codigo que inicializa el apuntador de stack
//----------------------------------------------------------------------------

inicio:
	ldi regis_ldr, high(RAMEND)	;INICIAMOS EL APUNTADOR DE STACK
    out SPH, regis_ldr
    ldi regis_ldr, low(RAMEND)
    out SPL, regis_ldr 


;---------------------------------------------------------------------
;                 DECLARANDO ENTRADAS Y SALIDAS
;---------------------------------------------------------------------

	ldi regis_ldr,$ff
	out ddrb,regis_ldr
	out ddrc,regis_ldr

	ldi regis_ldr,$00
	out ddrd,regis_ldr 

;---------------------------------------------------------------------
;                        ZONA DE CODIGO
;---------------------------------------------------------------------
clr regis_ldr 
time_adj:
	in regis_ldr ,portd

	cpi regis_ldr ,$01
	breq adj_min

	cpi regis_ldr ,$02
	breq adj_hrs

	cpi regis_ldr ,$04
	breq adj_end

	rjmp time_adj

	adj_min:
		inc minsx1
		out portb,minsx1
		rjmp time_adj

	adj_hrs:
		inc hrsx1
		out portc,hrsx1
		rjmp time_adj

	adj_end:
		rjmp pre_Strt


borrar:
;------------------------------
; REGISTROS DE TIEMPO(CONTENO)
;------------------------------

	clr minsx1
	clr minsx10
	clr hrsx1
	clr hrsx10

pre_Strt:
;------------------------------
; REGISTROS DE TIEMPO(MODIFICACION)
;------------------------------

	ldi m10_addr,$10
	ldi m12_cont,$0C ;$0C
	out portb,minsx1
	out portc,minsx1

count_12:

	cpi m12_cont,$00
	breq borrar

min_delayer:
;---------------------------------------------------------------------
; delaying 999999 cycles:
          ldi  temp0, $09
WGLOOP0:  ldi  temp1, $BC
WGLOOP1:  ldi  temp2, $C4
WGLOOP2:  dec  temp2
          brne WGLOOP2
          dec  temp1
          brne WGLOOP1
          dec  temp0
          brne WGLOOP0
;---------------------------------------------------------------------

	cont_1_min:			//Contamos hasta 10 para indicar un paso de 10 minutos

		in minsx1,portb	//Lee lo que hay en el puerto (inicialmente es cero)
		inc minsx1		//Lo que hay, lo incremente en 1
		out portb,minsx1	//Y lo expulsa fuera en el puerto b
		andi minsx1,$0f	//Pero elimina la parte de los ultimos 4 bits 
		cpi minsx1,$0A;0A	//Para checar si la primera parte suman 10
		brne count_12	//Si es, pasa; si no, regresa hasta que sean

		clr minsx1		//Una vez pasa, limpia el registro
		out portb,minsx1

	cont_10_min:
		
		add minsx10,m10_addr	//Al registro 21, le suman $10 para incrementar los ultimos 4 bits hasta 6 ($60)
		out portb,minsx10	//Expulsa el resultado por el puerto
		cpi minsx10,$60;60	//Revisa si son 6 ($60)
		brne count_12	//Pasa 

		clr minsx10		//Limpia el registro
		out portb,minsx10	//Limpia el display, ahora queda en cero para mostrar el siguiente display

	cont_1_hr:

		dec m12_cont		//Decrementamos el registro 25, 12 veces
		inc hrsx1		//Incrementamos el registro 22 en 1
		out portc,hrsx1	//Sacamos el resultado por el puerto D
		andi hrsx1,$0f	//Pero solo leemos la parte inicial de 4 bits para checar
		cpi hrsx1,$0A;0A	//Comparamos si son 10($0A)
		brne count_12

		clr hrsx1		//Limpia el registro
		out portc,hrsx1	//Limpia el display, ahora queda en cero para mostrar el siguiente display

	cont_10_hr:
		inc hrsx10
		add hrsx10,m10_addr
		out portc,hrsx10
		cpi hrsx10,$02;01
		brne count_12

		clr hrsx10
		out portc,hrsx10

		rjmp borrar
