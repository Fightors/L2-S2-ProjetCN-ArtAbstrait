color startColor;
color endColor;
int steps = 1;
int currentStep = 0;
float drawSize = 1;
boolean retour = false;
boolean retourSteps=false;
boolean running =true;



//------------------------------------------------setup----------------------------------------------//
void setup() {
  size(800, 800); // Taille de la fenêtre
  frameRate(360); //Nombre d'image par seconde ( à diminuer ou augmenter selon la vitesse voulue )
  background(0); // Fond noir
  startColor = color(random(255), random(255), random(255), 100);
  endColor = color(random(255), random(255), random(255), 100);
  noStroke();
  noFill(); //On ne remplit pas les pétales
  strokeWeight(2-drawSize); //L'épaisseur du trait change avec la taille du dessin
  //noLoop();
}
//---------------------------------------------------------------------------------------------------//



//------------------------------------------------draw-----------------------------------------------//
void draw() {
  if (running) { //Détermine si le processus peut tourner ou pas, géré par un click de la souris
    if (currentStep <= steps && !retour) {
      currentStep++;
      drawSize+=0.006;
    } else {
      retour = true;
      currentStep--;

      drawSize-=0.006;
      if (currentStep == 0) {
        retour = false;
        startColor = color(random(255), random(255), random(255), 100);
        endColor = color(random(255), random(255), random(255), 100);
        steps+=50;
        if (retourSteps) { // Vérifie si on a atteint la fin du cadre
          steps-=100; //Maintenant le dessin rétrécit
        }
      }
    }
    color lerpedColor = lerpColor(startColor, endColor, (float) currentStep / steps); //Interpolation de nos deux couleurs pour obtenir un dégradé
    stroke(lerpedColor);

    translate(width/2, height/2); // Centrer la rosace
    rotate(frameCount*0.01); // On fait tourner la rosace en fonction du temps

    int petals = 5; // Nombre de pétales
    float angle = TWO_PI/petals; // Angle entre chaque pétale

    for (int i = 0; i < petals; i++) {
      //Notre compréhension du matrix stack vient de https://processing.org/tutorials/transform2d

      pushMatrix();
      rotate(i*angle); // Tourner selon le numéro de pétale
      drawPetal(); // Dessiner un pétale
      popMatrix();

      pushMatrix();
      rotate(i*angle + angle/2); // Tourner selon le numéro de pétale et l'angle entre deux pétales
      drawPetal(); // Dessiner un pétale
      popMatrix();
    }
    if (steps>=600) {
      retourSteps=true;
    }
    if (steps<=1) {
      retourSteps=false;
    }
  }
}
//---------------------------------------------------------------------------------------------------//




//------------------------------------------------drawPetal------------------------------------------//
//Dessine un pétale à l'aide de la fonctions bezierVertex() pour tracer les courbes.
void drawPetal() {
  beginShape();
  vertex(0, 0); //obligatoire pour utiliser bezierVertex, sert de point d'ancrage aux courbes
  bezierVertex(20*drawSize, -50*drawSize, 80*drawSize, -80*drawSize, 80*drawSize, -30*drawSize);
  bezierVertex(80*drawSize, 20*drawSize, 20*drawSize, 50*drawSize, 0*drawSize, 0*drawSize);
  endShape();

  beginShape();
  vertex(0, 0);
  bezierVertex(-20*drawSize, -50*drawSize, -80*drawSize, -80*drawSize, -80*drawSize, -30*drawSize);
  bezierVertex(-80*drawSize, 20*drawSize, -20*drawSize, 50*drawSize, 0*drawSize, 0*drawSize);
  endShape();
}
//---------------------------------------------------------------------------------------------------//

//------------------------------------------------mousePressed---------------------------------------//
//Stop ou relance le programme quand on clique sur un bouton de la souris
void mousePressed() {
  running = !running; // peret au processus de s'arrêter et repartir au click de la souris
}
//---------------------------------------------------------------------------------------------------//
