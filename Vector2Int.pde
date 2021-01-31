public class Vector2Int
{
  public int x;
  public int y;
  
  public Vector2Int(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  public Vector2Int()
  {
    x = 0;
    y = 0;
  }
  
  public Vector2Int add(Vector2Int other)
  {
    return new Vector2Int(x + other.x, y + other.y);
  }
  
  public Vector2Int sub(Vector2Int other)
  {
    return new Vector2Int(x - other.x, y - other.y);
  }
  
  public Vector2Int div(int other)
  {
    return new Vector2Int(x / other, y / other);
  }
  
  public Vector2Int mult(int other)
  {
    return new Vector2Int(x * other, y * other);
  }
  
  public PVector toPVector()
  {
    return new PVector(x, y);
  }
}
