#line 1 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/can.c"




unsigned char mesLeds = 0;
int sens = 0;


void decalage_droite(){
 while (mesLeds != 0x01) {
 mesLeds = mesLeds>>1;
 LATC = mesLeds;
 Delay_ms(200);
 }
}

void decalage_gauche(){
 while (mesLeds != 0x80) {
 mesLeds = mesLeds<<1;
 LATC = mesLeds;
 Delay_ms(200);
 }
}

void main() {

 TRISC = 0;
 LATC = 0;
 mesLeds = 1;
 LATC = mesLeds;


 while(1) {

 if (sens ==  1 ) {
 decalage_gauche();
 sens =  0 ;
 }
 else {
 decalage_droite();
 sens =  1 ;
 }

 }
}
