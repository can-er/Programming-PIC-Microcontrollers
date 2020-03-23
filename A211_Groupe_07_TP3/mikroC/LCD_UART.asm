
_send_values:

;LCD_UART.c,37 :: 		void send_values(){
;LCD_UART.c,38 :: 		if (ready_to_send){
	BTFSS       _ready_to_send+0, BitPos(_ready_to_send+0) 
	GOTO        L_send_values0
;LCD_UART.c,39 :: 		UART1_Write(SOT);
	MOVLW       2
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,40 :: 		UART1_Write_Text(content_line_1);
	MOVLW       _content_line_1+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_content_line_1+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;LCD_UART.c,41 :: 		UART1_Write(EOT);
	MOVLW       3
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,42 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,43 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,44 :: 		ready_to_send = 0;
	BCF         _ready_to_send+0, BitPos(_ready_to_send+0) 
;LCD_UART.c,45 :: 		}
L_send_values0:
;LCD_UART.c,46 :: 		}
L_end_send_values:
	RETURN      0
; end of _send_values

_recieve_values:

;LCD_UART.c,49 :: 		void recieve_values(){
;LCD_UART.c,50 :: 		if(UART1_Data_Ready()) {
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_recieve_values1
;LCD_UART.c,51 :: 		UART1_Read_Text(recieved_data,"]",10);
	MOVLW       _recieved_data+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_recieved_data+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       ?lstr1_LCD_UART+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(?lstr1_LCD_UART+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       10
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;LCD_UART.c,52 :: 		strncpy(buffer,recieved_data+2,1);
	MOVLW       _buffer+0
	MOVWF       FARG_strncpy_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strncpy_to+1 
	MOVLW       _recieved_data+2
	MOVWF       FARG_strncpy_from+0 
	MOVLW       hi_addr(_recieved_data+2)
	MOVWF       FARG_strncpy_from+1 
	MOVLW       1
	MOVWF       FARG_strncpy_size+0 
	MOVLW       0
	MOVWF       FARG_strncpy_size+1 
	CALL        _strncpy+0, 0
;LCD_UART.c,54 :: 		if (recieved_data[0] == 0x15){
	MOVF        _recieved_data+0, 0 
	XORLW       21
	BTFSS       STATUS+0, 2 
	GOTO        L_recieve_values2
;LCD_UART.c,56 :: 		Lcd_Out(1,14, "NOK");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_LCD_UART+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_LCD_UART+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LCD_UART.c,57 :: 		Delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_recieve_values3:
	DECFSZ      R13, 1, 1
	BRA         L_recieve_values3
	DECFSZ      R12, 1, 1
	BRA         L_recieve_values3
	DECFSZ      R11, 1, 1
	BRA         L_recieve_values3
	NOP
	NOP
;LCD_UART.c,58 :: 		}
	GOTO        L_recieve_values4
L_recieve_values2:
;LCD_UART.c,61 :: 		strncpy(buffer,recieved_data+2,3);
	MOVLW       _buffer+0
	MOVWF       FARG_strncpy_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strncpy_to+1 
	MOVLW       _recieved_data+2
	MOVWF       FARG_strncpy_from+0 
	MOVLW       hi_addr(_recieved_data+2)
	MOVWF       FARG_strncpy_from+1 
	MOVLW       3
	MOVWF       FARG_strncpy_size+0 
	MOVLW       0
	MOVWF       FARG_strncpy_size+1 
	CALL        _strncpy+0, 0
;LCD_UART.c,62 :: 		Lcd_Out(2,3, buffer);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _buffer+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LCD_UART.c,63 :: 		strncpy(buffer,recieved_data+5,3);
	MOVLW       _buffer+0
	MOVWF       FARG_strncpy_to+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_strncpy_to+1 
	MOVLW       _recieved_data+5
	MOVWF       FARG_strncpy_from+0 
	MOVLW       hi_addr(_recieved_data+5)
	MOVWF       FARG_strncpy_from+1 
	MOVLW       3
	MOVWF       FARG_strncpy_size+0 
	MOVLW       0
	MOVWF       FARG_strncpy_size+1 
	CALL        _strncpy+0, 0
;LCD_UART.c,64 :: 		Lcd_Out(2,9, buffer);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _buffer+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LCD_UART.c,65 :: 		Lcd_Out(1,14, " OK");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_LCD_UART+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_LCD_UART+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LCD_UART.c,66 :: 		}
L_recieve_values4:
;LCD_UART.c,67 :: 		memset(buffer,'\0',sizeof(buffer));
	MOVLW       _buffer+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       12
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;LCD_UART.c,68 :: 		}
L_recieve_values1:
;LCD_UART.c,69 :: 		}
L_end_recieve_values:
	RETURN      0
