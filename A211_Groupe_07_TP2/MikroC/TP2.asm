
_update_value:

;LED_LCD.c,28 :: 		void update_value(){
;LED_LCD.c,30 :: 		IntToHex(value,test);
	MOVF        _value+0, 0 
	MOVWF       FARG_IntToHex_input+0 
	MOVF        _value+1, 0 
	MOVWF       FARG_IntToHex_input+1 
	MOVLW       update_value_test_L0+0
	MOVWF       FARG_IntToHex_output+0 
	MOVLW       hi_addr(update_value_test_L0+0)
	MOVWF       FARG_IntToHex_output+1 
	CALL        _IntToHex+0, 0
;LED_LCD.c,31 :: 		if (Button(&PORTA, 0, 1, 0) && value + 10 <= 1023) {
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_value2
	MOVLW       10
	ADDWF       _value+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _value+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_value29
	MOVF        R1, 0 
	SUBLW       255
L__update_value29:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_value2
L__update_value27:
;LED_LCD.c,32 :: 		value += 10;
	MOVLW       10
	ADDWF       _value+0, 1 
	MOVLW       0
	ADDWFC      _value+1, 1 
;LED_LCD.c,33 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_value3:
	DECFSZ      R13, 1, 1
	BRA         L_update_value3
	DECFSZ      R12, 1, 1
	BRA         L_update_value3
	DECFSZ      R11, 1, 1
	BRA         L_update_value3
	NOP
	NOP
;LED_LCD.c,34 :: 		}
L_update_value2:
;LED_LCD.c,36 :: 		if (Button(&PORTA, 1, 1, 0) && value - 10 >= 0) {
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_value6
	MOVLW       10
	SUBWF       _value+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _value+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_value30
	MOVLW       0
	SUBWF       R1, 0 
L__update_value30:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_value6
L__update_value26:
;LED_LCD.c,37 :: 		value -= 10;
	MOVLW       10
	SUBWF       _value+0, 1 
	MOVLW       0
	SUBWFB      _value+1, 1 
;LED_LCD.c,38 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_value7:
	DECFSZ      R13, 1, 1
	BRA         L_update_value7
	DECFSZ      R12, 1, 1
	BRA         L_update_value7
	DECFSZ      R11, 1, 1
	BRA         L_update_value7
	NOP
	NOP
;LED_LCD.c,39 :: 		}
L_update_value6:
;LED_LCD.c,41 :: 		if (Button(&PORTA, 2, 1, 0) && value + 100 <= 1023) {
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_value10
	MOVLW       100
	ADDWF       _value+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _value+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_value31
	MOVF        R1, 0 
	SUBLW       255
L__update_value31:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_value10
L__update_value25:
;LED_LCD.c,42 :: 		value += 100;
	MOVLW       100
	ADDWF       _value+0, 1 
	MOVLW       0
	ADDWFC      _value+1, 1 
;LED_LCD.c,43 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_value11:
	DECFSZ      R13, 1, 1
	BRA         L_update_value11
	DECFSZ      R12, 1, 1
	BRA         L_update_value11
	DECFSZ      R11, 1, 1
	BRA         L_update_value11
	NOP
	NOP
;LED_LCD.c,44 :: 		}
L_update_value10:
;LED_LCD.c,46 :: 		if (Button(&PORTA, 3, 1, 0) && value - 100 >= 0) {
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_value14
	MOVLW       100
	SUBWF       _value+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _value+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_value32
	MOVLW       0
	SUBWF       R1, 0 
L__update_value32:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_value14
L__update_value24:
;LED_LCD.c,47 :: 		value -= 100;
	MOVLW       100
	SUBWF       _value+0, 1 
	MOVLW       0
	SUBWFB      _value+1, 1 
;LED_LCD.c,48 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_value15:
	DECFSZ      R13, 1, 1
	BRA         L_update_value15
	DECFSZ      R12, 1, 1
	BRA         L_update_value15
	DECFSZ      R11, 1, 1
	BRA         L_update_value15
	NOP
	NOP
;LED_LCD.c,49 :: 		}
L_update_value14:
;LED_LCD.c,50 :: 		}
L_end_update_value:
	RETURN      0
; end of _update_value

_update_pot:

;LED_LCD.c,55 :: 		void update_pot(){
;LED_LCD.c,56 :: 		pot_value = ADC_Read(20);
	MOVLW       20
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _pot_value+0 
	MOVF        R1, 0 
	MOVWF       _pot_value+1 
;LED_LCD.c,57 :: 		}
L_end_update_pot:
	RETURN      0
; end of _update_pot

_update_sign:

