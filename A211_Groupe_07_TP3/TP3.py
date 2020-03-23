"""
Auteur: KORKUT Caner - Ephec ISAT
Veuillez conecter le Terminal RS232 au microcontrôleur avant de lancer le programme.
Utilisation: ex: "python3 TP3.py 21"  
"""

import serial
import time 
import sys

myCom = serial.Serial()
portNumber = sys.argv[1]
myCom.port = 'COM'+str(portNumber)


packet = bytearray()
packet.append(0x15) # "NAK" caractère de non acquis attendu par le PIC18F45K22
packet.append(0x5D) # "]" caractère de fin attendu par le PIC18F45K22

#packet = b'\x15\x5D' => Ceci aurait pu substituer les 3 lignes précédentes


#Programme:
while True:

	try: # On essaye de se connecter au même port que le Terminal. 
		myCom.open() 			

	except serial.SerialException: # Port occupé: probablement utilisé par le Terminal 
		print("Microcontroleur connecté au Terminal...\n")

	else: # Si on y arrive:	
		myCom.write(packet)
		myCom.close()
		print('Envoi de paquets "NACK" au PIC18F45K22. => Terminal déconnecté.')
	time.sleep(0.5)