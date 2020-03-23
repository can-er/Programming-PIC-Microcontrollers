
_send_values:

;TP4_Bis.c,40 :: 		void send_values(){
;TP4_Bis.c,41 :: 		if (update_flag){
	BTFSS       _update_flag+0, BitPos(_update_flag+0) 
	GOTO        L_send_values0
;TP4_Bis.c,42 :: 		UART1_Write(SOT);
	MOVLW       2
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,43 :: 		UART1_Write_Text(content_line_1);
	MOVLW       _content_line_1+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_content_line_1+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP4_Bis.c,44 :: 		UART1_Write(EOT);
	MOVLW       3
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,45 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,46 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,47 :: 		update_flag = 0;
	BCF         _update_flag+0, BitPos(_update_flag+0) 
;TP4_Bis.c,48 :: 		}
L_send_values0:
;TP4_Bis.c,49 :: 		}
L_end_send_values:
	RETURN      0
; end of _send_values

_interrupt:

;TP4_Bis.c,52 :: 		void interrupt(){
;TP4_Bis.c,53 :: 		if(RC1IF_bit == 1){
	BTFSS       RC1IF_bit+0, BitPos(RC1IF_bit+0) 
	GOTO        L_interrupt1
;TP4_Bis.c,54 :: 		recieved_data  = UART_Read();
	CALL        _UART_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _recieved_data+0 
;TP4_Bis.c,55 :: 		switch (recieved_data){
	GOTO        L_interrupt2
;TP4_Bis.c,56 :: 		case '[': // Debut de l'acquisition
L_interrupt4:
;TP4_Bis.c,57 :: 		index = 0;
	CLRF        _index+0 
	CLRF        _index+1 
;TP4_Bis.c,58 :: 		break;
	GOTO        L_interrupt3
;TP4_Bis.c,59 :: 		case ']': // Fin de l'acquisition
L_interrupt5:
;TP4_Bis.c,60 :: 		command_line[index+1] = '\0';
	MOVLW       1
	ADDWF       _index+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _index+1, 0 
	MOVWF       R1 
	MOVLW       _command_line+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_command_line+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;TP4_Bis.c,61 :: 		data_recieved_flag = 1;
	BSF         _data_recieved_flag+0, BitPos(_data_recieved_flag+0) 
;TP4_Bis.c,62 :: 		break;
	GOTO        L_interrupt3
;TP4_Bis.c,63 :: 		default : // Acquisition de la donnee
L_interrupt6:
;TP4_Bis.c,64 :: 		command_line[index++] = recieved_data;
	MOVLW       _command_line+0
	ADDWF       _index+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_command_line+0)
	ADDWFC      _index+1, 0 
	MOVWF       FSR1H 
	MOVF        _recieved_data+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      _index+0, 1 
	INCF        _index+1, 1 
;TP4_Bis.c,65 :: 		}
	GOTO        L_interrupt3
L_interrupt2:
	MOVF        _recieved_data+0, 0 
	XORLW       91
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt4
	MOVF        _recieved_data+0, 0 
	XORLW       93
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt5
	GOTO        L_interrupt6
L_interrupt3:
;TP4_Bis.c,66 :: 		}
L_interrupt1:
;TP4_Bis.c,67 :: 		}
L_end_interrupt:
L__interrupt36:
	RETFIE      1
; end of _interrupt

_update_values:

