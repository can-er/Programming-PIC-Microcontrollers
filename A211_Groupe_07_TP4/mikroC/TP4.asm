
_Interrupt:

;TP4.c,17 :: 		void Interrupt(void){
;TP4.c,18 :: 		if (TMR0IF_bit){ // Timer0 toutes les 5ms
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_Interrupt0
;TP4.c,19 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;TP4.c,20 :: 		TMR0H = 0xD8;
	MOVLW       216
	MOVWF       TMR0H+0 
;TP4.c,21 :: 		TMR0L = 0xF0;
	MOVLW       240
	MOVWF       TMR0L+0 
;TP4.c,22 :: 		LATA = 0;
	CLRF        LATA+0 
;TP4.c,23 :: 		LATD = Segment[index];
	MOVLW       _Segment+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Segment+0)
	MOVWF       FSR0H 
	MOVF        _index+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       LATD+0 
;TP4.c,24 :: 		LATA = 1 << index;
	MOVF        _index+0, 0 
	MOVWF       R1 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
L__Interrupt44:
	BZ          L__Interrupt45
	RLCF        R0, 1 
	BCF         R0, 0 
	ADDLW       255
	GOTO        L__Interrupt44
L__Interrupt45:
	MOVF        R0, 0 
	MOVWF       LATA+0 
;TP4.c,25 :: 		index++;
	INCF        _index+0, 1 
;TP4.c,26 :: 		index = index%4;
	MOVLW       3
	ANDWF       _index+0, 1 
;TP4.c,27 :: 		}
L_Interrupt0:
;TP4.c,28 :: 		}
L_end_Interrupt:
L__Interrupt43:
	RETFIE      1
; end of _Interrupt

_Update_display:

;TP4.c,31 :: 		void Update_display(void)
;TP4.c,33 :: 		millier = (compteur/1000)%10;
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        _compteur+0, 0 
	MOVWF       R0 
	MOVF        _compteur+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _millier+0 
	MOVF        R1, 0 
	MOVWF       _millier+1 
;TP4.c,34 :: 		Segment[3] = conversion[millier];
	MOVLW       _conversion+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_conversion+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_conversion+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, _Segment+3
;TP4.c,35 :: 		centaine = (compteur/100)%10;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _compteur+0, 0 
	MOVWF       R0 
	MOVF        _compteur+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _centaine+0 
	MOVF        R1, 0 
	MOVWF       _centaine+1 
;TP4.c,36 :: 		Segment[2] = conversion[centaine];
	MOVLW       _conversion+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_conversion+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_conversion+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, _Segment+2
;TP4.c,37 :: 		dizaine = (compteur/10)%10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _compteur+0, 0 
	MOVWF       R0 
	MOVF        _compteur+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _dizaine+0 
	MOVF        R1, 0 
	MOVWF       _dizaine+1 
;TP4.c,38 :: 		Segment[1] = conversion[dizaine];
	MOVLW       _conversion+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_conversion+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_conversion+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, _Segment+1
;TP4.c,39 :: 		unite = compteur%10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _compteur+0, 0 
	MOVWF       R0 
	MOVF        _compteur+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _unite+0 
	MOVF        R1, 0 
	MOVWF       _unite+1 
;TP4.c,40 :: 		Segment[0] = conversion[unite];
	MOVLW       _conversion+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_conversion+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_conversion+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, _Segment+0
;TP4.c,41 :: 		}
L_end_Update_display:
	RETURN      0
; end of _Update_display

_setValue:

;TP4.c,43 :: 		void setValue(int n){
;TP4.c,44 :: 		if (n == 0 && compteur +1 < 1000){
	MOVLW       0
	XORWF       FARG_setValue_n+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue48
	MOVLW       0
	XORWF       FARG_setValue_n+0, 0 
L__setValue48:
	BTFSS       STATUS+0, 2 
	GOTO        L_setValue3
	MOVLW       1
	ADDWF       _compteur+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _compteur+1, 0 
	MOVWF       R2 
	MOVLW       3
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue49
	MOVLW       232
	SUBWF       R1, 0 
L__setValue49:
	BTFSC       STATUS+0, 0 
	GOTO        L_setValue3
L__setValue40:
;TP4.c,45 :: 		compteur += 1;
	INFSNZ      _compteur+0, 1 
	INCF        _compteur+1, 1 
;TP4.c,46 :: 		}
	GOTO        L_setValue4
L_setValue3:
;TP4.c,47 :: 		else if (n == 1 && compteur -1 > 0){
	MOVLW       0
	XORWF       FARG_setValue_n+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue50
	MOVLW       1
	XORWF       FARG_setValue_n+0, 0 
L__setValue50:
	BTFSS       STATUS+0, 2 
	GOTO        L_setValue7
	MOVLW       1
	SUBWF       _compteur+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _compteur+1, 0 
	MOVWF       R2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue51
	MOVF        R1, 0 
	SUBLW       0
L__setValue51:
	BTFSC       STATUS+0, 0 
	GOTO        L_setValue7
L__setValue39:
;TP4.c,48 :: 		compteur -= 1;
	MOVLW       1
	SUBWF       _compteur+0, 1 
	MOVLW       0
	SUBWFB      _compteur+1, 1 
;TP4.c,49 :: 		}
	GOTO        L_setValue8
L_setValue7:
;TP4.c,50 :: 		else if (n == 2 && compteur +10 < 1000){
	MOVLW       0
	XORWF       FARG_setValue_n+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue52
	MOVLW       2
	XORWF       FARG_setValue_n+0, 0 
L__setValue52:
	BTFSS       STATUS+0, 2 
	GOTO        L_setValue11
	MOVLW       10
	ADDWF       _compteur+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _compteur+1, 0 
	MOVWF       R2 
	MOVLW       3
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue53
	MOVLW       232
	SUBWF       R1, 0 
L__setValue53:
	BTFSC       STATUS+0, 0 
	GOTO        L_setValue11
L__setValue38:
;TP4.c,51 :: 		compteur += 10;
	MOVLW       10
	ADDWF       _compteur+0, 1 
	MOVLW       0
	ADDWFC      _compteur+1, 1 
;TP4.c,52 :: 		}
	GOTO        L_setValue12
L_setValue11:
;TP4.c,53 :: 		else if (n == 3 && compteur -1 > 0){
	MOVLW       0
	XORWF       FARG_setValue_n+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue54
	MOVLW       3
	XORWF       FARG_setValue_n+0, 0 
L__setValue54:
	BTFSS       STATUS+0, 2 
	GOTO        L_setValue15
	MOVLW       1
	SUBWF       _compteur+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _compteur+1, 0 
	MOVWF       R2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue55
	MOVF        R1, 0 
	SUBLW       0
L__setValue55:
	BTFSC       STATUS+0, 0 
	GOTO        L_setValue15
L__setValue37:
;TP4.c,54 :: 		compteur -= 10;
	MOVLW       10
	SUBWF       _compteur+0, 1 
	MOVLW       0
	SUBWFB      _compteur+1, 1 
;TP4.c,55 :: 		}
	GOTO        L_setValue16
L_setValue15:
;TP4.c,56 :: 		else if (n == 4 && compteur +100 < 1000){
	MOVLW       0
	XORWF       FARG_setValue_n+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue56
	MOVLW       4
	XORWF       FARG_setValue_n+0, 0 
L__setValue56:
	BTFSS       STATUS+0, 2 
	GOTO        L_setValue19
	MOVLW       100
	ADDWF       _compteur+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _compteur+1, 0 
	MOVWF       R2 
	MOVLW       3
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue57
	MOVLW       232
	SUBWF       R1, 0 
L__setValue57:
	BTFSC       STATUS+0, 0 
	GOTO        L_setValue19
L__setValue36:
;TP4.c,57 :: 		compteur += 100;
	MOVLW       100
	ADDWF       _compteur+0, 1 
	MOVLW       0
	ADDWFC      _compteur+1, 1 
;TP4.c,58 :: 		}
	GOTO        L_setValue20
L_setValue19:
;TP4.c,59 :: 		else if (n == 5 && compteur -1 > 0){
	MOVLW       0
	XORWF       FARG_setValue_n+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue58
	MOVLW       5
	XORWF       FARG_setValue_n+0, 0 
L__setValue58:
	BTFSS       STATUS+0, 2 
	GOTO        L_setValue23
	MOVLW       1
	SUBWF       _compteur+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _compteur+1, 0 
	MOVWF       R2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setValue59
	MOVF        R1, 0 
	SUBLW       0
L__setValue59:
	BTFSC       STATUS+0, 0 
	GOTO        L_setValue23
L__setValue35:
;TP4.c,60 :: 		compteur -= 100;
	MOVLW       100
	SUBWF       _compteur+0, 1 
	MOVLW       0
	SUBWFB      _compteur+1, 1 
;TP4.c,61 :: 		}
	GOTO        L_setValue24
L_setValue23:
;TP4.c,63 :: 		compteur = 0;
	CLRF        _compteur+0 
	CLRF        _compteur+1 
;TP4.c,64 :: 		}
L_setValue24:
L_setValue20:
L_setValue16:
L_setValue12:
L_setValue8:
L_setValue4:
;TP4.c,65 :: 		}
L_end_setValue:
	RETURN      0