; end of _recieve_values

_update_values:

;LCD_UART.c,72 :: 		void update_values(){
;LCD_UART.c,73 :: 		if (Button(&PORTC, 0, 1, 0) && val_1 + 10 <= 255) {
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
	GOTO        L_update_values7
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
	GOTO        L__update_values33
	MOVF        R1, 0 
	SUBLW       255
L__update_values33:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_values7
L__update_values29:
;LCD_UART.c,74 :: 		val_1 += 10;
	MOVLW       10
	ADDWF       _val_1+0, 1 
	MOVLW       0
	ADDWFC      _val_1+1, 1 
;LCD_UART.c,75 :: 		ready_to_send = 1;
	BSF         _ready_to_send+0, BitPos(_ready_to_send+0) 
;LCD_UART.c,76 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_values8:
	DECFSZ      R13, 1, 1
	BRA         L_update_values8
	DECFSZ      R12, 1, 1
	BRA         L_update_values8
	DECFSZ      R11, 1, 1
	BRA         L_update_values8
	NOP
	NOP
;LCD_UART.c,77 :: 		}
L_update_values7:
;LCD_UART.c,79 :: 		if (Button(&PORTC, 1, 1, 0) && val_1 - 10 >= 0) {
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
	GOTO        L_update_values11
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
	GOTO        L__update_values34
	MOVLW       0
	SUBWF       R1, 0 
L__update_values34:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_values11
L__update_values28:
;LCD_UART.c,80 :: 		val_1 -= 10;
	MOVLW       10
	SUBWF       _val_1+0, 1 
	MOVLW       0
	SUBWFB      _val_1+1, 1 
;LCD_UART.c,81 :: 		ready_to_send = 1;
	BSF         _ready_to_send+0, BitPos(_ready_to_send+0) 
;LCD_UART.c,82 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_values12:
	DECFSZ      R13, 1, 1
	BRA         L_update_values12
	DECFSZ      R12, 1, 1
	BRA         L_update_values12
	DECFSZ      R11, 1, 1
	BRA         L_update_values12
	NOP
	NOP
;LCD_UART.c,83 :: 		}
L_update_values11:
;LCD_UART.c,85 :: 		if (Button(&PORTC, 2, 1, 0) && val_2 + 10 <= 255) {
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
	GOTO        L_update_values15
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
	GOTO        L__update_values35
	MOVF        R1, 0 
	SUBLW       255
L__update_values35:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_values15
L__update_values27:
;LCD_UART.c,86 :: 		val_2 += 10;
	MOVLW       10
	ADDWF       _val_2+0, 1 
	MOVLW       0
	ADDWFC      _val_2+1, 1 
;LCD_UART.c,87 :: 		ready_to_send = 1;
	BSF         _ready_to_send+0, BitPos(_ready_to_send+0) 
;LCD_UART.c,88 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_values16:
	DECFSZ      R13, 1, 1
	BRA         L_update_values16
	DECFSZ      R12, 1, 1
	BRA         L_update_values16
	DECFSZ      R11, 1, 1
	BRA         L_update_values16
	NOP
	NOP
;LCD_UART.c,89 :: 		}
L_update_values15:
;LCD_UART.c,91 :: 		if (Button(&PORTC, 3, 1, 0) && val_2 - 10 >= 0) {
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
	GOTO        L_update_values19
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
	GOTO        L__update_values36
	MOVLW       0
	SUBWF       R1, 0 
L__update_values36:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_values19
L__update_values26:
;LCD_UART.c,92 :: 		val_2 -= 10;
	MOVLW       10
	SUBWF       _val_2+0, 1 
	MOVLW       0
	SUBWFB      _val_2+1, 1 
;LCD_UART.c,93 :: 		ready_to_send = 1;
	BSF         _ready_to_send+0, BitPos(_ready_to_send+0) 
;LCD_UART.c,94 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_update_values20:
	DECFSZ      R13, 1, 1
	BRA         L_update_values20
	DECFSZ      R12, 1, 1
	BRA         L_update_values20
	DECFSZ      R11, 1, 1
	BRA         L_update_values20
	NOP
	NOP
;LCD_UART.c,95 :: 		}
L_update_values19:
;LCD_UART.c,96 :: 		}
L_end_update_values:
	RETURN      0
