import java.util.Queue;
import java.util.ArrayDeque;

String INPUT_FILE = "./../input.txt";
int[][] sizeMap;
boolean[][] isLowPoint;
boolean[][] drawnWater;
boolean[][] floodedPointsEnd;
boolean[][] doubleBuffer;
int yMax;
int xMax;

int frameDelay = 250;
int endDelay = 1500;

int rectngleSize = 9;

void setup() {
  size(900, 900); //Assuming input is 100 by 100 and rectngle size is 9
  noStroke();
  SolveProblem();
}

void setGroundFillByValue(int value){
  switch(value) {
    case 0:
      fill(0, 255, 0);
      break;
    case 1:
      fill(102, 255, 51);
      break;
    case 2:
      fill(204, 255, 51);
      break;
    case 3:
      fill(255, 255, 0);
      break;
    case 4:
      fill(255, 204, 0);
      break;
    case 5:
      fill(255, 153, 51);
      break;
    case 6:
      fill(255, 102, 0);
      break;
    case 7:
      fill(255, 0, 0);
      break;
    case 8:
      fill(204, 0, 0);
      break;
    case 9:
      fill(102, 0, 0);
      break;
  }
}

void setWaterFillByValue(int value){
  switch(value) {
    case 0:
      fill(0, 39, 51);
      break;
    case 1:
      fill(0, 61, 77);
      break;
    case 2:
      fill(0, 102, 128);
      break;
    case 3:
      fill(0, 143, 179);
      break;
    case 4:
      fill(0, 184, 230);
      break;
    case 5:
      fill(26, 209, 255);
      break;
    case 6:
      fill(77, 219, 255);
      break;
    case 7:
      fill(128, 229, 255);
      break;
    case 8:
      fill(179, 240, 255);
      break;
  }
}

void drawHeightMap() {
  for(int y = 0; y < yMax; y++) {
    for(int x = 0; x < xMax; x++) {
      if(drawnWater[y][x])
        setWaterFillByValue(sizeMap[y][x]);
      else
        setGroundFillByValue(sizeMap[y][x]);
      rect(rectngleSize*x, rectngleSize*y, rectngleSize, rectngleSize);
    }
  }
}

void resetDrawStatus() {
  drawnWater = new boolean[yMax][xMax];
  doubleBuffer = new boolean[yMax][xMax];
}

boolean isAnimationFirstFrame() {
  for(int y = 0; y < yMax; y++) {
    for(int x = 0; x < xMax; x++) {
      if(drawnWater[y][x])
        return false;
    }
  }
  return true;
}

void copyBooleanArrays(boolean[][] from, boolean[][] to) {
  for(int y = 0; y < yMax; y++) {
    for(int x = 0; x < xMax; x++) {
      to[y][x] = from[y][x];
    }
  }
}

boolean isAnimationFinished() {
  for(int y = 0; y < yMax; y++) {
    for(int x = 0; x < xMax; x++) {
      if(drawnWater[y][x] != floodedPointsEnd[y][x])
        return false;
    }
  }
  return true;
}

void advanceAnimation() {
  if(isAnimationFirstFrame()) {
    delay(endDelay);
    copyBooleanArrays(isLowPoint, drawnWater);
    return;
  }
  
  if(isAnimationFinished()) {
    resetDrawStatus();
    return;
  }
  
  // Next frame
  copyBooleanArrays(drawnWater, doubleBuffer);
  for(int y = 0; y < yMax; y++) {
    for(int x = 0; x < xMax; x++) {
      if(drawnWater[y][x]) {
        // Up
        if(y != 0 && sizeMap[y-1][x] < 9)
          doubleBuffer[y-1][x] = true;
        // Down
        if(y != yMax-1 && sizeMap[y+1][x] < 9)
          doubleBuffer[y+1][x] = true;
        // Left
        if(x != 0 && sizeMap[y][x-1] < 9)
          doubleBuffer[y][x-1] = true;
        // Right
        if(x != xMax-1 && sizeMap[y][x+1] < 9)
          doubleBuffer[y][x+1] = true;
      }
    }
  }
  copyBooleanArrays(doubleBuffer, drawnWater);
}

int getPartOneScore() {
  int sum = 0;
  for(int y = 0; y < yMax; y++) {
    for(int x = 0; x < xMax; x++) {
      if(isLowPoint[y][x])
        sum += sizeMap[y][x] + 1;
    }
  }
  return sum;
}

int floodFromLowPoint(int x, int y) {
  int size = 0;

  Queue< Integer > queueX = new ArrayDeque< Integer >();
  Queue< Integer > queueY = new ArrayDeque< Integer >();
  
  queueX.add(x);
  queueY.add(y);
  
  while(queueX.peek() != null) {
     int tx = queueX.poll(); //<>//
     int ty = queueY.poll();
     
     if(floodedPointsEnd[ty][tx])
       continue;
     
     floodedPointsEnd[ty][tx] = true;
     size++;
     
     // Up
     if(ty != 0 && !floodedPointsEnd[ty-1][tx] && sizeMap[ty-1][tx] < 9) {
       queueX.add(tx);
       queueY.add(ty-1);
     }
     // Down
     if(ty != yMax-1 && !floodedPointsEnd[ty+1][tx] && sizeMap[ty+1][tx] < 9) {
       queueX.add(tx);
       queueY.add(ty+1);
     }
     // Left
     if(tx != 0 && !floodedPointsEnd[ty][tx-1] && sizeMap[ty][tx-1] < 9) {
       queueX.add(tx-1);
       queueY.add(ty);
     }
     // Right
     if(tx != xMax-1 && !floodedPointsEnd[ty][tx+1] && sizeMap[ty][tx+1] < 9) {
       queueX.add(tx+1);
       queueY.add(ty);
     }
  }
  
  return size;
}

void SolveProblem() {
   String[] lines = loadStrings(INPUT_FILE);
  
  yMax = lines.length;
  xMax = lines[0].length();

  // Fill sizeMap looking at lines from file
  sizeMap = new int[yMax][xMax];
  for(int y = 0; y < yMax; y++) {
    for(int x = 0; x < xMax; x++) {
      sizeMap[y][x] = lines[y].charAt(x) - '0'; 
    }
  }
  
  // Find lowest points
  isLowPoint = new boolean[yMax][xMax];
  for(int y = 0; y < yMax; y++) {
    for(int x = 0; x < xMax; x++) {
      int v = sizeMap[y][x];
     
      // Up
      if(y != 0 && sizeMap[y-1][x] <= v)
        continue;
      // Down
      if(y != yMax-1 && sizeMap[y+1][x] <= v)
        continue;
      // Left
      if(x != 0 && sizeMap[y][x-1] <= v)
        continue;
      // Right
      if(x != xMax-1 && sizeMap[y][x+1] <= v)
        continue;
        
      // All adjecent are bigger than value
      isLowPoint[y][x] = true;
    }
  }
  
  // Find all basins
  IntList basinSizes = new IntList();
  floodedPointsEnd = new boolean[yMax][xMax];
  for(int y = 0; y < yMax; y++) {
    for(int x = 0; x < xMax; x++) {
      if(isLowPoint[y][x])
         basinSizes.append(floodFromLowPoint(x, y));
    }
  }
  
  basinSizes.sort();
  basinSizes.reverse();
  
  resetDrawStatus();
  
  print("Part 1: ");
  println(getPartOneScore());
  
  print("Part 2: ");
  println(basinSizes.get(0)*basinSizes.get(1)*basinSizes.get(2));
}

void draw() {
  drawHeightMap();
  advanceAnimation();
  delay(frameDelay);
}
