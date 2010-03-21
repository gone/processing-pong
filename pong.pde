Paddle left;
Paddle right;
Ball baller; //playa gotta play
int COLOR = 255;
int paddle_speed  = 10;
int paddle_height = 80;
int paddle_width  = 10;
int player1_score = 0;
int player2_score = 0;
float[] player1_score_pos;
float[] player2_score_pos;

PFont font;

Thing[] objects = new Thing[3];

int X = 0;
int Y = 1;
int KEYBOARD = 0;
int MOUSE = 1;

void setup(){
	font  = loadFont("AndaleMono-48.vlw");

	size(1000, 1000);
	stroke(COLOR);

	player1_score_pos = new float[] {width/2+width*.2, height*.05};
	player2_score_pos = new float[] {width/2-width*.2, height*.05};

	//ball
	float[] initspeed = {0, 0};
	float[] initpos = {width/2, height/2};
	baller = new Ball(COLOR, initpos, initspeed);
	objects[0] = baller;

	//paddles
	left = new Paddle(width *.05, height/2, 
					  paddle_speed, COLOR,
					  paddle_width, paddle_height,
					  KEYBOARD);
	objects[1] = left;

	right = new Paddle(width * .95, height/2, 
					   paddle_speed, COLOR,
					   paddle_width, paddle_height,
					   MOUSE);
	objects[2] = right;
}


void intro(){




void mousePressed() {
	baller.speed = new float[]{-5, 0};
}

void draw(){
	background(0);
 	textFont(font, 48);
	fill(COLOR);
	text(player1_score, player1_score_pos[X], player1_score_pos[Y]);
	text(player2_score, player2_score_pos[X], player2_score_pos[Y]);

	for (int i = 0; i < objects.length; i++){
		objects[i].display();
		objects[i].move();
		if (objects[i] != baller && 
			baller.detectCollide( (Paddle)objects[i] ))
			{
				baller.speed[X] = -baller.speed[X];
				float diff = objects[i].pos[Y] - baller.pos[Y];
				float delta = diff *.1;
				baller.speed[Y] = baller.speed[Y] - delta;
				baller.speed[X] += baller.speed[X] *.05;
			}
	}

	if (baller.pos[X] > width){ //player 1 scored
		player1_score++;
		newball();
	} else if (baller.pos[X] < 0){ //player 2 scored
		player2_score++;
		newball();
	}
}

void newball(){
	float[] initspeed = {0, 0};
	float[] initpos = {width/2, height/2};
	baller = new Ball(COLOR, initpos, initspeed);
	objects[0] = baller;
}

class Thing{

	float[] pos = new float[2];
	float[] speed = new float[2];
	int col; 

	Thing(){}
	void display(){}
	void move(){}

	void checkWalls(){
		if (pos[Y] > height || pos[Y] < 0){
			pos[Y] += (pos[Y] < 0) ? speed[Y] : -speed[Y];
		}
	}
}
class Text extends Thing{
	String txt;

	Text(txt_, pos_, col_){
		txt = txt_;
		pos = pos_;
		col = col_;
		speed = new float[] {0, 0};
	}
		
	void display(){
		textFont(font, 48);
		fill(COLOR);
		text(txt, pos[X], [Y]);
	}
}
				 


class Paddle extends Thing{
	float width; 
	float hei;
	int update;

	Paddle(float x_, float y_,
		   float speed_, int col_,
		   float width_, float hei_,
		   int update_){
		pos[X] = x_;
		pos[Y] = y_;	 
		speed[Y] = speed_;
		speed[X] = 0;
		col = col_; 
		width = width_; 
		hei = hei_;
		update = update_;
	}
	void display(){
		stroke(col);
		rectMode(CENTER);
		rect(pos[X], pos[Y], width, hei);
	}
	
	void keyboardUpdate(){
		if(keyPressed) {
			if (key == 'w'){
				pos[Y] -= speed[Y];
			}
			else if (key == 's'){
				pos[Y] += speed[Y];
			}
		}
	}

	void mouseUpdate(){
		if (mouseY > 0 && pos[Y] != mouseY){
			float diff = pos[Y] - mouseY;
			float spd;

			if (abs(diff) < speed[Y]){
				spd = abs(diff);
			} else {
				spd = speed[Y];
			}

			if ( diff > 0){
				pos[Y] -= spd;

			}else if  (diff < 0){
				pos[Y] += spd;
			}
		}
	}

	void move(){
		if (update == KEYBOARD){
			keyboardUpdate();
		}else if (update == MOUSE){
			mouseUpdate();
		}
		checkWalls();
	}
}

class Ball extends Thing{

	int radius = 10;

	Ball(int col_,float[] pos_, float[] speed_){
		pos = pos_;
		col = col_;
		speed = speed_;
	}

	void display(){
		stroke(col);
		ellipse(pos[X], pos[Y], radius, radius);
	}

	void move(){
		pos[X] += speed[X];
		pos[Y] += speed[Y];
		checkWalls();
	}

 	boolean detectCollide(Paddle paddle){
 		float[] bhitbox = {pos[X] - (radius * .8), pos[Y] - (radius * .8),
 						   pos[X] + (radius * .8), pos[Y] + (radius * .8)};

		float[] phitbox = {paddle.pos[X] - paddle.width/2, paddle.pos[Y] - paddle.hei/2,
						   paddle.pos[X] + paddle.width/2, paddle.pos[Y] + paddle.hei/2};
		int LEFT = 0;
		int TOP = 1;
		int RIGHT = 2;
		int BOTTOM = 3;

 		if ( bhitbox[BOTTOM] < phitbox[TOP] ||
			 bhitbox[TOP] > phitbox[BOTTOM] ||
			 bhitbox[RIGHT] < phitbox[LEFT] ||
			 phitbox[RIGHT] < bhitbox[LEFT]) {
			return false;
		}
		return true;
	}
}
