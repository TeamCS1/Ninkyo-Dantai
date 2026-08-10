image_speed = 0;

randomize();
direction = choose(0,90,180,270);
newDirection = -1;

speed = choose(0,1,2,3);
doAgainInterval = choose(3,4,5,6,7,8,9,10);
alarm[0] = room_speed * doAgainInterval;
stringState = "";
stringStateVending = "";
drawState = 0;  //This is used to prevent overlapping of draw events
states = 0;
