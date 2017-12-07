ArrayList<PVector> plot1, plot2, plot3;
int counter = 0;
int LIMIT = 50;
float phase = 0;
int timer = 0;
int TIMER_LIMIT = 50;
int ELLIPSE_DIAM = 5;

int timeStep = 0;
int PERIOD = 1000;

int cooling = 0;
int COOLDOWN = 25;

PShape arrow;

int COLOR;
int COLOR1 = #33FF33;
int COLOR2 = #FF3333;
int COLOR3 = #3333FF;

boolean run = true;

void initPlots() {
  counter = 0;
  plot1 = new ArrayList<PVector>();
  plot2 = new ArrayList<PVector>();
  plot3 = new ArrayList<PVector>();
}

void setup() {
  size(1000, 1000, P3D);
  initArrow();
  initPlots();
  camera(1500.0*sin(2*PI*timeStep/PERIOD), 1500.0*cos(2*PI*timeStep/PERIOD), 1500, 1500, 1500, 0, 0.0, 0.0, -1.0);
}

void draw() {
  
  background(255);
  //camera(1500.0*sin(4*PI*float(mouseX)/width), 1500.0*cos(4*PI*float(mouseX)/width), 3000*float(mouseY)/height - 1500, 500, 500, 0, 0.0, 0.0, -1.0);
  camera(1500.0*sin(2*PI*timeStep/PERIOD), 1500.0*cos(2*PI*timeStep/PERIOD), 1500*(height-float(mouseY))/height, 500, 500, 500, 0.0, 0.0, -1.0);
  //camera(1500.0*sin(1.5*PI), 1500.0*cos(2*PI), 1500*(height-float(mouseY))/height, 500, 500, 500, 0.0, 0.0, -1.0);
  arrow.setStroke(false);
  COLOR = color(COLOR1, 200);
  arrow.setFill(COLOR);
  render(plot1);
  COLOR = color(COLOR2, 200);
  arrow.setFill(COLOR);
  render(plot2);
  COLOR = color(COLOR3, 200);
  arrow.setFill(COLOR);
  render(plot3);
  
  noFill();
  stroke(200);
  strokeWeight(1);
  textSize(50);
  textAlign(CENTER);
  fill(0);
  
  pushMatrix();
  translate(500, -50);
  text("COST", 0, 0);
  popMatrix();
  
  pushMatrix();
  rotate(-PI/2);
  translate(-500, -50);
  text("DURATION", 0, 0);
  popMatrix();
  
  pushMatrix();
  rotateZ(PI);
  rotateY(PI/2);
  rotateX(PI/4);
  translate(-500, 70, 0);
  text("CONFIDENCE", 0, 0);
  popMatrix();
  
  noFill();
  translate( width/2,  height/2,  height/2);
  box(width);
  translate(-width/2, -height/2, -height/2);
  
//  fill(255);
//  line(50, 50, 50, height-50);
//  line(50, height-50, width-50, height-50);
  
  if (timeStep == PERIOD) {
    timeStep = 0;
  } else {
    timeStep++;
  }
  
  if (cooling > 0) {
    cooling--;
  }
  
  if (run) {
    advance();
  }
  
}

void addPoint(ArrayList<PVector> list, float constrain) {
  float x0 = 0;
  float y0 = 0;
  float z0 = 0;
  float x, y, z;
  
  if (list.size() > 0) {
    x0 = list.get(list.size()-1).x;
    y0 = list.get(list.size()-1).y;
    z0 = list.get(list.size()-1).z;
    
    x = x0 + random(-0.075*width, +0.06*width);
    y = y0 + random(-0.075*width, +0.06*width);
    z = z0 + random(-0.075*width, +0.06*width);
    
    x = max(0, x);
    x = min(x, width);
    
    y = max(0, y);
    y = min(y, height);
    
    z = max(0, z);
    z = min(z, height);
    
  } else {
    x = random(constrain*width, width);
    y = random(constrain*height, height);
    z = random(constrain*height, height);
  }

  list.add(new PVector(x, y, z));
}

