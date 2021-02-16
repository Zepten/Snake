int mapSize = 20;
float timeStep = 10, timer = 0;
boolean pause;

int[][] snake;
int len;
int direction, nextDirection;

int fx, fy;

// CONTROLS

final int up    = 87;
final int left  = 65;
final int down  = 83;
final int right = 68;

void setup() {
  size(800, 800, P2D);
  colorMode(HSB);
  strokeWeight(2);
  restart();
}

void setFood() {
  fx = int(random(mapSize));
  fy = int(random(mapSize));
  for (int i = 0; i < len; i++)
    while (fx == snake[0][i] && fy == snake[1][i]) {
      fx = int(random(mapSize));
      fy = int(random(mapSize));
    }
}

void restart() {
  pause = true;
  snake = new int[2][mapSize*mapSize];
  snake[0][0] = mapSize/2;
  snake[1][0] = mapSize/2;
  direction = 0;
  nextDirection = 0;
  len = 1;
  setFood();
}

void keyPressed(){
  if (pause) {
    if (keyCode == right) nextDirection = 0;
    if (keyCode == up)    nextDirection = 1;
    if (keyCode == left)  nextDirection = 2;
    if (keyCode == down)  nextDirection = 3;
    pause = false;
  } else {
    if (keyCode == right && direction != 2) nextDirection = 0;
    if (keyCode == up    && direction != 3) nextDirection = 1;
    if (keyCode == left  && direction != 0) nextDirection = 2;
    if (keyCode == down  && direction != 1) nextDirection = 3;
    if (keyCode == 32) len++;
  }
}

void step(){
  direction = nextDirection;
  
  // SNAKE BENDING
  
  for (int i = len-1; i > 0; i--) {
    snake[0][i] = snake[0][i-1];
    snake[1][i] = snake[1][i-1];
  }
  
  // CONTROLS
  
  switch (direction) {
    case 0: {
      snake[0][0]++;
      break;
    }
    case 1: {
      snake[1][0]--;
      break;
    }
    case 2: {
      snake[0][0]--;
      break;
    }
    case 3: {
      snake[1][0]++;
      break;
    }
  }
  
  // GETTING THROUGH BOUNDS
  
  if (snake[0][0] > mapSize-1) snake[0][0] = 0;
  else if (snake[0][0] < 0) snake[0][0] = mapSize-1;
  if (snake[1][0] > mapSize-1) snake[1][0] = 0;
  else if (snake[1][0] < 0) snake[1][0] = mapSize-1;
  
  // SNAKE COLLISION
  
  for (int i = 1; i < len; i++)
    if (snake[0][0] == snake[0][i] && snake[1][0] == snake[1][i]) {
      restart();
      break;
    }
  
  // FOOD GETTING
  
  if (snake[0][0] == fx && snake[1][0] == fy) {
    snake[0][len] = snake[0][len-1];
    snake[1][len] = snake[1][len-1];
    if (len + 1 < mapSize*mapSize) {
      setFood();
      len++;
    } else {
      fx = -1000; fy = -1000;
      restart();
    }
  }
}

void draw() {
  background(0);
  
  // GRID RENDER
  
  for (int y = 0; y < mapSize; y++)
    for (int x = 0; x < mapSize; x++) {
      fill(20); stroke(50);
      rect(width/mapSize*x, width/mapSize*y, width/mapSize, height/mapSize);
    }
  
  // FOOD RENDER
  
  fill(130); stroke(255);
  rect(width/mapSize*fx, width/mapSize*fy, width/mapSize, height/mapSize);
  
  // SNAKE RENDER
  
  for (int i = 0; i < len; i++) {
    fill((75 + i * 10) % 255, 255, 130); stroke((75 + i * 10) % 255, 255, 255);
    rect(width/mapSize*snake[0][i], width/mapSize*snake[1][i], width/mapSize, height/mapSize);
  }
  
  // TIMER AND STEPS
  
  if (!pause) timer--;
  if (timer <= 0) {
    timer = timeStep;
    step();
  }
  
  // HUD
  
  textSize(30);
  fill(255); text(len, 10, 30);
  
  // AI
  /*
  if (snake[0][0] < fx) {
    nextDirection = 0;
  }else if (snake[0][0] > fx) {
    nextDirection = 2;
  } else {
     if (snake[1][0] < fy)
       nextDirection = 3;
     else
       nextDirection = 1;
  }*/
}
