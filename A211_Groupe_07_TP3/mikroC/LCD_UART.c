#define SOT 2
#define EOT 3
#define LF 10
#define CR 13

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
int val_1 = 0;
int val_2 = 0;

bit ready_to_send;

unsigned int pot_val;
unsigned int old_pot_val;

char content_line_1[16];
char content_line_2[16];
char buffer[12];
char recieved_data[12];

// Envoi des valeurs
void send_values(){
  if (ready_to_send){
    UART1_Write(SOT);
    UART1_Write_Text(content_line_1);
    UART1_Write(EOT);
    UART1_Write(LF);
    UART1_Write(CR);
    ready_to_send = 0;
  }
}

// Reception des valeurs
void recieve_values(){
  if(UART1_Data_Ready()) {
    UART1_Read_Text(recieved_data,"]",10);
    strncpy(buffer,recieved_data+2,1);
    
    if (recieved_data[0] == 0x15){
      // Cas où le message provient du programme Python:
      Lcd_Out(1,14, "NOK");
      Delay_ms(500);
    }
    else{
      // Cas où le message provient du Terminal RS232:
      strncpy(buffer,recieved_data+2,3);
      Lcd_Out(2,3, buffer);
      strncpy(buffer,recieved_data+5,3);
      Lcd_Out(2,9, buffer);
      Lcd_Out(1,14, " OK");
    }
    memset(buffer,'\0',sizeof(buffer));
  }
}

// Lecture de l'etat des boutons
void update_values(){
    if (Button(&PORTC, 0, 1, 0) && val_1 + 10 <= 255) {
    val_1 += 10;
    ready_to_send = 1;
    delay_ms(300);
    }

    if (Button(&PORTC, 1, 1, 0) && val_1 - 10 >= 0) {
    val_1 -= 10;
    ready_to_send = 1;
    delay_ms(300);
    }

    if (Button(&PORTC, 2, 1, 0) && val_2 + 10 <= 255) {
    val_2 += 10;
    ready_to_send = 1;
    delay_ms(300);
    }

    if (Button(&PORTC, 3, 1, 0) && val_2 - 10 >= 0) {
    val_2 -= 10;
    ready_to_send = 1;
    delay_ms(300);
    }
}


// Lecture de l'etat du potentiometre
void update_pot(){
  old_pot_val = pot_val;
  pot_val = ADC_Read(0);
  if (old_pot_val != pot_val){
    ready_to_send = 1;
  }
}

// Met a jour l'ecran du LCD
void update_LCD(){
  sprintf(content_line_1, "%03u %03u %04u", val_1, val_2, pot_val);
  sprintl(content_line_2, "A:    B:");
  Lcd_Out(1, 1, content_line_1);
  Lcd_Out(2, 1,content_line_2);
  //Lcd_Chr_CP(buffer);
}

// Affichage du message initial sur le Terminal
void terminal_init_message(){
  UART1_Write_Text("Connecté au PIC18F45K22");
  UART1_Write(LF);
  UART1_Write(CR);
  UART1_Write_Text("Bienvenue à mon programme...");
  UART1_Write(LF);
  UART1_Write(CR);
  UART1_Write_Text("Format des données à envoyer: [X;Y]");
  UART1_Write(LF);
  UART1_Write(CR);
  UART1_Write_Text("Où X et Y sont des entiers compris entre 0 et 999.");
  UART1_Write(LF);
  UART1_Write(CR);
}

// Affichage du message initial sur le LCD
void LCD_init_message(){
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Cmd(_LCD_CURSOR_OFF);
  Lcd_Out(1,1,"Initialisation...");
  Delay_ms(1000);
  Lcd_Cmd(_LCD_CLEAR);
}
// Initialisation des routines uniques
void init(){
  ANSELA  = 0b00000001;
  ANSELB = 0;
  ANSELD  = 0;
  ANSELC = 0;
  
  ready_to_send = 0;

  // Desactive les comparateurs
  C1ON_bit = 0;
  C2ON_bit = 0;

  // Initialise les entrees et sorties
  TRISC = 0b10001111;

  TRISA = 0b00000001;

  /*Initialise les objets lies
  au bibliotheques utilisees*/
  ADC_Init();

  UART1_Init(9600);
  terminal_init_message();

  Lcd_Init();
  LCD_init_message();

}

// Fonction principale:
void main() {
     init();

  // Programme:
  for(;;){        
    update_pot();
    update_values();
    update_LCD();
    send_values();
    recieve_values();
  }
}