; end of _update_values

_update_pot:

;LCD_UART.c,100 :: 		void update_pot(){
;LCD_UART.c,101 :: 		old_pot_val = pot_val;
	MOVF        _pot_val+0, 0 
	MOVWF       _old_pot_val+0 
	MOVF        _pot_val+1, 0 
	MOVWF       _old_pot_val+1 
;LCD_UART.c,102 :: 		pot_val = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _pot_val+0 
	MOVF        R1, 0 
	MOVWF       _pot_val+1 
;LCD_UART.c,103 :: 		if (old_pot_val != pot_val){
	MOVF        _old_pot_val+1, 0 
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_pot38
	MOVF        R0, 0 
	XORWF       _old_pot_val+0, 0 
L__update_pot38:
	BTFSC       STATUS+0, 2 
	GOTO        L_update_pot21
;LCD_UART.c,104 :: 		ready_to_send = 1;
	BSF         _ready_to_send+0, BitPos(_ready_to_send+0) 
;LCD_UART.c,105 :: 		}
L_update_pot21:
;LCD_UART.c,106 :: 		}
L_end_update_pot:
	RETURN      0
; end of _update_pot

_update_LCD:

;LCD_UART.c,109 :: 		void update_LCD(){
;LCD_UART.c,110 :: 		sprintf(content_line_1, "%03u %03u %04u", val_1, val_2, pot_val);
	MOVLW       _content_line_1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_content_line_1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_4_LCD_UART+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_4_LCD_UART+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_4_LCD_UART+0)
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
;LCD_UART.c,111 :: 		sprintl(content_line_2, "A:    B:");
	MOVLW       _content_line_2+0
	MOVWF       FARG_sprintl_wh+0 
	MOVLW       hi_addr(_content_line_2+0)
	MOVWF       FARG_sprintl_wh+1 
	MOVLW       ?lstr_5_LCD_UART+0
	MOVWF       FARG_sprintl_f+0 
	MOVLW       hi_addr(?lstr_5_LCD_UART+0)
	MOVWF       FARG_sprintl_f+1 
	MOVLW       higher_addr(?lstr_5_LCD_UART+0)
	MOVWF       FARG_sprintl_f+2 
	CALL        _sprintl+0, 0
