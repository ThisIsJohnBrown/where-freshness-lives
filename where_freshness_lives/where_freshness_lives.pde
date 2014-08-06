import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import g4p_controls.*;

import vialab.SMT.event.*;
import vialab.SMT.util.*;
import vialab.SMT.*;
import vialab.SMT.renderer.*;
import vialab.SMT.swipekeyboard.*;

import vialab.SMT.*;

PImage texture;

int oWidth;
int oHeight;

ArrayList<Ring> rings;
ArrayList<Ring> killRings;
Touch touches[];

Ring ring;

void setup()
{
  oWidth = displayWidth;
  oHeight = displayHeight;
  
  size(oWidth, oHeight, SMT.RENDERER);
  SMT.init( this, TouchSource.AUTOMATIC);
  
  Zone zone = new Zone( "MyZone");
  SMT.add( zone);
  
  SMT.setTouchDraw(TouchDraw.NONE);
  noCursor();
  
  colorMode(HSB, 100);
  texture = loadImage("ring.png");
  Ani.init(this);

  rings = new ArrayList<Ring>();
  killRings = new ArrayList<Ring>();
//  for (int i = 0; i < rings.length; i++) {
//    rings[i] = new Ring(random(0, width), random(0, height), random(0, width), random(0, height));
//    rings[i].draw();
//  }
  touches = new Touch[0];
  
//  pulseSlider = new GSlider(this, width - 100, height - 30, 100, 30, 15);
//  speedSlider = new GSlider(this, width - 200, height - 30, 100, 30, 15);
//  ringNumSlider = new GSlider(this, width - 300, height - 30, 100, 30, 15);
  
  
}

void pickDrawMyZone( Zone zone){
  rect( 0, 0, width, height);
}
 
void draw()
{
  background(0);
  for (int i = 0; i < killRings.size(); i++) {
    Ring ring = killRings.get(i);
    ring.draw();
  }
  for (int i = 0; i < rings.size(); i++) {
    Ring ring = rings.get(i);
    boolean skipKill = false;
    for (int j = 0; j < touches.length; j++) {
      if (touches[j].sessionID == ring.id) {
        skipKill = true;
        ring.move(touches[j].getX(), touches[j].getY());
      }
    }
    if (skipKill == false) {
      Ring tempRing = ring;
      rings.remove(ring);
      killRings.add(tempRing);
      tempRing.turnOff();
    }
    ring.draw();
  }
  touches = new Touch[0];
  
//  updatePixels();
  ellipseMode(CENTER);
  
}

void drawMyZone( Zone zone){
  
}

void touchMyZone( Zone zone){
  touches = zone.getTouches();
  for (int i = rings.size(); i < touches.length; i++) {
    rings.add(new Ring(random(0, width), random(0, height), random(0, width), random(0, height), touches[i].sessionID));
  }
//  for (int i = 0; i < touches.length; i++) {
//    for (int j = 0; j < rings.size(); j++) {
//      Ring ring = rings.get(j);
//      println(ring.id);
//    } 
////    rings[i] = new Ring(random(0, width), random(0, height), random(0, width), random(0, height));
////    rings[i].draw();
//  }
}

class Ring
{
  float x, y, size, hue, seekX, seekY, newX, newY, opacity;
  boolean awake;
  long id;
  
  Ring(float x1, float y1, float x2, float y2, long id1) {
    //reset(x1, x2);
    size = oWidth * .8;
    opacity = 0;
    awake = false;
    id = id1;
    hue = random(0, 100);
    turnOn();
  }
  
  void turnOn() {
    if (awake == false) {
      Ani.to(this, .3, "opacity", 100, Ani.LINEAR);
    }
    awake = true;
  }
  
  void turnOff() {
    if (awake == true) {
      Ani.to(this, 1, "opacity", 0, Ani.LINEAR);
    }
    awake = false;
  }
  
  void move(float x1, float y1) {
    x = x1;
    y = y1;
  }
 
  void draw()
  {
    blendMode(ADD);
    tint(hue, 50, opacity);
    image(texture, x - size/2, y - size/2, size, size);
  }
};




boolean sketchFullScreen() {
  return true;
}

void mouseDragged(){
  
}
