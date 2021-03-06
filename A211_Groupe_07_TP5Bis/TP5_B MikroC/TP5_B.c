// Constantes
#define EEPROM_WR       0xA0
#define EEPROM_RD       0xA1
#define SOT             2
#define EOT             3
#define LF              10
#define CR              13

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

unsigned short index = 0 ;
unsigned short last_index = 0;
unsigned short dump_index = 1;

 unsigned int test_val;
 unsigned char test_tableau[10];
// Lecture de l'etat des boutons

bit old_state_1;
bit old_state_2;
bit old_state_3;
bit start_flag;
bit dump_flag;

char content_adc[16];
char pot_val;

// Fonction de lecture d'un octet de l'Eeprom
unsigned short ReadFromEEprom(unsigned short Address) {
  unsigned short temp;
  I2C1_Start();
  I2C1_Wr(EEPROM_WR);
  I2C1_Wr(Address);
  I2C1_Repeated_Start();
  I2C1_Wr(EEPROM_RD);
  temp = I2C1_Rd(0u);
  I2C1_Stop();
  return temp;
}

// Fonction d'ecriture d'un octet dans l'Eeprom
void WriteToEEprom(unsigned short Address, unsigned short Data) {
    I2C1_Start();
    I2C1_Wr(EEPROM_WR);
    I2C1_Wr(Address);
    I2C1_Wr(Data);
    I2C1_Stop();
}
// Envoi des donn�es dans l'UART1
void send_values(char val_to_send){
    //UART1_Write(SOT);
    UART1_Write_Text(val_to_send);
    //UART1_Write(EOT);
    UART1_Write(LF);
    UART1_Write(CR);
}


void hexDump(char *desc, void *addr, int len)
{
    int i;
    unsigned char buff[17];
    unsigned char *pc = addr;
    unsigned char to_send[50];

    // Output description if given.
    if (desc != 0x00){
       sprintf(to_send, "%p (%s):\n", addr, desc);
       UART1_Write_Text(to_send);
       memset(to_send, '\0', sizeof(to_send));
       }
    else{
        sprintf(to_send, "%p:\n", addr);
        UART1_Write_Text(to_send);
        memset(to_send, '\0', sizeof(to_send));
        }
    // Process every byte in the data.

    for (i = 0; i < len; i++) {
        // Multiple of 16 means new line (with line offset).

        if ((i % 16) == 0) {
            // Just don't print ASCII for the zeroth line.
            if (i != 0)
                sprintf (to_send, "  %s\n ", buff);

            // Output the offset.
            sprintf (to_send, "  %04x ", i);
            UART1_Write_Text(to_send);
            memset(to_send, '\0', sizeof(to_send));
        }

        // Now the hex code for the specific character.
        sprintf (to_send, " %02x", pc[i]);
        UART1_Write_Text(to_send);
        memset(to_send, '\0', sizeof(to_send));

        // And store a printable ASCII character for later.
        if ((pc[i] < 0x20) || (pc[i] > 0x7e))
            buff[i % 16] = '.';
        else
            buff[i % 16] = pc[i];
        buff[(i % 16) + 1] = '\0';
    }

    // Pad out last line if not exactly 16 characters.
    while ((i % 16) != 0) {
        UART1_Write_Text("   ");
        i++;
    }

    // And print the final ASCII bit.
    sprintf (to_send, "  %s\n", buff);
    UART1_Write_Text(to_send);
    memset(to_send, '\0', sizeof(to_send));
}

void update_values(){
    if (Button(&PORTD, 0, 1, 1)){
      old_state_1 = 1;
    }
      if (Button(&PORTD, 0, 1, 0 ) && old_state_1) {
        start_flag = 1;
        old_state_1 = 0;
      }

    if (Button(&PORTD, 1, 1, 1)){
      old_state_2 = 1;
    }
      if (Button(&PORTD, 1, 1, 0 ) && old_state_2) {
        start_flag = 0;
        LCD_Out(2,6,"Stop        ");
        old_state_2 = 0;
    }

    if (Button(&PORTD, 2, 1, 1)){
      old_state_3 = 1;
    }
      if (Button(&PORTD, 2, 1, 0 ) && old_state_3) {
        dump_flag = 1;
        old_state_3 = 0;
    }
}

/*Ecriture de l'ADC dans l'E2PROM
selon la sequence demandee*/
void adc2eeprom(){
   unsigned int adc;
   while(start_flag && index <= 100 && (last_index!=index)){
    adc = ADC_Read(0);
    adc  >> 2;
    WriteToEEprom(index, adc);
    Delay_10ms();
    update_values();
    LCD_Out(2,6,"Start         ");
    last_index = index ;
   }
}

// Reinitalise l'adresse de chargement de l'E2PROM
void reset_if_last_pos(){
      if (dump_index == index){
         dump_flag = 0;
         dump_index = 0;
      }
      dump_index++;
}

/*Charge les donnees depuis l'EEPROM
 selon la s�quence demand�e*/
void dump_from_eeprom(){
    while (dump_flag && !start_flag){
      char content_eeprom[16];
      unsigned int eeprom_val;
      eeprom_val = ReadFromEEprom(dump_index);
      eeprom_val = eeprom_val<<2;
      sprintf(content_eeprom,"%04u",eeprom_val);
      //hexDump(content_eeprom, sizeof(content_eeprom));
      hexDump("Frame:", content_eeprom, sizeof(content_eeprom));
      LCD_Out(1,1,content_eeprom);
      LCD_Out(2,6,"Dumping...    ");
      reset_if_last_pos();
    }
}

// Routine d'interruption     Read
void Interrupt(){
  if (TMR0IF_bit){
    TMR0IF_bit    = 0;
    TMR0H         = 0x0B;
    TMR0L         = 0xDC;
    if (start_flag){
       index++;
    }
  }
}

// Message d'initialisation du LCD
void LCD_init_message(){
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Cmd(_LCD_CURSOR_OFF);
  Lcd_Out(1,1,"Initialisation...");
  Delay_ms(1000);
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Out(2,1,"Mode:Attente");
}

// Sequence d'initalisation
void init(){
  // Selection des ports analogiques
  ANSELA        = 0b00000001;
  ANSELB        = 0;
  ANSELD        = 0;
  ANSELC        = 0;

  // Desactive les comparateurs
  C1ON_bit      = 0;
  C2ON_bit      = 0;

  // Initialise les entrees et sorties
  TRISD         = 0b00000111;
  TRISA         = 0b00000001;
  TRISB         = 0;

  // Initialise les flag
  start_flag    = 0;
  dump_flag     = 0;
  old_state_1   = 0;
  old_state_2   = 0;

  // Timer0 interruption
  T0CON         = 0x85;
  TMR0H         = 0x0B;
  TMR0L         = 0xDC;
  GIE_bit       = 1;
  TMR0IE_bit    = 1;

  /*Initialise les objets lies
  au bibliotheques utilisees*/
  ADC_Init();
  UART1_Init(9600);
  Lcd_Init();
  I2C1_Init(100000);  // initalise le I2C
  Delay_100ms();
  LCD_init_message();
}

//Fonction principale
void main(){
    init();

  //Programme principal
  for(;;){
  test_val = ADC_Read(0);
  sprintf(test_tableau,"ADC:%04u", test_val);
  LCD_Out(1,9,test_tableau);
    update_values();
    adc2eeprom();
    dump_from_eeprom();
  }
}