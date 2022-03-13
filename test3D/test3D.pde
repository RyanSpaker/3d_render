//define camera
PVector CamPos = new PVector(0, 10, 0);//
PVector CamX = new PVector(1, 0, 0);
PVector CamY = new PVector(0, 1, 0);
PVector CamZ = new PVector(0, 0, 1);
float nearClip = .839f;
float farClip = 50f;
PVector recordSize = new PVector(2, 1.125);
Camera MainCamera = new Camera(CamPos, CamX, CamY, CamZ, nearClip, recordSize); 
//other variables
float theta = 0.05;
PVector screenSize;
ArrayList<Shape> shapes = new ArrayList<Shape>();
float centerX;
PVector lightSource = new PVector(0, 10, -10);
float[][] screen;
int[][] colors;
PImage img;
ArrayList<Face> floor= new ArrayList<Face>();
boolean[] keys = new boolean[200];
void setup() {
  frameRate(60);
  size(1152, 648);
  shapes.add(new Cube(new PVector(0, 0, 20), 5, new PVector(0, 0, 1), new PVector(0, 1, 0), new PVector(1, 0, 0)));
  shapes.add(new Cube(new PVector(12, 3, 20), 2, new PVector(0, 0, 1), new PVector(0, 1, 0), new PVector(1, 0, 0)));
  screenSize = new PVector(width, height);
  img = createImage((int)screenSize.x, (int)screenSize.y, RGB);
  img.loadPixels();
  for(int i=0; i<img.pixels.length;i++) img.pixels[i] = color(0, 0, 0);
}

void draw() {
  background(0);
  /*screen = new float[(int)screenSize.y][(int)screenSize.x];
  colors = new int[(int)screenSize.y][(int)screenSize.x];
  for(int y = 0; y < screen.length; y++)
  {
    for(int x = 0; x < screen[0].length; x++)
    {
      screen[y][x] = farClip;
      colors[y][x] = color(0, 0, 0);
    }
  }
  img.loadPixels();
  for(int i=0; i<img.pixels.length;i++) img.pixels[i] = color(0, 0, 0);
  drawFaces();//speed up
  for(int y = 0; y < colors.length; y++)
  {
    for(int x = 0; x < colors[0].length; x++)
    {
      img.pixels[y*(int)screenSize.x + x] = colors[y][x];
    }
  }
  img.updatePixels();
  image(img, 0, 0);
  //drawWireFrame();*/
  drawWireFrame();
  if(keys[39])
    MainCamera.rot(getRotateY(theta), CamPos.copy());
  if(keys[37])
    MainCamera.rot(getRotateY(-1f*theta), CamPos.copy());
  if(keys[38])
    MainCamera.rot(getRotateX(-1f*theta), CamPos.copy());//local
  if(keys[40])
    MainCamera.rot(getRotateX(theta), CamPos.copy());//local
}
void keyPressed()
{
  if (key == CODED)
  {
    keys[keyCode] = true;
    println((int)keyCode);
  }else 
  {
    keys[key] = true;
    println((int)key);
  }
}
void keyReleased()
{
  if (key == CODED)
  {
    keys[keyCode] = false;
  }else 
  {
    keys[key] = false;
  }
}
void drawWireFrame()
{
  for (Shape i: shapes)
  {
    i.drawPoints(MainCamera, screenSize);
    i.drawWireFrame(MainCamera, screenSize);
  }
}
void drawFaces()
{
  for(Shape i: shapes)
  {
    i.drawFaces(MainCamera, screenSize, lightSource, screen, colors);
  }
}
public static boolean intersectRayWithSquare(PVector R1, PVector R2, PVector S1, PVector S2, PVector S3) {
        // 1.
        PVector dS21 = PVector.sub(S2.copy(), S1.copy());
        PVector dS31 = PVector.sub(S3.copy(), S1.copy());
        PVector n = new PVector();
        PVector.cross(dS21.copy(), dS31.copy(), n);

        // 2.
        PVector dR = PVector.sub(R1.copy(), R2.copy());

        float ndotdR = PVector.dot(n.copy(), dR.copy());

        if (Math.abs(ndotdR) < 1e-6f) { // Choose your tolerance
            return false;
        }

        float t = - PVector.dot(n.copy(), PVector.sub(R1.copy(), S1.copy())) / ndotdR;
        PVector M = PVector.add(R1.copy(), dR.mult(t));

        // 3.
        PVector dMS1 = M.sub(S1);
        float u = dMS1.dot(dS21);
        float v = dMS1.dot(dS31);

        // 4.
        return (u >= 0.0f && u <= dS21.dot(dS21) && v >= 0.0f && v <= dS31.dot(dS31));
}
