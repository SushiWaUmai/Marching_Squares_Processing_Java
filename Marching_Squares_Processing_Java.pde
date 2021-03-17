// noise map
float[][] heightMap;

// width and height of the nodes
int mapHeight = 50;
int mapWidth = 50;

// noise offset
float xOffset = 0;
float yOffset = 0;

// noise scale
float xScale = 10;
float yScale = 10;

// Noise Movement Speed
float xMoveSpeed = 0.01f;
float yMoveSpeed = 0;

// node size in pixel
float xCellSize;
float yCellSize;

// value between 0 and 1 that defines the position of the lines
float ratio = 0.6f;

// Colorshift of the hue color
float colorShift = 100;

float circleSize = 0.3f;

color gridColor = color(64, 64, 64);

// Node vertex positions
Vector2Int[] positions = new Vector2Int[]
{
  new Vector2Int( 0, 1),
  new Vector2Int( 1, 1),
  new Vector2Int( 1, 0),
  new Vector2Int( 0, 0)
};

// connection position thanks to http://jamie-wong.com/2014/08/19/metaballs-and-marching-squares/
Vector2Int[][][] indecies = new Vector2Int[][][]
{
  new Vector2Int[][] {},
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(3, 0), new Vector2Int(0, 1) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(0, 1), new Vector2Int(1, 2) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(3, 0), new Vector2Int(1, 2) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(1, 2), new Vector2Int(2, 3) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(3, 0), new Vector2Int(2, 3) }, new Vector2Int[] { new Vector2Int(0, 1), new Vector2Int(1, 2) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(0, 1), new Vector2Int(2, 3) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(3, 0), new Vector2Int(2, 3) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(3, 0), new Vector2Int(2, 3) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(0, 1), new Vector2Int(2, 3) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(3, 0), new Vector2Int(0, 1) }, new Vector2Int[] { new Vector2Int(1, 2), new Vector2Int(2, 3) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(1, 2), new Vector2Int(2, 3) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(3, 0), new Vector2Int(1, 2) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(0, 1), new Vector2Int(1, 2) } },
  new Vector2Int[][] { new Vector2Int[] { new Vector2Int(3, 0), new Vector2Int(0, 1) } },
  new Vector2Int[][] {},
};

void setup()
{
  size(750, 750);
  initValues();
  background(0);
}

void draw()
{
  clear();
  xOffset += xMoveSpeed;
  yOffset += yMoveSpeed;
  initHeightMap();
  drawGrid();
  drawCircles(circleSize);
  drawLines();
}

void initValues()
{
  yCellSize =  (float)height / mapHeight;
  xCellSize = (float)width / mapWidth;
}

void line(PVector a, PVector b)
{
  line(a.x, a.y, b.x, b.y);
}

PVector lerp(PVector a, PVector b, float t)
{
  return new PVector(lerp(a.x, b.x, t), lerp(a.y, b.y, t));
}

// Draws the lines between nodes
void drawLines()
{
  stroke(255);
  fill(255);
  
  for(int x = 0; x < mapWidth - 1; x++)
  {
    for(int y = 0; y < mapHeight - 1; y++)
    {
      int configuration = getConfiguration(heightMap[x][y+1], heightMap[x+1][y+1], heightMap[x+1][y], heightMap[x][y]);
      drawConfiguration(configuration, x, y);
    }
  }
  stroke(255);
}

// gets the configuration based on the heightmap values
int getConfiguration(float x, float y, float z, float w)
{
  int digit1 = x > ratio ? 1 : 0;
  int digit2 = y > ratio ? 1 : 0;
  int digit4 = z > ratio ? 1 : 0;
  int digit8 = w > ratio ? 1 : 0;
  
  return digit1 + digit2 * 2 + digit4 * 4 + digit8 * 8;
}

// draws the line of the configuration
void drawConfiguration(int configuration, int x, int y)
{
  Vector2Int[][] lines = indecies[configuration];
  
  for(int i = 0; i < lines.length; i++)
  {
    Vector2Int range1 = lines[i][0];
    Vector2Int range2 = lines[i][1];
    
    PVector value1 = new PVector(heightMap[x + positions[range1.x].x][y + positions[range1.x].y], heightMap[x + positions[range1.y].x][y + positions[range1.y].y]);
    PVector value2 = new PVector(heightMap[x + positions[range2.x].x][y + positions[range2.x].y], heightMap[x + positions[range2.y].x][y + positions[range2.y].y]); 
    
    boolean b1 = value1.x > value1.y;
    boolean b2 = value2.x > value2.y;
    
    int x1 = b1 ? range1.x : range1.y;
    int y1 = b1 ? range1.y : range1.x;
    int x2 = b2 ? range2.x : range2.y;
    int y2 = b2 ? range2.y : range2.x;
    
    
    PVector point1 = lerp(positions[x1].toPVector(), positions[y1].toPVector(), (value1.x + value1.y) / 2);
    PVector point2 = lerp(positions[x2].toPVector(), positions[y2].toPVector(), (value2.x + value2.y) / 2);
    
    line(gridToPixel(point1.add(new PVector(x, y))), gridToPixel(point2.add(new PVector(x, y))));
  }
}

// draws the circles of the verteces of the nodes
void drawCircles(float scale)
{
  for(int x = 0; x < mapWidth; x++)
  {
    for(int y = 0; y < mapHeight; y++)
    {
      // fill(heightMap[x][y] > 0.5f ? 255 : 128);
      // fill(heightMap[x][y] * 255);
      fill(grayToColor(heightMap[x][y]));
      PVector pos = gridToPixel(x, y);
      ellipse(pos.x, pos.y, xCellSize * scale, yCellSize * scale);
    }
  }
}

// Draws a grid
void drawGrid()
{
  stroke(gridColor);
  for(int x = 0; x < mapWidth - 1; x++)
  {
    for(int y = 0; y < mapHeight - 1; y++)
    {
      line(gridToPixel(x, y), gridToPixel(x + 1, y));
      line(gridToPixel(x, y), gridToPixel(x, y + 1));
      line(gridToPixel(x + 1, y), gridToPixel(x + 1, y + 1));
      line(gridToPixel(x, y + 1), gridToPixel(x + 1, y + 1));
    }
  }
}

// Converts grid index to pixel position
PVector gridToPixel(PVector grid)
{
  return new PVector(grid.x * xCellSize + xCellSize * 0.5f, grid.y * yCellSize + yCellSize * 0.5f);
}

PVector gridToPixel(int x, int y)
{
  return gridToPixel(new PVector(x, y));
}

// initialized heightmap with new noise values
void initHeightMap()
{
  heightMap =  new float[mapWidth][mapHeight];
  
  for(int x = 0; x < mapWidth; x++)
  {
    for(int y = 0; y < mapHeight; y++)
    {
      heightMap[x][y] = noise((float)x / mapWidth * xScale + xOffset, (float)y / mapHeight * yScale + yOffset);
      // heightMap[x][y] = random(1);
    }
  }
}

// converts gray to hue color values
color grayToColor(float val)
{
  colorMode(HSB);
  val *= 255;
  return color((val + colorShift) % 255, 255, 255);
}
