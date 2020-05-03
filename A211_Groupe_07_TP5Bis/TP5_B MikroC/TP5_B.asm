
_ReadFromEEprom:

;TP5_B.c,43 :: 		unsigned short ReadFromEEprom(unsigned short Address) {
;TP5_B.c,45 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;TP5_B.c,46 :: 		I2C1_Wr(EEPROM_WR);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;TP5_B.c,47 :: 		I2C1_Wr(Address);
	MOVF        FARG_ReadFromEEprom_Address+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;TP5_B.c,48 :: 		I2C1_Repeated_Start();
	CALL        _I2C1_Repeated_Start+0, 0
;TP5_B.c,49 :: 		I2C1_Wr(EEPROM_RD);
	MOVLW       161
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;TP5_B.c,50 :: 		temp = I2C1_Rd(0u);
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       ReadFromEEprom_temp_L0+0 
;TP5_B.c,51 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;TP5_B.c,52 :: 		return temp;
	MOVF        ReadFromEEprom_temp_L0+0, 0 
	MOVWF       R0 
;TP5_B.c,53 :: 		}
L_end_ReadFromEEprom:
	RETURN      0
; end of _ReadFromEEprom

_WriteToEEprom:

;TP5_B.c,56 :: 		void WriteToEEprom(unsigned short Address, unsigned short Data) {
;TP5_B.c,57 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;TP5_B.c,58 :: 		I2C1_Wr(EEPROM_WR);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;TP5_B.c,59 :: 		I2C1_Wr(Address);
	MOVF        FARG_WriteToEEprom_Address+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;TP5_B.c,60 :: 		I2C1_Wr(Data);
	MOVF        FARG_WriteToEEprom_Data+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;TP5_B.c,61 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;TP5_B.c,62 :: 		}
L_end_WriteToEEprom:
	RETURN      0
; end of _WriteToEEprom

_send_values:

;TP5_B.c,64 :: 		void send_values(char val_to_send){
;TP5_B.c,66 :: 		UART1_Write_Text(val_to_send);
	MOVF        FARG_send_values_val_to_send+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       0
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP5_B.c,68 :: 		UART1_Write(LF);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP5_B.c,69 :: 		UART1_Write(CR);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TP5_B.c,70 :: 		}
L_end_send_values:
	RETURN      0
; end of _send_values

_hexDump:

;TP5_B.c,73 :: 		void hexDump(char *desc, void *addr, int len)
;TP5_B.c,77 :: 		unsigned char *pc = addr;
	MOVF        FARG_hexDump_addr+0, 0 
	MOVWF       hexDump_pc_L0+0 
	MOVF        FARG_hexDump_addr+1, 0 
	MOVWF       hexDump_pc_L0+1 
;TP5_B.c,81 :: 		if (desc != 0x00){
	MOVLW       0
	XORWF       FARG_hexDump_desc+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hexDump50
	MOVLW       0
	XORWF       FARG_hexDump_desc+0, 0 
L__hexDump50:
	BTFSC       STATUS+0, 2 
	GOTO        L_hexDump0
;TP5_B.c,82 :: 		sprintf(to_send, "%p (%s):\n", addr, desc);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_1_TP5_B+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_TP5_B+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_TP5_B+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        FARG_hexDump_addr+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        FARG_hexDump_addr+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        FARG_hexDump_desc+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        FARG_hexDump_desc+1, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;TP5_B.c,83 :: 		UART1_Write_Text(to_send);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP5_B.c,84 :: 		memset(to_send, '\0', sizeof(to_send));
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       50
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;TP5_B.c,85 :: 		}
	GOTO        L_hexDump1
