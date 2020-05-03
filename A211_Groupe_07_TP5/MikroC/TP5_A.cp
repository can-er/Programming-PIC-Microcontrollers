#line 1 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/TP5_A.c"









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


unsigned short index = 0 ;
unsigned short last_index = 0;
unsigned short dump_index = 1;


bit old_state_1;
bit old_state_2;
bit old_state_3;
bit start_flag;
bit dump_flag;

char content_adc[16];
char pot_val;


void WriteToEEprom(unsigned short Address, unsigned short Data) {
 I2C1_Start();
 I2C1_Wr( 0xA0 );
 I2C1_Wr(Address);
 I2C1_Wr(Data);
 I2C1_Stop();
}


unsigned short ReadFromEEprom(unsigned short Address) {
 unsigned short temp;
 I2C1_Start();
 I2C1_Wr( 0xA0 );
 I2C1_Wr(Address);
 I2C1_Repeated_Start();
 I2C1_Wr( 0xA1 );
 temp = I2C1_Rd(0u);
 I2C1_Stop();
 return temp;
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
#line 90 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/TP5_A.c"
void adc2eeprom(){
 unsigned int adc;
 while(start_flag && index <= 100 && (last_index!=index)){
 adc = ADC_Read(0);
 WriteToEEprom(index, adc);
 Delay_10ms();
 update_values();
 LCD_Out(2,6,"Start         ");
 last_index = index ;
 }
}


void send_values(char val_to_send){
 UART1_Write( 2 );
 UART1_Write_Text(val_to_send);
 UART1_Write( 3 );
 UART1_Write( 10 );
 UART1_Write( 13 );
}


void reset_if_last_pos(){
 if (dump_index == index){
 dump_flag = 0;
 dump_index = 0;
 }
 dump_index++;
}
#line 122 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/TP5_A.c"
void dump_from_eeprom(){
 while (dump_flag && !start_flag){
 char content_eeprom[16];
 unsigned int eeprom_val;
 eeprom_val = ReadFromEEprom(dump_index);
 sprintf(content_eeprom,"Data: %u",eeprom_val);
 send_values(content_eeprom);
 LCD_Out(1,1,content_eeprom);
 LCD_Out(2,6,"Dumping...    ");
 reset_if_last_pos();
 }
}


void Interrupt(){
 if (TMR0IF_bit){
 TMR0IF_bit = 0;
 TMR0H = 0x0B;
 TMR0L = 0xDC;
 if (start_flag){
 index++;
 }
 }
}


void LCD_init_message(){
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"Initialisation...");
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(2,1,"Mode:Attente");
}


void init(){

 ANSELA = 0b00000001;
 ANSELB = 0;
 ANSELD = 0;
 ANSELC = 0;


 C1ON_bit = 0;
 C2ON_bit = 0;


 TRISD = 0b00000111;
 TRISA = 0b00000001;
 TRISB = 0;


 start_flag = 0;
 dump_flag = 0;
 old_state_1 = 0;
 old_state_2 = 0;


 T0CON = 0x85;
 TMR0H = 0x0B;
 TMR0L = 0xDC;
 GIE_bit = 1;
 TMR0IE_bit = 1;
#line 189 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/TP5_A.c"
 ADC_Init();
 UART1_Init(9600);
 Lcd_Init();
 I2C1_Init(100000);
 Delay_100ms();
 LCD_init_message();
}


void main(){
 init();

 for(;;){
 update_values();
 adc2eeprom();
 dump_from_eeprom();
 }
}
