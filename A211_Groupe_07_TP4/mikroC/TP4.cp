#line 1 "C:/Users/HE303710/Desktop/Simple LCD/TP4.c"
#line 6 "C:/Users/HE303710/Desktop/Simple LCD/TP4.c"
unsigned int compteur, millier, centaine, dizaine, unite;
unsigned char index;
unsigned char Segment[4]={0,0,0,0};


const unsigned char conversion[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

bit oldState;
int i;


void Interrupt(void){
 if (TMR0IF_bit){
 TMR0IF_bit = 0;
 TMR0H = 0xD8;
 TMR0L = 0xF0;
 LATA = 0;
 LATD = Segment[index];
 LATA = 1 << index;
 index++;
 index = index%4;
 }
}


void Update_display(void)
{
 millier = (compteur/1000)%10;
 Segment[3] = conversion[millier];
 centaine = (compteur/100)%10;
 Segment[2] = conversion[centaine];
 dizaine = (compteur/10)%10;
 Segment[1] = conversion[dizaine];
 unite = compteur%10;
 Segment[0] = conversion[unite];
}

void setValue(int n){
 if (n == 0 && compteur +1 < 1000){
 compteur += 1;
 }
 else if (n == 1 && compteur -1 > 0){
 compteur -= 1;
 }
 else if (n == 2 && compteur +10 < 1000){
 compteur += 10;
 }
 else if (n == 3 && compteur -1 > 0){
 compteur -= 10;
 }
 else if (n == 4 && compteur +100 < 1000){
 compteur += 100;
 }
 else if (n == 5 && compteur -1 > 0){
 compteur -= 100;
 }
 else{
 compteur = 0;
 }
}

void update_value(void){
 for (i = 0; i < 6; i++){
 if (Button(&PORTC, i, 1, 1)){
 oldState = 1;
 }
 if (Button(&PORTC, i, 1, 0) && oldState){
 setValue(i);
 }
 }
}


void main(void) {
 ANSELA = 0;
 ANSELD = 0;
 TRISA = 0;
 LATA = 0;
 TRISD = 0;

 TRISC = 0b01111111;
 ANSELC = 0;
 oldState = 0;

 LATD = 0;
 compteur = 0;
 index = 0;

 T0CON = 0x88;
 TMR0H = 0xD8;
 TMR0L = 0xF0;
 INTCON.GIE = 1;
 INTCON.TMR0IE = 1;


 while(1) {
 Update_display();
 update_value();
 delay_ms(100);
 }
}