L_hexDump0:
;TP5_B.c,87 :: 		sprintf(to_send, "%p:\n", addr);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_2_TP5_B+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_2_TP5_B+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_2_TP5_B+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        FARG_hexDump_addr+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        FARG_hexDump_addr+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;TP5_B.c,88 :: 		UART1_Write_Text(to_send);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP5_B.c,89 :: 		memset(to_send, '\0', sizeof(to_send));
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       50
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;TP5_B.c,90 :: 		}
L_hexDump1:
;TP5_B.c,93 :: 		for (i = 0; i < len; i++) {
	CLRF        hexDump_i_L0+0 
	CLRF        hexDump_i_L0+1 
L_hexDump2:
	MOVLW       128
	XORWF       hexDump_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_hexDump_len+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hexDump51
	MOVF        FARG_hexDump_len+0, 0 
	SUBWF       hexDump_i_L0+0, 0 
L__hexDump51:
	BTFSC       STATUS+0, 0 
	GOTO        L_hexDump3
;TP5_B.c,96 :: 		if ((i % 16) == 0) {
	MOVLW       16
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        hexDump_i_L0+0, 0 
	MOVWF       R0 
	MOVF        hexDump_i_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hexDump52
	MOVLW       0
	XORWF       R0, 0 
L__hexDump52:
	BTFSS       STATUS+0, 2 
	GOTO        L_hexDump5
;TP5_B.c,98 :: 		if (i != 0)
	MOVLW       0
	XORWF       hexDump_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hexDump53
	MOVLW       0
	XORWF       hexDump_i_L0+0, 0 
L__hexDump53:
	BTFSC       STATUS+0, 2 
	GOTO        L_hexDump6
;TP5_B.c,99 :: 		sprintf (to_send, "  %s\n ", buff);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_3_TP5_B+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_3_TP5_B+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_3_TP5_B+0)
	MOVWF       FARG_sprintf_f+2 
	MOVLW       hexDump_buff_L0+0
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       hi_addr(hexDump_buff_L0+0)
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
L_hexDump6:
;TP5_B.c,102 :: 		sprintf (to_send, "  %04x ", i);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_4_TP5_B+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_4_TP5_B+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_4_TP5_B+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        hexDump_i_L0+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        hexDump_i_L0+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;TP5_B.c,103 :: 		UART1_Write_Text(to_send);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP5_B.c,104 :: 		memset(to_send, '\0', sizeof(to_send));
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       50
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;TP5_B.c,105 :: 		}
L_hexDump5:
;TP5_B.c,108 :: 		sprintf (to_send, " %02x", pc[i]);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_5_TP5_B+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_5_TP5_B+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_5_TP5_B+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        hexDump_i_L0+0, 0 
	ADDWF       hexDump_pc_L0+0, 0 
	MOVWF       FSR0 
	MOVF        hexDump_i_L0+1, 0 
	ADDWFC      hexDump_pc_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	CALL        _sprintf+0, 0
;TP5_B.c,109 :: 		UART1_Write_Text(to_send);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP5_B.c,110 :: 		memset(to_send, '\0', sizeof(to_send));
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       50
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;TP5_B.c,113 :: 		if ((pc[i] < 0x20) || (pc[i] > 0x7e))
	MOVF        hexDump_i_L0+0, 0 
	ADDWF       hexDump_pc_L0+0, 0 
	MOVWF       FSR0 
	MOVF        hexDump_i_L0+1, 0 
	ADDWFC      hexDump_pc_L0+1, 0 
	MOVWF       FSR0H 
	MOVLW       32
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L__hexDump40
	MOVF        hexDump_i_L0+0, 0 
	ADDWF       hexDump_pc_L0+0, 0 
	MOVWF       FSR0 
	MOVF        hexDump_i_L0+1, 0 
	ADDWFC      hexDump_pc_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       126
	BTFSS       STATUS+0, 0 
	GOTO        L__hexDump40
	GOTO        L_hexDump9
