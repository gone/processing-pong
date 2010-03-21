Paddle left;
Paddle right;
Ball baller; //playa gotta play
int COLOR = 255;
int paddle_speed  = 10;
int paddle_height = 80;
int paddle_width  = 10;
Number player1_score;
Number player2_score;
float[] player1_score_pos;
float[] player2_score_pos;

PFont font;

Thing[] objects = new Thing[0];

int X = 0;
int Y = 1;
int KEYBOARD = 0;
int MOUSE = 1;

void setup(){
	font  = loadFont("AndaleMono-48.vlw");

	size(800, 800);
	stroke(COLOR);

	intro();
	//newGame();
}


void intro(){
	objects = new Thing[4];
	Text pong = new Text("PONG", new float[] {width/2, height*.15}, COLOR);
	Text newgame = new Text("Start", new float[] {width/2, height*.25}, COLOR);
	Text options = new Text("Options", new float[] {width/2, height*.35}, COLOR);
	Text credits = new Text("Created By Ben Beecher", new float[] {width/2, height*.80}, COLOR);
	objects[0] = pong;
	objects[1] = newgame;
	objects[2] = options;
	objects[3] = credits;
}


void newGame(){
	objects = new Thing[5];
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


	player1_score_pos = new float[] {width/2+width*.2, height*.05};
	player2_score_pos = new float[] {width/2-width*.2, height*.05};
	player1_score = new Number(0, player1_score_pos, COLOR);
	player2_score = new Number(0, player2_score_pos, COLOR);
	objects[3] = player1_score;
	objects[4] = player2_score;

}

void mousePressed() {
	baller.speed = new float[]{-5, 0};
}

void draw(){
	background(0);

	for (int i = 0; i < objects.length; i++){
		objects[i].display();
		objects[i].move();
	}
	gameloop();
}

void gameloop(){
	baller.detectCollide(left);
	baller.detectCollide(right);

	if (baller.pos[X] > width){
		println(baller.pos[X]);
		player1_score.txt++; 
		baller.reset();
	} else if (baller.pos[X] < 0){
		println(baller.pos[X]);
		player2_score.txt++;
		baller.reset();
	}
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
	boolean select;
	Text(String txt_,float[] pos_,int col_, boolean select_){
		txt = txt_;
		pos = pos_;
		col = col_;
		select = select_;
		speed = new float[] {0, 0};
	}
	Text(float[] pos_,int col_){
		pos = pos_;
		col = col_;
		speed = new float[] {0, 0};
	}

	void move(){}
	void display(){
		textFont(font, 48);
		fill(col);
		textAlign(CENTER);
		text(txt, pos[X], pos[Y]);
	}
}

class Number extends Text{
	int txt;
	Number(int txt_, float[] pos_, int col_){
		super(pos_, col_);
		txt = txt_;
	}
	void move(){}

	void display(){
		textFont(font, 48);
		fill(col);
		textAlign(CENTER);
		text(txt, pos[X], pos[Y]);
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

	void checkWalls(){
		if (pos[Y] > height || pos[Y] < 0){
			speed[Y] = -speed[Y];
		}
	}

	void move(){
		pos[X] += speed[X];
		pos[Y] += speed[Y];
		checkWalls();
	}

	

 	void detectCollide(Paddle paddle){
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
		}else {
			baller.speed[X] = -baller.speed[X];
			float diff = paddle.pos[Y] - baller.pos[Y];
			float delta = diff *.1;
			baller.speed[Y] = baller.speed[Y] - delta;
			baller.speed[X] += baller.speed[X] *.05;
		}
	}
	void reset(){
		pos = new float[] {width/2, height/2};
		speed = new float[] {0, 0};
	}

}
