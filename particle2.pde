class Particle2{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  Particle2(float x, float y){
    location = new PVector(x,y);
    velocity = new PVector(random(-10/Scale),random(-10/Scale));
    topspeed = 5/Scale;
  }  
  void update(float x, float y) {   
   PVector mouse = new PVector(x,y);
    PVector acceleration = PVector.sub(mouse,location);
    acceleration.setMag(0.3/Scale);
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
  }  
  
  void display(){
    noStroke();
   fill(255,150);
   ellipse(location.x,location.y,10/Scale,10/Scale);
  } 
}