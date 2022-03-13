class Face
{
  PVector[] points = new PVector[3];
  PVector[] pixelPoints = new PVector[3];
  PVector normal;
  PVector center;
  int r = 255;
  int g = 255;
  int b = 255;
  public Face(PVector a, PVector b, PVector c, PVector normalAngle)
  {
    points[0] = a.copy();
    points[1] = b.copy();
    points[2] = c.copy();
    normal = normalAngle.copy().normalize();
    center = PVector.div(PVector.add(PVector.add(points[0].copy(), points[1].copy()), points[2].copy()), 3);
  }
  public void calculatePixel(Camera cam, PVector screenSize)
  {
    pixelPoints[0] = cam.WorldToPixel(points[0], screenSize);
    pixelPoints[1] = cam.WorldToPixel(points[1], screenSize);
    pixelPoints[2] = cam.WorldToPixel(points[2], screenSize);
    for(int i = 0; i < pixelPoints.length; i++) try{pixelPoints[i] = new PVector(pixelPoints[i].x+(int)(screenSize.x/2), -1f*pixelPoints[i].y+(int)(screenSize.y/2), pixelPoints[i].z);}catch(Exception e){}
  }
  public float getlightPercent(PVector lightSource)
  {
    float a = PVector.angleBetween(normal, lightSource);
    return (1 - a/((float)Math.PI));
  }
  public void rasterize(PVector lightSource, float[][] screenZ, int[][] colors)
  {
    //get the face bounding box
    float bottom = Math.max(Math.min(Math.min(pixelPoints[0].y, pixelPoints[2].y), pixelPoints[1].y), 0);
    float left = Math.max(Math.min(Math.min(pixelPoints[0].x, pixelPoints[2].x), pixelPoints[1].x), 0);
    float top = Math.min(Math.max(Math.max(pixelPoints[0].y, pixelPoints[2].y), pixelPoints[1].y), screenSize.y);
    float right = Math.min(Math.max(Math.max(pixelPoints[0].x, pixelPoints[2].x), pixelPoints[1].x), screenSize.x);
    for (int y = (int)bottom; y <= top; y++)
    {
      for (int x = (int)left; x <= right; x++)
      {
        
        PVector tempPoint = new PVector(x+0.5f, y+0.5f);
        if (PointInTriangle(tempPoint, pixelPoints[0], pixelPoints[1], pixelPoints[2])){ 
          //float startTime = millis();
          float weight1 = ((pixelPoints[1].y - pixelPoints[2].y)*(tempPoint.x - pixelPoints[2].x) + (pixelPoints[2].x - pixelPoints[1].x)*(tempPoint.y - pixelPoints[2].y)) / ((pixelPoints[1].y - pixelPoints[2].y)*(pixelPoints[0].x - pixelPoints[2].x) + (pixelPoints[2].x - pixelPoints[1].x)*(pixelPoints[0].y- pixelPoints[2].y));
          float weight2 = ((pixelPoints[2].y - pixelPoints[0].y)*(tempPoint.x - pixelPoints[2].x) + (pixelPoints[0].x - pixelPoints[2].x)*(tempPoint.y - pixelPoints[2].y)) / ((pixelPoints[1].y - pixelPoints[2].y)*(pixelPoints[0].x - pixelPoints[2].x) + (pixelPoints[2].x - pixelPoints[1].x)*(pixelPoints[0].y- pixelPoints[2].y));
          float weight3 = 1-weight1-weight2;
          weight1*=pixelPoints[0].z;
          weight2*=pixelPoints[1].z;
          weight3*=pixelPoints[2].z;
          float z = weight1+weight2+weight3;
          //println("1:      " + (millis() - startTime));
          //startTime = millis();
          if (z < screenZ[y][x] && z > 0)
          {
            screen[y][x] = z;
            colors[y][x] = color(r*getlightPercent(lightSource), g*getlightPercent(lightSource), b*getlightPercent(lightSource));
            //println("2:      " + (millis() - startTime));
          }
        }
      }
    }
  }
  public void drawFace(Camera cam, PVector screenSize, PVector lightSource, float[][] screenZ, int[][] colors)
  {
    calculatePixel(cam, screenSize);
    rasterize(lightSource, screen, colors);
  }
  public float sign(PVector a, PVector b, PVector c)
  {
    return (a.x-c.x)*(b.y-c.y) - (b.x-c.x)*(a.y-c.y);
  }
  public boolean PointInTriangle(PVector p, PVector v1, PVector v2, PVector v3)
  {
    float d1, d2, d3;
    boolean has_neg, has_pos;

    d1 = sign(p, v1, v2);
    d2 = sign(p, v2, v3);
    d3 = sign(p, v3, v1);

    has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    return !(has_neg && has_pos);
  }
}
