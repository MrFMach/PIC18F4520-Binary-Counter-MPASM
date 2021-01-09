
;******************************************************************************
;   LED BINARY CRESCENT/DECRESCENT COUNTER WITH TWO BUTTONS
;    
;   Studying Assembly Language with PIC18f4520 on PIC-Board kit
;   Using MPASM Compiller and MPLAB X IDE v4.15
;   
;   Author: FABIO MACHADO                                                    
;   GitHub: https://github.com/MrFMach                                       
;******************************************************************************

;******************************************************************************
;List directives
	
    list p=18F4520		;directive to define processor
    
;******************************************************************************
;Includes
    
    #INCLUDE <P18F4520.INC>	;processor specific variable definitions

;******************************************************************************
;Configuration bits

    CONFIG  OSC = HS		;pic-board cristal cscillator = 20 MHz

;******************************************************************************
;I/O define
    
#DEFINE	CRES_BUTTON	PORTC,0
#DEFINE DECR_BUTTON	PORTC,1

;******************************************************************************
;Variables

    CBLOCK 0x0C
	
	COUNTER
	DCounter1
	DCounter2
	DCounter3
	
	ENDC

;******************************************************************************
;Reset Vector

RES_VECT    CODE    0x0000	;processor reset vector
    GOTO    START		;go to beginning of program

;******************************************************************************
;Add interrupts here if used
    
;******************************************************************************
;Main program

MAIN_PROG CODE			;let linker place main program
 
DELAY:
    DELAY
    MOVLW 0X58
    MOVWF DCounter1
    MOVLW 0X58
    MOVWF DCounter2
    MOVLW 0X07
    MOVWF DCounter3
    LOOP
    DECFSZ DCounter1, 1
    GOTO LOOP
    DECFSZ DCounter2, 1
    GOTO LOOP
    DECFSZ DCounter3, 1
    GOTO LOOP
    NOP
    RETURN

START:
    MOVLW B'11111111'
    MOVWF TRISC		;PORT as input
    MOVLW B'00000000'
    MOVWF TRISB		;PORT as output
    CLRF PORTB
    CLRF PORTC
    CLRF COUNTER

MAIN:

CRES_TEST:
    BTFSS CRES_BUTTON	;CRESCENT BUTTON TEST
    GOTO DECR_TEST	;IF NOT PRESS BUTTON, GO TO DECRESCENT BUTTON TEST
    GOTO CRES_COUNT	;IF PRESS BUTTON, GO TO CRESCENT LOGIC
    
DECR_TEST:
    BTFSS DECR_BUTTON	;DECRESCENT BUTTON TEST
    GOTO CRES_TEST	;IF NOT PRESS BUTTON, GO TO CRESCENT BUTTON TEST
    GOTO DECR_COUNT	;IF PRESS BUTTON, GO TO DECRESCENT LOGIC
    
CRES_COUNT:
    CALL DELAY
    INCF COUNTER
    MOVFF COUNTER,PORTB
    GOTO MAIN
    
DECR_COUNT:
    CALL DELAY
    DECF COUNTER
    MOVFF COUNTER,PORTB
    GOTO MAIN

;******************************************************************************
;End
    END