// Variables globales
#define TRUE 1
#define FALSE 0

unsigned char mesLeds = 0;
int sens = 0;

// Creation des fonctions
void decalage_droite(){
    while (mesLeds != 0x01) { // Tant que mesLeds != 0b00000001
      mesLeds = mesLeds>>1; // Decalage a droite
      LATC = mesLeds;
      Delay_ms(200);
    }
}

void decalage_gauche(){
    while (mesLeds != 0x80) { // Tant que mesLeds != 0b10000000
      mesLeds = mesLeds<<1; // Decalage a gauche
      LATC = mesLeds;
      Delay_ms(200);
    }
}

void main() {

    TRISC = 0;  // Initialisation du registre de direction du PORT(B) en SORTIE digitale
    LATC = 0; // Initialisation des bits du PORT(B) a l'etat BAS
    mesLeds = 1; // Initialisation de l'etat initiale de la chenille
    LATC = mesLeds; // Initialisation de l'etat du PORT(B) a la variable "mesLeds"

    // Programme:
    while(1) {

      if (sens == TRUE) { // Si sens est a 1 on decale a gauche
        decalage_gauche();
        sens = FALSE;
      }
      else { // Sinon on decale a droite
        decalage_droite();
        sens = TRUE;
      }
       // Basculement dans l'autre etat
    }
}