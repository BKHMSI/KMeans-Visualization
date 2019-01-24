
int k = 4;
int randOffset = 10;
int numPoints = 100;
color clusterColor[];
Point points[];
Point centers[];
boolean didFinish = false;
color defaultColors[];

void setup(){
  size(500,500);
  smooth();
  
  // init
  points = new Point[numPoints];
  defaultColors = new color[5];
  centers = new Point[10];
  clusterColor = new color[10];
  
  defaultColors[0] = color(255,0,0);
  defaultColors[1] = color(0,0,255);
  defaultColors[2] = color(0,255,0);
  defaultColors[3] = color(255,0,255);
  defaultColors[4] = color(255,255,0);

  for(int i = 0; i<numPoints; i++)
    points[i] = new Point(randOffset+random(width-randOffset),randOffset+random(height-randOffset));
  for(int i = 0; i<10; i++){
      clusterColor[i] = i < 5 ? defaultColors[i]:color(random(255),random(255),random(255));
      centers[i] = new Point(randOffset+random(width-randOffset),randOffset+random(height-randOffset),clusterColor[i]);
  }
}

void draw(){
  background(200);
  drawGrid();
  for(int i = 0; i<k; i++)
    centers[i].display();
  for(int i = 0; i<numPoints; i++)
    points[i].display();
}

void keyPressed(){
  if(!didFinish)
    runKMeans();
  else
    println("Finish");
}

void setPoints(int points){
  numPoints = points;
}

boolean finish(){
  return didFinish;
}

void changeK(int _k){
  reset();
  k = _k;
}

void reset(){
  for(int i = 0; i<k; i++)
    centers[i].reset();
  for(int i = 0; i<numPoints; i++)
    points[i].reset();
}

void runKMeans(){
  int cluster[][] = new int[k][numPoints];
  for(int i = 0; i<numPoints; i++){
      float min = 10000;
      int idx = 0;
      for(int j = 0; j<k; j++){
          float dx2 = pow(points[i].x-centers[j].x,2);
          float dy2 = pow(points[i].y-centers[j].y,2);
          float dist = sqrt(dx2+dy2);
          if(dist < min){
            min = dist;
            idx = j;
          }
      }
      points[i].setCluster(idx);
  }
  
  for(int i = 0; i<k; i++){
     float xx = 0, yy = 0, counter = 0;
     float x = centers[i].x, y = centers[i].y;
     didFinish = true;
     for(int j = 0; j<numPoints; j++){
       if(points[j].getCluster() == i){
          xx+=points[j].x;
          yy+=points[j].y;
          counter++;
       }
     }
     xx/=counter;
     yy/=counter;
     if(x != xx && y != yy)
       didFinish = false;
     centers[i].setXY(xx,yy);
  }
}

class Point{
  public float x, y, rad = 10;
  private int cluster;
  private color c;
  private boolean isCenter = false;
  public Point(float _x, float _y){
    x = _x; y = _y;
    c = color(0);
  }
  
  public Point(float _x, float _y, color _c){
    x = _x; y = _y;
    c = _c;
    isCenter = true;
  }
  
  public void setXY(float _x, float _y){
    x = _x; y = _y;
  }
  
  public void setCluster(int k){
    cluster = k;
    c = clusterColor[k];
  }
  
  public int getCluster(){
    return cluster;
  } 
  
  public void reset(){
    didFinish = false;
    if(isCenter){
      x = randOffset+random(width-randOffset);
      y = randOffset+random(height-randOffset);
    }else{
      c = color(0);
    }
  }
  
  void display(){
     noStroke();
     fill(c);
     float r = isCenter ? rad*2:rad;
     ellipse(x,y,r,r);
  }
}

void drawGrid() {
  stroke(192, 192, 192);
  strokeWeight(1);
  for (int i = 0; i<=width; i+=20) {
    line(i, 0, i, height);
  }
  for ( int j = 0; j<=height; j+=20) {
    line(0, j, width, j);
  }
}

