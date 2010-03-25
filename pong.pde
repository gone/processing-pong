Paddle left;
Paddle right;
Ball baller; //playa gotta play
int COLOR = 0;
int paddle_speed  = 10;
int paddle_height = 80;
int paddle_width  = 10;
Number player1_score;
Number player2_score;
float[] player1_score_pos;
float[] player2_score_pos;
Text mouseover;
boolean GAMESTARTED = false;
int test = -1;

PFont font;

Thing[] objects = new Thing[0];

int X = 0;
int Y = 1;
int KEYBOARD = 0;
int MOUSE = 1;

void setup(){
	font  = loadFont("AndaleMono-48.vlw");
	
	size(800, 800);
	//	stroke(COLOR);
	intro();
}

void intro(){
	objects = new Thing[3];
	Text pong = new Text("PONG", new float[] {width/2, height*.15}, COLOR, false);
	Text newgame = new Start("Start", new float[] {width/2, height*.25}, COLOR, true);
	//Text options = new Text("Options", new float[] {width/2, height*.35}, COLOR, true);
	Text credits = new Text("BenBeecher@gmail.com", new float[] {width/2, height*.80}, COLOR, false);
	objects[0] = pong;
	objects[1] = newgame;
	objects[2] = credits;
	//	objects[2] = options;
}


void newGame(){
	objects = new Thing[5];
	float[] initspeed = {0, 0};
	float[] initpos = {width/2, height/2};
	baller = new Ball(#EEEE00, initpos, initspeed);
	objects[0] = baller;

	//paddles
	left = new Paddle(width *.05, height/2, 
					  paddle_speed, #EE0000,
					  paddle_width, paddle_height,
					  KEYBOARD);
	objects[1] = left;

	right = new Paddle(width * .95, height/2, 
					   paddle_speed, #00009C,
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
	if (GAMESTARTED){
		baller.speed = new float[]{-5, 0};
	}
	if (mouseover != null){
		mouseover.isClicked();
	}
}

void draw(){
	background(255);

	for (int i = 0; i < objects.length; i++){
		objects[i].display();
		objects[i].move();
	}
	if (GAMESTARTED){
		gameloop();
	}
}

void gameloop(){
	baller.detectCollide(left);
	baller.detectCollide(right);

	if (baller.pos[X] > width){
		player2_score.txt++; 
		baller.reset();
	} else if (baller.pos[X] < 0){
		player1_score.txt++;
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
		textFont(font, 32);
		fill(col);
		textAlign(CENTER);
		text(txt, pos[X], pos[Y]);
		if (select){
			isSelected();
		}
	}
	void isSelected(){
		float width = textWidth(txt);
		float height = textAscent() + textDescent();
		float left = pos[X] - width/2;
		float right = pos[X] + width/2;
		float top = pos[Y] - height/2;
		float bottom = pos[Y] + height/2;
		
		if (mouseY < bottom &&
			mouseY > top  &&
			mouseX < right &&
			mouseX > left){
			
			mouseover = this;
			select();
		}
	    else if (mouseover == this) {
			unselect();
			mouseover = null;
		}
			
	}
	void isClicked(){}
	void select(){}
	void unselect(){}

}

class Start extends Text{
	Start(String txt_,float[] pos_,int col_, boolean select_){
		super(txt_, pos_, col_, select_);
	}
	void isClicked(){
		newGame();
		GAMESTARTED = true;
		unselect();
	}
	void select(){
		col = #FF6600;
	}
	void unselect(){
		col = COLOR;
		mouseover = null;
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
	float wid; 
	float hei;
	int update;

	Paddle(float x_, float y_,
		   float speed_, int col_,
		   float wid_, float hei_,
		   int update_){
		pos[X] = x_;
		pos[Y] = y_;	 
		speed[Y] = speed_;
		speed[X] = 0;
		col = col_; 
		wid = wid_; 
		hei = hei_;
		update = update_;
	}
	void display(){
		stroke(COLOR);
		line(width, pos[Y]+hei/2, 0, pos[Y]+hei/2);
		line(width, pos[Y]-hei/2, 0, pos[Y]-hei/2);
		line(pos[X]+wid/2, height, pos[X]+wid/2, 0);
		line(pos[X]-wid/2, height, pos[X]-wid/2, 0);


		fill(col);
		rectMode(CENTER);
		rect(pos[X], pos[Y], wid, hei);
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
		stroke(COLOR);
		line(width, pos[Y]+radius/2, 0, pos[Y]+radius/2);
		line(width, pos[Y]-radius/2, 0, pos[Y]-radius/2);
		line(pos[X]+radius/2, height, pos[X]+radius/2, 0);
		line(pos[X]-radius/2, height, pos[X]-radius/2, 0);

		fill(col);
		rectMode(CENTER);
		rect(pos[X], pos[Y], float(radius), float(radius));
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

		float[] phitbox = {paddle.pos[X] - paddle.wid/2, paddle.pos[Y] - paddle.hei/2,
						   paddle.pos[X] + paddle.wid/2, paddle.pos[Y] + paddle.hei/2};
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
