;
; PROGRAMA_BERTHA.asm
;
; Created: 20/05/2021 06:12:01 p. m.
; Author : pablo
//-------------------------------------------------------------
//               ZONA DE CODIGO(PREPARACION)
//-------------------------------------------------------------
.def register = r16
.def BCD = r20
//-------------------------------------------------------------
//               ZONA DE CODIGO(PREPARACION)
//-------------------------------------------------------------
.org $00
 jmp SETUP	
//-------------------------------------------------------------
//               ZONA DE CODIGO(PREPARACION)
//-------------------------------------------------------------
SETUP:      ldi register, high(RAMEND)	
            out SPH, register
            ldi register, low(RAMEND)
            out SPL, register    

			ldi register,$ff
			out ddrd,register

			ldi register,$00
			out ddrb,register
//-------------------------------------------------------------
LECTURE:	in register, pinb
			rcall COMPARATOR
			rjmp LECTURE
//-------------------------------------------------------------
COMPARATOR:	cpi register,$00		//PARA NUMEROS PARES
			breq FUN_PAR
			cpi register,$02
			breq FUN_PAR
			cpi register,$04
			breq FUN_PAR
			cpi register,$06
			breq FUN_PAR
			cpi register,$08
			breq FUN_PAR

			cpi register,$01		//PARA NUMEROS IMPARES
			breq FUN_INPAR
			cpi register,$03
			breq FUN_INPAR
			cpi register,$05
			breq FUN_INPAR
			cpi register,$07
			breq FUN_INPAR
			cpi register,$09
			breq FUN_INPAR
			RET
//-------------------------------------------------------------
			//CERO		// ANODO					CATODO
FUN_PAR:	ldi BCD,$01	//	$01						 $7E	
			out portd,BCD
			rcall delay

			//DOS
			ldi BCD,$12	//	$12						 $6D	
			out portd,BCD
			rcall delay

			//CUATRO
			ldi BCD,$4C	//	$4C						 $33	
			out portd,BCD
			rcall delay

			//SEIS
			ldi BCD,$1F	//	$1F						 $1F	
			out portd,BCD
			rcall delay

			//OCHO
			ldi BCD,$00	//	$00						 $7F	
			out portd,BCD
			rcall delay
			RET
//-------------------------------------------------------------
			//UNO		// ANODO					CATODO
FUN_INPAR:	ldi BCD,$4F	//	$4F						 $30	
			out portd,BCD
			rcall delay

			//TRES
			ldi BCD,$06	//	$06						 $79	
			out portd,BCD
			rcall delay

			//CINCO
			ldi BCD,$24	//	$24						 $5B	
			out portd,BCD
			rcall delay

			//SIETE
			ldi BCD,$0F	//	$0F						 $70	
			out portd,BCD
			rcall delay

			//NUEVE
			ldi BCD,$00	//	$0C						 $73	
			out portd,BCD
			rcall delay
			RET
//-------------------------------------------------------------
delay:
	; delay of 2 secs (2,000,000):
          ldi  R17, $01		//12
WGLOOP0:  ldi  R18, $01		//BC
WGLOOP1:  ldi  R19, $01		//C4
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
		  ret
//-------------------------------------------------------------