void render(ArrayList<PVector> list) {
  
  stroke(COLOR);
  strokeWeight(3);
  fill(COLOR, 150);
  
  PVector p1, p2, p2_animate, unit;
  int animate;
  
  noStroke();
  textSize(20);
  textAlign(LEFT);
  for (PVector p: list) {
    ellipse(p.x, p.y, ELLIPSE_DIAM, ELLIPSE_DIAM);
    pushMatrix();
    //rotateX(PI/4);
    translate(p.x, p.y, p.z);
    text("Comment", 10, 0);
    popMatrix();
  }
  
  if (timer > 0) {
    animate = 1;
  } else {
    animate = 0;
  }
  
  for (int i=0; i<list.size()-1-animate; i++) {
    p1 = list.get(i);
    p2 = list.get(i+1);
    stroke(  COLOR, 
             max(50, 255*(float(i+1)/(list.size()-1-animate)))
          );
    strokeWeight(max(0.5, 3*(float(i+1)/(list.size()-1-animate))));
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
    
    
    strokeWeight(0.5);
    stroke(100, 50);
    line(p1.x, p1.y, p2.x, p2.y);
    line(p2.x, p2.y, 0, p2.x, p2.y, p2.z);
  }
  
  if (list.size() > 1) {
    p1 = list.get(list.size()-2);
    p2 = list.get(list.size()-1);
    
    p2_animate = new PVector(p2.x, p2.y, p2.z);
    p2_animate.sub(p1);
    unit = new PVector(p2_animate.x, p2_animate.y, p2_animate.z);
    unit.setMag(2.0);
  
    if (animate == 1 && list.size() > 1) {
      
      phase = PI/2 * float(TIMER_LIMIT - timer) / TIMER_LIMIT;
      float mag = p2_animate.mag() * sin(phase);
      p2_animate.setMag(mag);
      p2_animate.add(p1);
      
      stroke( COLOR );
      line(p1.x, p1.y, p1.z, p2_animate.x, p2_animate.y, p2_animate.z);
      stroke(100, 50);
      line(p1.x, p1.y, p2_animate.x, p2_animate.y);
      
      noStroke();
      fill(COLOR, 150);
      arrow.rotate(  unit.heading() );
      shape(arrow, p2_animate.x, p2_animate.y);
      arrow.rotate( -unit.heading() ); 
      
      pushMatrix();
      translate(p2_animate.x, p2_animate.y, p2_animate.z);
      sphere(10);
      popMatrix();
      
      timer --;
    } else if (animate == 0 && list.size() > 1) {
      
      noStroke();
      fill(COLOR, 150);
      arrow.rotate(  unit.heading() );
      shape(arrow, p2.x, p2.y);
      arrow.rotate( -unit.heading() );
     
      pushMatrix();
      translate(p2.x, p2.y, p2.z);
      sphere(10);
      popMatrix(); 
    }
    
  }
 
}

void keyPressed() {
  advance();
  
  switch(key) {
    case ' ':
      run = !run;
      break;
    case 'r':
      initPlots();
      break;
  }
}

void advance() {
  if (counter < LIMIT && cooling == 0) {
    
    addPoint(plot1, 0.9);
    addPoint(plot2, 0.5);
    addPoint(plot3, 0.25);
    
    timer = TIMER_LIMIT;
    cooling = COOLDOWN;
    counter++;
    
  }
}

void initArrow() {
  float scaler = 1.0;
  arrow = createShape();
  arrow.beginShape();
  arrow.vertex(-5, -5);
  arrow.vertex(scaler*10, scaler*25);
  arrow.vertex(scaler*15, scaler*15);
  arrow.vertex(scaler*25, scaler*10);
  arrow.rotate(3*PI/4);
  arrow.strokeWeight(2);
  arrow.endShape();
}
