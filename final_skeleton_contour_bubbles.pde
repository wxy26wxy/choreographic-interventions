import KinectPV2.KJoint;
import gab.opencv.*;
import KinectPV2.*;
PShape s;
boolean flying = false;
OpenCV opencv;
KinectPV2 kinect;
KJoint[] joints;
float polygonFactor = 1;
int threshold = 10;
int maxD = 2500; 
int minD = 50;
boolean contourBodyIndex = false;
int counter = 1;
float noiseScale = 0.0;
int moreNoise = 1;
float Scale=300.0;
float yoff = 0.0;  
float xoff = 0; 
float p=1;
float o=1.5;
float e=2;
float r=2.5;
int mode=0;
ArrayList<Particle> particles1 = new ArrayList<Particle>();
ArrayList<Particle2> particles2 = new ArrayList<Particle2>();
boolean firstTime = true;

void setup() {
  //size(2000, 1000, P3D);
  fullScreen(P3D);
  smooth();
  opencv = new OpenCV(this, 512, 424);
  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.enableBodyTrackImg(true);
  kinect.enablePointCloud(true);
  kinect.enableSkeleton3DMap(true);
  kinect.init();
}
int state=0;
void draw() {
  background(0);
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(Scale, Scale, 1);
  rotateX(PI);
  rotateY(PI);
  if (state==0) {
    skeleton();
  }
  popMatrix();
  if (state==1) {
    contour();
  }
  if (state==2) {
    skeleton();
  }
}
void keyPressed() {
  if (key == 'a') {
    counter++;
  } else if (key == 's') {
    moreNoise++;
  } else if (key == 'd') {
    counter--;
  }

  // bubbles
  if (key=='z') {
    state=0;
    // contours
  } else if (key=='x') {
    state=1;
    // bubbles fly away
  } else if (key=='v') {
    state = 2;
    for (Particle p : particles1) {
      p.acceleration.add(new PVector(.1/Scale,.1/Scale));
      p.flying= true;
    }
  }
}

void contour() {
  int q=770;
  int w=270;
  pushMatrix();
  scale(2);
  translate(-280, 20);
  translate(q, w);
  strokeWeight(3);
  noFill();
  if (contourBodyIndex) {
    opencv.blur(80);
    opencv.gray();
    opencv.threshold(threshold);    
    PImage a=kinect.getBodyTrackImage();
    opencv.loadImage(a);
  } else {
    opencv.blur(80);
    opencv.gray();
    opencv.threshold(threshold);
    PImage b=kinect.getPointCloudDepthImage();
    opencv.loadImage(b);
  }

  ArrayList<Contour> contours = opencv.findContours(false, false);
  ArrayList<PVector> z=new ArrayList<PVector>();

  if (contours.size() > 0) {
    for (Contour contour : contours) {
      contour.setPolygonApproximationFactor(100);
      if (contour.numPoints() > 50) { 
        stroke(255, 100);
        strokeWeight(10);
        //for (PVector point : contour.getPoints()) {
        for (int i=0; i<contour.getPoints().size(); i++) {
          z.add(contour.getPoints().get(i));
        }
        for (int i=0; i<z.size(); i+=1) {
          pushMatrix();
          scale(p); 
          beginShape();
          point(1024-z.get(i).x-q, z.get(i).y-w);
          endShape();
          popMatrix();

          pushMatrix();
          scale(o);    
          point(1024-z.get(i).x-q, z.get(i).y-w);
          popMatrix();

          pushMatrix();
          scale(e);    
          point(1024-z.get(i).x-q, z.get(i).y-w);
          popMatrix();

          pushMatrix();
          scale(r);    
          point(1024-z.get(i).x-q, z.get(i).y-w);
          popMatrix();        
          point(1024-z.get(i).x-q, z.get(i).y-w);
        }
        p+=0.005;
        o+=0.005;
        e+=0.005;
        r+=0.005;
        if (p>=2.5)p=1; 
        if (o>=2.5)o=1; 
        if (e>=2.5)e=1;
        if (r>=2.5)r=1;
      }
    }
  }
  pushMatrix();
  if (contours.size() > 0) {
    for (Contour contour : contours) {
      contour.setPolygonApproximationFactor(polygonFactor);
      if (contour.numPoints() > 100) {
        int red = 0;
        int green = 200;
        int blue = 200;
        float offset = 1.0;
        for (int i=0; i<counter; i++) {
          stroke(red, green, blue);
          s = createShape();
          s.beginShape();
          //for (PVector point : contour.getPolygonApproximation().getPoints()) {
          for (int j=0; j<contour.getPolygonApproximation().getPoints().size(); j++) {
            PVector point = contour.getPolygonApproximation().getPoints().get(j);
            noiseScale += .01;
            float n = noise(noiseScale) * moreNoise;
            s.vertex((1024-point.x-q) +n, (point.y-w)+n);
            //if (firstTime && particles1.size() > j) {
            //  particles1.get(j).flyToContour(contour.getPoints().get(j));
            //}
          }
          firstTime = false;
          s.endShape();
          s.scale(offset);
          shape(s);
          red += 25;
          green -= 30;
          blue -= 15;
          offset += .05;
        }
      }
    }
  }
  popMatrix();  
  popMatrix();
  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);
}

