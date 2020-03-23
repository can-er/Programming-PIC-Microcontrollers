#define SOT 2
#define EOT 3
#define LF 10
#define CR 13
#define MAX_CMD_LEN 40

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
int index;

bit update_flag;
bit data_recieved_flag;

unsigned int pot_val;
unsigned int old_pot_val;

char content_line_1[16];
char buffer[MAX_CMD_LEN];
char recieved_data;
char command_line[MAX_CMD_LEN];

// Envoi des valeurs
void send_values(){
  if (update_flag){
    UART1_Write(SOT);
    UART1_Write_Text(content_line_1);
    UART1_Write(EOT);
    UART1_Write(LF);
    UART1_Write(CR);
    update_flag = 0;
  }
}

 // Interrupt
void interrupt(){
   if(RC1IF_bit == 1){
     recieved_data  = UART_Read();
     switch (recieved_data){
        case '[': // Debut de l'acquisition
          index = 0;
          break;
        case ']': // Fin de l'acquisition
          command_line[index+1] = '\0';
          data_recieved_flag = 1;
          break;
        default : // Acquisition de la donnee
          command_line[index++] = recieved_data;
     }
   }
}

// Lecture de l'etat des boutons
void update_values(){
    if (Button(&PORTC, 0, 1, 0) && val_1 + 10 <= 255) {
      val_1 += 10;
      update_flag = 1;
      delay_ms(300);
    }

    if (Button(&PORTC, 1, 1, 0) && val_1 - 10 >= 0) {
      val_1 -= 10;
      update_flag = 1;
      delay_ms(300);
    }

    if (Button(&PORTC, 2, 1, 0) && val_2 + 10 <= 255) {
      val_2 += 10;
      update_flag = 1;
      delay_ms(300);
    }

    if (Button(&PORTC, 3, 1, 0) && val_2 - 10 >= 0) {
      val_2 -= 10;
      update_flag = 1;
      delay_ms(300);
    }
}

// Lecture de l'etat du potentiometre
void update_pot(){
  old_pot_val = pot_val;
  pot_val = ADC_Read(0);
  if (old_pot_val != pot_val){
    update_flag = 1;
  }
}

// Met a jour l'ecran du LCD
void update_LCD(){
  if (update_flag){
    sprintf(content_line_1, "%03u %03u %04u", val_1, val_2, pot_val);
    Lcd_Out(1, 1, content_line_1);
    }
  if (data_recieved_flag){
    Lcd_Out(2,3, strncpy(buffer,command_line+0,3));
    Lcd_Out(2,9, strncpy(buffer,command_line+4,3));
    data_recieved_flag = 0;
  }
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
  sprintf(content_line_1, "%03u %03u %04u", val_1, val_2, pot_val);
  Lcd_Out(1, 1, content_line_1 );
  Lcd_Out(2,1,"A:");
  Lcd_Out(2,7,"B:");
}

// Fonction d'initialisation
void init(){
  ANSELA  = 0b00000001;
  ANSELB = 0;
  ANSELD  = 0;
  ANSELC = 0;

  update_flag = 0;
  data_recieved_flag = 0;

  // Desactive les comparateurs
  C1ON_bit = 0;
  C2ON_bit = 0;

  // Initialise les entrees et sorties
  TRISC = 0b10001111;
  TRISA = 0b00000001;

  /*Initialise les objets lies
  au bibliotheques utilisees*/
  ADC_Init();

  UART1_Init(115200);
  terminal_init_message();

  Lcd_Init();
  LCD_init_message();

  Delay_1sec();
  RC1IE_bit = 1;                    // turn ON interrupt on UART1 receive
  RC1IF_bit = 0;                    // Clear interrupt flag
  PEIE_bit  = 1;                    // Enable peripheral interrupts
  GIE_bit   = 1;                    // Enable GLOBAL interrupts
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
  }
}