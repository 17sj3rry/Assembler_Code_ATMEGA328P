;
; CONTADOR ASCENDENTE O DESCENDENTE
;
; Created: 11/05/2021 03:05:57 p. m.
; Author : pablo
;

.ORG $00
rjmp SETUP 

SETUP:
	ldi R16, high(RAMEND)	;INICIAMOS EL APUNTADOR DE STACK
    out SPH, R16
    ldi R16, low(RAMEND)
    out SPL, R16    

	ldi r16,$00			;CONFIGURAR COMO ENTRADA EL PUERTO B
	out ddrb,r16

	ldi r16,$ff			;CONFIGURAR COMO SALIDA EL PUERTO D
	out ddrd,r16
	clr r16				//limpiamos la lectura 
	clr r20				//Limpiamos el conteo
//-----------------------------------------------------
		LOOP:
			in r16,pinb		//Si el SW0 (o el pin PB0 o el PIN14 del atmega) esta en alto, que la cuenta sea ascendente
			cpi r16,$01		//$01 = 0000 0001 
			breq INCREMENTO	//Branch IF EQual = Relaciona si es igual
			brne DECREMENTO //Branch IF Not Equal = Relaciona si no es igual

		INCREMENTO:
			inc r20		//INC = INCREMENTAR | INCREMENTAMOS EN UNA UNIDAD 
			out portd,r20
			rcall delay		//Para poder observar el numero vamos a este delay

		DECREMENTO:
			dec r20		//DEC = DECREMENTAR	| DECREMENTA EN UNA UNIDAD
			out portd,r20
			rcall delay		//Para poder observar el numero vamos a este delay

		delay:				//PARA RETRASAR UN SEGUNDO
		  ldi  R17, $06;06
WGLOOP0:  ldi  R18, $37;37
WGLOOP1:  ldi  R19, $c9;c9
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
		  rjmp LOOP