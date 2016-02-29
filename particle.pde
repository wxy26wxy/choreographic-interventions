class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float a;
  PVector destination;
  boolean flying = false;
  float  topspeed = 5/Scale;
  Particle(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0.2/Scale);
    a=random(-0.0005/10, 0.0005/10);
    acceleration = new PVector(0, 0);
  } 
  void update() {  
    //if (!flying) {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(-1/Scale);
    //println(this.velocity.y*Scale);
    //} else {
    //  PVector diff = PVector.sub(this.location, this.destination);
    //  diff.normalize();
    //  //this.applyForce(diff);
    //  //acceleration.add(diff);
    //  diff.div(500*Scale*100);            
    //  acceleration.add(diff);
    //  velocity.limit(topspeed);
    //  velocity.add(acceleration);
    //  location.add(velocity);
    //  acceleration.mult(-1/Scale);
    //  println(this.velocity.y*Scale);
    //}
  }  
  void updatex() {  

    location.x+=a*(height/2/Scale-location.y);
  }  
  void applyForce(PVector force) {

    acceleration.sub(force);
  }    
  void display() {
    noStroke();
    fill(255);
    ellipse(location.x, location.y, 4/Scale, 4/Scale);
    print(this.flying);
    print("HERE");
  }

  //void flyToContour(PVector contour) {
  //  this.destination = contour;
  //  this.flying = true;
  //}
}