; end of _setValue

_update_value:

;TP4.c,67 :: 		void update_value(void){
;TP4.c,68 :: 		for (i = 0; i < 6; i++){
	CLRF        _i+0 
	CLRF        _i+1 
L_update_value25:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_value61
	MOVLW       6
	SUBWF       _i+0, 0 
L__update_value61:
	BTFSC       STATUS+0, 0 
	GOTO        L_update_value26
;TP4.c,69 :: 		if (Button(&PORTC, i, 1, 1)){
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	MOVF        _i+0, 0 
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_value28
;TP4.c,70 :: 		oldState = 1;
	BSF         _oldState+0, BitPos(_oldState+0) 
;TP4.c,71 :: 		}
L_update_value28:
;TP4.c,72 :: 		if (Button(&PORTC, i, 1, 0) && oldState){
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	MOVF        _i+0, 0 
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_value31
	BTFSS       _oldState+0, BitPos(_oldState+0) 
	GOTO        L_update_value31
L__update_value41:
;TP4.c,73 :: 		setValue(i);
	MOVF        _i+0, 0 
	MOVWF       FARG_setValue_n+0 
	MOVF        _i+1, 0 
	MOVWF       FARG_setValue_n+1 
	CALL        _setValue+0, 0
;TP4.c,74 :: 		}
L_update_value31:
;TP4.c,68 :: 		for (i = 0; i < 6; i++){
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;TP4.c,75 :: 		}
	GOTO        L_update_value25
L_update_value26:
;TP4.c,76 :: 		}
L_end_update_value:
	RETURN      0
; end of _update_value

_main:

;TP4.c,79 :: 		void main(void) {
;TP4.c,80 :: 		ANSELA = 0;
	CLRF        ANSELA+0 
;TP4.c,81 :: 		ANSELD = 0;
	CLRF        ANSELD+0 
;TP4.c,82 :: 		TRISA = 0;
	CLRF        TRISA+0 
;TP4.c,83 :: 		LATA  = 0;
	CLRF        LATA+0 
;TP4.c,84 :: 		TRISD = 0;
	CLRF        TRISD+0 
;TP4.c,86 :: 		TRISC = 0b01111111;
	MOVLW       127
	MOVWF       TRISC+0 
;TP4.c,87 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;TP4.c,88 :: 		oldState = 0;
	BCF         _oldState+0, BitPos(_oldState+0) 
;TP4.c,90 :: 		LATD  = 0;
	CLRF        LATD+0 
;TP4.c,91 :: 		compteur = 0;
	CLRF        _compteur+0 
	CLRF        _compteur+1 
;TP4.c,92 :: 		index = 0;
	CLRF        _index+0 
;TP4.c,94 :: 		T0CON = 0x88;
	MOVLW       136
	MOVWF       T0CON+0 
;TP4.c,95 :: 		TMR0H = 0xD8;
	MOVLW       216
	MOVWF       TMR0H+0 
;TP4.c,96 :: 		TMR0L = 0xF0;
	MOVLW       240
	MOVWF       TMR0L+0 
;TP4.c,97 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;TP4.c,98 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;TP4.c,101 :: 		while(1) {
L_main32:
;TP4.c,102 :: 		Update_display();
	CALL        _Update_display+0, 0
;TP4.c,103 :: 		update_value();
	CALL        _update_value+0, 0
;TP4.c,104 :: 		delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main34:
	DECFSZ      R13, 1, 1
	BRA         L_main34
	DECFSZ      R12, 1, 1
	BRA         L_main34
	DECFSZ      R11, 1, 1
	BRA         L_main34
	NOP
;TP4.c,105 :: 		}
	GOTO        L_main32
;TP4.c,106 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
