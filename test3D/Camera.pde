class Camera{
  PVector CamPos;
  PVector CamX;
  PVector CamY;
  PVector CamZ;
  float nearClip;
  PVector recordSize;
  public Camera(PVector position, PVector x, PVector y, PVector z, float near, PVector size)
  {
    CamPos = position.copy();
    CamX = x.copy();
    CamY = y.copy();
    CamZ = z.copy();
    nearClip = near;
    recordSize = size;
  }
  public float[][] getWorldToCamRotation()
  {
    float[][]WorldToCamRot = {{CamX.x, CamX.y, CamX.z, 0}, {CamY.x, CamY.y, CamY.z, 0}, {CamZ.x, CamZ.y, CamZ.z, 0}, {0, 0, 0, 1}};
    return WorldToCamRot;
  }
  public float[][] getWorldToCamTranslation()
  {
    PVector C = CamPos.copy();
    float[][]WorldToCamTra = {{1, 0, 0, -1f*C.x}, {0, 1, 0, -1f*C.y}, {0, 0, 1, -1f*C.z}, {0, 0, 0, 1}};
    return WorldToCamTra;
  }
  public PVector WorldToCam(PVector position)
  {
    float[][]WorldPos = {{position.x}, {position.y}, {position.z}, {1}};
    float[][]WorldToCamRot = getWorldToCamRotation();
    float[][]WorldToCamTra = getWorldToCamTranslation();
    float[][]PointCamPosition = matmul(matmul(WorldToCamRot, WorldToCamTra), WorldPos);
    return new PVector(PointCamPosition[0][0], PointCamPosition[1][0], PointCamPosition[2][0]);
  }
  public PVector CamToFilm(PVector position, PVector screenSize)
  {
    PVector filmPos = null;
    if (position.z > nearClip){
      filmPos = new PVector(nearClip*position.x/position.z, nearClip*position.y/position.z);
      if (filmPos.x > 0-20f*screenSize.x && filmPos.y > 0-20f*screenSize.y && filmPos.x < 20f*screenSize.x && filmPos.y < 20f*screenSize.y)
        return filmPos;
      else
        return null;
    }
    return null;
  }
  public PVector FilmToPixel(PVector filmPos, PVector screenSize)
  {
    try{
    return new PVector(filmPos.x*screenSize.x/recordSize.x, filmPos.y*screenSize.y/recordSize.y);
    }catch(Exception e){
    return null;
    }
  }
  public PVector WorldToPixel(PVector position, PVector screenSize)
  {
    PVector temp = WorldToCam(position.copy());
    float z = temp.z;
    temp = CamToFilm(temp, screenSize.copy());
    temp = FilmToPixel(temp, screenSize.copy());
    try{
    return new PVector(temp.x, temp.y, z);
    }catch (Exception e){return null;}
  }
  public void rot(float[][] matrix, PVector center)
  {
    float[][] campoint = {{CamPos.x-center.x}, {CamPos.y-center.y}, {CamPos.z-center.z}};
    float[][] camXpoint = {{CamX.x}, {CamX.y}, {CamX.z}};
    float[][] camYpoint = {{CamY.x}, {CamY.y}, {CamY.z}};
    float[][] camZpoint = {{CamZ.x}, {CamZ.y}, {CamZ.z}};
    float[][] newCam = matmul(matrix, campoint);
    float[][] newCamX = matmul(matrix, camXpoint);
    float[][] newCamY = matmul(matrix, camYpoint);
    float[][] newCamZ = matmul(matrix, camZpoint);
    CamPos = new PVector(newCam[0][0] + center.x, newCam[1][0] + center.y, newCam[2][0]+center.z);
    CamX = new PVector(newCamX[0][0], newCamX[1][0], newCamX[2][0]);
    CamY = new PVector(newCamY[0][0], newCamY[1][0], newCamY[2][0]);
    CamZ = new PVector(newCamZ[0][0], newCamZ[1][0], newCamZ[2][0]);
  }
  public void rot(float[][] matrix)
  {
    float[][] campoint = {{0}, {0}, {0}};
    float[][] camXpoint = {{CamX.x}, {CamX.y}, {CamX.z}};
    float[][] camYpoint = {{CamY.x}, {CamY.y}, {CamY.z}};
    float[][] camZpoint = {{CamZ.x}, {CamZ.y}, {CamZ.z}};
    float[][] newCam = matmul(matrix, campoint);
    float[][] newCamX = matmul(matrix, camXpoint);
    float[][] newCamY = matmul(matrix, camYpoint);
    float[][] newCamZ = matmul(matrix, camZpoint);
    CamPos = new PVector(newCam[0][0] + CamPos.x, newCam[1][0] + CamPos.y, newCam[2][0]+CamPos.z);
    CamX = new PVector(newCamX[0][0], newCamX[1][0], newCamX[2][0]);
    CamY = new PVector(newCamY[0][0], newCamY[1][0], newCamY[2][0]);
    CamZ = new PVector(newCamZ[0][0], newCamZ[1][0], newCamZ[2][0]);
  }
}
