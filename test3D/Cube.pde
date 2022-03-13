class Cube extends Shape
{
  PVector[] points = new PVector[8];
  PVector center;
  Face[] faces;
  public Cube(PVector center1, float radius, PVector forward, PVector up, PVector right)
  {
    /*
        p8---------------p7
       /|               /|
    p4----------------p3 |
     |  |             |  |
     |  |             |  |
     |  p5------------|--p6   forward points out perpendicular from face P1234
     | /              | /     right points out perpendicular to face P1458
    p1----------------p2      up points out perpendicular to face P3478
    */
    forward.mult(radius);
    up.mult(radius);
    right.mult(radius);
    PVector down = PVector.mult(up.copy(), -1f);
    PVector left = PVector.mult(right.copy(), -1f);
    PVector back = PVector.mult(forward.copy(), -1f);
    center = center1.copy();
    PVector P1 = PVector.add(PVector.add(PVector.add(center1.copy(), forward), right), down);
    PVector P2 = PVector.add(PVector.add(PVector.add(center1.copy(), forward), left), down);
    PVector P3 = PVector.add(PVector.add(PVector.add(center1.copy(), forward), left), up);
    PVector P4 = PVector.add(PVector.add(PVector.add(center1.copy(), forward), right), up);
    PVector P5 = PVector.add(PVector.add(PVector.add(center1.copy(), back), right), down);
    PVector P6 = PVector.add(PVector.add(PVector.add(center1.copy(), back), left), down);
    PVector P7 = PVector.add(PVector.add(PVector.add(center1.copy(), back), left), up);
    PVector P8 = PVector.add(PVector.add(PVector.add(center1.copy(), back), right), up);
    PVector[]pointsTemp = {P1, P2, P3, P4, P5, P6, P7, P8};
    points = pointsTemp;
    faces = new Face[12];
    faces[0] = new Face(points[0], points[1], points[2], forward.copy());//front
    faces[1] = new Face(points[0], points[2], points[3], forward.copy());//front
    faces[2] = new Face(points[3], points[2], points[6], up.copy());//up
    faces[3] = new Face(points[3], points[7], points[6], up.copy());//up
    faces[4] = new Face(points[4], points[5], points[6], back.copy());//back
    faces[5] = new Face(points[4], points[6], points[7], back.copy());//back
    faces[6] = new Face(points[0], points[1], points[5], down.copy());//down
    faces[7] = new Face(points[0], points[4], points[5], down.copy());//down
    faces[8] = new Face(points[3], points[4], points[7], right.copy());//right
    faces[9] = new Face(points[0], points[3], points[4], right.copy());//right
    faces[10] = new Face(points[1], points[2], points[5], left.copy());//left
    faces[11] = new Face(points[2], points[5], points[6], left.copy());//left
  }
  public PVector[] getPixelPoints(Camera cam, PVector screenSize)
  {
    PVector[] returning = new PVector[points.length];
    int index = 0;
    for (PVector i : points)
    {
      returning[index] = cam.WorldToPixel(i, screenSize);
      index++;
    }
    return returning;
  }
  public void drawPoints(Camera cam, PVector screenSize)
  {
    stroke(255, 0, 0);
    strokeWeight(5);
    pushMatrix();
    translate(width/2, height/2);
    PVector[]pixelPoints = getPixelPoints(cam, screenSize);
    for (PVector i : pixelPoints)
    {
      try{
      point(i.x, -1f*i.y);// we do -1f*i.y because the canvas has the y value increase as it goes down, and we want the y to increase as it goes up
      }catch(Exception e){}
    }
    popMatrix();
  }
  public void rot(float[][] matrix)
  {
    for (int i = 0; i < points.length; i++)
    {
      float[][] point = {{points[i].x-center.x}, {points[i].y-center.y}, {points[i].z-center.z}}; //<>//
      float[][] newPoint = matmul(matrix, point);
      points[i] = new PVector(newPoint[0][0] + center.x, newPoint[1][0] + center.y, newPoint[2][0] + center.z);
    }
  }
  public void drawWireFrame(Camera cam, PVector screenSize)
  {
    stroke(255);
    strokeWeight(1);
    pushMatrix();
    translate(width/2, height/2);
    PVector[]pixelPoints = getPixelPoints(cam, screenSize);
    for(int i = 0; i < pixelPoints.length; i++) try{pixelPoints[i] = new PVector(pixelPoints[i].x, -1f*pixelPoints[i].y);}catch(Exception e){}
    try{line(pixelPoints[0].x, pixelPoints[0].y, pixelPoints[1].x, pixelPoints[1].y);}catch(Exception e){}
    try{line(pixelPoints[1].x, pixelPoints[1].y, pixelPoints[2].x, pixelPoints[2].y);}catch(Exception e){}
    try{line(pixelPoints[2].x, pixelPoints[2].y, pixelPoints[3].x, pixelPoints[3].y);}catch(Exception e){}
    try{line(pixelPoints[0].x, pixelPoints[0].y, pixelPoints[3].x, pixelPoints[3].y);}catch(Exception e){}
    try{line(pixelPoints[4].x, pixelPoints[4].y, pixelPoints[5].x, pixelPoints[5].y);}catch(Exception e){}
    try{line(pixelPoints[5].x, pixelPoints[5].y, pixelPoints[6].x, pixelPoints[6].y);}catch(Exception e){}
    try{line(pixelPoints[6].x, pixelPoints[6].y, pixelPoints[7].x, pixelPoints[7].y);}catch(Exception e){}
    try{line(pixelPoints[4].x, pixelPoints[4].y, pixelPoints[7].x, pixelPoints[7].y);}catch(Exception e){}
    try{line(pixelPoints[1].x, pixelPoints[1].y, pixelPoints[5].x, pixelPoints[5].y);}catch(Exception e){}
    try{line(pixelPoints[2].x, pixelPoints[2].y, pixelPoints[6].x, pixelPoints[6].y);}catch(Exception e){}
    try{line(pixelPoints[3].x, pixelPoints[3].y, pixelPoints[7].x, pixelPoints[7].y);}catch(Exception e){}
    try{line(pixelPoints[0].x, pixelPoints[0].y, pixelPoints[4].x, pixelPoints[4].y);}catch(Exception e){}
    popMatrix();
  }
  public Face[] getFaces()
  {
    return faces;
  }
  public void drawFaces(Camera cam, PVector screenSize, PVector lightSource, float[][] screenZ, int[][] colors)
  {
    for(Face i: faces) i.drawFace(cam, screenSize, lightSource, screenZ, colors);
  }
}
