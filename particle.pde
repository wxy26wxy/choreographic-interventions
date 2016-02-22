class Particle{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float a;
  Particle(float x, float y){
    location = new PVector(x, y);
    velocity = new PVector(0, 0.2/Scale);
    acceleration = new PVector(0, 0);
    a=random(-0.0005/10,0.0005/10);
  }  
  void update() {   
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(-1/Scale);
  }  
  void updatex() {  
   location.x+=a*(height/2/Scale-location.y);
  }  
  void applyForce(PVector force) {
    acceleration.sub(force);
  }    
  void display(){
    noStroke();
   fill(255);
   ellipse(location.x,location.y,4/Scale,4/Scale);
  } 
}