;LCD_UART.c,112 :: 		Lcd_Out(1, 1, content_line_1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _content_line_1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_content_line_1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LCD_UART.c,113 :: 		Lcd_Out(2, 1,content_line_2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _content_line_2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_content_line_2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LCD_UART.c,115 :: 		}
L_end_update_LCD:
	RETURN      0
; end of _update_LCD

_terminal_init_message:

;LCD_UART.c,118 :: 		void terminal_init_message(){
;LCD_UART.c,119 :: 		UART1_Write_Text("Connecté au PIC18F45K22");
	MOVLW       ?lstr6_LCD_UART+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_LCD_UART+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;LCD_UART.c,120 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,121 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,122 :: 		UART1_Write_Text("Bienvenue à mon programme...");
	MOVLW       ?lstr7_LCD_UART+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr7_LCD_UART+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;LCD_UART.c,123 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,124 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,125 :: 		UART1_Write_Text("Format des données à envoyer: [X;Y]");
	MOVLW       ?lstr8_LCD_UART+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr8_LCD_UART+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;LCD_UART.c,126 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,127 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,128 :: 		UART1_Write_Text("Où X et Y sont des entiers compris entre 0 et 999.");
	MOVLW       ?lstr9_LCD_UART+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr9_LCD_UART+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;LCD_UART.c,129 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,130 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;LCD_UART.c,131 :: 		}
L_end_terminal_init_message:
	RETURN      0
; end of _terminal_init_message

_LCD_init_message:

;LCD_UART.c,134 :: 		void LCD_init_message(){
;LCD_UART.c,135 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LCD_UART.c,136 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LCD_UART.c,137 :: 		Lcd_Out(1,1,"Initialisation...");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr10_LCD_UART+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr10_LCD_UART+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LCD_UART.c,138 :: 		Delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_LCD_init_message22:
	DECFSZ      R13, 1, 1
	BRA         L_LCD_init_message22
	DECFSZ      R12, 1, 1
	BRA         L_LCD_init_message22
	DECFSZ      R11, 1, 1
	BRA         L_LCD_init_message22
	NOP
	NOP
;LCD_UART.c,139 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LCD_UART.c,140 :: 		}
L_end_LCD_init_message:
	RETURN      0
; end of _LCD_init_message

_init:

;LCD_UART.c,142 :: 		void init(){
;LCD_UART.c,143 :: 		ANSELA  = 0b00000001;
	MOVLW       1
	MOVWF       ANSELA+0 
;LCD_UART.c,144 :: 		ANSELB = 0;
	CLRF        ANSELB+0 
;LCD_UART.c,145 :: 		ANSELD  = 0;
	CLRF        ANSELD+0 
;LCD_UART.c,146 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;LCD_UART.c,148 :: 		ready_to_send = 0;
	BCF         _ready_to_send+0, BitPos(_ready_to_send+0) 
;LCD_UART.c,151 :: 		C1ON_bit = 0;
	BCF         C1ON_bit+0, BitPos(C1ON_bit+0) 
;LCD_UART.c,152 :: 		C2ON_bit = 0;
	BCF         C2ON_bit+0, BitPos(C2ON_bit+0) 
;LCD_UART.c,155 :: 		TRISC = 0b10001111;
	MOVLW       143
	MOVWF       TRISC+0 
;LCD_UART.c,157 :: 		TRISA = 0b00000001;
	MOVLW       1
	MOVWF       TRISA+0 
;LCD_UART.c,161 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;LCD_UART.c,163 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;LCD_UART.c,164 :: 		terminal_init_message();
	CALL        _terminal_init_message+0, 0
;LCD_UART.c,166 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;LCD_UART.c,167 :: 		LCD_init_message();
	CALL        _LCD_init_message+0, 0
;LCD_UART.c,169 :: 		}
L_end_init:
	RETURN      0
; end of _init

_main:

;LCD_UART.c,172 :: 		void main() {
;LCD_UART.c,173 :: 		init();
	CALL        _init+0, 0
;LCD_UART.c,176 :: 		for(;;){
L_main23:
;LCD_UART.c,177 :: 		update_pot();
	CALL        _update_pot+0, 0
;LCD_UART.c,178 :: 		update_values();
	CALL        _update_values+0, 0
;LCD_UART.c,179 :: 		update_LCD();
	CALL        _update_LCD+0, 0
;LCD_UART.c,180 :: 		send_values();
	CALL        _send_values+0, 0
;LCD_UART.c,181 :: 		recieve_values();
	CALL        _recieve_values+0, 0
;LCD_UART.c,182 :: 		}
	GOTO        L_main23
;LCD_UART.c,183 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
