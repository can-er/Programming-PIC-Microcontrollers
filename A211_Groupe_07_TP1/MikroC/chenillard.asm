
_decalage_droite:

;can.c,9 :: 		void decalage_droite(){
;can.c,10 :: 		while (mesLeds != 0x01) { // Tant que mesLeds != 0b00000001
L_decalage_droite0:
	MOVF        _mesLeds+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_decalage_droite1
;can.c,11 :: 		mesLeds = mesLeds>>1; // Decalage a droite
	MOVF        _mesLeds+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        R0, 0 
	MOVWF       _mesLeds+0 
;can.c,12 :: 		LATC = mesLeds;
	MOVF        R0, 0 
	MOVWF       LATC+0 
;can.c,13 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_decalage_droite2:
	DECFSZ      R13, 1, 1
	BRA         L_decalage_droite2
	DECFSZ      R12, 1, 1
	BRA         L_decalage_droite2
	DECFSZ      R11, 1, 1
	BRA         L_decalage_droite2
;can.c,14 :: 		}
	GOTO        L_decalage_droite0
L_decalage_droite1:
;can.c,15 :: 		}
L_end_decalage_droite:
	RETURN      0
; end of _decalage_droite

_decalage_gauche:

;can.c,17 :: 		void decalage_gauche(){
;can.c,18 :: 		while (mesLeds != 0x80) { // Tant que mesLeds != 0b10000000
L_decalage_gauche3:
	MOVF        _mesLeds+0, 0 
	XORLW       128
	BTFSC       STATUS+0, 2 
	GOTO        L_decalage_gauche4
;can.c,19 :: 		mesLeds = mesLeds<<1; // Decalage a gauche
	MOVF        _mesLeds+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	MOVWF       _mesLeds+0 
;can.c,20 :: 		LATC = mesLeds;
	MOVF        R0, 0 
	MOVWF       LATC+0 
;can.c,21 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_decalage_gauche5:
	DECFSZ      R13, 1, 1
	BRA         L_decalage_gauche5
	DECFSZ      R12, 1, 1
	BRA         L_decalage_gauche5
	DECFSZ      R11, 1, 1
	BRA         L_decalage_gauche5
;can.c,22 :: 		}
	GOTO        L_decalage_gauche3
L_decalage_gauche4:
;can.c,23 :: 		}
L_end_decalage_gauche:
	RETURN      0
; end of _decalage_gauche

_main:

;can.c,25 :: 		void main() {
;can.c,27 :: 		TRISC = 0;  // Initialisation du registre de direction du PORT(B) en SORTIE digitale
	CLRF        TRISC+0 
;can.c,28 :: 		LATC = 0; // Initialisation des bits du PORT(B) a l'etat BAS
	CLRF        LATC+0 
;can.c,29 :: 		mesLeds = 1; // Initialisation de l'etat initiale de la chenille
	MOVLW       1
	MOVWF       _mesLeds+0 
;can.c,30 :: 		LATC = mesLeds; // Initialisation de l'etat du PORT(B) a la variable "mesLeds"
	MOVLW       1
	MOVWF       LATC+0 
;can.c,33 :: 		while(1) {
L_main6:
;can.c,35 :: 		if (sens == TRUE) { // Si sens est a 1 on decale a gauche
	MOVLW       0
	XORWF       _sens+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main13
	MOVLW       1
	XORWF       _sens+0, 0 
L__main13:
	BTFSS       STATUS+0, 2 
	GOTO        L_main8
;can.c,36 :: 		decalage_gauche();
	CALL        _decalage_gauche+0, 0
;can.c,37 :: 		sens = FALSE;
	CLRF        _sens+0 
	CLRF        _sens+1 
;can.c,38 :: 		}
	GOTO        L_main9
L_main8:
;can.c,40 :: 		decalage_droite();
	CALL        _decalage_droite+0, 0
;can.c,41 :: 		sens = TRUE;
	MOVLW       1
	MOVWF       _sens+0 
	MOVLW       0
	MOVWF       _sens+1 
;can.c,42 :: 		}
L_main9:
;can.c,44 :: 		}
	GOTO        L_main6
;can.c,45 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
