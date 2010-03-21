import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class pong extends PApplet {

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

public void setup(){
	font  = loadFont("AndaleMono-48.vlw");

	size(800, 800);
	stroke(COLOR);

	intro();
	//newGame();
}


public void intro(){
	objects = new Thing[4];
	Text pong = new Text("PONG", new float[] {width/2, height*.15f}, COLOR);
	Text newgame = new Text("Start", new float[] {width/2, height*.25f}, COLOR);
	Text options = new Text("Options", new float[] {width/2, height*.35f}, COLOR);
	Text credits = new Text("Created By Ben Beecher", new float[] {width/2, height*.80f}, COLOR);
	objects[0] = pong;
	objects[1] = newgame;
	objects[2] = options;
	objects[3] = credits;
}


public void newGame(){
	objects = new Thing[5];
	float[] initspeed = {0, 0};
	float[] initpos = {width/2, height/2};
	baller = new Ball(COLOR, initpos, initspeed);
	objects[0] = baller;

	//paddles
	left = new Paddle(width *.05f, height/2, 
					  paddle_speed, COLOR,
					  paddle_width, paddle_height,
					  KEYBOARD);
	objects[1] = left;

	right = new Paddle(width * .95f, height/2, 
					   paddle_speed, COLOR,
					   paddle_width, paddle_height,
					   MOUSE);
	objects[2] = right;


	player1_score_pos = new float[] {width/2+width*.2f, height*.05f};
	player2_score_pos = new float[] {width/2-width*.2f, height*.05f};
	player1_score = new Number(0, player1_score_pos, COLOR);
	player2_score = new Number(0, player2_score_pos, COLOR);
	objects[3] = player1_score;
	objects[4] = player2_score;

}

public void mousePressed() {
	baller.speed = new float[]{-5, 0};
}

public void draw(){
	background(0);

	for (int i = 0; i < objects.length; i++){
		objects[i].display();
		objects[i].move();
	}
	gameloop();
}

public void gameloop(){
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
	boolean solid = true;
	Thing(){}
	public void display(){}
	public void move(){}
	public void checkWalls(){
		if (pos[Y] > height || pos[Y] < 0){
			pos[Y] += (pos[Y] < 0) ? speed[Y] : -speed[Y];
		}
	}
}

class Text extends Thing{
	String txt;
	boolean solid = false;
	Text(String txt_,float[] pos_,int col_){
		txt = txt_;
		pos = pos_;
		col = col_;
		speed = new float[] {0, 0};
	}
	Text(float[] pos_,int col_){
		pos = pos_;
		col = col_;
		speed = new float[] {0, 0};
	}

	public void move(){}
	public void display(){
		textFont(font, 48);
		fill(col);
		textAlign(CENTER);
		text(txt, pos[X], pos[Y]);
	}
}

class Number extends Text{
	int txt;
	boolean solid = false;
	Number(int txt_, float[] pos_, int col_){
		super(pos_, col_);
		txt = txt_;
	}
	public void move(){}

	public void display(){
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
	public void display(){
		stroke(col);
		rectMode(CENTER);
		rect(pos[X], pos[Y], width, hei);
	}
	
	public void keyboardUpdate(){
		if(keyPressed) {
			if (key == 'w'){
				pos[Y] -= speed[Y];
			}
			else if (key == 's'){
				pos[Y] += speed[Y];
			}
		}
	}

	public void mouseUpdate(){
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

	public void move(){
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

	public void display(){
		stroke(col);
		ellipse(pos[X], pos[Y], radius, radius);
	}

	public void checkWalls(){
		if (pos[Y] > height || pos[Y] < 0){
			speed[Y] = -speed[Y];
		}
	}

	public void move(){
		pos[X] += speed[X];
		pos[Y] += speed[Y];
		checkWalls();
	}

	

 	public void detectCollide(Paddle paddle){
 		float[] bhitbox = {pos[X] - (radius * .8f), pos[Y] - (radius * .8f),
 						   pos[X] + (radius * .8f), pos[Y] + (radius * .8f)};

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
			float delta = diff *.1f;
			baller.speed[Y] = baller.speed[Y] - delta;
			baller.speed[X] += baller.speed[X] *.05f;
		}
	}
	public void reset(){
		pos = new float[] {width/2, height/2};
		speed = new float[] {0, 0};
	}

}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "pong" });
  }
}