void drawJoint(int jointType) {
  KJoint joint = joints[jointType];
  PVector jointPosition = joint.getPosition();
  point(jointPosition.x, jointPosition.y, 0);
}

void drawJoints() {
  //Bust
  drawJoint(KinectPV2.JointType_Head);
  drawJoint(KinectPV2.JointType_Neck);
  drawJoint(KinectPV2.JointType_SpineShoulder);

  //Torso
  drawJoint(KinectPV2.JointType_SpineMid);
  drawJoint(KinectPV2.JointType_SpineBase);

  // Right Arm    
  drawJoint(KinectPV2.JointType_ShoulderRight);
  drawJoint(KinectPV2.JointType_ElbowRight);
  drawJoint(KinectPV2.JointType_WristRight);
  drawJoint(KinectPV2.JointType_HandRight);
  drawJoint(KinectPV2.JointType_HandTipRight);
  drawJoint(KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawJoint(KinectPV2.JointType_ShoulderLeft);
  drawJoint(KinectPV2.JointType_ElbowLeft);
  drawJoint(KinectPV2.JointType_WristLeft);
  drawJoint(KinectPV2.JointType_HandLeft);
  drawJoint(KinectPV2.JointType_HandTipLeft);
  drawJoint(KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawJoint(KinectPV2.JointType_HipRight);
  drawJoint(KinectPV2.JointType_KneeRight);
  drawJoint(KinectPV2.JointType_AnkleRight);
  drawJoint(KinectPV2.JointType_FootRight);

  // Left Leg
  drawJoint(KinectPV2.JointType_HipLeft);
  drawJoint(KinectPV2.JointType_KneeLeft);
  drawJoint(KinectPV2.JointType_AnkleLeft);
  drawJoint(KinectPV2.JointType_FootLeft);
}

int getTrailingJointIndex(int index ) { 
  if (index==0) {
    return KinectPV2.JointType_Head;
  } else if (index==1) {
    return KinectPV2.JointType_SpineShoulder;
  } else if ( index==2) {
    return KinectPV2.JointType_SpineMid;
  } else  if ( index==3) {
    return KinectPV2.JointType_SpineBase;
  } else  if ( index==4) {
    return KinectPV2.JointType_HipRight;
  } else return KinectPV2.JointType_Head;
}

void skeleton() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
  if (skeletonArray.size() > 0) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(0);   
    if (skeleton.isTracked()) {
      joints = skeleton.getJoints();      
      stroke(255);
      strokeWeight(10);
      //drawJoints();
      strokeWeight(0.1);
      //drawLine
      pushMatrix();
      noStroke();
      fill(255, 100); 
      popMatrix();
      //Intersecton
      //KJoint jointSpineM = joints[KinectPV2.JointType_SpineMid];
      //PVector jointdot = jointSpineM.getPosition();
      //line(jointdot.x,jointdot.y,jointdot.x,height/2/Scale);
      //line(jointdot.x,jointdot.y,jointdot.x,-height/2/Scale);
      //line(jointdot.x,jointdot.y,-width/2/Scale,jointdot.y);
      //line(jointdot.x,jointdot.y,width/2/Scale,jointdot.y);
      // yoff += 0.05;

      // bubbles
      PVector[] t;
      t= new PVector[5];

      if (state==0) {
        particles1.add( new Particle(0, -height/2/Scale)); 
        
      }
      if (particles1.size()>10000) {
          particles1.remove(0);
        }

      for (int i=0; i<5; i++) { 
        KJoint j = joints[getTrailingJointIndex(i)];
        t[i] = j.getPosition().copy();    
        for (Particle mover : particles1) {
          float d = PVector.dist(t[i], mover.location);      
          if (((d > 0) && (d < 200/70)) && state==0) {
            PVector  m=new PVector(t[i].x, mover.location.y);
            PVector diff = PVector.sub(m, mover.location);
            diff.normalize();
            diff.div(500*Scale*d);            
            mover.applyForce(diff);
          }  
          mover.update();
          mover.display();
          mover.updatex();
        }
      }
    }



    //pull
    pushMatrix();
    //particles2.add( new Particle2(-(mouseX-width/2)/Scale, -(mouseY-height/2)/Scale));  
    //if (particles2.size()>500) {
    // particles2.remove(0);
    //}    
    //for (Particle2 mover : particles2) {
    // mover.update(jointhand.x, jointhand.y);   
    // mover.display();
    //}
    //for (Particle2 mover : particles2) {
    // mover.update(jointhand.x, jointhand.y);   
    // mover.display();
    //}
    //for (Particle2 mover : particles2) {
    // mover.update(jointhand.x, jointhand.y);   
    // mover.display();
    //}
    popMatrix();
  }
}