// Connexions du module LCD
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
// Fin des connexions du module LCD


// Declaration des variables globales
int value;
unsigned int pot_value;
char txt_1[] = "Bonjour";
char txt_2[] = "Seuil";
char txt_3[] = "ADC";
char valeur[256] = "";
char potentio[256] = "";

// Lecture de l'etat des boutons
void update_value(){
    char test[256];
    IntToHex(value,test);
    if (Button(&PORTA, 0, 1, 0) && value + 10 <= 1023) {
    value += 10;
    delay_ms(300);
    }

    if (Button(&PORTA, 1, 1, 0) && value - 10 >= 0) {
    value -= 10;
    delay_ms(300);
    }

    if (Button(&PORTA, 2, 1, 0) && value + 100 <= 1023) {
    value += 100;
    delay_ms(300);
    }

    if (Button(&PORTA, 3, 1, 0) && value - 100 >= 0) {
    value -= 100;
    delay_ms(300);
    }
}



// Lecture de l'etat du potentiometre
void update_pot(){
  pot_value = ADC_Read(20);
}

// Comparaison des valeurs value et pot_value
void update_sign(unsigned int a, unsigned int b){
  if (a < b){
    Lcd_Out(2, 12, "S<ADC");
  }
  else{
    if (a > b){
      Lcd_Out(2, 12, "S>ADC" );
    }
    else{
      Lcd_Out(2, 12, "S=ADC" );
    }
  }
}

// Met a jour l'ecran du LCD
void update_LCD(){
  IntToStr(value, valeur);
  Lcd_Out(1, 7, valeur);
  IntToStr(pot_value, potentio);
  Lcd_Out(2,4, potentio);
  update_sign(value, pot_value);
}

// Initialisation des routines uniques
void init(){
  ANSELA  = 0;
  ANSELB = 0;
  ANSELD  = 0b00000001;

  // Desactive les comparateurs
  C1ON_bit = 0;
  C2ON_bit = 0;

  // Initialise les entrees et sorties
  TRISA = 0b00001111;
  TRISD = 0b00000001;

  /*Initialise les objets lies
  au bibliotheques utilisees*/
  ADC_Init();
  Lcd_Init();
  
  /* Affichage des caracteres
  "fixes" de l'ecran du LCD */
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Cmd(_LCD_CURSOR_OFF);
  Lcd_Out(1,1,txt_1);
  Delay_ms(1000);
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Out(1,1,txt_2);
  Lcd_Out(2,1,txt_3);

}

// Fonction principale:
void main() {
 
  init();

  // Programme:
  for(;;){
    update_value();
    update_pot();
    update_LCD();
  }
}