;TP4_Bis.c,70 :: 		void update_values(){
;TP4_Bis.c,71 :: 		if (Button(&PORTC, 0, 1, 0) && val_1 + 10 <= 255) {
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values9
	MOVLW       10
	ADDWF       _val_1+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _val_1+1, 0 
	MOVWF       R2 
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_values38
	MOVF        R1, 0 
	SUBLW       255
L__update_values38:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_values9
L__update_values33:
;TP4_Bis.c,72 :: 		val_1 += 10;
	MOVLW       10
	ADDWF       _val_1+0, 1 
	MOVLW       0
	ADDWFC      _val_1+1, 1 
;TP4_Bis.c,73 :: 		update_flag = 1;
	BSF         _update_flag+0, BitPos(_update_flag+0) 
;TP4_Bis.c,74 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_values10:
	DECFSZ      R13, 1, 1
	BRA         L_update_values10
	DECFSZ      R12, 1, 1
	BRA         L_update_values10
	DECFSZ      R11, 1, 1
	BRA         L_update_values10
	NOP
	NOP
;TP4_Bis.c,75 :: 		}
L_update_values9:
;TP4_Bis.c,77 :: 		if (Button(&PORTC, 1, 1, 0) && val_1 - 10 >= 0) {
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values13
	MOVLW       10
	SUBWF       _val_1+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _val_1+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_values39
	MOVLW       0
	SUBWF       R1, 0 
L__update_values39:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_values13
L__update_values32:
;TP4_Bis.c,78 :: 		val_1 -= 10;
	MOVLW       10
	SUBWF       _val_1+0, 1 
	MOVLW       0
	SUBWFB      _val_1+1, 1 
;TP4_Bis.c,79 :: 		update_flag = 1;
	BSF         _update_flag+0, BitPos(_update_flag+0) 
;TP4_Bis.c,80 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_values14:
	DECFSZ      R13, 1, 1
	BRA         L_update_values14
	DECFSZ      R12, 1, 1
	BRA         L_update_values14
	DECFSZ      R11, 1, 1
	BRA         L_update_values14
	NOP
	NOP
;TP4_Bis.c,81 :: 		}
L_update_values13:
;TP4_Bis.c,83 :: 		if (Button(&PORTC, 2, 1, 0) && val_2 + 10 <= 255) {
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values17
	MOVLW       10
	ADDWF       _val_2+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _val_2+1, 0 
	MOVWF       R2 
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_values40
	MOVF        R1, 0 
	SUBLW       255
L__update_values40:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_values17
L__update_values31:
;TP4_Bis.c,84 :: 		val_2 += 10;
	MOVLW       10
	ADDWF       _val_2+0, 1 
	MOVLW       0
	ADDWFC      _val_2+1, 1 
;TP4_Bis.c,85 :: 		update_flag = 1;
	BSF         _update_flag+0, BitPos(_update_flag+0) 
;TP4_Bis.c,86 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_values18:
	DECFSZ      R13, 1, 1
	BRA         L_update_values18
	DECFSZ      R12, 1, 1
	BRA         L_update_values18
	DECFSZ      R11, 1, 1
	BRA         L_update_values18
	NOP
	NOP
;TP4_Bis.c,87 :: 		}
L_update_values17:
;TP4_Bis.c,89 :: 		if (Button(&PORTC, 3, 1, 0) && val_2 - 10 >= 0) {
	MOVLW       PORTC+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values21
	MOVLW       10
	SUBWF       _val_2+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _val_2+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_values41
	MOVLW       0
	SUBWF       R1, 0 
L__update_values41:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_values21
L__update_values30:
;TP4_Bis.c,90 :: 		val_2 -= 10;
	MOVLW       10
	SUBWF       _val_2+0, 1 
	MOVLW       0
	SUBWFB      _val_2+1, 1 
;TP4_Bis.c,91 :: 		update_flag = 1;
	BSF         _update_flag+0, BitPos(_update_flag+0) 
;TP4_Bis.c,92 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_values22:
	DECFSZ      R13, 1, 1
	BRA         L_update_values22
	DECFSZ      R12, 1, 1
	BRA         L_update_values22
	DECFSZ      R11, 1, 1
	BRA         L_update_values22
	NOP
	NOP
;TP4_Bis.c,93 :: 		}
L_update_values21:
;TP4_Bis.c,94 :: 		}
L_end_update_values:
	RETURN      0
; end of _update_values

_update_pot:

;TP4_Bis.c,97 :: 		void update_pot(){
;TP4_Bis.c,98 :: 		old_pot_val = pot_val;
	MOVF        _pot_val+0, 0 
	MOVWF       _old_pot_val+0 
	MOVF        _pot_val+1, 0 
	MOVWF       _old_pot_val+1 
;TP4_Bis.c,99 :: 		pot_val = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _pot_val+0 
	MOVF        R1, 0 
	MOVWF       _pot_val+1 
;TP4_Bis.c,100 :: 		if (old_pot_val != pot_val){
	MOVF        _old_pot_val+1, 0 
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_pot43
	MOVF        R0, 0 
	XORWF       _old_pot_val+0, 0 
L__update_pot43:
	BTFSC       STATUS+0, 2 
	GOTO        L_update_pot23
;TP4_Bis.c,101 :: 		update_flag = 1;
	BSF         _update_flag+0, BitPos(_update_flag+0) 
;TP4_Bis.c,102 :: 		}
L_update_pot23:
;TP4_Bis.c,103 :: 		}
L_end_update_pot:
	RETURN      0
; end of _update_pot

_update_LCD:

;TP4_Bis.c,106 :: 		void update_LCD(){
;TP4_Bis.c,107 :: 		if (update_flag){
	BTFSS       _update_flag+0, BitPos(_update_flag+0) 
	GOTO        L_update_LCD24
;TP4_Bis.c,108 :: 		sprintf(content_line_1, "%03u %03u %04u", val_1, val_2, pot_val);
	MOVLW       _content_line_1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_content_line_1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_1_TP4_Bis+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_TP4_Bis+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_TP4_Bis+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _val_1+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _val_1+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _val_2+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        _val_2+1, 0 
	MOVWF       FARG_sprintf_wh+8 
	MOVF        _pot_val+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	MOVF        _pot_val+1, 0 
	MOVWF       FARG_sprintf_wh+10 
	CALL        _sprintf+0, 0
;TP4_Bis.c,109 :: 		Lcd_Out(1, 1, content_line_1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _content_line_1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_content_line_1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP4_Bis.c,110 :: 		}
L_update_LCD24:
;TP4_Bis.c,111 :: 		if (data_recieved_flag){
	BTFSS       _data_recieved_flag+0, BitPos(_data_recieved_flag+0) 
	GOTO        L_update_LCD25
;TP4_Bis.c,112 :: 		Lcd_Out(2,3, strncpy(buffer,command_line+0,3));
	MOVLW       _buffer+0
	MOVWF       FARG_strncpy_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strncpy_to+1 
	MOVLW       _command_line+0
	MOVWF       FARG_strncpy_from+0 
	MOVLW       hi_addr(_command_line+0)
	MOVWF       FARG_strncpy_from+1 
	MOVLW       3
	MOVWF       FARG_strncpy_size+0 
	MOVLW       0
	MOVWF       FARG_strncpy_size+1 
	CALL        _strncpy+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;TP4_Bis.c,113 :: 		Lcd_Out(2,9, strncpy(buffer,command_line+4,3));
	MOVLW       _buffer+0
	MOVWF       FARG_strncpy_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strncpy_to+1 
	MOVLW       _command_line+4
	MOVWF       FARG_strncpy_from+0 
	MOVLW       hi_addr(_command_line+4)
	MOVWF       FARG_strncpy_from+1 
	MOVLW       3
	MOVWF       FARG_strncpy_size+0 
	MOVLW       0
	MOVWF       FARG_strncpy_size+1 
	CALL        _strncpy+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;TP4_Bis.c,114 :: 		data_recieved_flag = 0;
	BCF         _data_recieved_flag+0, BitPos(_data_recieved_flag+0) 
;TP4_Bis.c,115 :: 		}
L_update_LCD25:
;TP4_Bis.c,116 :: 		}
L_end_update_LCD:
	RETURN      0
; end of _update_LCD

_terminal_init_message:

;TP4_Bis.c,119 :: 		void terminal_init_message(){
;TP4_Bis.c,120 :: 		UART1_Write_Text("Connecté au PIC18F45K22");
	MOVLW       ?lstr2_TP4_Bis+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_TP4_Bis+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP4_Bis.c,121 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,122 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,123 :: 		UART1_Write_Text("Bienvenue à mon programme...");
	MOVLW       ?lstr3_TP4_Bis+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_TP4_Bis+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP4_Bis.c,124 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,125 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,126 :: 		UART1_Write_Text("Format des données à envoyer: [X;Y]");
	MOVLW       ?lstr4_TP4_Bis+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_TP4_Bis+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP4_Bis.c,127 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,128 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,129 :: 		UART1_Write_Text("Où X et Y sont des entiers compris entre 0 et 999.");
	MOVLW       ?lstr5_TP4_Bis+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_TP4_Bis+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP4_Bis.c,130 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,131 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP4_Bis.c,132 :: 		}
L_end_terminal_init_message:
	RETURN      0
; end of _terminal_init_message

_LCD_init_message:

;TP4_Bis.c,135 :: 		void LCD_init_message(){
;TP4_Bis.c,136 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TP4_Bis.c,137 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TP4_Bis.c,138 :: 		Lcd_Out(1,1,"Initialisation...");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_TP4_Bis+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_TP4_Bis+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP4_Bis.c,139 :: 		Delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_LCD_init_message26:
	DECFSZ      R13, 1, 1
	BRA         L_LCD_init_message26
	DECFSZ      R12, 1, 1
	BRA         L_LCD_init_message26
	DECFSZ      R11, 1, 1
	BRA         L_LCD_init_message26
	NOP
	NOP
;TP4_Bis.c,140 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TP4_Bis.c,141 :: 		sprintf(content_line_1, "%03u %03u %04u", val_1, val_2, pot_val);
	MOVLW       _content_line_1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_content_line_1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_7_TP4_Bis+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_7_TP4_Bis+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_7_TP4_Bis+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _val_1+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _val_1+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _val_2+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        _val_2+1, 0 
	MOVWF       FARG_sprintf_wh+8 
	MOVF        _pot_val+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	MOVF        _pot_val+1, 0 
	MOVWF       FARG_sprintf_wh+10 
	CALL        _sprintf+0, 0
;TP4_Bis.c,142 :: 		Lcd_Out(1, 1, content_line_1 );
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _content_line_1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_content_line_1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP4_Bis.c,143 :: 		Lcd_Out(2,1,"A:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_TP4_Bis+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_TP4_Bis+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP4_Bis.c,144 :: 		Lcd_Out(2,7,"B:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr9_TP4_Bis+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr9_TP4_Bis+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP4_Bis.c,145 :: 		}
L_end_LCD_init_message:
	RETURN      0
; end of _LCD_init_message

_init:

;TP4_Bis.c,148 :: 		void init(){
;TP4_Bis.c,149 :: 		ANSELA  = 0b00000001;
	MOVLW       1
	MOVWF       ANSELA+0 
;TP4_Bis.c,150 :: 		ANSELB = 0;
	CLRF        ANSELB+0 
;TP4_Bis.c,151 :: 		ANSELD  = 0;
	CLRF        ANSELD+0 
;TP4_Bis.c,152 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;TP4_Bis.c,154 :: 		update_flag = 0;
	BCF         _update_flag+0, BitPos(_update_flag+0) 
;TP4_Bis.c,155 :: 		data_recieved_flag = 0;
	BCF         _data_recieved_flag+0, BitPos(_data_recieved_flag+0) 
;TP4_Bis.c,158 :: 		C1ON_bit = 0;
	BCF         C1ON_bit+0, BitPos(C1ON_bit+0) 
;TP4_Bis.c,159 :: 		C2ON_bit = 0;
	BCF         C2ON_bit+0, BitPos(C2ON_bit+0) 
;TP4_Bis.c,162 :: 		TRISC = 0b10001111;
	MOVLW       143
	MOVWF       TRISC+0 
;TP4_Bis.c,163 :: 		TRISA = 0b00000001;
	MOVLW       1
	MOVWF       TRISA+0 
;TP4_Bis.c,167 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;TP4_Bis.c,169 :: 		UART1_Init(115200);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       16
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;TP4_Bis.c,170 :: 		terminal_init_message();
	CALL        _terminal_init_message+0, 0
;TP4_Bis.c,172 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;TP4_Bis.c,173 :: 		LCD_init_message();
	CALL        _LCD_init_message+0, 0
;TP4_Bis.c,175 :: 		Delay_1sec();
	CALL        _Delay_1sec+0, 0
;TP4_Bis.c,176 :: 		RC1IE_bit = 1;                    // turn ON interrupt on UART1 receive
	BSF         RC1IE_bit+0, BitPos(RC1IE_bit+0) 
;TP4_Bis.c,177 :: 		RC1IF_bit = 0;                    // Clear interrupt flag
	BCF         RC1IF_bit+0, BitPos(RC1IF_bit+0) 
;TP4_Bis.c,178 :: 		PEIE_bit  = 1;                    // Enable peripheral interrupts
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;TP4_Bis.c,179 :: 		GIE_bit   = 1;                    // Enable GLOBAL interrupts
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;TP4_Bis.c,180 :: 		}
L_end_init:
	RETURN      0
; end of _init

_main:

;TP4_Bis.c,183 :: 		void main() {
;TP4_Bis.c,184 :: 		init();
	CALL        _init+0, 0
;TP4_Bis.c,187 :: 		for(;;){
L_main27:
;TP4_Bis.c,188 :: 		update_pot();
	CALL        _update_pot+0, 0
;TP4_Bis.c,189 :: 		update_values();
	CALL        _update_values+0, 0
;TP4_Bis.c,190 :: 		update_LCD();
	CALL        _update_LCD+0, 0
;TP4_Bis.c,191 :: 		send_values();
	CALL        _send_values+0, 0
;TP4_Bis.c,192 :: 		}
	GOTO        L_main27
;TP4_Bis.c,193 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