L__hexDump40:
;TP5_B.c,114 :: 		buff[i % 16] = '.';
	MOVLW       16
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        hexDump_i_L0+0, 0 
	MOVWF       R0 
	MOVF        hexDump_i_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       hexDump_buff_L0+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(hexDump_buff_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       46
	MOVWF       POSTINC1+0 
	GOTO        L_hexDump10
L_hexDump9:
;TP5_B.c,116 :: 		buff[i % 16] = pc[i];
	MOVLW       16
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        hexDump_i_L0+0, 0 
	MOVWF       R0 
	MOVF        hexDump_i_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       hexDump_buff_L0+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(hexDump_buff_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        hexDump_i_L0+0, 0 
	ADDWF       hexDump_pc_L0+0, 0 
	MOVWF       FSR0 
	MOVF        hexDump_i_L0+1, 0 
	ADDWFC      hexDump_pc_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
L_hexDump10:
;TP5_B.c,117 :: 		buff[(i % 16) + 1] = '\0';
	MOVLW       16
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        hexDump_i_L0+0, 0 
	MOVWF       R0 
	MOVF        hexDump_i_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	INFSNZ      R0, 1 
	INCF        R1, 1 
	MOVLW       hexDump_buff_L0+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(hexDump_buff_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;TP5_B.c,93 :: 		for (i = 0; i < len; i++) {
	INFSNZ      hexDump_i_L0+0, 1 
	INCF        hexDump_i_L0+1, 1 
;TP5_B.c,118 :: 		}
	GOTO        L_hexDump2
L_hexDump3:
;TP5_B.c,121 :: 		while ((i % 16) != 0) {
L_hexDump11:
	MOVLW       16
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        hexDump_i_L0+0, 0 
	MOVWF       R0 
	MOVF        hexDump_i_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hexDump54
	MOVLW       0
	XORWF       R0, 0 
L__hexDump54:
	BTFSC       STATUS+0, 2 
	GOTO        L_hexDump12
;TP5_B.c,122 :: 		UART1_Write_Text("   ");
	MOVLW       ?lstr6_TP5_B+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_TP5_B+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP5_B.c,123 :: 		i++;
	INFSNZ      hexDump_i_L0+0, 1 
	INCF        hexDump_i_L0+1, 1 
;TP5_B.c,124 :: 		}
	GOTO        L_hexDump11
L_hexDump12:
;TP5_B.c,127 :: 		sprintf (to_send, "  %s\n", buff);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_7_TP5_B+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_7_TP5_B+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_7_TP5_B+0)
	MOVWF       FARG_sprintf_f+2 
	MOVLW       hexDump_buff_L0+0
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       hi_addr(hexDump_buff_L0+0)
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;TP5_B.c,128 :: 		UART1_Write_Text(to_send);
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;TP5_B.c,129 :: 		memset(to_send, '\0', sizeof(to_send));
	MOVLW       hexDump_to_send_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(hexDump_to_send_L0+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       50
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;TP5_B.c,130 :: 		}
L_end_hexDump:
	RETURN      0
; end of _hexDump

_update_values:

;TP5_B.c,132 :: 		void update_values(){
;TP5_B.c,133 :: 		if (Button(&PORTD, 0, 1, 1)){
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values13
;TP5_B.c,134 :: 		old_state_1 = 1;
	BSF         _old_state_1+0, BitPos(_old_state_1+0) 
;TP5_B.c,135 :: 		}
L_update_values13:
;TP5_B.c,136 :: 		if (Button(&PORTD, 0, 1, 0 ) && old_state_1) {
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values16
	BTFSS       _old_state_1+0, BitPos(_old_state_1+0) 
	GOTO        L_update_values16
L__update_values43:
;TP5_B.c,137 :: 		start_flag = 1;
	BSF         _start_flag+0, BitPos(_start_flag+0) 
;TP5_B.c,138 :: 		old_state_1 = 0;
	BCF         _old_state_1+0, BitPos(_old_state_1+0) 
;TP5_B.c,139 :: 		}
L_update_values16:
;TP5_B.c,141 :: 		if (Button(&PORTD, 1, 1, 1)){
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values17
;TP5_B.c,142 :: 		old_state_2 = 1;
	BSF         _old_state_2+0, BitPos(_old_state_2+0) 
;TP5_B.c,143 :: 		}
L_update_values17:
;TP5_B.c,144 :: 		if (Button(&PORTD, 1, 1, 0 ) && old_state_2) {
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values20
	BTFSS       _old_state_2+0, BitPos(_old_state_2+0) 
	GOTO        L_update_values20
L__update_values42:
;TP5_B.c,145 :: 		start_flag = 0;
	BCF         _start_flag+0, BitPos(_start_flag+0) 
;TP5_B.c,146 :: 		LCD_Out(2,6,"Stop        ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_TP5_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_TP5_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP5_B.c,147 :: 		old_state_2 = 0;
	BCF         _old_state_2+0, BitPos(_old_state_2+0) 
;TP5_B.c,148 :: 		}
L_update_values20:
;TP5_B.c,150 :: 		if (Button(&PORTD, 2, 1, 1)){
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values21
;TP5_B.c,151 :: 		old_state_3 = 1;
	BSF         _old_state_3+0, BitPos(_old_state_3+0) 
;TP5_B.c,152 :: 		}
L_update_values21:
;TP5_B.c,153 :: 		if (Button(&PORTD, 2, 1, 0 ) && old_state_3) {
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_update_values24
	BTFSS       _old_state_3+0, BitPos(_old_state_3+0) 
	GOTO        L_update_values24
L__update_values41:
;TP5_B.c,154 :: 		dump_flag = 1;
	BSF         _dump_flag+0, BitPos(_dump_flag+0) 
;TP5_B.c,155 :: 		old_state_3 = 0;
	BCF         _old_state_3+0, BitPos(_old_state_3+0) 
;TP5_B.c,156 :: 		}
L_update_values24:
;TP5_B.c,157 :: 		}
L_end_update_values:
	RETURN      0
; end of _update_values

_adc2eeprom:

;TP5_B.c,161 :: 		void adc2eeprom(){
;TP5_B.c,163 :: 		while(start_flag && index <= 100 && (last_index!=index)){
L_adc2eeprom25:
	BTFSS       _start_flag+0, BitPos(_start_flag+0) 
	GOTO        L_adc2eeprom26
	MOVF        _index+0, 0 
	SUBLW       100
	BTFSS       STATUS+0, 0 
	GOTO        L_adc2eeprom26
	MOVF        _last_index+0, 0 
	XORWF       _index+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_adc2eeprom26
L__adc2eeprom44:
;TP5_B.c,164 :: 		adc = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;TP5_B.c,166 :: 		WriteToEEprom(index, adc);
	MOVF        _index+0, 0 
	MOVWF       FARG_WriteToEEprom_Address+0 
	MOVF        R0, 0 
	MOVWF       FARG_WriteToEEprom_Data+0 
	CALL        _WriteToEEprom+0, 0
;TP5_B.c,167 :: 		Delay_10ms();
	CALL        _Delay_10ms+0, 0
;TP5_B.c,168 :: 		update_values();
	CALL        _update_values+0, 0
;TP5_B.c,169 :: 		LCD_Out(2,6,"Start         ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr9_TP5_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr9_TP5_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP5_B.c,170 :: 		last_index = index ;
	MOVF        _index+0, 0 
	MOVWF       _last_index+0 
;TP5_B.c,171 :: 		}
	GOTO        L_adc2eeprom25
L_adc2eeprom26:
;TP5_B.c,172 :: 		}
L_end_adc2eeprom:
	RETURN      0
; end of _adc2eeprom

_reset_if_last_pos:

;TP5_B.c,175 :: 		void reset_if_last_pos(){
;TP5_B.c,176 :: 		if (dump_index == index){
	MOVF        _dump_index+0, 0 
	XORWF       _index+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_reset_if_last_pos29
;TP5_B.c,177 :: 		dump_flag = 0;
	BCF         _dump_flag+0, BitPos(_dump_flag+0) 
;TP5_B.c,178 :: 		dump_index = 0;
	CLRF        _dump_index+0 
;TP5_B.c,179 :: 		}
L_reset_if_last_pos29:
;TP5_B.c,180 :: 		dump_index++;
	INCF        _dump_index+0, 1 
;TP5_B.c,181 :: 		}
L_end_reset_if_last_pos:
	RETURN      0
; end of _reset_if_last_pos

_dump_from_eeprom:

;TP5_B.c,185 :: 		void dump_from_eeprom(){
;TP5_B.c,186 :: 		while (dump_flag && !start_flag){
L_dump_from_eeprom30:
	BTFSS       _dump_flag+0, BitPos(_dump_flag+0) 
	GOTO        L_dump_from_eeprom31
	BTFSC       _start_flag+0, BitPos(_start_flag+0) 
	GOTO        L_dump_from_eeprom31
L__dump_from_eeprom45:
;TP5_B.c,189 :: 		eeprom_val = ReadFromEEprom(dump_index);
	MOVF        _dump_index+0, 0 
	MOVWF       FARG_ReadFromEEprom_Address+0 
	CALL        _ReadFromEEprom+0, 0
	MOVF        R0, 0 
	MOVWF       dump_from_eeprom_eeprom_val_L1+0 
	MOVLW       0
	MOVWF       dump_from_eeprom_eeprom_val_L1+1 
;TP5_B.c,190 :: 		eeprom_val = eeprom_val<<2;
	MOVF        dump_from_eeprom_eeprom_val_L1+0, 0 
	MOVWF       R0 
	MOVF        dump_from_eeprom_eeprom_val_L1+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	MOVWF       dump_from_eeprom_eeprom_val_L1+0 
	MOVF        R1, 0 
	MOVWF       dump_from_eeprom_eeprom_val_L1+1 
;TP5_B.c,191 :: 		sprintf(content_eeprom,"%04u",eeprom_val);
	MOVLW       dump_from_eeprom_content_eeprom_L1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(dump_from_eeprom_content_eeprom_L1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_10_TP5_B+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_10_TP5_B+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_10_TP5_B+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;TP5_B.c,193 :: 		hexDump("Frame:", content_eeprom, sizeof(content_eeprom));
	MOVLW       ?lstr11_TP5_B+0
	MOVWF       FARG_hexDump_desc+0 
	MOVLW       hi_addr(?lstr11_TP5_B+0)
	MOVWF       FARG_hexDump_desc+1 
	MOVLW       dump_from_eeprom_content_eeprom_L1+0
	MOVWF       FARG_hexDump_addr+0 
	MOVLW       hi_addr(dump_from_eeprom_content_eeprom_L1+0)
	MOVWF       FARG_hexDump_addr+1 
	MOVLW       16
	MOVWF       FARG_hexDump_len+0 
	MOVLW       0
	MOVWF       FARG_hexDump_len+1 
	CALL        _hexDump+0, 0
;TP5_B.c,194 :: 		LCD_Out(1,1,content_eeprom);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       dump_from_eeprom_content_eeprom_L1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(dump_from_eeprom_content_eeprom_L1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP5_B.c,195 :: 		LCD_Out(2,6,"Dumping...    ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr12_TP5_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr12_TP5_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP5_B.c,196 :: 		reset_if_last_pos();
	CALL        _reset_if_last_pos+0, 0
;TP5_B.c,197 :: 		}
	GOTO        L_dump_from_eeprom30
L_dump_from_eeprom31:
;TP5_B.c,198 :: 		}
L_end_dump_from_eeprom:
	RETURN      0
; end of _dump_from_eeprom

_Interrupt:

;TP5_B.c,201 :: 		void Interrupt(){
;TP5_B.c,202 :: 		if (TMR0IF_bit){
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_Interrupt34
;TP5_B.c,203 :: 		TMR0IF_bit    = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;TP5_B.c,204 :: 		TMR0H         = 0x0B;
	MOVLW       11
	MOVWF       TMR0H+0 
;TP5_B.c,205 :: 		TMR0L         = 0xDC;
	MOVLW       220
	MOVWF       TMR0L+0 
;TP5_B.c,206 :: 		if (start_flag){
	BTFSS       _start_flag+0, BitPos(_start_flag+0) 
	GOTO        L_Interrupt35
;TP5_B.c,207 :: 		index++;
	INCF        _index+0, 1 
;TP5_B.c,208 :: 		}
L_Interrupt35:
;TP5_B.c,209 :: 		}
L_Interrupt34:
;TP5_B.c,210 :: 		}
L_end_Interrupt:
L__Interrupt60:
	RETFIE      1
; end of _Interrupt

_LCD_init_message:

;TP5_B.c,213 :: 		void LCD_init_message(){
;TP5_B.c,214 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TP5_B.c,215 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TP5_B.c,216 :: 		Lcd_Out(1,1,"Initialisation...");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr13_TP5_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr13_TP5_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP5_B.c,217 :: 		Delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_LCD_init_message36:
	DECFSZ      R13, 1, 1
	BRA         L_LCD_init_message36
	DECFSZ      R12, 1, 1
	BRA         L_LCD_init_message36
	DECFSZ      R11, 1, 1
	BRA         L_LCD_init_message36
	NOP
	NOP
;TP5_B.c,218 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TP5_B.c,219 :: 		Lcd_Out(2,1,"Mode:Attente");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr14_TP5_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr14_TP5_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP5_B.c,220 :: 		}
L_end_LCD_init_message:
	RETURN      0
; end of _LCD_init_message

_init:

;TP5_B.c,223 :: 		void init(){
;TP5_B.c,225 :: 		ANSELA        = 0b00000001;
	MOVLW       1
	MOVWF       ANSELA+0 
;TP5_B.c,226 :: 		ANSELB        = 0;
	CLRF        ANSELB+0 
;TP5_B.c,227 :: 		ANSELD        = 0;
	CLRF        ANSELD+0 
;TP5_B.c,228 :: 		ANSELC        = 0;
	CLRF        ANSELC+0 
;TP5_B.c,231 :: 		C1ON_bit      = 0;
	BCF         C1ON_bit+0, BitPos(C1ON_bit+0) 
;TP5_B.c,232 :: 		C2ON_bit      = 0;
	BCF         C2ON_bit+0, BitPos(C2ON_bit+0) 
;TP5_B.c,235 :: 		TRISD         = 0b00000111;
	MOVLW       7
	MOVWF       TRISD+0 
;TP5_B.c,236 :: 		TRISA         = 0b00000001;
	MOVLW       1
	MOVWF       TRISA+0 
;TP5_B.c,237 :: 		TRISB         = 0;
	CLRF        TRISB+0 
;TP5_B.c,240 :: 		start_flag    = 0;
	BCF         _start_flag+0, BitPos(_start_flag+0) 
;TP5_B.c,241 :: 		dump_flag     = 0;
	BCF         _dump_flag+0, BitPos(_dump_flag+0) 
;TP5_B.c,242 :: 		old_state_1   = 0;
	BCF         _old_state_1+0, BitPos(_old_state_1+0) 
;TP5_B.c,243 :: 		old_state_2   = 0;
	BCF         _old_state_2+0, BitPos(_old_state_2+0) 
;TP5_B.c,246 :: 		T0CON         = 0x85;
	MOVLW       133
	MOVWF       T0CON+0 
;TP5_B.c,247 :: 		TMR0H         = 0x0B;
	MOVLW       11
	MOVWF       TMR0H+0 
;TP5_B.c,248 :: 		TMR0L         = 0xDC;
	MOVLW       220
	MOVWF       TMR0L+0 
;TP5_B.c,249 :: 		GIE_bit       = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;TP5_B.c,250 :: 		TMR0IE_bit    = 1;
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;TP5_B.c,254 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;TP5_B.c,255 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;TP5_B.c,256 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;TP5_B.c,257 :: 		I2C1_Init(100000);  // initalise le I2C
	MOVLW       20
	MOVWF       SSP1ADD+0 
	CALL        _I2C1_Init+0, 0
;TP5_B.c,258 :: 		Delay_100ms();
	CALL        _Delay_100ms+0, 0
;TP5_B.c,259 :: 		LCD_init_message();
	CALL        _LCD_init_message+0, 0
;TP5_B.c,260 :: 		}
L_end_init:
	RETURN      0
; end of _init

_main:

;TP5_B.c,263 :: 		void main(){
;TP5_B.c,264 :: 		init();
	CALL        _init+0, 0
;TP5_B.c,267 :: 		for(;;){
L_main37:
;TP5_B.c,268 :: 		test_val = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _test_val+0 
	MOVF        R1, 0 
	MOVWF       _test_val+1 
;TP5_B.c,269 :: 		sprintf(test_tableau,"ADC:%04u", test_val);
	MOVLW       _test_tableau+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_test_tableau+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_15_TP5_B+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_15_TP5_B+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_15_TP5_B+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;TP5_B.c,270 :: 		LCD_Out(1,9,test_tableau);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _test_tableau+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_test_tableau+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TP5_B.c,271 :: 		update_values();
	CALL        _update_values+0, 0
;TP5_B.c,272 :: 		adc2eeprom();
	CALL        _adc2eeprom+0, 0
;TP5_B.c,273 :: 		dump_from_eeprom();
	CALL        _dump_from_eeprom+0, 0
;TP5_B.c,274 :: 		}
	GOTO        L_main37
;TP5_B.c,275 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