;LED_LCD.c,60 :: 		void update_sign(unsigned int a, unsigned int b){
;LED_LCD.c,61 :: 		if (a < b){
	MOVF        FARG_update_sign_b+1, 0 
	SUBWF       FARG_update_sign_a+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_sign35
	MOVF        FARG_update_sign_b+0, 0 
	SUBWF       FARG_update_sign_a+0, 0 
L__update_sign35:
	BTFSC       STATUS+0, 0 
	GOTO        L_update_sign16
;LED_LCD.c,62 :: 		Lcd_Out(2, 12, "S<ADC");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_LED_LCD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_LED_LCD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LED_LCD.c,63 :: 		}
	GOTO        L_update_sign17
L_update_sign16:
;LED_LCD.c,65 :: 		if (a > b){
	MOVF        FARG_update_sign_a+1, 0 
	SUBWF       FARG_update_sign_b+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_sign36
	MOVF        FARG_update_sign_a+0, 0 
	SUBWF       FARG_update_sign_b+0, 0 
L__update_sign36:
	BTFSC       STATUS+0, 0 
	GOTO        L_update_sign18
;LED_LCD.c,66 :: 		Lcd_Out(2, 12, "S>ADC" );
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_LED_LCD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_LED_LCD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LED_LCD.c,67 :: 		}
	GOTO        L_update_sign19
L_update_sign18:
;LED_LCD.c,69 :: 		Lcd_Out(2, 12, "S=ADC" );
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_LED_LCD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_LED_LCD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LED_LCD.c,70 :: 		}
L_update_sign19:
;LED_LCD.c,71 :: 		}
L_update_sign17:
;LED_LCD.c,72 :: 		}
L_end_update_sign:
	RETURN      0
; end of _update_sign

_update_LCD:

;LED_LCD.c,75 :: 		void update_LCD(){
;LED_LCD.c,76 :: 		IntToStr(value, valeur);
	MOVF        _value+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _value+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _valeur+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_valeur+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;LED_LCD.c,77 :: 		Lcd_Out(1, 7, valeur);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _valeur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_valeur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LED_LCD.c,78 :: 		IntToStr(pot_value, potentio);
	MOVF        _pot_value+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _pot_value+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _potentio+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_potentio+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;LED_LCD.c,79 :: 		Lcd_Out(2,4, potentio);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _potentio+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_potentio+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LED_LCD.c,80 :: 		update_sign(value, pot_value);
	MOVF        _value+0, 0 
	MOVWF       FARG_update_sign_a+0 
	MOVF        _value+1, 0 
	MOVWF       FARG_update_sign_a+1 
	MOVF        _pot_value+0, 0 
	MOVWF       FARG_update_sign_b+0 
	MOVF        _pot_value+1, 0 
	MOVWF       FARG_update_sign_b+1 
	CALL        _update_sign+0, 0
;LED_LCD.c,81 :: 		}
L_end_update_LCD:
	RETURN      0
; end of _update_LCD

_init:

;LED_LCD.c,84 :: 		void init(){
;LED_LCD.c,85 :: 		ANSELA  = 0;
	CLRF        ANSELA+0 
;LED_LCD.c,86 :: 		ANSELB = 0;
	CLRF        ANSELB+0 
;LED_LCD.c,87 :: 		ANSELD  = 0b00000001;
	MOVLW       1
	MOVWF       ANSELD+0 
;LED_LCD.c,90 :: 		C1ON_bit = 0;
	BCF         C1ON_bit+0, BitPos(C1ON_bit+0) 
;LED_LCD.c,91 :: 		C2ON_bit = 0;
	BCF         C2ON_bit+0, BitPos(C2ON_bit+0) 
;LED_LCD.c,94 :: 		TRISA = 0b00001111;
	MOVLW       15
	MOVWF       TRISA+0 
;LED_LCD.c,95 :: 		TRISD = 0b00000001;
	MOVLW       1
	MOVWF       TRISD+0 
;LED_LCD.c,99 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;LED_LCD.c,100 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;LED_LCD.c,104 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LED_LCD.c,105 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LED_LCD.c,106 :: 		Lcd_Out(1,1,txt_1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt_1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt_1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LED_LCD.c,107 :: 		Delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_init20:
	DECFSZ      R13, 1, 1
	BRA         L_init20
	DECFSZ      R12, 1, 1
	BRA         L_init20
	DECFSZ      R11, 1, 1
	BRA         L_init20
	NOP
	NOP
;LED_LCD.c,108 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LED_LCD.c,109 :: 		Lcd_Out(1,1,txt_2);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt_2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt_2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LED_LCD.c,110 :: 		Lcd_Out(2,1,txt_3);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt_3+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt_3+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LED_LCD.c,112 :: 		}
L_end_init:
	RETURN      0
; end of _init

_main:

;LED_LCD.c,115 :: 		void main() {
;LED_LCD.c,117 :: 		init();
	CALL        _init+0, 0
;LED_LCD.c,120 :: 		for(;;){
L_main21:
;LED_LCD.c,121 :: 		update_value();
	CALL        _update_value+0, 0
;LED_LCD.c,122 :: 		update_pot();
	CALL        _update_pot+0, 0
;LED_LCD.c,123 :: 		update_LCD();
	CALL        _update_LCD+0, 0
;LED_LCD.c,124 :: 		}
	GOTO        L_main21
;LED_LCD.c,125 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
