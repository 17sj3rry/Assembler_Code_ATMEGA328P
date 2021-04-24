;
; Calcualdora maestra.asm
;
; Created: 20/04/2021 03:40:41 p. m.
; Author : pablo
;


; Replace with your application code

;----------------------------------------------------------------	
;----------------------------------------------------------------
;					PINOUT ZONE
;----------------------------------------------------------------
	ldi r16,$00
	out ddrb,r16

	ldi r16,$ff
	out ddrd,r16

	ldi r16,$ff
	out ddrc,r16

	ldi r16,$00
	out portb,r16

	LDI R16,$00
	LDI R20,$00
	LDI R21,$00
;----------------------------------------------------------------
;					CODE ZONE
;----------------------------------------------------------------
	LEC_FUNC:
		in r16,pinb
		mov r21,R16
		ldi r16,$00
		in r16,pinc
		cpi r16,$01
		brne LEC_FUNC

		ldi r22,$04
		out portc,r22

		rjmp DELAYER

DELAYER:	
	; ============================= 
	;    delay loop generator 
	;     1000000 cycles:
	; ----------------------------- 
	; delaying 999999 cycles:
				ldi  R17, $09
	WGLOOP0_1:  ldi  R18, $BC
	WGLOOP1_1:  ldi  R19, $C4
	WGLOOP2_1:  dec  R19
			  brne WGLOOP2_1
			  dec  R18
			  brne WGLOOP1_1
			  dec  R17
			  brne WGLOOP0_1
	; ----------------------------- 
	; delaying 1 cycle:
			  nop
	; ============================= 
		ldi r22,$00
		out portc,r22
		nop
	

 MK_ADD:
		add r20,r21
		in r16,pinc
		cpi r16,$02
		brne LEC_FUNC

		ldi r22,$04
		out portc,r22

DELAYER_1:	
	; ============================= 
	;    delay loop generator 
	;     1000000 cycles:
	; ----------------------------- 
	; delaying 999999 cycles:
			  ldi  R17, $09;09
	WGLOOP0:  ldi  R18, $BC;bc
	WGLOOP1:  ldi  R19, $C4;c4
	WGLOOP2:  dec  R19
			  brne WGLOOP2
			  dec  R18
			  brne WGLOOP1
			  dec  R17
			  brne WGLOOP0
	; ----------------------------- 
	; delaying 1 cycle:
			  nop
	; ============================= 
		ldi r22,$00
		out portc,r22

	out portd,r20

SHOW_RES: 
		  MOV R21,R20
		  ANDI R20,$0F
		  CPI R20,$0F
		  BRNE LEC_FUNC
	MOVE: ANDI R21,$F0
		  CPI R21,$F0
		  BRNE LEC_FUNC

carry:
	ldi r22,$08
	out portc,r22
	rjmp LEC_FUNC




	
			
